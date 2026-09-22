terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==============================================================================
# 1. DATA SOURCES (Default VPC, Subnets, AL2023 AMI, ACM Certificate)
# ==============================================================================

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_acm_certificate" "cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# ==============================================================================
# 2. AMAZON ECR REPOSITORY (Docker Image Storage)
# ==============================================================================

resource "aws_ecr_repository" "app_repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "capstone-ecr-repo"
  }
}

resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images to optimize storage costs"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# ==============================================================================
# 3. IAM ROLE & INSTANCE PROFILE FOR EC2 (ECR Pull Access)
# ==============================================================================

resource "aws_iam_role" "ec2_role" {
  name = "capstone-ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "capstone-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "capstone-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# ==============================================================================
# 4. DATABASE: AMAZON RDS (MySQL 8.0)
# Uses Existing Security Group: RDS Capstone Proj (sg-044e01cabc894f815)
# ==============================================================================

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "capstone-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "capstone-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "capstone-mysql-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 50
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "capstone-mysql-db"
  }
}

# ==============================================================================
# 5. APPLICATION LOAD BALANCER & TARGET GROUP
# Uses Existing Security Group: ALB Capstone Proj (sg-0e7c28c370e7f6020)
# ==============================================================================

resource "aws_lb_target_group" "app_tg" {
  name        = "capstone-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "capstone-app-tg"
  }
}

resource "aws_lb" "alb" {
  name               = "capstone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "capstone-alb"
  }
}

# HTTP Port 80 Listener -> Redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Port 443 Listener -> Forward to Target Group (using ACM Cert)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ==============================================================================
# 6. LAUNCH TEMPLATE & AUTO SCALING GROUP (MAX 2 SERVERS)
# Uses Existing Security Group: EC2 Capstone Proj (sg-0c6135b6b87b56318)
# ==============================================================================

resource "aws_launch_template" "app_lt" {
  name_prefix   = "capstone-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [var.ec2_security_group_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -ex

    # 1. Update system packages
    dnf update -y

    # 2. Install Tools, Git, Apache & PHP 8.3 with all extensions
    dnf install -y awscli git wget unzip tar httpd
    dnf install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysqlnd php8.3-mbstring php8.3-xml php8.3-curl php8.3-gd php8.3-zip php8.3-bcmath php8.3-intl php8.3-opcache

    # 3. Install Node.js 20 & NPM
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    dnf install -y nodejs

    # 4. Install Composer globally
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

    # 5. Install & Configure phpMyAdmin in /var/www/html/phpmyadmin
    PMA_VER="5.2.1"
    wget -q https://files.phpmyadmin.net/phpMyAdmin/$${PMA_VER}/phpMyAdmin-$${PMA_VER}-all-languages.tar.gz -O /tmp/pma.tar.gz
    mkdir -p /var/www/html/phpmyadmin
    tar -xzf /tmp/pma.tar.gz -C /var/www/html/phpmyadmin --strip-components=1
    rm -f /tmp/pma.tar.gz

    # Inject RDS Endpoint into phpMyAdmin config
    RDS_ENDPOINT="${aws_db_instance.mysql.address}"
    cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
    BLOWFISH_SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
    sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = '$BLOWFISH_SECRET';/" /var/www/html/phpmyadmin/config.inc.php
    sed -i "s/\$cfg\['Servers'\]\[\$i\]\['host'\] = 'localhost';/\$cfg\['Servers'\]\[\$i\]\['host'\] = '$RDS_ENDPOINT';/" /var/www/html/phpmyadmin/config.inc.php

    # 6. Clone Application Repository to /var/www/html/Capstone_Project_DevOps
    APP_DIR="/var/www/html/Capstone_Project_DevOps"
    mkdir -p $APP_DIR
    git clone https://github.com/ZainCloud009/Capstone_Project_DevOps.git $APP_DIR || true
    cd $APP_DIR

    # Configure .env with RDS Database
    if [ -f "$APP_DIR/.env.example" ]; then
      cp "$APP_DIR/.env.example" "$APP_DIR/.env"
      sed -i "s/DB_HOST=127.0.0.1/DB_HOST=$RDS_ENDPOINT/" "$APP_DIR/.env"
      sed -i "s/DB_DATABASE=laravel/DB_DATABASE=idea/" "$APP_DIR/.env"
      sed -i "s/DB_USERNAME=root/DB_USERNAME=admin/" "$APP_DIR/.env"
      sed -i "s/DB_PASSWORD=/DB_PASSWORD=RootPassword123!/" "$APP_DIR/.env"
      sed -i "s|APP_URL=http://localhost|APP_URL=https://iamzain.space|" "$APP_DIR/.env"
      sed -i "s/APP_ENV=local/APP_ENV=production/" "$APP_DIR/.env"
      sed -i "s/APP_DEBUG=true/APP_DEBUG=false/" "$APP_DIR/.env"
    fi

    # Install Composer dependencies
    export COMPOSER_ALLOW_SUPERUSER=1
    composer install --no-dev --optimize-autoloader --no-interaction || true

    # Generate App Key, migrate database, and optimize Laravel
    php artisan key:generate --force || true
    php artisan migrate --force || true
    php artisan storage:link || true
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true

    # Install NPM packages and build frontend assets
    npm install || true
    npm run build || true

    # 7. Configure Apache VirtualHost on Port 80
    cat <<'APACHECONF' > /etc/httpd/conf.d/capstone.conf
<VirtualHost *:80>
    ServerName iamzain.space
    ServerAlias iamzain.space
    ServerAdmin www@localhost
    DocumentRoot "/var/www/html/Capstone_Project_DevOps/public"
    AccessFileName .htaccess

    Alias /phpmyadmin /var/www/html/phpmyadmin
    <Directory "/var/www/html/phpmyadmin">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <Directory "/var/www/html/Capstone_Project_DevOps/public">
        Options Indexes FollowSymLinks
        Order allow,deny
        Allow from All
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/capstone_error.log
    CustomLog /var/log/httpd/capstone_access.log combined
</VirtualHost>
APACHECONF

    # 8. Set correct file permissions for Apache
    chown -R apache:apache /var/www/html
    chmod -R 775 $APP_DIR/storage $APP_DIR/bootstrap/cache || true

    # 9. Enable and start PHP-FPM and Apache HTTPD services
    systemctl enable --now php-fpm
    systemctl enable --now httpd
    systemctl restart php-fpm
    systemctl restart httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "capstone-asg-server"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name_prefix         = "capstone-asg-"
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  min_size         = 1
  max_size         = 2
  desired_capacity = 1

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 600

  tag {
    key                 = "Name"
    value               = "capstone-asg-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# 7. CLOUDFRONT DISTRIBUTION
# ==============================================================================

resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "CapstoneALBOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Capstone CloudFront CDN Distribution"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "CapstoneALBOrigin"

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "capstone-cloudfront"
  }
}
