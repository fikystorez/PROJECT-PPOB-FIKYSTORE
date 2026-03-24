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
echo "[3/5] Membangun Antarmuka Website (Menu Operator & Game)..."

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
.btn-yellow { width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s; }
.tech-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E"); background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem; }
.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
/* Custom SweetAlert2 Styling */
.swal2-popup { background-color: #002147 !important; border-radius: 1rem !important; color: #ffffff !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6) !important; width: 320px !important; padding: 1.5rem 1.25rem 1.25rem !important; }
.swal2-title { color: #fde047 !important; font-size: 1.15rem !important; font-weight: 800 !important; letter-spacing: 0.5px !important; margin: 0 0 0.5em !important; }
.swal2-html-container { color: #cbd5e1 !important; font-size: 0.85rem !important; line-height: 1.5 !important; margin: 0.5em 0.2em 1em !important; }
.swal2-confirm { background: linear-gradient(135deg, #facc15 0%, #fde047 100%) !important; color: #001229 !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(253, 224, 71, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-cancel { background: linear-gradient(135deg, #ef4444 0%, #f87171 100%) !important; color: #ffffff !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-icon { transform: scale(0.7) !important; margin: 0 auto 0.5em !important; border-width: 3px !important; }
.slide-down { animation: slideDown 0.3s ease-out forwards; }
@keyframes slideDown { 0% { opacity: 0; transform: translateY(-10px); } 100% { opacity: 1; transform: translateY(0); } }
.animate-slide-up { animation: slideUp 0.3s ease-out forwards; }
@keyframes slideUp { 0% { opacity: 0; transform: scale(0.95) translateY(20px); } 100% { opacity: 1; transform: scale(1) translateY(0); } }
input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
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
            <div><input type="text" id="identifier" class="compact-input-box" required placeholder="Email / No. HP"></div>
            <div><input type="password" id="password" class="compact-input-box" required placeholder="Password"></div>
            <div class="text-right mb-5 mt-[-5px]"><a href="/forgot.html" class="text-[0.8rem] text-[#fde047] font-bold">Lupa password?</a></div>
            <button type="submit" class="btn-yellow">Login Sekarang</button>
        </form>
        <div class="mt-6 text-center compact-text-small">Belum punya akun? <a href="/register.html" class="text-[0.8rem] text-[#fde047] font-bold">Daftar disini</a></div>
    </div>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const identifier = document.getElementById('identifier').value; const password = document.getElementById('password').value;
            try {
                const res = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) });
                const data = await res.json();
                if (res.ok) { localStorage.setItem('user', JSON.stringify(data.user)); window.location.href = '/dashboard.html'; } 
                else { Swal.fire({ icon: 'error', title: 'Gagal Login', text: data.error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Terjadi kesalahan sistem.', background: '#002147', color: '#fff' }); }
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
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors duration-300">
        
        <div class="flex justify-between items-center p-4 bg-white dark:bg-[#0b1320] shadow-sm dark:shadow-md sticky top-0 z-40 transition-colors duration-300">
            <div class="flex items-center gap-4"><i class="fas fa-bars text-xl cursor-pointer text-gray-600 dark:text-gray-300 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="toggleSidebar()"></i><h1 class="font-medium text-[17px] tracking-wide text-gray-800 dark:text-white" id="headerGreeting">Hai, Member</h1></div>
            <div class="text-[11px] font-bold text-gray-600 dark:text-gray-300 bg-gray-200 dark:bg-white/10 px-3 py-1.5 rounded-full">0 Trx</div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
            <div class="w-full bg-black/40 dark:bg-black/60 backdrop-blur-sm" onclick="toggleSidebar()"></div>
            <div class="absolute top-0 left-0 w-[80%] max-w-[300px] h-full bg-white dark:bg-[#001730] shadow-2xl flex flex-col transition-colors border-r border-gray-200 dark:border-[#0a2342]">
                <div class="p-8 pb-4 flex flex-col items-center relative bg-gray-50 dark:bg-[#050b14] border-b border-gray-200 dark:border-gray-800 transition-colors">
                    <button class="absolute top-5 right-5 text-gray-400 hover:text-red-500 transition" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button>
                    <div class="w-[4.5rem] h-[4.5rem] bg-white rounded-full flex justify-center items-center text-[#001730] font-extrabold text-3xl mb-3 shadow-md border-2 border-gray-200 dark:border-none" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg text-gray-800 dark:text-white tracking-wide" id="sidebarName">User Name</h3>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-[14px]">
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/profile.html'"><i class="far fa-user w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Profil Akun</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/riwayat.html'"><i class="far fa-clock w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Transaksi Saya</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/info.html'"><i class="far fa-bell w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Pusat Informasi</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="bantuanAdmin()"><i class="fas fa-headset w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Hubungi Admin</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center justify-between cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="toggleDarkMode()">
                            <div class="flex items-center gap-4"><i class="far fa-moon w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Mode Gelap</span></div>
                            <div class="w-11 h-[22px] bg-gray-300 dark:bg-blue-500 rounded-full relative transition-colors duration-300" id="darkModeToggleBg"><div class="w-[18px] h-[18px] bg-white rounded-full absolute top-[2px] left-[2px] shadow-md transform transition-transform duration-300" id="darkModeToggleDot"></div></div>
                        </li>
                    </ul>
                </div>
                <div class="p-6">
                    <button onclick="logout()" class="w-full py-3.5 bg-transparent border border-red-500 text-red-500 font-bold rounded-xl hover:bg-red-50 dark:hover:bg-red-900/20 transition">Keluar Akun</button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-2 bg-[#002147] rounded-[1.5rem] p-6 text-white relative overflow-hidden shadow-lg border border-[#1e3a8a]">
            <div class="tech-bg opacity-40"></div> 
            <div class="text-center relative z-10">
                <p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p>
                <h2 class="text-4xl font-extrabold mb-6 tracking-tight drop-shadow-md" id="displaySaldo">Rp 0</h2>
                <div class="flex gap-4">
                    <button class="flex-1 border border-gray-500/50 bg-[#001229]/50 text-white rounded-full py-2.5 text-[11px] font-bold hover:bg-yellow-400 hover:text-[#001229] transition" onclick="location.href='/topup.html'">ISI SALDO</button>
                    <button class="flex-1 border border-gray-500/50 bg-[#001229]/50 text-white rounded-full py-2.5 text-[11px] font-bold hover:bg-yellow-400 hover:text-[#001229] transition" onclick="bantuanAdmin()">BANTUAN</button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-6 relative rounded-[1.2rem] h-[170px] overflow-hidden border border-gray-200 dark:border-gray-800 bg-white dark:bg-[#111c2e] shadow-sm">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-8 mb-4">
            <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] tracking-wide ml-1 transition-colors">Layanan Produk</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pulsa'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-mobile-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PULSA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=data'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-globe"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">DATA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/game.html'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-gamepad"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">GAME</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-ticket-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">VOUCHER</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-wallet"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">E-WALLET</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-bolt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PLN</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=masaaktif'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-calendar-check"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase text-center leading-tight transition-colors">MASA<br>AKTIF</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-sim-card"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PERDANA</span></div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8">
            <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] tracking-wide ml-1 transition-colors">Produk Digital</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-file-invoice-dollar"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">TAGIHAN</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-id-card"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase text-center leading-tight transition-colors">SALDO<br>E-TOLL</span></div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.1)] dark:shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.5)] z-40 transition-colors">
            <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
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

        function applyDarkMode() {
            const isDark = localStorage.getItem('darkMode') === 'true';
            const root = document.getElementById('html-root');
            const dot = document.getElementById('darkModeToggleDot');
            const bg = document.getElementById('darkModeToggleBg');
            if (isDark) { 
                root.classList.add('dark'); if(dot) dot.classList.add('translate-x-5'); if(bg) bg.classList.replace('bg-gray-300', 'bg-blue-500'); 
            } else { 
                root.classList.remove('dark'); if(dot) dot.classList.remove('translate-x-5'); if(bg) bg.classList.replace('bg-blue-500', 'bg-gray-300'); 
            }
        }
        function toggleDarkMode() { localStorage.setItem('darkMode', !(localStorage.getItem('darkMode') === 'true')); applyDarkMode(); }
        if(localStorage.getItem('darkMode') === null) localStorage.setItem('darkMode', 'true'); 
        applyDarkMode();

        function logout() { 
            Swal.fire({ title: 'Keluar Akun?', text: "Apakah Anda yakin ingin keluar?", icon: 'warning', showCancelButton: true, confirmButtonText: 'Ya, Keluar', cancelButtonText: 'Batal', confirmButtonColor: '#d33', cancelButtonColor: '#002147', background: localStorage.getItem('darkMode') === 'true' ? '#0b1320' : '#ffffff', color: localStorage.getItem('darkMode') === 'true' ? '#fff' : '#000'})
            .then((result) => { if (result.isConfirmed) { localStorage.removeItem('user'); window.location.href = '/'; } });
        }

        function bantuanAdmin() {
            const text = encodeURIComponent(`Halo Admin DIGITAL FIKY STORE,\n\nSaya butuh bantuan terkait akun saya (${user.phone}). Mohon dibantu ya min, terima kasih.`);
            window.open(`https://wa.me/6282231154407?text=${text}`, '_blank');
        }

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); });

        fetch('/api/config').then(res => res.json()).then(data => {
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

# HTML OPERATOR (PULSA / DATA / MASA AKTIF) - BARU!
cat << 'EOF' > public/operator.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pilih Operator - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden transition-colors">
        
        <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 transition-colors">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="history.back()"></i>
            <h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white" id="pageTitle">Operator</h1>
        </div>

        <div class="px-4 mt-6">
            <h3 class="text-[10px] text-gray-500 dark:text-gray-400 font-bold tracking-wider mb-3 uppercase">PILIH OPERATOR TUJUAN</h3>
            <div class="bg-white dark:bg-[#111c2e] rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-sm transition-colors">
                
                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'Axis', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-purple-600 flex items-center justify-center text-white font-bold text-[13px] shrink-0">AX</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">Axis</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>
                
                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'Indosat', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-yellow-500 flex items-center justify-center text-black font-bold text-[13px] shrink-0">IS</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">Indosat</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'Smartfren', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-red-500 flex items-center justify-center text-white font-bold text-[13px] shrink-0">SF</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">Smartfren</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'Telkomsel', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-red-600 flex items-center justify-center text-white font-bold text-[13px] shrink-0">TS</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">Telkomsel</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'By.U', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold text-[13px] shrink-0">BU</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">By.U</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

                <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'Three', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-gray-700 flex items-center justify-center text-white font-bold text-[13px] shrink-0">3</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">Three</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

                <div class="flex items-center p-4 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition" onclick="Swal.fire({icon:'info', title:'XL', text:'Fitur sedang dikembangkan.'})">
                    <div class="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white font-bold text-[13px] shrink-0">XL</div>
                    <div class="flex-1 ml-4 text-[15px] font-bold text-gray-800 dark:text-gray-200">XL</div>
                    <i class="fas fa-chevron-right text-gray-400 dark:text-gray-500 text-sm"></i>
                </div>

            </div>
        </div>
    </div>
    <script>
        if (!localStorage.getItem('user')) window.location.href = '/';
        if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark');
        
        const params = new URLSearchParams(window.location.search);
        const type = params.get('type');
        const titleEl = document.getElementById('pageTitle');
        
        if(type === 'pulsa') titleEl.innerText = 'Isi Pulsa';
        else if(type === 'data') titleEl.innerText = 'Paket Internet';
        else if(type === 'masaaktif') titleEl.innerText = 'Masa Aktif';
        else titleEl.innerText = 'Pilih Operator';
    </script>
</body>
</html>
EOF

# HTML TOP UP GAME (BARU!)
cat << 'EOF' > public/game.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Up Game - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden transition-colors">
        
        <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 transition-colors">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="history.back()"></i>
            <h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white">Top Up Game</h1>
        </div>

        <div class="px-4 mt-6">
            <h3 class="text-[10px] text-gray-500 dark:text-gray-400 font-bold tracking-wider mb-3 uppercase">PILIH GAME FAVORITMU</h3>
            
            <div class="bg-white dark:bg-[#111c2e] rounded-b-2xl rounded-t-xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-sm transition-colors mt-4">
                
                <div class="bg-black p-4 flex items-center gap-2">
                    <i class="fas fa-gamepad text-yellow-400 text-lg"></i>
                    <span class="font-bold text-white text-sm">Game</span>
                </div>

                <div class="p-4 grid grid-cols-3 gap-3">
                    
                    <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="Swal.fire({icon:'info', title:'Free Fire', text:'Fitur sedang dikembangkan.'})">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 dark:border-gray-500 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold italic text-sm mb-2 shrink-0">FF</div>
                        <div class="text-[11px] font-medium text-gray-700 dark:text-gray-300 text-center leading-tight">Free Fire</div>
                    </div>

                    <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="Swal.fire({icon:'info', title:'Mobile Legends', text:'Fitur sedang dikembangkan.'})">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 dark:border-gray-500 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold italic text-xs leading-tight text-center shrink-0">ML<br>BB</div>
                        <div class="text-[11px] font-medium text-gray-700 dark:text-gray-300 text-center leading-tight">Mobile<br>Legends</div>
                    </div>

                    <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="Swal.fire({icon:'info', title:'PUBG Mobile', text:'Fitur sedang dikembangkan.'})">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 dark:border-gray-500 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold italic text-[10px] shrink-0">PUBG</div>
                        <div class="text-[11px] font-medium text-gray-700 dark:text-gray-300 text-center leading-tight">PUBG<br>Mobile</div>
                    </div>

                    <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="Swal.fire({icon:'info', title:'Valorant', text:'Fitur sedang dikembangkan.'})">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 dark:border-gray-500 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold italic text-[11px] shrink-0">VALO</div>
                        <div class="text-[11px] font-medium text-gray-700 dark:text-gray-300 text-center leading-tight">Valorant</div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <script>
        if (!localStorage.getItem('user')) window.location.href = '/';
        if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark');
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS
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
const infoFile = './info.json'; 

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : (file===infoFile?[]:{});
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.qrisUrl = configAwal.qrisUrl || "https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg";
configAwal.banners = configAwal.banners || [
    "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80",
    "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80"
];
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});
if (!fs.existsSync(infoFile)) saveJSON(infoFile, []);

app.get('/api/config', (req, res) => { let cfg = loadJSON(configFile); res.json({ banners: cfg.banners, qrisUrl: cfg.qrisUrl }); });
app.get('/api/info', (req, res) => res.json({ info: loadJSON(infoFile) }));
app.post('/api/user/balance', (req, res) => res.json({ saldo: loadJSON(dbFile)[req.body.phone]?.saldo || 0 }));

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) return res.status(400).json({ error: 'Nomor sudah terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fPhone] = { name, email, password, isVerified: false, otp }; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Halo *${name}*!\n\nKode OTP Pendaftaran Akun DIGITAL FIKY STORE Anda adalah: *${otp}*\n\n_Jangan berikan kode ini kepada siapapun._` }); res.json({ message: 'OTP Terkirim', phone: fPhone }); } catch(e) { res.status(500).json({ error: 'Gagal mengirim WA.' }); }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].isVerified = true; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers);
        let db = loadJSON(dbFile); if (!db[phone]) { db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net' }; saveJSON(dbFile, db); } res.json({ message: 'Sukses!' });
    } else res.status(400).json({ error: 'OTP Salah atau Kedaluwarsa.' });
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => (p === fPhone || webUsers[p].email === identifier) && webUsers[p].password === password);
    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' });
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email } });
    } else res.status(400).json({ error: 'Data salah.' });
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (!webUsers[fPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fPhone].otp = otp; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Kode OTP Reset Password: *${otp}*` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) { webUsers[phone].password = newPassword; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers); res.json({ message: 'Diubah!' }); } 
    else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/auth/request-update-otp', async (req, res) => {
    const { oldPhone, newPhone } = req.body; let webUsers = loadJSON(webUsersFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (webUsers[fNew] && fNew !== fOld) return res.status(400).json({ error: 'Nomor baru sudah terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    if(webUsers[fOld]) { webUsers[fOld].updateOtp = otp; saveJSON(webUsersFile, webUsers); try { await global.waSocket?.sendMessage(fNew + '@c.us', { text: `Kode OTP Perubahan Nomor HP: *${otp}*` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); } } 
    else res.status(400).json({ error: 'Akun tidak ditemukan.' });
});

app.post('/api/auth/update', (req, res) => {
    const { oldPhone, newPhone, newName, otp } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    if (fOld !== fNew) {
        if (webUsers[fNew]) return res.status(400).json({ error: 'Nomor sudah dipakai.' });
        if (webUsers[fOld].updateOtp !== otp) return res.status(400).json({ error: 'Kode OTP Salah.' });
        webUsers[fNew] = { ...webUsers[fOld], name: newName }; delete webUsers[fNew].updateOtp; delete webUsers[fOld];
        if (db[fOld]) { db[fNew] = { ...db[fOld], jid: fNew + '@s.whatsapp.net' }; delete db[fOld]; }
    } else { webUsers[fOld].name = newName; }
    saveJSON(webUsersFile, webUsers); saveJSON(dbFile, db); res.json({ message: 'Profil diperbarui.', phone: fNew });
});

app.post('/api/auth/delete', (req, res) => {
    const { phone } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    if(webUsers[phone]) delete webUsers[phone]; if(db[phone]) delete db[phone];
    saveJSON(webUsersFile, webUsers); saveJSON(dbFile, db); res.json({ message: 'Akun dihapus.' });
});

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: Browsers.ubuntu('Chrome'), printQRInTerminal: false });
    if (!sock.authState.creds.registered) { let config = loadJSON(configFile); if (config.botNumber) { setTimeout(async () => { try { const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, '')); console.log(`\n🔑 KODE PAIRING ANDA :  ${code}  \n`); } catch (error) {} }, 3000); } }
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
    echo "      🤖 PANEL DIGITAL FIKY STORE (V44) 🤖     "
    echo "==============================================="
    echo "1. Setup No. Bot & Login Pairing"
    echo "2. Jalankan Bot (Latar Belakang/PM2)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo "5. Reset Sesi WhatsApp"
    echo "6. 👥 Tambah Saldo Member"
    echo "7. 🖼️ Ganti Foto Banner Promo"
    echo "8. 📲 Ganti Foto QRIS Top Up"
    echo "9. 📢 Manajemen Pusat Informasi"
    echo "10. Update Sistem (Tarik Kode Terbaru)"
    echo "0. Keluar"
    read -p "Pilih menu [0-10]: " choice

    case $choice in
        1) cd "$HOME/$DIR_NAME" && node index.js ;;
        2) cd "$HOME/$DIR_NAME" && pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save ;;
        3) pm2 stop $BOT_NAME ;;
        4) pm2 logs $BOT_NAME ;;
        5) pm2 stop $BOT_NAME 2>/dev/null; rm -rf "$HOME/$DIR_NAME/sesi_bot"; echo "Sesi dihapus!" ;;
        6) read -p "ID Member (No WA): " nomor && read -p "Jumlah Tambah Saldo: " jumlah && node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(!db['$nomor']) db['$nomor']={saldo:0};db['$nomor'].saldo+=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));console.log('Saldo Ditambah!');" ; read -p "Tekan Enter..." ;;
        7) read -p "Link Slide 1: " b1 && read -p "Link Slide 2: " b2 && read -p "Link Slide 3: " b3 && read -p "Link Slide 4: " b4 && node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};if(!cfg.banners)cfg.banners=['','','',''];if('$b1'.trim())cfg.banners[0]='$b1'.trim();if('$b2'.trim())cfg.banners[1]='$b2'.trim();if('$b3'.trim())cfg.banners[2]='$b3'.trim();if('$b4'.trim())cfg.banners[3]='$b4'.trim();fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('Banner diperbarui!');"; read -p "Tekan Enter..." ;;
        8) read -p "Masukkan Link URL Gambar QRIS: " qrisurl && node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};if('$qrisurl'.trim())cfg.qrisUrl='$qrisurl'.trim();fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('QRIS diperbarui!');"; read -p "Tekan Enter..." ;;
        9) while true; do clear; echo "--- 📢 PUSAT INFORMASI ---"; echo "1. Tambah Info Baru"; echo "2. Hapus Info"; echo "0. Kembali"; read -p "Pilih: " infomenu; case $infomenu in 1) read -p "Judul: " judul; read -p "Isi: " isi; node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];d.push({judul:'$judul',isi:'$isi',date:new Date().toLocaleDateString('id-ID')});fs.writeFileSync(f,JSON.stringify(d,null,2));"; echo "Berhasil!"; read -p "Enter...";; 2) node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(d.length===0)console.log('Kosong.');else{d.forEach((x,i)=>console.log('['+i+'] '+x.judul));}"; read -p "Nomor yg dihapus: " hapusid; if [ ! -z "$hapusid" ]; then node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(d['$hapusid']){d.splice('$hapusid',1);fs.writeFileSync(f,JSON.stringify(d,null,2));console.log('Dihapus!');}"; fi; read -p "Enter...";; 0) break;; esac; done ;;
        10) cd "$HOME" && wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh && chmod +x install.sh && ./install.sh && exit 0 ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SISTEM WEB & BOT BERHASIL DIPERBARUI SECARA PENUH!      "
echo "=========================================================="
