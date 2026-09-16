<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $title }} | CapStone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
        rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .glass {
            background: rgba(11, 17, 32, 0.85);
            backdrop-filter: blur(16px);
        }

        .nav-glow {
            box-shadow: 0 4px 20px -2px rgba(37, 99, 235, 0.15);
        }
    </style>
</head>

<body class="bg-[#0B1120] text-slate-200 min-h-screen selection:bg-blue-600 selection:text-white relative overflow-x-hidden">

    <!-- Ambient background glows -->
    <div class="fixed top-0 left-1/2 -translate-x-1/2 -z-10 w-[800px] h-[350px] bg-blue-600/10 blur-[120px] pointer-events-none rounded-full"></div>
    <div class="fixed bottom-0 right-0 -z-10 w-[500px] h-[350px] bg-indigo-600/10 blur-[100px] pointer-events-none rounded-full"></div>

    @php
        // Simple helper to check active route
        $isActive = fn($route) => request()->routeIs($route)
            ? 'text-blue-400 font-semibold'
            : 'text-slate-400 hover:text-slate-200';
        $activeDot = '<span class="absolute -bottom-1 left-1/2 -translate-x-1/2 w-1.5 h-1.5 bg-blue-500 rounded-full shadow-[0_0_8px_rgba(59,130,246,0.8)]"></span>';
    @endphp

    <nav class="sticky top-0 z-50 glass border-b border-blue-500/15 nav-glow">
        <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">

            @guest
                <a href="{{ route('home') }}" class="flex items-center gap-2.5 group">
                    <div
                        class="w-9 h-9 bg-gradient-to-tr from-blue-600 to-indigo-500 rounded-xl flex items-center justify-center group-hover:scale-105 group-hover:rotate-6 transition-all duration-300 shadow-md shadow-blue-500/30">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                                d="M13 10V3L4 14h7v7l9-11h-7z" />
                        </svg>
                    </div>
                    <span class="text-xl font-extrabold tracking-tight text-white uppercase italic">Cap<span class="text-blue-500">Stone</span></span>
                </a>

                <div class="flex items-center gap-4 md:gap-8">
                    <div class="flex items-center gap-4 md:gap-6">
                        <a href="{{ route('login') }}"
                            class="relative text-xs md:text-sm transition {{ $isActive('login') }}">
                            Login
                            {!! request()->routeIs('login') ? $activeDot : '' !!}
                        </a>
                    </div>

                    <div class="h-4 w-[1px] bg-blue-500/20 hidden sm:block"></div>

                    <a href="{{ route('register') }}"
                        class="px-4 py-2 md:px-5 md:py-2 rounded-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white transition font-bold text-xs md:text-sm shadow-lg shadow-blue-600/25 active:scale-95">
                        Register
                    </a>
                </div>
            @endguest

            @auth
                <a href="{{ route('ideas') }}" class="flex items-center gap-2.5 group">
                    <div
                        class="w-9 h-9 bg-gradient-to-tr from-blue-600 to-indigo-500 rounded-xl flex items-center justify-center group-hover:scale-105 group-hover:rotate-6 transition-all duration-300 shadow-md shadow-blue-500/30">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                                d="M13 10V3L4 14h7v7l9-11h-7z" />
                        </svg>
                    </div>
                    <span class="text-xl font-extrabold tracking-tight text-white uppercase italic">Cap<span class="text-blue-500">Stone</span></span>
                </a>

                <div class="flex items-center gap-4 md:gap-6">
                    <span class="text-sm text-slate-400 hidden sm:inline">
                        Welcome, <span class="text-blue-400 font-semibold">{{ auth()->user()->name }}</span>
                    </span>

                    <!-- Edit Profile Button -->
                    <a href="{{ route('profile.edit') }}"
                        class="px-4 py-1.5 rounded-full border border-blue-500/30 text-blue-300 hover:bg-blue-600/20 hover:text-white hover:border-blue-400 transition font-medium text-xs uppercase tracking-widest">
                        Edit Profile
                    </a>

                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button
                            class="px-4 py-1.5 rounded-full border border-red-500/30 text-red-400 hover:bg-red-500/20 hover:text-red-300 transition font-medium text-xs uppercase tracking-widest">
                            Logout
                        </button>
                    </form>
                </div>
            @endauth

        </div>
    </nav>

    @if (session('success'))
        <div id="success-toast"
            class="fixed top-24 left-1/2 -translate-x-1/2 z-[60] w-full max-w-sm px-4 opacity-0 transition-all duration-500 transform -translate-y-4">

            <div
                class="bg-[#0F172A]/90 backdrop-blur-xl border border-blue-500/30 rounded-2xl p-4 shadow-[0_0_30px_rgba(37,99,235,0.25)] flex items-center gap-4">
                <div
                    class="flex-shrink-0 w-8 h-8 bg-gradient-to-tr from-blue-600 to-indigo-600 rounded-full flex items-center justify-center shadow-[0_0_15px_rgba(37,99,235,0.5)]">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
                    </svg>
                </div>
                <div class="flex-1">
                    <p class="text-white text-sm font-semibold tracking-wide">{{ session('success') }}</p>
                </div>
                <button onclick="closeToast()" class="text-slate-400 hover:text-white transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path d="M6 18L18 6M6 6l12 12" stroke-width="2" stroke-linecap="round"
                            stroke-linejoin="round" />
                    </svg>
                </button>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const toast = document.getElementById('success-toast');

                // 1. Show the toast (Fade in & Slide down)
                setTimeout(() => {
                    toast.classList.remove('opacity-0', '-translate-y-4');
                    toast.classList.add('opacity-100', 'translate-y-0');
                }, 100);

                // 2. Automatically hide after 4.5 seconds
                setTimeout(() => {
                    closeToast();
                }, 4500);
            });

            function closeToast() {
                const toast = document.getElementById('success-toast');
                if (toast) {
                    toast.classList.remove('opacity-100', 'translate-y-0');
                    toast.classList.add('opacity-0', '-translate-y-4');
                    // Remove from DOM after transition ends
                    setTimeout(() => toast.remove(), 200);
                }
            }
        </script>
    @endif

    <main class="max-w-7xl mx-auto px-6 py-12">
        {{ $slot }}
    </main>

</body>

</html>
