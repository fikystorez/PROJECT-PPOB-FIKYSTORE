#!/bin/bash

# Pastikan script dijalankan dengan akses root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "Tolong jalankan script ini sebagai root (ketik: sudo su)"
  exit
fi

if command -v dos2unix > /dev/null 2>&1; then
    dos2unix "$0" > /dev/null 2>&1
fi

DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"
PORT=3000

echo "=========================================================="
echo "      MENGINSTAL DIGITAL FIKY STORE - TECH DASHBOARD      "
echo "=========================================================="

echo "[1/5] Memperbarui sistem dan menginstal Node.js..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip -y > /dev/null 2>&1

if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1
fi

echo "[2/5] Membuat direktori aplikasi dan web..."
mkdir -p "$HOME/$DIR_NAME/public"
cd "$HOME/$DIR_NAME"

cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.0.0",
  "description": "Aplikasi PPOB DIGITAL FIKY STORE",
  "main": "index.js",
  "scripts": { "start": "node index.js" },
  "dependencies": {
    "@hapi/boom": "^10.0.1",
    "@whiskeysockets/baileys": "^6.7.5",
    "axios": "^1.6.8",
    "body-parser": "^1.20.2",
    "express": "^4.19.2",
    "pino": "^8.20.0"
  }
}
EOF

# ==========================================
# MEMBUAT TAMPILAN WEB (CSS & HTML)
# ==========================================
echo "[3/5] Membangun Antarmuka Website (Edit Profile Fix)..."

cat << 'EOF' > public/style.css
body { background-color: #fde047; margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif; }
.centered-modal-box { background-color: #002147; padding: 3rem 1.5rem 2rem 1.5rem; border-radius: 1.2rem; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2); width: 90%; max-width: 360px; text-align: center; position: relative; z-index: 10; }
.logo-f-metalik-box { width: 85px; height: 85px; margin: 0 auto; display: flex; justify-content: center; align-items: center; border-radius: 50%; border: 3px solid #94a3b8; background: radial-gradient(circle, #333333 0%, #000000 100%); box-shadow: inset 0 0 10px rgba(255,255,255,0.2), 0 10px 20px rgba(0,0,0,0.5); position: relative; }
.logo-f-metalik-box::before { content: "F"; font-size: 55px; font-family: "Times New Roman", Times, serif; font-weight: bold; color: #e2e8f0; text-shadow: 2px 2px 4px rgba(0,0,0,0.9), -1px -1px 1px rgba(255,255,255,0.3); position: absolute; top: 52%; left: 50%; transform: translate(-50%, -50%); }
.compact-input-box { width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; border-radius: 0.5rem; margin-bottom: 0.85rem; font-size: 0.875rem; outline: none; background-color: #ffffff; color: #0f172a; }
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.compact-link-small:hover { text-decoration: underline; color: #fef08a; }
.btn-yellow { width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-yellow:hover { background-color: #facc15; }
.tech-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E"); background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem; }
.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

/* Custom SweetAlert2 Styling */
.swal2-popup { background-color: #002147 !important; border-radius: 1rem !important; color: #ffffff !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6) !important; width: 280px !important; padding: 1.5rem 1.25rem 1.25rem !important; }
.swal2-title { color: #fde047 !important; font-size: 1.15rem !important; font-weight: 800 !important; letter-spacing: 0.5px !important; margin: 0 0 0.5em !important; }
.swal2-html-container { color: #cbd5e1 !important; font-size: 0.85rem !important; line-height: 1.5 !important; margin: 0.5em 0.5em 1em !important; }
.swal2-confirm { background: linear-gradient(135deg, #facc15 0%, #fde047 100%) !important; color: #001229 !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(253, 224, 71, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-cancel { background: linear-gradient(135deg, #ef4444 0%, #f87171 100%) !important; color: #ffffff !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-icon { transform: scale(0.7) !important; margin: 0 auto 0.5em !important; border-width: 3px !important; }

/* Animasi untuk kotak dropdown ubah password & Edit Profile */
.slide-down { animation: slideDown 0.3s ease-out forwards; }
@keyframes slideDown { 0% { opacity: 0; transform: translateY(-10px); } 100% { opacity: 1; transform: translateY(0); } }
.animate-slide-up { animation: slideUp 0.3s ease-out forwards; }
@keyframes slideUp { 0% { opacity: 0; transform: scale(0.95) translateY(20px); } 100% { opacity: 1; transform: scale(1) translateY(0); } }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4"><h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1></div>
        <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
        <p class="compact-text-small mb-6">Silahkan masukkan email/no HP dan password kamu!</p>
        <form id="loginForm">
            <div><label class="compact-label">Email / No. HP</label><input type="text" id="identifier" class="compact-input-box" required placeholder="Ketik disini"></div>
            <div><label class="compact-label">Password</label><input type="password" id="password" class="compact-input-box" required placeholder="Ketik disini"></div>
            <div class="text-right mb-5 mt-[-5px]"><a href="/forgot.html" class="compact-link-small">Lupa password?</a></div>
            <button type="submit" class="btn-yellow">Login Sekarang</button>
        </form>
        <div class="mt-6 text-center compact-text-small">Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a></div>
    </div>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const identifier = document.getElementById('identifier').value;
            const password = document.getElementById('password').value;
            try {
                const res = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) });
                const data = await res.json();
                if (res.ok) { localStorage.setItem('user', JSON.stringify(data.user)); window.location.href = '/dashboard.html'; } 
                else { Swal.fire({ icon: 'error', title: 'Gagal Login', text: data.error }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Terjadi kesalahan sistem.' }); }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-100 dark:bg-gray-900 font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl transition-colors duration-300 overflow-x-hidden">
        <div class="flex justify-between items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40 transition-colors">
            <div class="flex items-center gap-4"><i class="fas fa-bars text-xl cursor-pointer text-gray-300 hover:text-white transition" onclick="toggleSidebar()"></i><h1 class="font-medium text-[17px] tracking-wide" id="headerGreeting">Hai, Member</h1></div>
            <div class="bg-white/10 text-[11px] font-bold px-3 py-1.5 rounded-full border border-white/20 shadow-sm flex items-center gap-1 text-gray-200">0 Trx</div>
        </div>
        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
            <div class="w-full bg-black bg-opacity-50" onclick="toggleSidebar()"></div>
            <div class="absolute top-0 left-0 w-3/4 max-w-[300px] h-full bg-white dark:bg-gray-900 shadow-2xl flex flex-col transition-colors">
                <div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white relative">
                    <button class="absolute top-3 right-4 text-gray-300 hover:text-white" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button>
                    <div class="w-20 h-20 bg-white rounded-full flex justify-center items-center text-[#002147] font-bold text-3xl mb-3 shadow-inner" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg tracking-wide" id="sidebarName">User Name</h3>
                    <p class="text-sm text-gray-300" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-gray-700 dark:text-gray-200">
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer transition" onclick="location.href='/profile.html'"><i class="far fa-user text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Profil Akun</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer transition"><i class="far fa-clock text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Transaksi Saya</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer transition"><i class="far fa-bell text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Pemberitahuan</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer transition" onclick="window.open('https://wa.me/6282231154407', '_blank')"><i class="fas fa-headset text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Hubungi Admin</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between hover:bg-gray-50 cursor-pointer transition" onclick="toggleDarkMode()">
                            <div class="flex items-center gap-4"><i class="far fa-moon text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Mode Gelap</span></div>
                            <div class="w-10 h-5 bg-gray-300 dark:bg-blue-500 rounded-full relative transition-colors duration-300" id="darkModeToggleBg"><div class="w-5 h-5 bg-white rounded-full absolute left-0 shadow-md transform transition-transform duration-300" id="darkModeToggleDot"></div></div>
                        </li>
                    </ul>
                </div>
                <div class="p-6 border-t border-gray-100 dark:border-gray-800"><button onclick="logout()" class="w-full py-3 border-2 border-red-500 text-red-500 font-bold rounded-lg hover:bg-red-50 transition">Keluar Akun</button></div>
            </div>
        </div>
        <div class="mx-4 mt-5 bg-[#002147] rounded-3xl p-6 text-white relative overflow-hidden shadow-lg border-b-[5px] border-yellow-400">
            <div class="tech-bg opacity-70"></div> 
            <div class="text-center relative z-10">
                <p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p>
                <h2 class="text-4xl font-extrabold mb-6 tracking-tight drop-shadow-md" id="displaySaldo">Rp 0</h2>
                <div class="flex gap-4"><button class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition" onclick="Swal.fire({icon: 'info', title: 'Top Up', text: 'Fitur deposit saldo akan segera hadir.'})">ISI SALDO</button><button class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition" onclick="window.open('https://wa.me/6282231154407', '_blank')">BANTUAN</button></div>
            </div>
        </div>
        <div class="mx-4 mt-6 relative rounded-2xl h-[170px] overflow-hidden shadow-sm border border-gray-200 dark:border-gray-700 bg-gray-200 dark:bg-gray-800">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>
        <div class="mx-4 mt-6 bg-white dark:bg-gray-800 p-5 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700 transition-colors mb-8">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-5 text-[15px] tracking-wide ml-1">Layanan Pilihan</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-2">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu Pulsa', text: 'Sistem pembelian sedang dibangun.'})"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-cyan-400 to-blue-600 text-white flex items-center justify-center text-xl shadow-lg shadow-blue-500/30 mb-2"><i class="fas fa-mobile-screen"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide">PULSA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu Data', text: 'Sistem pembelian sedang dibangun.'})"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-emerald-400 to-green-600 text-white flex items-center justify-center text-xl shadow-lg shadow-green-500/30 mb-2"><i class="fas fa-globe"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide">DATA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center text-xl shadow-lg shadow-orange-500/30 mb-2"><i class="fas fa-bolt"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide">PLN</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-purple-400 to-pink-600 text-white flex items-center justify-center text-xl shadow-lg shadow-pink-500/30 mb-2"><i class="fas fa-gamepad"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide">GAME</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-indigo-400 to-purple-600 text-white flex items-center justify-center text-xl shadow-lg shadow-indigo-500/30 mb-2"><i class="fas fa-wallet"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide text-center">E-WALLET</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-rose-400 to-red-500 text-white flex items-center justify-center text-xl shadow-lg shadow-red-500/30 mb-2"><i class="fas fa-ticket-alt"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide text-center">VOUCHER</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-teal-400 to-cyan-600 text-white flex items-center justify-center text-xl shadow-lg shadow-cyan-500/30 mb-2"><i class="fas fa-phone-volume"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide text-center leading-tight mt-0.5">SMS<br>TELP</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-gray-400 to-gray-600 text-white flex items-center justify-center text-xl shadow-lg shadow-gray-500/30 mb-2"><i class="fas fa-th-large"></i></div><span class="text-[10px] font-bold text-[#002147] dark:text-gray-200 tracking-wide text-center">LAINNYA</span></div>
            </div>
        </div>
        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>
    </div>
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        document.getElementById('headerGreeting').innerText = "Hai, " + user.name.split(' ')[0];
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase();

        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); }
        
        function logout() { 
            Swal.fire({
                title: 'Keluar Akun?', text: "Apakah Anda yakin ingin keluar?", icon: 'warning',
                showCancelButton: true, confirmButtonText: 'Ya, Keluar', cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) { localStorage.removeItem('user'); window.location.href = '/'; }
            });
        }

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); });

        let isDark = localStorage.getItem('darkMode') === 'true';
        function applyDarkMode() {
            if (isDark) { document.getElementById('html-root').classList.add('dark'); document.getElementById('darkModeToggleDot').classList.add('translate-x-5'); document.getElementById('darkModeToggleBg').classList.add('bg-blue-500'); } 
            else { document.getElementById('html-root').classList.remove('dark'); document.getElementById('darkModeToggleDot').classList.remove('translate-x-5'); document.getElementById('darkModeToggleBg').classList.remove('bg-blue-500'); }
        }
        function toggleDarkMode() { isDark = !isDark; localStorage.setItem('darkMode', isDark); applyDarkMode(); }
        applyDarkMode();

        fetch('/api/banners').then(res => res.json()).then(data => {
            if(data.banners && data.banners.length > 0 && data.banners[0] !== "") {
                const slider = document.getElementById('promoSlider');
                const dotsContainer = document.getElementById('promoDots');
                slider.innerHTML = data.banners.map(url => `<div class="w-full h-full shrink-0 snap-center relative"><img src="${url}" class="absolute inset-0 w-full h-full object-cover"></div>`).join('');
                let dotsHTML = '';
                for(let i=0; i<data.banners.length; i++) dotsHTML += `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} dot-indicator shadow-sm"></div>`;
                dotsContainer.innerHTML = dotsHTML;
            }
            const sliderElement = document.getElementById('promoSlider');
            let dots = document.querySelectorAll('.dot-indicator');
            let currentSlide = 0;
            sliderElement.addEventListener('scroll', () => {
                let slideIndex = Math.round(sliderElement.scrollLeft / sliderElement.clientWidth);
                dots.forEach((dot, idx) => { dot.classList.toggle('opacity-100', idx === slideIndex); dot.classList.toggle('opacity-40', idx !== slideIndex); });
                currentSlide = slideIndex;
            });
            setInterval(() => { currentSlide = (currentSlide + 1) % (dots.length||4); sliderElement.scrollTo({ left: currentSlide * sliderElement.clientWidth, behavior: 'smooth' }); }, 3500);
        });
    </script>
</body>
</html>
EOF

# HTML PROFIL PREMIUM DARK (DENGAN MODAL EDIT)
cat << 'EOF' > public/profile.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-[#0b1320] font-sans">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden text-white">
        
        <div class="bg-[#050b14] p-8 pb-10 flex flex-col items-center relative rounded-b-[2rem] shadow-lg">
            <div class="absolute top-6 right-6 text-xl cursor-pointer hover:text-yellow-400 transition" onclick="openEditModal()">
                <i class="fas fa-pencil-alt text-gray-300"></i>
            </div>
            
            <div class="w-24 h-24 bg-gray-200 rounded-full flex justify-center items-center text-black font-extrabold text-4xl mt-2 mb-3 shadow-xl" id="profileCircle">
                U
            </div>
            
            <h2 class="text-2xl font-bold tracking-wide text-gray-100" id="profileName">User Name</h2>
        </div>

        <div class="mt-4 px-2">
            <div class="flex items-center px-4 py-5 border-b border-gray-800">
                <i class="fas fa-envelope text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Email</div>
                <div class="text-sm text-gray-400" id="profileEmail">-</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-gray-800">
                <i class="fas fa-phone-alt text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">No. Telp</div>
                <div class="text-sm text-gray-400" id="profilePhoneData">08...</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-gray-800">
                <i class="fas fa-wallet text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Saldo Akun</div>
                <div class="text-sm font-bold text-yellow-400" id="profileSaldo">Rp 0</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-gray-800">
                <i class="fas fa-shopping-cart text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Jumlah Transaksi</div>
                <div class="text-sm text-gray-400">0 Trx</div>
            </div>
            
            <div class="flex items-center px-4 py-5 border-b border-gray-800 cursor-pointer hover:bg-gray-800/50 transition" onclick="toggleChangePassword()">
                <i class="fas fa-lock text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Ubah Password</div>
                <i class="fas fa-chevron-down text-gray-500 text-sm transition-transform duration-300" id="cpwIcon"></i>
            </div>
            
            <div id="changePasswordBox" class="hidden px-6 py-5 border-b border-gray-800 bg-[#070e18] slide-down">
                <div id="step1Cp">
                    <p class="text-xs text-gray-400 mb-3 text-center">Klik tombol di bawah untuk menerima kode OTP ke nomor WA Anda.</p>
                    <button class="w-full py-2.5 bg-[#0b1320] hover:bg-gray-800 text-yellow-400 font-bold rounded-lg text-sm border border-gray-700 transition" onclick="requestOtpCp()"><i class="fab fa-whatsapp mr-2"></i>Kirim OTP ke WA</button>
                </div>
                <div id="step2Cp" class="hidden">
                    <p class="text-xs text-green-400 mb-4 text-center"><i class="fas fa-check-circle mr-1"></i>OTP terkirim ke WhatsApp.</p>
                    <label class="block text-[10px] text-gray-500 mb-1">Kode OTP</label>
                    <input type="number" id="cpOtp" class="w-full bg-[#0b1320] border border-gray-700 rounded-lg px-3 py-2 text-white text-lg mb-3 focus:outline-none focus:border-yellow-400 text-center tracking-[0.5em] font-bold" placeholder="XXXX">
                    <label class="block text-[10px] text-gray-500 mb-1">Password Baru</label>
                    <input type="password" id="cpNewPassword" class="w-full bg-[#0b1320] border border-gray-700 rounded-lg px-3 py-2 text-white text-sm mb-5 focus:outline-none focus:border-yellow-400 text-center" placeholder="Ketik password baru">
                    <button class="w-full py-3 bg-yellow-400 text-[#001229] font-bold rounded-lg text-sm" onclick="submitChangePassword()">Simpan Password</button>
                </div>
            </div>

            <div class="flex items-center px-4 py-5 cursor-pointer hover:bg-gray-800/50 transition" onclick="logout()">
                <i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-red-600 ml-2">Keluar Akun</div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.5)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>
    </div>

    <div id="editProfileModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center bg-black/70">
        <div class="bg-[#0b1320] w-[90%] max-w-[340px] rounded-[1.25rem] border border-gray-800 shadow-2xl relative p-6 animate-slide-up">
            <button onclick="closeEditModal()" class="absolute top-4 right-4 text-gray-400 hover:text-white"><i class="fas fa-times text-xl"></i></button>
            <h3 class="text-center text-white font-bold text-lg mb-6">Ubah Profil</h3>
            
            <div class="relative w-20 h-20 mx-auto mb-8">
                <div class="w-full h-full rounded-full border-2 border-yellow-400 flex items-center justify-center text-white text-3xl font-bold bg-[#1e293b]" id="editModalInitial">U</div>
                <div class="absolute bottom-0 right-0 bg-yellow-400 rounded-full w-7 h-7 flex items-center justify-center text-[#0b1320] border-[3px] border-[#0b1320] cursor-pointer" onclick="Swal.fire({icon:'info', title:'Coming Soon', text:'Fitur ganti foto menyusul.', confirmButtonColor: '#002147'})">
                    <i class="fas fa-camera text-[10px]"></i>
                </div>
            </div>

            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Email (Hanya Baca)</label>
                <input type="email" id="editEmail" readonly class="w-full bg-[#1e293b]/50 border border-gray-800 rounded-lg px-3 py-3 text-gray-400 text-sm focus:outline-none cursor-not-allowed">
            </div>
            
            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Nama Pengguna</label>
                <input type="text" id="editName" class="w-full bg-[#0b1320] border border-gray-700 rounded-lg px-3 py-3 text-white text-sm focus:outline-none focus:border-yellow-400 transition-colors">
            </div>

            <div class="mb-8">
                <label class="block text-[10px] text-gray-500 mb-1">Nomor Telepon</label>
                <input type="number" id="editPhone" class="w-full bg-[#0b1320] border border-gray-700 rounded-lg px-3 py-3 text-white text-sm focus:outline-none focus:border-yellow-400 transition-colors">
            </div>

            <button onclick="saveProfile()" class="w-full py-3.5 bg-yellow-400 text-[#001229] font-bold rounded-xl mb-3 shadow-[0_2px_10px_rgba(253,224,71,0.2)]">Simpan Profil</button>
            <button onclick="deleteAccount()" class="w-full py-3.5 bg-[#3f161e] border border-[#5c1a24] text-red-500 font-bold rounded-xl transition hover:bg-red-900/50">Hapus Akun</button>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';

        function loadProfileData() {
            document.getElementById('profileName').innerText = user.name;
            document.getElementById('profilePhoneData').innerText = user.phone;
            document.getElementById('profileCircle').innerText = user.name.charAt(0).toUpperCase();
            document.getElementById('profileEmail').innerText = user.email || 'fikyshoto@gmail.com';
        }
        loadProfileData();

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('profileSaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); });

        function logout() { 
            Swal.fire({
                title: 'Keluar Akun?', text: "Apakah Anda yakin ingin keluar?", icon: 'warning',
                showCancelButton: true, confirmButtonText: 'Ya, Keluar', cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) { localStorage.removeItem('user'); window.location.href = '/'; }
            });
        }

        // LOGIKA UBAH PASSWORD
        function toggleChangePassword() {
            const box = document.getElementById('changePasswordBox');
            const icon = document.getElementById('cpwIcon');
            if(box.classList.contains('hidden')) { box.classList.remove('hidden'); icon.classList.replace('fa-chevron-down', 'fa-chevron-up'); } 
            else { box.classList.add('hidden'); icon.classList.replace('fa-chevron-up', 'fa-chevron-down'); document.getElementById('step1Cp').classList.remove('hidden'); document.getElementById('step2Cp').classList.add('hidden'); }
        }
        async function requestOtpCp() {
            try {
                Swal.fire({title: 'Mengirim...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
                const res = await fetch('/api/auth/forgot', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) });
                if (res.ok) { Swal.fire({ icon: 'success', title: 'Terkirim', text: 'OTP terkirim ke WA!', timer: 1500, showConfirmButton: false }); document.getElementById('step1Cp').classList.add('hidden'); document.getElementById('step2Cp').classList.remove('hidden'); } 
                else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error }); }
            } catch(e) { Swal.fire({ icon: 'error', title: 'Error', text: 'Kesalahan jaringan.' }); }
        }
        async function submitChangePassword() {
            const otp = document.getElementById('cpOtp').value;
            const newPassword = document.getElementById('cpNewPassword').value;
            if(!otp || !newPassword) return Swal.fire({ icon: 'warning', title: 'Lengkapi Data', text: 'Wajib diisi.' });
            try {
                Swal.fire({title: 'Menyimpan...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
                const res = await fetch('/api/auth/reset', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone, otp, newPassword }) });
                if (res.ok) { Swal.fire({ icon: 'success', title: 'Berhasil!', text: 'Password diubah.' }).then(() => { toggleChangePassword(); document.getElementById('cpOtp').value=''; document.getElementById('cpNewPassword').value=''; }); } 
                else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error }); }
            } catch(e) { Swal.fire({ icon: 'error', title: 'Error', text: 'Kesalahan jaringan.' }); }
        }

        // LOGIKA MODAL UBAH PROFIL & HAPUS AKUN
        function openEditModal() {
            document.getElementById('editModalInitial').innerText = user.name.charAt(0).toUpperCase();
            document.getElementById('editEmail').value = user.email || 'fikyshoto@gmail.com';
            document.getElementById('editName').value = user.name;
            document.getElementById('editPhone').value = user.phone;
            document.getElementById('editProfileModal').classList.remove('hidden');
        }
        function closeEditModal() { document.getElementById('editProfileModal').classList.add('hidden'); }
        
        async function saveProfile() {
            const oldPhone = user.phone;
            const newName = document.getElementById('editName').value;
            const newPhone = document.getElementById('editPhone').value;
            if(!newName || !newPhone) return Swal.fire({icon:'warning', title:'Gagal', text:'Nama & No WA wajib diisi!'});
            
            Swal.fire({title: 'Menyimpan...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
            try {
                const res = await fetch('/api/auth/update', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ oldPhone, newName, newPhone }) });
                if(res.ok) {
                    user.name = newName; user.phone = newPhone; localStorage.setItem('user', JSON.stringify(user));
                    Swal.fire({icon:'success', title:'Berhasil', text:'Profil diperbarui!'}).then(() => { location.reload(); });
                } else { Swal.fire({icon:'error', title:'Gagal', text: (await res.json()).error}); }
            } catch(e) { Swal.fire({icon:'error', title:'Oops', text:'Kesalahan jaringan.'}); }
        }

        function deleteAccount() {
            Swal.fire({
                title: 'Hapus Akun Permanen?', text: "Akun dan sisa saldo Anda akan hangus. Tidak bisa dikembalikan!", icon: 'error',
                showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#3085d6', confirmButtonText: 'Ya, Hapus!', cancelButtonText: 'Batal'
            }).then(async (result) => {
                if (result.isConfirmed) {
                    Swal.fire({title: 'Menghapus...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
                    try {
                        const res = await fetch('/api/auth/delete', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) });
                        if(res.ok) { localStorage.removeItem('user'); Swal.fire({icon:'success', title:'Terhapus', text:'Akun dihapus.'}).then(() => { location.href = '/'; }); }
                    } catch(e) { Swal.fire({icon:'error', title:'Error', text:'Gagal menghapus.'}); }
                }
            });
        }
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS (API UPDATE & DELETE)
# ==========================================
echo "[4/5] Menulis ulang logika Backend Node.js..."
cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, Browsers, fetchLatestBaileysVersion } = require('@whiskeysockets/baileys');
const { Boom } = require('@hapi/boom');
const fs = require('fs');
const pino = require('pino');
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

const configFile = './config.json';
const dbFile = './database.json';
const webUsersFile = './web_users.json'; 

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.banners = configAwal.banners || [
    "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80",
    "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80",
    "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&w=600&q=80",
    "https://images.unsplash.com/photo-1616077168712-fc6c788db4fa?auto=format&fit=crop&w=600&q=80"
];
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});

app.get('/api/banners', (req, res) => res.json({ banners: loadJSON(configFile).banners }));

app.post('/api/user/balance', (req, res) => res.json({ saldo: loadJSON(dbFile)[req.body.phone]?.saldo || 0 }));

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) return res.status(400).json({ error: 'Nomor sudah terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[fPhone] = { name, email, password, isVerified: false, otp };
    saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Halo *${name}*!\n\nKode OTP Pendaftaran Akun DIGITAL FIKY STORE Anda adalah: *${otp}*\n\n_Jangan berikan kode ini kepada siapapun._` }); res.json({ message: 'OTP Terkirim', phone: fPhone }); } catch(e) { res.status(500).json({ error: 'Gagal mengirim WA.' }); }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].isVerified = true; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers);
        let db = loadJSON(dbFile); if (!db[phone]) { db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net' }; saveJSON(dbFile, db); }
        res.json({ message: 'Sukses!' });
    } else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => (p === fPhone || webUsers[p].email === identifier) && webUsers[p].password === password);
    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' });
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email } });
    } else res.status(400).json({ error: 'Data salah.' });
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (!webUsers[fPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[fPhone].otp = otp; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Kode OTP Reset Password Anda: *${otp}*` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) { webUsers[phone].password = newPassword; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers); res.json({ message: 'Diubah!' }); } 
    else res.status(400).json({ error: 'OTP Salah.' });
});

// API UPDATE PROFIL
app.post('/api/auth/update', (req, res) => {
    const { oldPhone, newPhone, newName } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let db = loadJSON(dbFile);
    
    if (!webUsers[oldPhone]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    if (oldPhone !== newPhone) {
        if (webUsers[newPhone]) return res.status(400).json({ error: 'Nomor baru sudah terdaftar pengguna lain.' });
        webUsers[newPhone] = { ...webUsers[oldPhone], name: newName }; delete webUsers[oldPhone];
        if (db[oldPhone]) { db[newPhone] = { ...db[oldPhone], jid: newPhone + '@s.whatsapp.net' }; delete db[oldPhone]; }
    } else { webUsers[oldPhone].name = newName; }
    saveJSON(webUsersFile, webUsers); saveJSON(dbFile, db);
    res.json({ message: 'Profil diperbarui.' });
});

// API DELETE ACCOUNT
app.post('/api/auth/delete', (req, res) => {
    const { phone } = req.body;
    let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    if(webUsers[phone]) delete webUsers[phone];
    if(db[phone]) delete db[phone];
    saveJSON(webUsersFile, webUsers); saveJSON(dbFile, db);
    res.json({ message: 'Akun dihapus.' });
});

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: Browsers.ubuntu('Chrome'), printQRInTerminal: false });
    if (!sock.authState.creds.registered) {
        let config = loadJSON(configFile);
        if (config.botNumber) { setTimeout(async () => { try { const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, '')); console.log(`\n🔑 KODE PAIRING ANDA :  ${code}  \n`); } catch (error) {} }, 3000); }
    }
    sock.ev.on('creds.update', saveCreds); global.waSocket = sock; 
}

if (require.main === module) { app.listen(3000, () => { console.log('🌐 Web Server berjalan.'); }); startBot(); }
EOF

echo "Menginstal modul Node.js (harap tunggu sebentar)..."
npm install --silent
npm install -g pm2 > /dev/null 2>&1

echo "[5/5] Memperbarui Panel Manajemen..."
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

while true; do clear
    echo "==============================================="
    echo "      🤖 PANEL DIGITAL FIKY STORE (V36) 🤖     "
    echo "==============================================="
    echo "1. Setup No. Bot & Login Pairing"
    echo "2. Jalankan Bot (Latar Belakang/PM2)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo "5. Reset Sesi WhatsApp"
    echo "6. 👥 Tambah Saldo Member"
    echo "7. 🖼️ Ganti Foto Banner Promo"
    echo "8. Update Sistem (Tarik Kode Terbaru)"
    echo "0. Keluar"
    read -p "Pilih menu [0-8]: " choice

    case $choice in
        1) cd "$HOME/$DIR_NAME" && node index.js ;;
        2) cd "$HOME/$DIR_NAME" && pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save ;;
        3) pm2 stop $BOT_NAME ;;
        4) pm2 logs $BOT_NAME ;;
        5) pm2 stop $BOT_NAME 2>/dev/null; rm -rf "$HOME/$DIR_NAME/sesi_bot"; echo "Sesi dihapus!" ;;
        6) read -p "ID Member (No WA): " nomor && read -p "Jumlah Tambah Saldo: " jumlah && node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(!db['$nomor']) db['$nomor']={saldo:0};db['$nomor'].saldo+=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));" ;;
        7) echo "Silakan ganti di file config.json" ;;
        8) cd "$HOME" && wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh && chmod +x install.sh && ./install.sh && exit 0 ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SISTEM WEB & BOT BERHASIL DIPERBARUI SECARA PENUH!      "
echo "=========================================================="
