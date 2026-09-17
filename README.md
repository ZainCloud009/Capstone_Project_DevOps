🚀 Excited to share my latest DevOps Milestone: Complete Containerization & Automated CI/CD Pipeline on AWS EC2! 🌐🐳

I recently completed an end-to-end DevOps deployment pipeline for "CapStone" – a full-stack project management web application built with Laravel 12.

The goal was simple: Zero manual intervention from code commit to production deployment on AWS. 🎯

Here is a breakdown of the architectural workflow and implementation:

──────────────────────────────────────────────
🏗️ SYSTEM ARCHITECTURE & CI/CD WORKFLOW
──────────────────────────────────────────────

[ Developer ] ──> git push (main)
      │
      ▼
┌────────────────────────────────────────────────────────┐
│  GITHUB ACTIONS CI/CD PIPELINE                         │
│                                                        │
│  1️⃣ TEST & LINT (CI)                                   │
│     ├── Setup PHP 8.3 & Node.js 20                     │
│     ├── Composer & NPM Dependencies                    │
│     ├── Compile Vite & Tailwind Assets                 │
│     └── Execute PHPUnit Automated Test Suite           │
│                                                        │
│  2️⃣ DOCKER BUILD & PUSH                                │
│     ├── Multi-Stage Dockerfile Build                   │
│     ├── Layer Caching Optimization                     │
│     └── Push Tagged Image to Docker Hub Registry       │
│                                                        │
│  3️⃣ AUTO DEPLOY TO AWS EC2 (CD via SSH)                │
│     ├── Secure SSH Authentication with EC2             │
│     ├── Self-Healing Docker Compose Setup              │
│     ├── Pull Latest Application Image                  │
│     ├── Orchestrate Multi-Container Stack              │
│     └── Run DB Migrations & Production Caching         │
└────────────────────────┬───────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│  AWS EC2 PRODUCTION ENVIRONMENT (Docker Compose)       │
│                                                        │
│  ┌──────────────────┐  ┌──────────────────┐            │
│  │   capstone_app   │  │   capstone_rds   │            │
│  │   (Laravel 12)   ├──┤    (MySQL 8.0)   │            │
│  │     Port 80      │  │    Port 3306     │            │
│  └──────────────────┘  └────────┬─────────┘            │
│                                 │                      │
│                        ┌────────┴─────────┐            │
│                        │ capstone_phpmyadmin│          │
│                        │     Port 8080    │            │
│                        └──────────────────┘            │
└────────────────────────────────────────────────────────┘

──────────────────────────────────────────────
💡 KEY TECHNICAL HIGHLIGHTS
──────────────────────────────────────────────

🔹 Multi-Stage Dockerization:
Built an optimized multi-stage Dockerfile: Stage 1 compiles frontend assets via Node.js, and Stage 2 runs production-grade PHP 8.3 + Apache with OPcache and core extensions (pdo_mysql, mbstring, gd, zip, bcmath).

🔹 Orchestrated Multi-Container Stack:
Defined 3 isolated services using Docker Compose:
- Application Container: Serving the app on Port 80.
- Database Container (RDS/MySQL 8.0): Configured with persistent volumes and healthcheck triggers.
- phpMyAdmin Container: Secure web GUI for database management on Port 8080.

🔹 Robust Self-Healing CI/CD Pipeline:
Configured GitHub Actions (.github/workflows/Capstonepipeline.yml) to automatically:
- Trigger on git push to main.
- Run automated PHPUnit tests against isolated databases.
- Handle dynamic Docker Compose CLI auto-installation on remote EC2 instances.
- Execute seamless zero-downtime container replacement and database migrations.

🔹 Real-World Troubleshooting:
Encountered and solved real-world DevOps edge cases including MySQL 8 container user configuration conflicts, Docker volume lifecycle management, and container healthcheck dependencies (`service_healthy`).

Tech Stack:
💻 Laravel 12 | PHP 8.3 | Apache
🐳 Docker & Docker Compose
☁️ AWS EC2 & Cloud Security Groups
⚙️ GitHub Actions (CI/CD)
🗄️ MySQL 8.0 & phpMyAdmin
🎨 Tailwind CSS & Vite

Continuous improvement and hands-on implementation are the best ways to master Cloud & DevOps! Would love to hear your thoughts and feedback. 👇

#DevOps #Docker #AWS #CloudComputing #GitHubActions #CICD #DockerCompose #Laravel #WebDevelopment #SoftwareEngineering #Automation #ContinuousIntegration #AWSCloud
