<x-nav title="Home">
    <div class="relative py-24 md:py-32 flex flex-col items-center text-center">
        <!-- Ambient Radial Background Glow -->
        <div
            class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 -z-10 h-[500px] w-full max-w-4xl bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-blue-600/20 via-indigo-600/10 to-transparent blur-3xl pointer-events-none">
        </div>

        <!-- Project Badge -->
        <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-blue-500/30 bg-blue-500/10 text-blue-400 text-xs font-semibold mb-8 backdrop-blur-md">
            <span class="w-2 h-2 rounded-full bg-blue-400 animate-pulse"></span>
            CapStone DevOps & Project Management
        </div>

        <h1
            class="text-5xl md:text-7xl lg:text-8xl font-black tracking-tight text-white mb-6 leading-[1.1]">
            Innovate. Build. <br>
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-sky-300 to-indigo-400">
                Scale with CapStone.
            </span>
        </h1>
        <p class="text-slate-400 text-lg md:text-xl max-w-2xl mb-10 leading-relaxed font-normal">
            The unified workspace to organize, track, and execute your milestone ideas with modern DevOps speed and clarity.
        </p>

        <div class="flex flex-wrap items-center justify-center gap-4">
            <a href="{{ route('register') }}"
                class="px-8 py-4 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white rounded-full font-bold shadow-xl shadow-blue-600/25 hover:shadow-blue-600/40 hover:scale-105 active:scale-95 transition-all">
                Get Started with CapStone
            </a>
            <a href="{{ route('login') }}"
                class="px-8 py-4 rounded-full border border-blue-500/30 bg-[#0F172A]/80 text-blue-200 hover:bg-blue-600/20 hover:text-white hover:border-blue-400 font-semibold transition-all">
                Sign In
            </a>
        </div>

        <!-- Highlights Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mt-20 w-full max-w-4xl text-left">
            <div class="p-6 rounded-2xl bg-[#0F172A]/70 border border-blue-500/20 backdrop-blur-sm">
                <div class="w-10 h-10 rounded-xl bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-400 mb-4 font-bold">
                    01
                </div>
                <h3 class="text-lg font-bold text-white mb-1">Milestone Tracking</h3>
                <p class="text-sm text-slate-400">Track tasks, actionable steps, and progress in real-time.</p>
            </div>

            <div class="p-6 rounded-2xl bg-[#0F172A]/70 border border-blue-500/20 backdrop-blur-sm">
                <div class="w-10 h-10 rounded-xl bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-400 mb-4 font-bold">
                    02
                </div>
                <h3 class="text-lg font-bold text-white mb-1">DevOps Precision</h3>
                <p class="text-sm text-slate-400">Structure project requirements, resources, and external links effortlessly.</p>
            </div>

            <div class="p-6 rounded-2xl bg-[#0F172A]/70 border border-blue-500/20 backdrop-blur-sm">
                <div class="w-10 h-10 rounded-xl bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-400 mb-4 font-bold">
                    03
                </div>
                <h3 class="text-lg font-bold text-white mb-1">Focused Workspace</h3>
                <p class="text-sm text-slate-400">Distraction-free environment built for productivity and speed.</p>
            </div>
        </div>
    </div>
</x-nav>
