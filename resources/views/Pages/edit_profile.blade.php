<x-nav title="Edit Profile">
    <div class="max-w-md mx-auto pt-6 md:pt-10">
        <div class="bg-[#0F172A]/90 border border-blue-500/25 rounded-3xl p-8 md:p-10 shadow-[0_20px_50px_rgba(15,23,42,0.8)] backdrop-blur-xl relative overflow-hidden">
            <!-- Subtle Top Corner Glow -->
            <div class="absolute top-0 right-0 -translate-y-1/2 translate-x-1/2 w-48 h-48 bg-blue-500/15 rounded-full blur-3xl pointer-events-none"></div>

            <div class="text-center mb-8 relative z-10">
                <div class="w-12 h-12 bg-gradient-to-tr from-blue-600 to-indigo-500 rounded-2xl mx-auto mb-4 flex items-center justify-center shadow-lg shadow-blue-500/30">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                </div>
                <h2 class="text-2xl md:text-3xl font-bold text-white mb-2 tracking-tight">
                    Edit <span class="text-blue-400">Profile</span>
                </h2>
                <p class="text-slate-400 text-sm">Manage your CapStone account information</p>
            </div>

            <form action="{{ route('profile.update') }}" method="POST" class="space-y-5 relative z-10">
                @csrf
                @method('PUT')

                <div>
                    <label class="block mb-2 text-xs uppercase tracking-widest font-semibold text-blue-300/80">Full
                        Name</label>
                    <input type="text" name="name" value="{{ old('name', $user->name) }}"
                        class="w-full px-4 py-3.5 rounded-2xl bg-[#0B1120] border border-blue-500/20 text-white placeholder-slate-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/25 transition outline-none"
                        placeholder="John Doe">
                    @error('name')
                        <p class="text-red-400 text-xs mt-2 ml-1">{{ $message }}</p>
                    @enderror
                </div>

                <div>
                    <label class="block mb-2 text-xs uppercase tracking-widest font-semibold text-blue-300/80">Email
                        Address</label>
                    <input type="email" name="email" value="{{ old('email', $user->email) }}"
                        class="w-full px-4 py-3.5 rounded-2xl bg-[#0B1120] border border-blue-500/20 text-white placeholder-slate-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/25 transition outline-none"
                        placeholder="name@company.com">
                    @error('email')
                        <p class="text-red-400 text-xs mt-2 ml-1">{{ $message }}</p>
                    @enderror
                </div>

                <div class="pt-2">
                    <hr class="border-blue-500/20 mb-5">
                    <h3 class="text-xs uppercase tracking-widest font-bold text-blue-400 mb-3">Security Verification
                    </h3>
                </div>

                <div>
                    <label class="block mb-2 text-xs uppercase tracking-widest font-semibold text-blue-300/80">Current
                        Password *</label>
                    <input type="password" name="current_password"
                        class="w-full px-4 py-3.5 rounded-2xl bg-[#0B1120] border border-blue-500/20 text-white placeholder-slate-500 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/25 transition outline-none"
                        placeholder="Enter current password to confirm changes">
                    @error('current_password')
                        <p class="text-red-400 text-xs mt-2 ml-1">{{ $message }}</p>
                    @enderror
                </div>

                <button type="submit"
                    class="w-full py-4 mt-4 rounded-2xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white font-bold transition-all active:scale-[0.98] shadow-lg shadow-blue-600/30">
                    Update CapStone Profile
                </button>

            </form>
        </div>
    </div>
</x-nav>
