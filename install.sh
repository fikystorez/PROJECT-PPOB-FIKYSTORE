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

C_RED="\e[31m"
C_GREEN="\e[32m"
C_YELLOW="\e[33m"
C_CYAN="\e[36m"
C_MAG="\e[35m"
C_RST="\e[0m"
C_BOLD="\e[1m"

# Buka Port
sudo ufw allow 3000/tcp > /dev/null 2>&1 || true
sudo ufw allow 80/tcp > /dev/null 2>&1 || true
sudo ufw allow 443/tcp > /dev/null 2>&1 || true

echo -e "${C_CYAN}${C_BOLD}==========================================================${C_RST}"
echo -e "${C_YELLOW}${C_BOLD}   🚀 MENGINSTALL DIGITAL FIKY STORE - V55 FIX MODULE 🚀  ${C_RST}"
echo -e "${C_CYAN}${C_BOLD}==========================================================${C_RST}"

echo "[1/5] Memperbarui sistem & menginstal dependensi dasar..."
export DEBIAN_FRONTEND=noninteractive
apt update -y > /dev/null 2>&1
apt install curl wget gnupg git dos2unix psmisc zip unzip nginx certbot python3-certbot-nginx -y > /dev/null 2>&1

if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1
fi

echo "[2/5] Membuat struktur aplikasi..."
mkdir -p "$HOME/$DIR_NAME/public"
cd "$HOME/$DIR_NAME"

cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "5.5.0",
  "main": "index.js",
  "dependencies": {
    "@hapi/boom": "^10.0.1",
    "@whiskeysockets/baileys": "^6.7.5",
    "axios": "^1.6.8",
    "body-parser": "^1.20.2",
    "express": "^4.19.2",
    "pino": "^8.20.0",
    "xlsx": "^0.18.5"
  }
}
EOF

cat << 'EOF' > fiky_crypt.js
const fs = require('fs');
const crypto = require('crypto');
const ALGO = 'aes-256-cbc';
const KEY = crypto.scryptSync('DigitalFikyStore_SecureKey_2026', 'salt', 32);

function encrypt(text) {
    let iv = crypto.randomBytes(16);
    let cipher = crypto.createCipheriv(ALGO, KEY, iv);
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return iv.toString('hex') + ':' + encrypted.toString('hex');
}

function decrypt(text) {
    let textParts = text.split(':');
    let iv = Buffer.from(textParts.shift(), 'hex');
    let encryptedText = Buffer.from(textParts.join(':'), 'hex');
    let decipher = crypto.createDecipheriv(ALGO, KEY, iv);
    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
}

module.exports = {
    load: (file, defaultData = {}) => {
        try {
            if (!fs.existsSync(file)) return defaultData;
            let raw = fs.readFileSync(file, 'utf8');
            if(!raw) return defaultData;
            if (raw.trim().startsWith('{') || raw.trim().startsWith('[')) {
                let parsed = JSON.parse(raw);
                module.exports.save(file, parsed); 
                return parsed;
            }
            return JSON.parse(decrypt(raw));
        } catch(e) {
            return defaultData;
        }
    },
    save: (file, data) => {
        fs.writeFileSync(file, encrypt(JSON.stringify(data, null, 2)));
    }
};
EOF

echo "[3/5] Membangun Antarmuka Website (UI/UX)..."
cat << 'EOF' > public/style.css
body { background-color: #fde047; margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, sans-serif; }
.centered-modal-box { background-color: #002147; padding: 3rem 1.5rem 2rem 1.5rem; border-radius: 1.2rem; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.3); width: 90%; max-width: 360px; text-align: center; position: relative; z-index: 10; }
.logo-f-metalik-box { width: 85px; height: 85px; margin: 0 auto; display: flex; justify-content: center; align-items: center; border-radius: 50%; border: 3px solid #94a3b8; background: radial-gradient(circle, #333333 0%, #000000 100%); box-shadow: inset 0 0 10px rgba(255,255,255,0.2), 0 10px 20px rgba(0,0,0,0.5); position: relative; }
.logo-f-metalik-box::before { content: "F"; font-size: 55px; font-family: "Times New Roman", Times, serif; font-weight: bold; color: #e2e8f0; text-shadow: 2px 2px 4px rgba(0,0,0,0.9); position: absolute; top: 52%; left: 50%; transform: translate(-50%, -50%); }
.compact-input-box { width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; border-radius: 0.5rem; margin-bottom: 0.85rem; font-size: 0.875rem; outline: none; background-color: #ffffff; color: #0f172a; }
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.btn-yellow { width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-yellow:hover { background-color: #facc15; }
.tech-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E"); background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem; }
.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
.modal-enter { transform: translateY(0) !important; opacity: 1 !important; }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Login - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4"><h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1></div>
        <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
        <form id="loginForm">
            <div><label class="compact-label">Email / No. HP</label><input type="text" id="identifier" class="compact-input-box" required placeholder="Ketik disini"></div>
            <div><label class="compact-label">Password</label>
                <div class="relative mb-[0.85rem]"><input type="password" id="password" class="compact-input-box !mb-0 pr-10" required placeholder="Ketik disini"><i class="fas fa-eye absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 cursor-pointer hover:text-gray-700" onclick="togglePassword('password', this)"></i></div>
            </div>
            <div class="text-right mb-5 mt-[-5px]"><a href="/forgot.html" class="compact-link-small">Lupa password?</a></div>
            <button type="submit" class="btn-yellow" id="btnLogin">Login Sekarang</button>
        </form>
        <div class="mt-6 text-center compact-text-small">Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a></div>
    </div>
    <div id="customAlert" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-2xl border border-gray-700"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md">OKE</button></div></div>
    <script>
        function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } }
        let alertCallback = null; function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; } function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); }
        document.getElementById('loginForm').addEventListener('submit', async (e) => { 
            e.preventDefault(); document.getElementById('btnLogin').innerText = 'Memproses...'; const identifier = document.getElementById('identifier').value; const password = document.getElementById('password').value; 
            try { 
                const res = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) }); 
                const data = await res.json(); 
                if (res.ok && data.success) { localStorage.setItem('user', JSON.stringify(data.data)); window.location.href = '/dashboard.html'; } 
                else { showAlert('Login Gagal', data.message || 'Error', false); document.getElementById('btnLogin').innerText = 'Login Sekarang'; } 
            } catch (err) { showAlert('Error', 'Gagal terhubung ke server.', false); document.getElementById('btnLogin').innerText = 'Login Sekarang'; } 
        });
    </script>
</body></html>
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
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl transition-colors duration-300 overflow-x-hidden">
        
        <div class="flex justify-between items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40 transition-colors">
            <div class="flex items-center gap-4">
                <i class="fas fa-bars text-xl cursor-pointer text-gray-300 hover:text-white transition" onclick="toggleSidebar()"></i>
                <h1 class="font-medium text-[17px] tracking-wide" id="headerGreeting">Hai, Member</h1>
            </div>
            <div class="bg-white/10 text-[11px] font-bold px-3 py-1.5 rounded-full border border-white/20 shadow-sm flex items-center gap-1 text-gray-200" id="top-trx-badge">0 Trx</div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 ease-in-out flex">
            <div class="w-full bg-black bg-opacity-50" onclick="toggleSidebar()"></div>
            <div class="absolute top-0 left-0 w-3/4 max-w-[300px] h-full bg-white dark:bg-[#001229] shadow-2xl flex flex-col transition-colors">
                <div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white relative">
                    <button class="absolute top-3 right-4 text-gray-300 hover:text-white" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button>
                    <div class="w-20 h-20 bg-white rounded-full flex justify-center items-center text-[#002147] font-bold text-3xl mb-3 shadow-inner overflow-hidden" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg tracking-wide" id="sidebarName">User Name</h3>
                    <p class="text-sm text-gray-300" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-gray-700 dark:text-gray-200">
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/profile.html'"><i class="far fa-user text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Profil Akun</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/riwayat.html'"><i class="far fa-clock text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Transaksi Saya</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/info.html'"><i class="far fa-bell text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Pusat Informasi</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="bantuanWA()"><i class="fas fa-headset text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Hubungi Admin</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="toggleDarkMode()">
                            <div class="flex items-center gap-4"><i class="far fa-moon text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Mode Gelap</span></div>
                            <div class="w-10 h-5 bg-gray-300 dark:bg-blue-500 rounded-full relative transition-colors duration-300" id="darkModeToggleBg"><div class="w-5 h-5 bg-white rounded-full absolute left-0 shadow-md transform transition-transform duration-300" id="darkModeToggleDot"></div></div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-5 bg-[#002147] rounded-3xl p-6 text-white relative overflow-hidden shadow-lg border-b-[5px] border-yellow-400">
            <div class="tech-bg opacity-70"></div> 
            <div class="text-center relative z-10">
                <p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p>
                <h2 class="text-4xl font-extrabold mb-6 tracking-tight drop-shadow-md" id="displaySaldo">Rp 0</h2>
                <div class="flex gap-4">
                    <button onclick="openTopupModal()" class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition shadow-md">ISI SALDO</button>
                    <button onclick="bantuanWA()" class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition shadow-md">BANTUAN</button>
                </div>
            </div>
        </div>

        <div id="bannerContainer" class="mx-4 mt-6 relative rounded-2xl h-[170px] overflow-hidden shadow-sm border border-gray-200 dark:border-gray-700 group bg-gray-200 dark:bg-gray-800 hidden">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-6">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Layanan Produk</h3>
            <div class="grid grid-cols-4 gap-y-4 gap-x-3">
                <div onclick="location.href='/provider.html?type=pulsa'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-mobile-alt text-3xl text-blue-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PULSA</span></div>
                <div onclick="location.href='/provider.html?type=data'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-globe text-3xl text-green-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">DATA</span></div>
                <div onclick="location.href='/provider.html?type=game'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-gamepad text-3xl text-rose-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">GAME</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur pembelian Voucher sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-ticket-alt text-3xl text-amber-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">VOUCHER</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur top up E-Wallet sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-wallet text-3xl text-indigo-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">E-WALLET</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur Token PLN sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-bolt text-3xl text-yellow-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PLN</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur Masa Aktif sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="far fa-calendar-check text-3xl text-orange-500 dark:text-yellow-400"></i></div><span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">MASA<br>AKTIF</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur Perdana sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-sim-card text-3xl text-teal-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">PERDANA</span></div>
            </div>
        </div>
        
        <div class="mx-4 mt-6 mb-8">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Produk Digital</h3>
            <div class="grid grid-cols-4 gap-y-4 gap-x-3">
                <div onclick="showAlert('Segera Hadir!', 'Fitur pembayaran Tagihan sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-file-invoice text-3xl text-purple-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">TAGIHAN</span></div>
                <div onclick="showAlert('Segera Hadir!', 'Fitur Saldo E-Toll sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-id-card text-3xl text-teal-500 dark:text-yellow-400"></i></div><span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">SALDO<br>E-TOLL</span></div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>
    </div>

    <div id="customAlert" class="fixed inset-0 z-[1001] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-2xl border border-gray-700 transform transition-transform scale-100"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-[#001229] dark:text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-500 dark:text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#001229] dark:bg-[#facc15] text-yellow-400 dark:text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md">OKE</button></div></div>
    
    <div id="topupModal" class="fixed inset-0 z-[998] hidden flex items-end sm:items-center justify-center bg-black/60 backdrop-blur-sm transition-all duration-300"><div class="bg-white dark:bg-[#0f172a] w-full max-w-md rounded-t-[2rem] sm:rounded-[1.5rem] p-6 shadow-2xl border-t border-gray-200 dark:border-gray-700 transform transition-transform duration-300 translate-y-full" id="topupModalContent"><div class="flex justify-between items-center mb-5"><h3 class="text-lg font-extrabold text-[#001229] dark:text-white">Isi Saldo</h3><button onclick="closeTopupModal()" class="text-gray-400 hover:text-red-500"><i class="fas fa-times text-xl"></i></button></div><div class="mb-4"><label class="text-[11px] font-bold text-gray-500 block mb-2 ml-1">Nominal Top Up</label><div class="relative"><span class="absolute left-4 top-1/2 transform -translate-y-1/2 font-bold text-[#001229] dark:text-gray-300">Rp</span><input type="number" id="topupNominal" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-3 pl-12 pr-4 text-lg font-bold text-[#001229] dark:text-white outline-none focus:border-yellow-400 transition" placeholder="0"></div></div><div class="grid grid-cols-4 gap-2 mb-6"><button onclick="setNominal(10000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 hover:border-yellow-400 transition">10k</button><button onclick="setNominal(20000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 hover:border-yellow-400 transition">20k</button><button onclick="setNominal(50000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 hover:border-yellow-400 transition">50k</button><button onclick="setNominal(100000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 hover:border-yellow-400 transition">100k</button></div><label class="text-[11px] font-bold text-gray-500 block mb-2 ml-1">Metode Pembayaran</label><div class="space-y-3 mb-6"><label class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition method-label" id="lbl-qris"><div class="flex items-center gap-3"><div class="w-10 h-10 bg-blue-50 dark:bg-blue-900/30 rounded-full flex items-center justify-center"><i class="fas fa-qrcode text-xl text-blue-500 dark:text-yellow-400"></i></div><div><p class="text-sm font-bold text-[#001229] dark:text-white">QRIS Otomatis</p><p class="text-[10px] text-gray-500">Bebas biaya admin</p></div></div><input type="radio" name="paymentMethod" value="qris" class="hidden" onchange="selectMethod('qris')"><div class="w-5 h-5 rounded-full border-2 border-gray-300 flex items-center justify-center radio-indicator" id="radio-qris"><div class="w-2.5 h-2.5 bg-yellow-400 rounded-full hidden inner-dot"></div></div></label><label class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition method-label" id="lbl-manual"><div class="flex items-center gap-3"><div class="w-10 h-10 bg-green-50 dark:bg-green-900/30 rounded-full flex items-center justify-center"><i class="fab fa-whatsapp text-xl text-green-500"></i></div><div><p class="text-sm font-bold text-[#001229] dark:text-white">Transfer Manual (WA)</p><p class="text-[10px] text-gray-500">Konfirmasi ke Admin</p></div></div><input type="radio" name="paymentMethod" value="manual" class="hidden" onchange="selectMethod('manual')"><div class="w-5 h-5 rounded-full border-2 border-gray-300 flex items-center justify-center radio-indicator" id="radio-manual"><div class="w-2.5 h-2.5 bg-yellow-400 rounded-full hidden inner-dot"></div></div></label></div><button onclick="processTopup()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-3.5 rounded-xl font-bold tracking-wide shadow-lg">Lanjutkan Pembayaran</button></div></div>
    <div id="qrisModal" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-2xl border border-gray-700 relative"><button onclick="closeQrisModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-white"><i class="fas fa-times text-xl"></i></button><h3 class="text-lg font-extrabold text-[#001229] dark:text-white mb-1">Pembayaran QRIS</h3><p class="text-[11px] text-gray-500 dark:text-gray-400 mb-4">Scan kode QR di bawah ini</p><div class="bg-white p-2 rounded-xl inline-block mb-4 shadow-sm border border-gray-200"><img id="qrisImg" src="" class="w-48 h-48 object-cover rounded-lg"></div><p class="text-xs font-bold text-gray-500 dark:text-gray-400 mb-1">Total Pembayaran</p><h2 class="text-2xl font-extrabold text-blue-600 dark:text-yellow-400 mb-5 tracking-wide" id="qrisAmountDisplay">Rp 0</h2><button onclick="confirmQris()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-3 rounded-xl font-bold shadow-md">Saya Sudah Bayar</button></div></div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        document.getElementById('headerGreeting').innerText = "Hai, " + user.name;
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        
        if (user.photo) { document.getElementById('sidebarInitial').innerHTML = `<img src="${user.photo}" class="w-full h-full object-cover">`; } 
        else { document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase(); }

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { 
            document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); 
            document.getElementById('top-trx-badge').innerText = (data.trx_count || 0) + ' Trx';
        });

        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); }

        let isDark = localStorage.getItem('darkMode') === 'true';
        const htmlRoot = document.getElementById('html-root'); const dot = document.getElementById('darkModeToggleDot'); const bg = document.getElementById('darkModeToggleBg');
        function applyDarkMode() { if (isDark) { htmlRoot.classList.add('dark'); dot.classList.add('translate-x-5'); bg.classList.add('bg-blue-500'); } else { htmlRoot.classList.remove('dark'); dot.classList.remove('translate-x-5'); bg.classList.remove('bg-blue-500'); } }
        function toggleDarkMode() { isDark = !isDark; localStorage.setItem('darkMode', isDark); applyDarkMode(); }
        applyDarkMode();

        fetch('/api/banners').then(res => res.json()).then(data => {
            const container = document.getElementById('bannerContainer');
            if(data.success && data.data && Array.isArray(data.data)) {
                const validBanners = data.data.filter(url => url && url.trim() !== "");
                if (validBanners.length > 0) {
                    const slider = document.getElementById('promoSlider'); const dotsContainer = document.getElementById('promoDots');
                    slider.innerHTML = validBanners.map((url) => `<div class="w-full h-full shrink-0 snap-center relative flex items-center justify-center bg-[#002147]"><img src="${url}" class="absolute inset-0 w-full h-full object-cover"></div>`).join('');
                    dotsContainer.innerHTML = validBanners.map((_, i) => `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} transition-opacity duration-300 dot-indicator shadow-sm"></div>`).join('');
                    let dots = document.querySelectorAll('.dot-indicator'); let cur = 0;
                    slider.addEventListener('scroll', () => { let idx = Math.round(slider.scrollLeft / slider.clientWidth); dots.forEach((d, i) => { d.classList.toggle('opacity-100', i === idx); d.classList.toggle('opacity-40', i !== idx); }); cur = idx; });
                    setInterval(() => { cur = (cur + 1) % dots.length; slider.scrollTo({ left: cur * slider.clientWidth, behavior: 'smooth' }); }, 3500);
                    container.classList.remove('hidden');
                } else { container.classList.add('hidden'); }
            } else { container.classList.add('hidden'); }
        });

        function bantuanWA() {
            const adminNumber = "6282231154407";
            const text = `Halo Admin, saya butuh bantuan terkait aplikasi Digital Fiky Store.\n\nNama: ${user.name}\nNo HP: ${user.phone}`;
            window.open(`https://wa.me/${adminNumber}?text=${encodeURIComponent(text)}`, '_blank');
        }

        let selectedMethod = '';
        function openTopupModal() { document.getElementById('topupModal').classList.remove('hidden'); setTimeout(() => document.getElementById('topupModalContent').classList.add('modal-enter'), 10); }
        function closeTopupModal() { document.getElementById('topupModalContent').classList.remove('modal-enter'); setTimeout(() => document.getElementById('topupModal').classList.add('hidden'), 300); }
        function setNominal(val) { document.getElementById('topupNominal').value = val; }
        
        function selectMethod(method) {
            selectedMethod = method;
            document.querySelectorAll('.method-label').forEach(el => el.classList.remove('border-yellow-400', 'bg-yellow-50', 'dark:bg-gray-800'));
            document.querySelectorAll('.radio-indicator').forEach(el => el.classList.remove('border-yellow-400'));
            document.querySelectorAll('.inner-dot').forEach(el => el.classList.add('hidden'));
            document.getElementById('lbl-' + method).classList.add('border-yellow-400', 'bg-yellow-50', 'dark:bg-gray-800');
            document.getElementById('radio-' + method).classList.add('border-yellow-400');
            document.querySelector(`#radio-${method} .inner-dot`).classList.remove('hidden');
        }

        let alertCallback = null;
        function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-tools text-yellow-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; }
        function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); }

        async function processTopup() {
            const nom = document.getElementById('topupNominal').value;
            if(!nom || nom < 10000) return showAlert('Peringatan', 'Minimal Top Up adalah Rp 10.000', false);
            if(!selectedMethod) return showAlert('Peringatan', 'Silakan pilih metode pembayaran', false);

            if(selectedMethod === 'manual') {
                const adminWA = "6282231154407";
                const text = `Halo Admin, saya ingin *Top Up Saldo* (Manual).\n\nNama: ${user.name}\nNo Akun: ${user.phone}\nNominal: *Rp ${parseInt(nom).toLocaleString('id-ID')}*\n\nMohon instruksi pembayarannya.`;
                closeTopupModal();
                window.open(`https://wa.me/${adminWA}?text=${encodeURIComponent(text)}`, '_blank');
            } else if (selectedMethod === 'qris') {
                closeTopupModal();
                try {
                    let r = await fetch('/api/topup', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({phone: user.phone, nominal: nom})});
                    let d = await r.json();
                    if(d.success) {
                        document.getElementById('qrisAmountDisplay').innerText = 'Rp ' + parseInt(d.total).toLocaleString('id-ID');
                        document.getElementById('qrisImg').src = d.qris;
                        document.getElementById('qrisModal').classList.remove('hidden');
                    } else {
                        showAlert('Gagal', d.message || 'Sistem QRIS belum diatur Admin', false);
                    }
                } catch(e){ showAlert('Error', 'Kesalahan jaringan', false); }
            }
        }
        function closeQrisModal() { document.getElementById('qrisModal').classList.add('hidden'); }
        function confirmQris() { closeQrisModal(); showAlert('Diproses', 'Sistem mengecek pembayaran QRIS otomatis. Saldo masuk jika sukses.', true); }
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/provider.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Pilih Provider - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-8 shadow-2xl overflow-x-hidden"><div class="flex items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40"><i class="fas fa-arrow-left text-xl cursor-pointer text-gray-300 hover:text-white mr-4 px-2" onclick="history.back()"></i><h1 class="font-bold text-[17px] tracking-wide flex-1" id="pageTitle">Pilih Provider</h1></div><div class="px-4 mt-6 mb-2"><p class="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider ml-1" id="topLabel">Pilih Operator Tujuan</p></div><div class="mx-4" id="contentContainer"></div></div><div id="customAlert" class="fixed inset-0 z-[1001] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-100 dark:border-gray-700 transform transition-transform scale-100"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-[#001229] dark:text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-500 dark:text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#001229] dark:bg-[#facc15] text-yellow-400 dark:text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-[#002147] dark:hover:bg-yellow-500 transition">OKE</button></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark'); const params = new URLSearchParams(window.location.search); const type = params.get('type') || 'pulsa'; const topLabel = document.getElementById('topLabel'); const contentContainer = document.getElementById('contentContainer'); let alertCallback = null; function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-tools text-yellow-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; } function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); } if (type === 'game') { document.getElementById('pageTitle').innerText = 'Top Up Game'; topLabel.innerText = 'PILIH GAME FAVORITMU'; contentContainer.innerHTML = `<div class="bg-white dark:bg-[#0f172a] rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 overflow-hidden"><div class="bg-black text-white px-4 py-3 flex items-center gap-2"><i class="fas fa-gamepad text-yellow-400"></i> <span class="font-bold text-[15px] tracking-wide">Game</span></div><div class="p-4 grid grid-cols-3 gap-3"><div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="showAlert('Segera Hadir!', 'Menu nominal untuk Free Fire sedang tahap pengembangan.', false)"><div class="w-14 h-14 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center mb-2 text-[#001229] dark:text-yellow-400 font-black italic text-sm tracking-tighter">FF</div><span class="text-[10px] font-bold text-center text-[#001229] dark:text-gray-200">Free Fire</span></div><div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="showAlert('Segera Hadir!', 'Menu nominal untuk Mobile Legends sedang tahap pengembangan.', false)"><div class="w-14 h-14 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center mb-2 text-[#001229] dark:text-yellow-400 font-black italic text-[10px] text-center leading-tight tracking-tighter">ML<br>BB</div><span class="text-[10px] font-bold text-center text-[#001229] dark:text-gray-200 leading-tight mt-1">Mobile<br>Legends</span></div><div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="showAlert('Segera Hadir!', 'Menu nominal untuk PUBG Mobile sedang tahap pengembangan.', false)"><div class="w-14 h-14 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center mb-2 text-[#001229] dark:text-yellow-400 font-black italic text-xs tracking-tighter">PUBG</div><span class="text-[10px] font-bold text-center text-[#001229] dark:text-gray-200 leading-tight mt-1">PUBG<br>Mobile</span></div><div class="border border-gray-200 dark:border-gray-700 rounded-xl p-3 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="showAlert('Segera Hadir!', 'Menu nominal untuk Valorant sedang tahap pengembangan.', false)"><div class="w-14 h-14 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center mb-2 text-[#001229] dark:text-yellow-400 font-black italic text-[11px] tracking-tighter">VALO</div><span class="text-[10px] font-bold text-center text-[#001229] dark:text-gray-200 mt-1">Valorant</span></div></div></div>`; } else { document.getElementById('pageTitle').innerText = type === 'data' ? 'Paket Internet' : 'Isi Pulsa'; topLabel.innerText = 'PILIH OPERATOR TUJUAN'; const providers = [ { name: 'Axis', color: 'bg-purple-600', initial: 'AX' }, { name: 'Indosat', color: 'bg-yellow-500', initial: 'IS' }, { name: 'Smartfren', color: 'bg-red-500', initial: 'SF' }, { name: 'Telkomsel', color: 'bg-red-600', initial: 'TS' }, { name: 'By.U', color: 'bg-blue-400', initial: 'BU' }, { name: 'Three', color: 'bg-gray-800', initial: '3' }, { name: 'XL', color: 'bg-blue-600', initial: 'XL' } ]; let html = '<div class="bg-white dark:bg-[#0f172a] rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 overflow-hidden">'; providers.forEach((p, idx) => { const border = idx !== providers.length - 1 ? 'border-b border-gray-100 dark:border-gray-800' : ''; html += `<div class="flex items-center px-5 py-4 ${border} cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="showAlert('Segera Hadir!', 'Menu nominal untuk ${p.name} sedang dalam tahap pengembangan.', false)"><div class="w-10 h-10 rounded-full ${p.color} text-white flex items-center justify-center font-extrabold text-sm shadow-sm mr-4 tracking-tighter">${p.initial}</div><div class="flex-1 font-bold text-[#001229] dark:text-gray-200 text-[15px] tracking-wide">${p.name}</div><i class="fas fa-chevron-right text-gray-400 text-sm"></i></div>`; }); html += '</div>'; contentContainer.innerHTML = html; }</script></body></html>
EOF

cat << 'EOF' > public/profile.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Profil - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-white dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl"><div class="bg-black text-white p-8 flex flex-col items-center relative rounded-b-[2.5rem] shadow-lg"><div class="flex items-center justify-center gap-3 mb-2 relative"><div class="w-8"></div><div class="w-24 h-24 bg-gray-200 rounded-full flex justify-center items-center text-black font-bold text-4xl border-4 border-gray-400 shadow-xl overflow-hidden" id="profileCircle">U</div><div class="w-8 text-xl cursor-pointer hover:text-gray-300 transition flex items-center justify-center" onclick="openEditProfile()"><i class="fas fa-pencil-alt"></i></div></div><h2 class="text-xl font-bold tracking-wide mt-2" id="profileName">Nama Member</h2></div><div class="mt-6"><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-envelope text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Email</div><div class="text-sm text-gray-500 dark:text-gray-400 font-medium" id="profileEmail">email@domain.com</div></div><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-phone-alt text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">No. Telp</div><div class="text-sm text-gray-500 dark:text-gray-400 font-medium" id="profilePhoneData">0888...</div></div><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-wallet text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Saldo Akun</div><div class="text-sm font-extrabold text-blue-600 dark:text-yellow-400 tracking-wide" id="profileSaldo">Rp 0</div></div><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-shopping-cart text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Jumlah Transaksi</div><div class="text-[11px] font-bold text-gray-600 bg-gray-100 dark:bg-gray-800 dark:text-gray-300 px-3 py-1.5 rounded-full border border-gray-200 dark:border-gray-700">0 Trx</div></div><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition" onclick="openChangePassword()"><i class="fas fa-lock text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Ubah Password</div><i class="fas fa-chevron-right text-gray-400 text-sm"></i></div><div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800 cursor-pointer hover:bg-red-50 dark:hover:bg-red-900/20 transition" onclick="logout()"><i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-bold text-red-600 ml-2 tracking-wide">Keluar Akun</div></div></div><div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div></div></div><div id="customAlert" class="fixed inset-0 z-[1001] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-yellow-500 transition">OKE</button></div></div><div id="editProfileModal" class="fixed inset-0 z-[998] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[340px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-100 dark:border-gray-700 relative"><button onclick="closeEditProfile()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-white"><i class="fas fa-times text-xl"></i></button><h3 class="text-lg font-extrabold text-[#001229] dark:text-white mb-4">Ubah Profil</h3><div class="flex justify-center mb-4"><div class="relative w-20 h-20"><div id="editPreview" class="w-full h-full bg-gray-200 dark:bg-gray-800 rounded-full flex items-center justify-center text-2xl font-bold border-2 border-yellow-400 overflow-hidden text-[#001229] dark:text-white">U</div><button onclick="document.getElementById('photoInput').click()" class="absolute bottom-0 right-0 bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] w-7 h-7 rounded-full flex items-center justify-center border border-white dark:border-gray-900 shadow-sm hover:scale-110 transition"><i class="fas fa-camera text-xs"></i></button></div><input type="file" id="photoInput" accept="image/*" class="hidden" onchange="previewPhoto(event)"></div><div class="text-left mb-3"><label class="text-[10px] font-bold text-gray-500 ml-1">Email (Hanya Baca)</label><input type="email" id="editEmail" disabled class="w-full bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl py-2 px-3 text-sm text-gray-500 outline-none mt-1"></div><div class="text-left mb-3"><label class="text-[10px] font-bold text-gray-500 ml-1">Nama Pengguna</label><input type="text" id="editName" class="w-full bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2 px-3 text-sm text-[#001229] dark:text-white outline-none focus:border-yellow-400 mt-1 transition"></div><div class="text-left mb-5"><label class="text-[10px] font-bold text-gray-500 ml-1">Nomor Telepon</label><input type="number" id="editPhone" class="w-full bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2 px-3 text-sm text-[#001229] dark:text-white outline-none focus:border-yellow-400 mt-1 transition"></div><button onclick="saveProfile()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-2.5 rounded-xl font-bold tracking-wide shadow-md mb-3 hover:bg-[#002147] dark:hover:bg-yellow-500 transition">Simpan Profil</button><button onclick="deleteAccount()" class="w-full bg-red-50 dark:bg-red-900/30 text-red-600 border border-red-200 dark:border-red-800 py-2.5 rounded-xl font-bold tracking-wide transition hover:bg-red-100">Hapus Akun</button></div></div><div id="changePassModal" class="fixed inset-0 z-[998] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-100 dark:border-gray-700 relative"><button onclick="closeChangePass()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-white"><i class="fas fa-times text-xl"></i></button><h3 class="text-lg font-extrabold text-[#001229] dark:text-white mb-4">Ubah Password</h3><div class="text-left mb-3 relative"><label class="text-[10px] font-bold text-gray-500 ml-1">Password Lama</label><input type="password" id="oldPass" class="w-full bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2 px-3 pr-10 text-sm text-[#001229] dark:text-white outline-none focus:border-yellow-400 mt-1 transition"><i class="fas fa-eye absolute right-3 top-8 text-gray-500 cursor-pointer hover:text-gray-700 dark:hover:text-gray-300" onclick="togglePassword('oldPass', this)"></i></div><div class="text-left mb-5 relative"><label class="text-[10px] font-bold text-gray-500 ml-1">Password Baru</label><input type="password" id="newPass" class="w-full bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2 px-3 pr-10 text-sm text-[#001229] dark:text-white outline-none focus:border-yellow-400 mt-1 transition"><i class="fas fa-eye absolute right-3 top-8 text-gray-500 cursor-pointer hover:text-gray-700 dark:hover:text-gray-300" onclick="togglePassword('newPass', this)"></i></div><button onclick="savePassword()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-2.5 rounded-xl font-bold tracking-wide shadow-md hover:bg-[#002147] dark:hover:bg-yellow-500 transition">Simpan Password</button></div></div><div id="otpVerifyModal" class="fixed inset-0 z-[1000] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-100 dark:border-gray-700 relative"><button onclick="closeOtpModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-white"><i class="fas fa-times text-xl"></i></button><h3 class="text-lg font-extrabold text-[#001229] dark:text-white mb-2">Verifikasi Keamanan</h3><p class="text-xs text-gray-500 dark:text-gray-400 mb-4" id="otpVerifyMsg">Masukkan kode OTP dari WhatsApp.</p><input type="number" id="modalOtpInput" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-3 px-4 text-center text-2xl tracking-[0.5em] font-bold text-[#001229] dark:text-white outline-none focus:border-yellow-400 mb-5 transition" placeholder="XXXX"><button onclick="submitOtpAction()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-[#002147] dark:hover:bg-yellow-500 transition">VERIFIKASI</button></div></div><script>let user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; function renderProfile() { document.getElementById('profileName').innerText = user.name; document.getElementById('profilePhoneData').innerText = user.phone; document.getElementById('profileEmail').innerText = user.email || 'Belum diatur'; if (user.photo) { document.getElementById('profileCircle').innerHTML = `<img src="${user.photo}" class="w-full h-full object-cover">`; document.getElementById('editPreview').innerHTML = `<img src="${user.photo}" class="w-full h-full object-cover">`; } else { document.getElementById('profileCircle').innerText = user.name.charAt(0).toUpperCase(); document.getElementById('editPreview').innerText = user.name.charAt(0).toUpperCase(); } } renderProfile(); function logout() { localStorage.removeItem('user'); window.location.href = '/'; } fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }).then(res => res.json()).then(data => { document.getElementById('profileSaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); }); if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark'); let alertCallback = null; function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; } function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); } function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } } let otpContext = ''; let pendingProfileData = {}; let pendingPasswordData = {}; function showOtpModal(msg) { document.getElementById('otpVerifyMsg').innerText = msg; document.getElementById('modalOtpInput').value = ''; document.getElementById('otpVerifyModal').classList.remove('hidden'); } function closeOtpModal() { document.getElementById('otpVerifyModal').classList.add('hidden'); } async function submitOtpAction() { const otp = document.getElementById('modalOtpInput').value; if(!otp) return showAlert('Peringatan', 'OTP tidak boleh kosong.', false); if(otpContext === 'profile') { pendingProfileData.otp = otp; try { const res = await fetch('/api/user/update', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(pendingProfileData) }); const data = await res.json(); if(res.ok) { user = data.user; localStorage.setItem('user', JSON.stringify(user)); renderProfile(); closeOtpModal(); closeEditProfile(); showAlert('Berhasil!', 'Profil dan Nomor WA berhasil diperbarui.', true); } else { showAlert('Gagal', data.error, false); } } catch(e) { showAlert('Error', 'Gagal terhubung ke server', false); } } else if(otpContext === 'password') { pendingPasswordData.otp = otp; try { const res = await fetch('/api/user/change-password', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(pendingPasswordData) }); const data = await res.json(); if(res.ok) { closeOtpModal(); closeChangePass(); showAlert('Berhasil', 'Password berhasil diubah!', true); } else { showAlert('Gagal', data.error, false); } } catch(e) { showAlert('Error', 'Gagal terhubung ke server', false); } } } let tempPhotoBase64 = user.photo || ''; function openEditProfile() { document.getElementById('editName').value = user.name; document.getElementById('editPhone').value = user.phone; document.getElementById('editEmail').value = user.email || ''; document.getElementById('editProfileModal').classList.remove('hidden'); } function closeEditProfile() { document.getElementById('editProfileModal').classList.add('hidden'); } function previewPhoto(event) { const file = event.target.files[0]; if (file) { const reader = new FileReader(); reader.onload = function(e) { tempPhotoBase64 = e.target.result; document.getElementById('editPreview').innerHTML = `<img src="${tempPhotoBase64}" class="w-full h-full object-cover">`; }; reader.readAsDataURL(file); } } async function saveProfile() { const name = document.getElementById('editName').value; const newPhone = document.getElementById('editPhone').value; const payload = { oldPhone: user.phone, name, newPhone, photo: tempPhotoBase64 }; try { const res = await fetch('/api/user/update', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) }); const data = await res.json(); if(data.status === 'OTP_SENT') { pendingProfileData = payload; otpContext = 'profile'; showOtpModal(`Masukkan OTP yang dikirim ke WA baru Anda.`); } else if (res.ok) { user = data.user; localStorage.setItem('user', JSON.stringify(user)); renderProfile(); closeEditProfile(); showAlert('Berhasil!', 'Profil berhasil diperbarui.', true); } else { showAlert('Gagal', data.error, false); } } catch(e) { showAlert('Error', 'Gagal terhubung ke server', false); } } async function deleteAccount() { if(confirm("Yakin hapus akun permanen? Saldo hangus.")) { try { const res = await fetch('/api/user/delete', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }); if(res.ok) { alert('Akun dihapus.'); logout(); } else { showAlert('Gagal', 'Tidak dapat menghapus akun.', false); } } catch(e) { showAlert('Error', 'Gagal terhubung', false); } } } function openChangePassword() { document.getElementById('oldPass').value=''; document.getElementById('newPass').value=''; document.getElementById('changePassModal').classList.remove('hidden'); } function closeChangePass() { document.getElementById('changePassModal').classList.add('hidden'); } async function savePassword() { const oldPassword = document.getElementById('oldPass').value; const newPassword = document.getElementById('newPass').value; if(!oldPassword || !newPassword) return showAlert('Peringatan', 'Harap isi semua kolom.', false); const payload = { phone: user.phone, oldPassword, newPassword }; try { const res = await fetch('/api/user/change-password', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) }); const data = await res.json(); if(data.status === 'OTP_SENT') { pendingPasswordData = payload; otpContext = 'password'; showOtpModal('Masukkan OTP yang dikirim ke WA Anda.'); } else { showAlert('Gagal', data.error || 'Password lama salah.', false); } } catch(e) { showAlert('Error', 'Gagal terhubung', false); } }</script></body></html>
EOF

cat << 'EOF' > public/riwayat.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Riwayat - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><style> .hide-scrollbar::-webkit-scrollbar { display: none; } </style><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl overflow-x-hidden"><div class="flex items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40"><i class="fas fa-arrow-left text-xl cursor-pointer text-gray-300 hover:text-white mr-4" onclick="location.href='/dashboard.html'"></i><h1 class="font-bold text-[17px] tracking-wide flex-1">Riwayat Transaksi</h1></div><div class="mx-4 mt-5 bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm border border-gray-100 dark:border-gray-700"><div class="relative mb-4"><i class="fas fa-search absolute left-3 top-3 text-gray-400"></i><input type="text" placeholder="Cari transaksi..." class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2.5 pl-10 pr-4 text-sm outline-none focus:border-yellow-400 dark:text-gray-200 transition"></div><div class="flex gap-2 overflow-x-auto hide-scrollbar pb-1"><button class="bg-[#001229] text-yellow-400 px-5 py-1.5 rounded-full text-xs font-bold shrink-0 border border-[#001229] shadow-sm">Semua</button><button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Sukses</button><button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Proses</button><button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Gagal</button></div><div class="flex gap-2 mt-4 items-end"><div class="flex-1"><label class="text-[10px] font-bold text-gray-500 mb-1 block">Dari</label><input type="date" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg py-1.5 px-2 text-xs outline-none text-gray-600 dark:text-gray-300"></div><div class="flex-1"><label class="text-[10px] font-bold text-gray-500 mb-1 block">Sampai</label><input type="date" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg py-1.5 px-2 text-xs outline-none text-gray-600 dark:text-gray-300"></div><button class="bg-gray-100 dark:bg-gray-700 w-8 h-8 rounded-lg flex items-center justify-center text-gray-500 border border-gray-200 hover:bg-gray-200"><i class="fas fa-sync-alt text-xs"></i></button></div></div><div class="flex flex-col items-center justify-center mt-12 mb-8"><div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4 shadow-inner"><i class="fas fa-receipt text-4xl text-gray-400"></i></div><h3 class="font-bold text-[#001229] dark:text-gray-100 text-lg">Belum Ada Transaksi</h3><p class="text-xs text-gray-500 mt-2 text-center max-w-[200px]">Ayo mulai transaksi pertamamu sekarang dan nikmati berbagai promo menarik!</p><button onclick="location.href='/dashboard.html'" class="mt-5 bg-[#001229] text-yellow-400 px-6 py-2.5 rounded-full text-xs font-bold shadow-md hover:bg-[#002147] transition">Transaksi Sekarang</button></div><div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">PROFIL</span></div></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark');</script></body></html>
EOF

cat << 'EOF' > public/info.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Pusat Info - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl overflow-x-hidden"><div class="flex items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40"><i class="fas fa-arrow-left text-xl cursor-pointer text-gray-300 hover:text-white mr-4" onclick="location.href='/dashboard.html'"></i><h1 class="font-bold text-[17px] tracking-wide flex-1">Pusat Informasi</h1></div><div id="infoContainer" class="mx-4 mt-5 pb-8"><div class="flex items-center justify-center h-40"><i class="fas fa-circle-notch fa-spin text-3xl text-gray-400"></i></div></div><div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">PROFIL</span></div></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark'); fetch('/api/info').then(res => res.json()).then(data => { const container = document.getElementById('infoContainer'); if (data.data.length === 0) { container.innerHTML = `<div class="flex flex-col items-center justify-center mt-12"><div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4 shadow-inner"><i class="fas fa-bell-slash text-4xl text-gray-400"></i></div><h3 class="font-bold text-[#001229] dark:text-gray-100 text-lg">Belum Ada Informasi</h3><p class="text-xs text-gray-500 mt-2 text-center max-w-[200px]">Saat ini belum ada pengumuman atau informasi terbaru.</p></div>`; } else { let html = ''; data.data.forEach(info => { html += `<div class="bg-white dark:bg-[#0f172a] rounded-2xl p-4 shadow-sm border border-gray-100 dark:border-gray-800 mb-4 flex gap-4 transition-transform hover:-translate-y-1 cursor-pointer"><div class="w-12 h-12 rounded-full bg-blue-50 dark:bg-black flex items-center justify-center text-blue-600 dark:text-yellow-400 shrink-0 border border-transparent dark:border-gray-700"><i class="fas fa-bullhorn text-xl"></i></div><div class="flex-1"><div class="flex justify-between items-start mb-1"><h4 class="font-bold text-[#001229] dark:text-gray-100 text-sm leading-tight pr-2">${info.title}</h4><span class="text-[9px] font-bold text-gray-400 shrink-0 mt-0.5">${info.date}</span></div><p class="text-[11px] text-gray-600 dark:text-gray-400 leading-relaxed">${info.content}</p></div></div>`; }); container.innerHTML = html; } }).catch(err => { document.getElementById('infoContainer').innerHTML = `<p class="text-center text-sm text-red-500 mt-10">Gagal memuat informasi.</p>`; });</script></body></html>
EOF

echo "[4/5] Mengatur sistem Backend Node.js..."
cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, Browsers, fetchLatestBaileysVersion } = require('@whiskeysockets/baileys');
const fs = require('fs');
const pino = require('pino');
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const crypto = require('crypto');
const axios = require('axios');
const { exec } = require('child_process');
const crypt = require('./fiky_crypt.js');

const app = express();
app.use(bodyParser.json({ limit: '10mb' })); 
app.use(express.static(path.join(__dirname, 'public')));

app.use((req, res, next) => {
    if (req.path.endsWith('.json')) return res.status(403).json({success: false, message: 'Akses Ditolak'});
    next();
});

const configFile = './config.json';
const dbFile = './database.json';
const infoFile = './info.json'; 
const trxFile = './trx.json';
const produkFile = './produk.json';
const topupFile = './topup.json';
const globalStatsFile = './global_stats.json';

const loadJSON = (file) => crypt.load(file, file === infoFile ? [] : {});
const saveJSON = (file, data) => crypt.save(file, data);

loadJSON(dbFile); loadJSON(produkFile); loadJSON(trxFile); loadJSON(topupFile); loadJSON(globalStatsFile);

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.digiflazzUsername = configAwal.digiflazzUsername || ""; 
configAwal.digiflazzApiKey = configAwal.digiflazzApiKey || "";     
configAwal.gopayToken = configAwal.gopayToken || "";
configAwal.gopayMerchantId = configAwal.gopayMerchantId || "";
configAwal.qrisText = configAwal.qrisText || "";
configAwal.banners = configAwal.banners || ["https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80", "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80"];
saveJSON(configFile, configAwal);

let globalSock = null;

const sendWhatsAppMessage = async (phone, message) => {
    try {
        if (!globalSock) return false;
        const jid = phone + '@s.whatsapp.net';
        await globalSock.sendMessage(jid, { text: message });
        return true;
    } catch (error) { return false; }
};

function convertToDynamicQris(staticQris, amount) {
    try {
        if(!staticQris || staticQris.length < 30) return staticQris;
        let qris = staticQris.substring(0, staticQris.length - 8);
        qris = qris.replace("010211", "010212");
        let parsed = ""; let i = 0;
        while (i < qris.length) {
            let id = qris.substring(i, i+2); let lenStr = qris.substring(i+2, i+4); let len = parseInt(lenStr, 10);
            if (isNaN(len)) break;
            let val = qris.substring(i+4, i+4+len);
            if (id !== "54") parsed += id + lenStr + val;
            i += 4 + len;
        }
        let amtStr = amount.toString(); let amtLen = amtStr.length.toString().padStart(2, '0');
        let tag54 = "54" + amtLen + amtStr;
        let finalQris = "";
        if (parsed.includes("5802ID")) finalQris = parsed.replace("5802ID", tag54 + "5802ID");
        else finalQris = parsed + tag54;
        finalQris += "6304";
        
        let crc = 0xFFFF;
        for(let j=0; j<finalQris.length; j++){
            crc ^= finalQris.charCodeAt(j) << 8;
            for(let k=0; k<8; k++){ if(crc & 0x8000) crc = (crc << 1) ^ 0x1021; else crc = crc << 1; }
        }
        let crcStr = (crc & 0xFFFF).toString(16).toUpperCase().padStart(4, '0');
        return finalQris + crcStr;
    } catch(e) { return staticQris; }
}

app.get('/api/banners', (req, res) => res.json({ success: true, data: loadJSON(configFile).banners }));
app.get('/api/info', (req, res) => res.json({ data: loadJSON(infoFile).reverse() }));
app.post('/api/user/balance', (req, res) => {
    let db = loadJSON(dbFile); let p = req.body.phone;
    if(db[p]) { res.json({saldo: db[p].saldo || 0, trx_count: db[p].trx_count || 0}); } else { res.json({saldo:0, trx_count:0}); }
});

app.post('/api/auth/login', (req, res) => {
    let { identifier, password } = req.body; let db = loadJSON(dbFile);
    let fPhone = identifier.toString().replace(/[^0-9]/g, ''); if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    let foundPhone = Object.keys(db).find(k => (k === fPhone || db[k].email === identifier) && db[k].password === password);
    if (foundPhone) {
        if (!db[foundPhone].isVerified && db[foundPhone].otp) return res.status(400).json({ success: false, message: 'Akun belum diverifikasi OTP.' });
        let safeData = {...db[foundPhone]}; delete safeData.password;
        res.json({ success: true, data: safeData });
    } else { res.status(400).json({ success: false, message: 'Email/No HP atau Password salah.' }); }
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body; let db = loadJSON(dbFile);
    let fPhone = phone.toString().replace(/[^0-9]/g, ''); if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    if (db[fPhone] && (!db[fPhone].otp || db[fPhone].isVerified)) return res.status(400).json({ success:false, error: 'Nomor WA sudah terdaftar.' });
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    db[fPhone] = { name: name, email: email, password: password, isVerified: false, otp: otp, photo: '', saldo: 0, trx_count: 0, history: [] }; 
    saveJSON(dbFile, db);
    const sent = await sendWhatsAppMessage(fPhone, `Halo *${name}*!\nSelamat datang di DIGITAL FIKY STORE.\n\nKode OTP Pendaftaran Anda: *${otp}*`);
    if(sent) res.json({ success: true, phone: fPhone }); else res.status(500).json({ success:false, error: 'Gagal mengirim OTP.' });
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body; let db = loadJSON(dbFile); 
    let fPhone = phone.toString().replace(/[^0-9]/g, ''); if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    if (db[fPhone] && db[fPhone].otp === otp.toString().trim()) {
        db[fPhone].isVerified = true; delete db[fPhone].otp; saveJSON(dbFile, db); res.json({ success: true });
    } else { res.status(400).json({ success:false, error: 'Kode OTP Salah.' }); }
});

app.post('/api/topup', async (req, res) => {
    try {
        let cfg = loadJSON(configFile);
        if(!cfg.gopayToken || !cfg.qrisText) return res.json({success: false, message: "Sistem QRIS belum diatur Admin."});
        let { phone, nominal } = req.body; let db = loadJSON(dbFile);
        if(!db[phone]) return res.json({success: false, message: "User tidak ditemukan."});
        
        let nominalAsli = parseInt(nominal);
        let uniqueCode = Math.floor(Math.random() * 99) + 1; let totalPay = nominalAsli + uniqueCode;
        let dynQris = convertToDynamicQris(cfg.qrisText, totalPay);
        let finalQrisUrl = "https://api.qrserver.com/v1/create-qr-code/?size=400x400&margin=15&format=jpeg&data=" + encodeURIComponent(dynQris);

        let topups = loadJSON(topupFile); let trxId = "TP-" + Date.now(); let expiredAt = Date.now() + 10 * 60 * 1000; 
        topups[trxId] = { phone, trx_id: trxId, amount_to_pay: totalPay, saldo_to_add: totalPay, status: 'pending', expired_at: expiredAt };
        saveJSON(topupFile, topups);

        db[phone].history = db[phone].history || [];
        db[phone].history.unshift({ ts: Date.now(), tanggal: new Date().toLocaleDateString('id-ID', { timeZone: 'Asia/Jakarta', day:'numeric', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit' }), type: 'Topup', nama: 'Topup Saldo QRIS', tujuan: 'Sistem Pembayaran', status: 'Pending', sn: trxId, amount: totalPay, qris_url: finalQrisUrl, expired_at: expiredAt });
        if(db[phone].history.length > 20) db[phone].history.pop();
        saveJSON(dbFile, db);

        res.json({success: true, total: totalPay, qris: finalQrisUrl});
    } catch(e) { res.json({success: false, message: "Gagal memproses QRIS."}); }
});

setInterval(async () => {
    try {
        let cfg = loadJSON(configFile); let topups = loadJSON(topupFile);
        let pendingKeys = Object.keys(topups).filter(k => topups[k].status === 'pending');
        if(pendingKeys.length === 0 || !cfg.gopayToken || !cfg.gopayMerchantId) return;

        const gopayRes = await axios.post('https://gopay.autoftbot.com/api/backend/transactions', 
            { merchant_id: cfg.gopayMerchantId }, 
            { headers: { 'Authorization': 'Bearer ' + cfg.gopayToken, 'Content-Type': 'application/json' } }
        );
        let responseStr = JSON.stringify(gopayRes.data);
        let db = loadJSON(dbFile); let changedTp = false; let changedDb = false;

        for(let key of pendingKeys) {
            let req = topups[key];
            if (Date.now() > req.expired_at) {
                req.status = 'gagal'; changedTp = true;
                if(db[req.phone]) {
                    let hist = db[req.phone].history.find(h => h.sn === req.trx_id);
                    if(hist && hist.status === 'Pending') { hist.status = 'Gagal'; changedDb = true; }
                }
            } else {
                let amountStr = req.amount_to_pay.toString();
                let isFound = responseStr.includes(`"${amountStr}"`) || responseStr.includes(`:${amountStr}`) || responseStr.includes(`"${amountStr}.00"`) || responseStr.includes(`:${amountStr}.00`);
                if(isFound) {
                    req.status = 'sukses'; changedTp = true;
                    if(db[req.phone]) {
                        db[req.phone].saldo += req.saldo_to_add; 
                        let hist = db[req.phone].history.find(h => h.sn === req.trx_id);
                        if(hist && hist.status === 'Pending') { hist.status = 'Sukses'; }
                        changedDb = true;
                        if(globalSock) {
                            let msg = `✅ *TOPUP QRIS BERHASIL*\n\nTotal: Rp ${req.amount_to_pay.toLocaleString('id-ID')}\nSaldo Sekarang: Rp ${db[req.phone].saldo.toLocaleString('id-ID')}`;
                            globalSock.sendMessage(req.phone + '@s.whatsapp.net', {text: msg}).catch(()=>{});
                        }
                    }
                }
            }
        }
        if(changedTp) saveJSON(topupFile, topups);
        if(changedDb) saveJSON(dbFile, db);
    } catch(e) {}
}, 30000); 

setInterval(() => {
    if(fs.existsSync('japri.txt')) {
        let lines = fs.readFileSync('japri.txt', 'utf8').split('\n'); fs.unlinkSync('japri.txt');
        for(let line of lines) {
            if(line.includes('|') && globalSock) {
                let parts = line.split('|'); let target = parts[0]; parts.shift(); let msg = parts.join('|');
                globalSock.sendMessage(target + '@s.whatsapp.net', { text: msg }).catch(e=>{});
            }
        }
    }
}, 3000);

function doBackupAndSend() {
    let cfg = loadJSON(configFile);
    if (!cfg.teleToken || !cfg.teleChatId) return;
    exec(`[ -d "/etc/letsencrypt" ] && sudo tar -czf ssl_backup.tar.gz -C / etc/letsencrypt 2>/dev/null; rm -f backup.zip && zip backup.zip config.json database.json trx.json produk.json topup.json info.json global_stats.json ssl_backup.tar.gz 2>/dev/null`, (err) => {
        if (!err) exec(`curl -s -F chat_id="${cfg.teleChatId}" -F document=@"backup.zip" -F caption="📦 Auto-Backup Fiky Store" https://api.telegram.org/bot${cfg.teleToken}/sendDocument`);
    });
}
if (configAwal.autoBackup) setInterval(doBackupAndSend, (configAwal.backupInterval || 720) * 60 * 1000); 

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: Browsers.ubuntu('Chrome'), printQRInTerminal: false });
    
    if (!sock.authState.creds.registered) {
        let config = loadJSON(configFile);
        if (config.botNumber) {
            setTimeout(async () => {
                try {
                    const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, ''));
                    console.log(`\n=======================================================\n🔑 KODE PAIRING ANDA :  ${code}  \n=======================================================\n`);
                } catch (error) {}
            }, 3000); 
        }
    }
    sock.ev.on('creds.update', saveCreds);
    sock.ev.on('connection.update', (update) => {
        const { connection } = update;
        if(connection === 'close') { startBot(); } else if(connection === 'open') { console.log("✅ BOT WHATSAPP TERHUBUNG!"); }
    });
    globalSock = sock; 
}

if (require.main === module) {
    app.listen(3000, () => { console.log('🌐 Web Server berjalan di port 3000'); });
    startBot();
}
EOF

echo "[5/5] Membuat Script Menu Terminal VPS..."
cat << 'EOF_MENU' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"
PORT=3000
PROJECT_DIR="$HOME/$DIR_NAME"

C_RED="\e[31m"
C_GREEN="\e[32m"
C_YELLOW="\e[33m"
C_CYAN="\e[36m"
C_MAG="\e[35m"
C_RST="\e[0m"
C_BOLD="\e[1m"

run_node_script() {
    cd "$PROJECT_DIR"
    cat << 'EOF_NODE' > menu_temp.js
const crypt = require('./fiky_crypt.js');
const fs = require('fs');
const { exec } = require('child_process');
try {
    const action = process.env.NODE_ACTION;
    
    if(action === 'set_tele') {
        let config = crypt.load('config.json');
        config.teleToken = process.env.T_TOKEN; config.teleChatId = process.env.T_CHATID;
        crypt.save('config.json', config);
        console.log('\x1b[32m\n✅ Data Telegram berhasil disimpan!\x1b[0m');
    } 
    else if (action === 'set_auto_backup') {
        let config = crypt.load('config.json');
        config.autoBackup = process.env.B_STATUS === 'true'; config.backupInterval = parseInt(process.env.B_MENIT);
        crypt.save('config.json', config);
    }
    else if (action === 'backup_now') {
        let config = crypt.load('config.json');
        if(config.teleToken && config.teleChatId) {
            console.log('\x1b[36m⏳ Sedang mengirim ke Telegram...\x1b[0m');
            let cmd = `curl -s -F chat_id="${config.teleChatId}" -F document=@"backup.zip" -F caption="📦 Manual Backup Data" https://api.telegram.org/bot${config.teleToken}/sendDocument`;
            exec(cmd, (err) => {
                if(err) console.log('\x1b[31m❌ Gagal mengirim ke Telegram.\x1b[0m');
                else console.log('\x1b[32m✅ File Backup berhasil mendarat di Telegram!\x1b[0m');
            });
        } else { console.log('\x1b[33m⚠️ Token Telegram belum diisi.\x1b[0m'); }
    }
    else if (action === 'add_saldo') {
        let db = crypt.load('database.json'); let nomor = process.env.T_NOMOR; let jumlah = parseInt(process.env.T_JUMLAH);
        let target = Object.keys(db).find(k => k === nomor || (db[k].email === nomor));
        if(!target) { console.log('\x1b[31m❌ Akun tidak ditemukan!\x1b[0m'); }
        else { 
            db[target].saldo += jumlah; if(db[target].saldo < 0) db[target].saldo = 0;
            crypt.save('database.json', db); console.log('\x1b[32m✅ Saldo berhasil diubah!\x1b[0m'); 
        }
    }
    else if (action === 'set_digi') {
        let config = crypt.load('config.json');
        if(process.env.D_USER) config.digiflazzUsername = process.env.D_USER.trim();
        if(process.env.D_KEY) config.digiflazzApiKey = process.env.D_KEY.trim();
        crypt.save('config.json', config);
        console.log('\x1b[32m\n✅ Konfigurasi Digiflazz berhasil disimpan!\x1b[0m');
    }
    else if (action === 'add_info') {
        let infos = crypt.load('info.json'); if(!Array.isArray(infos)) infos = [];
        const tgl = new Date().toLocaleDateString('id-ID', {day:'numeric', month:'short', year:'numeric'});
        infos.push({ title: process.env.I_TITLE, content: process.env.I_MSG, date: tgl });
        crypt.save('info.json', infos); console.log('\x1b[32m✅ Info berhasil ditambahkan!\x1b[0m');
    }
    else if (action === 'set_qris') {
        let config = crypt.load('config.json');
        if (process.env.Q_TOK) config.gopayToken = process.env.Q_TOK.trim();
        if (process.env.Q_MID) config.gopayMerchantId = process.env.Q_MID.trim();
        if (process.env.Q_TXT) config.qrisText = process.env.Q_TXT.trim();
        crypt.save('config.json', config);
        console.log('\x1b[32m\n✅ Konfigurasi GoPay berhasil disimpan!\x1b[0m');
    }
    else if (action === 'set_banner') {
        let config = crypt.load('config.json');
        let def = ["https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80", "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80"];
        if (!config.banners) config.banners = def;
        if (process.env.B1.trim()) config.banners[0] = process.env.B1.trim(); 
        if (process.env.B2.trim()) config.banners[1] = process.env.B2.trim();
        if (process.env.B3.trim()) config.banners[2] = process.env.B3.trim(); 
        if (process.env.B4.trim()) config.banners[3] = process.env.B4.trim();
        
        config.banners = config.banners.filter(b => b.trim() !== '');
        if(config.banners.length === 0) config.banners = def;
        crypt.save('config.json', config);
        console.log('\x1b[32m\n✅ Foto banner diperbarui!\x1b[0m');
    }
} catch(e) { console.log('Error: ' + e.message); }
EOF_NODE
    node menu_temp.js
    rm -f menu_temp.js
}

menu_telegram() {
    while true; do
        clear
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "${C_YELLOW}${C_BOLD}             ⚙️ BOT TELEGRAM SETUP ⚙️              ${C_RST}"
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "  ${C_GREEN}[1]${C_RST} Change BOT API & CHAT ID"
        echo -e "  ${C_GREEN}[2]${C_RST} Set Notifikasi Backup Otomatis"
        echo -e "${C_CYAN}------------------------------------------------------${C_RST}"
        echo -e "  ${C_RED}[0]${C_RST} Kembali ke Panel Utama"
        echo -e "${C_CYAN}======================================================${C_RST}"
        echo -ne "${C_YELLOW}Pilih menu [0-2]: ${C_RST}"
        read telechoice

        case $telechoice in
            1)
                read -p "Token Bot Telegram: " token
                read -p "Chat ID Anda: " chatid
                export NODE_ACTION="set_tele"
                export T_TOKEN="$token"
                export T_CHATID="$chatid"
                run_node_script
                read -p "Tekan Enter..."
                ;;
            2)
                read -p "Aktifkan Auto-Backup? (y/n): " set_auto
                if [ "$set_auto" == "y" ] || [ "$set_auto" == "Y" ]; then
                    export B_STATUS="true"
                    read -p "Berapa MENIT sekali? (Contoh: 60): " menit
                    if ! [[ "$menit" =~ ^[0-9]+$ ]]; then menit=720; fi
                    export B_MENIT="$menit"
                    echo -e "\n${C_GREEN}✅ Auto-Backup DIAKTIFKAN setiap $menit menit!${C_RST}"
                else
                    export B_STATUS="false"
                    export B_MENIT="720"
                    echo -e "\n${C_RED}❌ Auto-Backup DIMATIKAN!${C_RST}"
                fi
                export NODE_ACTION="set_auto_backup"
                run_node_script
                read -p "Tekan Enter..."
                ;;
            0) break ;;
            *) echo -e "${C_RED}❌ Pilihan tidak valid!${C_RST}"; sleep 1 ;;
        esac
    done
}

menu_backup() {
    while true; do
        clear
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "${C_YELLOW}${C_BOLD}                💾 BACKUP & RESTORE 💾                ${C_RST}"
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "  ${C_GREEN}[1]${C_RST} Backup Data (Kirim ke Telegram)"
        echo -e "  ${C_GREEN}[2]${C_RST} Restore Database dari Link ZIP"
        echo -e "${C_CYAN}------------------------------------------------------${C_RST}"
        echo -e "  ${C_RED}[0]${C_RST} Kembali ke Panel Utama"
        echo -e "${C_CYAN}======================================================${C_RST}"
        echo -ne "${C_YELLOW}Pilih menu [0-2]: ${C_RST}"
        read backchoice

        case $backchoice in
            1)
                echo -e "\n${C_MAG}⏳ Sedang memproses arsip backup...${C_RST}"
                if ! command -v zip &> /dev/null; then sudo apt install zip -y > /dev/null 2>&1; fi
                cd "$PROJECT_DIR"
                rm -f backup.zip
                if [ -d "/etc/letsencrypt" ]; then sudo tar -czf ssl_backup.tar.gz -C / etc/letsencrypt 2>/dev/null; fi
                zip backup.zip config.json database.json trx.json produk.json info.json topup.json global_stats.json ssl_backup.tar.gz 2>/dev/null
                echo -e "${C_GREEN}✅ File backup.zip berhasil dikompresi!${C_RST}"
                export NODE_ACTION="backup_now"
                run_node_script
                read -p "Tekan Enter..."
                ;;
            2)
                echo -e "\n${C_RED}${C_BOLD}⚠️ PERHATIAN: Restore akan MENIMPA database Anda saat ini!${C_RST}"
                read -p "Apakah Anda yakin ingin melanjutkan? (y/n): " yakin
                if [ "$yakin" == "y" ] || [ "$yakin" == "Y" ]; then
                    read -p "🔗 Masukkan Direct Link file ZIP Backup Anda: " linkzip
                    if [ ! -z "$linkzip" ]; then
                        cd "$PROJECT_DIR"
                        wget -qO restore.zip "$linkzip"
                        if [ -f "restore.zip" ]; then
                            if ! command -v unzip &> /dev/null; then sudo apt install unzip -y > /dev/null 2>&1; fi
                            unzip -o restore.zip > /dev/null 2>&1
                            if [ -f "ssl_backup.tar.gz" ]; then
                                sudo tar -xzf ssl_backup.tar.gz -C / 2>/dev/null
                                echo -e "${C_GREEN}✅ Sertifikat SSL berhasil direstore!${C_RST}"
                            fi
                            rm restore.zip
                            echo -e "\n${C_GREEN}${C_BOLD}✅ RESTORE BERHASIL SEPENUHNYA!${C_RST}"
                        else
                            echo -e "${C_RED}❌ Gagal mendownload file.${C_RST}"
                        fi
                    fi
                fi
                read -p "Tekan Enter untuk kembali..."
                ;;
            0) break ;;
            *) echo -e "${C_RED}❌ Pilihan tidak valid!${C_RST}"; sleep 1 ;;
        esac
    done
}

while true; do
    clear
    echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
    echo -e "${C_YELLOW}${C_BOLD}             🤖 PANEL ADMIN FIKY STORE 🤖             ${C_RST}"
    echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
    echo -e "${C_MAG}▶ MANAJEMEN BOT & WEB APP${C_RST}"
    echo -e "  ${C_GREEN}[1]${C_RST}  Mulai Bot (Terminal / Scan QR)"
    echo -e "  ${C_GREEN}[2]${C_RST}  Jalankan Sistem Latar Belakang (PM2)"
    echo -e "  ${C_GREEN}[3]${C_RST}  Hentikan Sistem (PM2)"
    echo -e "  ${C_GREEN}[4]${C_RST}  Lihat Log Error Server"
    echo ""
    echo -e "${C_MAG}▶ MANAJEMEN TOKO & SISTEM${C_RST}"
    echo -e "  ${C_GREEN}[5]${C_RST}  👥 Manajemen Saldo Member"
    echo -e "  ${C_GREEN}[6]${C_RST}  ⚙️ Pengaturan Bot Telegram (Auto-Backup)"
    echo -e "  ${C_GREEN}[7]${C_RST}  💾 Backup & Restore Database"
    echo -e "  ${C_GREEN}[8]${C_RST}  🔌 Ganti API Digiflazz"
    echo -e "  ${C_GREEN}[9]${C_RST}  🔄 Ganti Akun Bot WA (Reset Sesi)"
    echo -e "  ${C_GREEN}[10]${C_RST} 📢 Kirim Pemberitahuan ke Website"
    echo -e "  ${C_GREEN}[11]${C_RST} 💳 Setup GoPay Merchant API (QRIS Dinamis)"
    echo -e "  ${C_GREEN}[12]${C_RST} 🌍 Setup Domain & HTTPS (SSL)"
    echo -e "  ${C_GREEN}[13]${C_RST} 🖼️ Ganti Foto Banner Promo"
    echo -e "  ${C_GREEN}[14]${C_RST} 💬 Kirim Pesan Langsung (Japri) WA"
    echo -e "  ${C_GREEN}[15]${C_RST} 🛒 Import Produk Excel Digiflazz (Segera Hadir)"
    echo -e "${C_CYAN}------------------------------------------------------${C_RST}"
    echo -e "  ${C_GREEN}[16]${C_RST} 🚀 Update Script (Pull dari GitHub)"
    echo -e "${C_CYAN}======================================================${C_RST}"
    echo -e "  ${C_RED}[0]${C_RST}  Keluar dari Panel"
    echo -e "${C_CYAN}======================================================${C_RST}"
    echo -ne "${C_YELLOW}Pilih menu [0-16]: ${C_RST}"
    read choice

    case $choice in
        1) 
            cd "$PROJECT_DIR"
            if [ ! -d "sesi_bot" ]; then
                read -p "📲 Masukkan Nomor WA Bot (Awali 628...): " nomor_bot
                if [ ! -z "$nomor_bot" ]; then node -e "const crypt=require('./fiky_crypt.js');let cfg=crypt.load('config.json');cfg.botNumber='$nomor_bot';crypt.save('config.json',cfg);"; fi
            fi
            pm2 stop $BOT_NAME > /dev/null 2>&1; fuser -k $PORT/tcp > /dev/null 2>&1
            echo -e "\n${C_MAG}⏳ Menjalankan bot... (Tekan CTRL+C untuk mematikan dan kembali ke menu)${C_RST}"
            node index.js
            read -p "Tekan Enter untuk kembali..." ;;
        2) 
            cd "$PROJECT_DIR"
            pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save
            echo -e "\n${C_GREEN}✅ Sistem berjalan 24 jam!${C_RST}"
            read -p "Tekan Enter..." ;;
        3) 
            pm2 stop $BOT_NAME >/dev/null 2>&1
            echo -e "\n${C_GREEN}✅ Sistem dihentikan.${C_RST}"
            read -p "Tekan Enter..." ;;
        4) pm2 logs $BOT_NAME ;;
        5) 
            echo -e "\n${C_MAG}--- TAMBAH / UBAH SALDO MEMBER ---${C_RST}"
            read -p "ID Member (No WA / Email): " nomor
            read -p "Jumlah Saldo (Gunakan minus '-' untuk mengurangi): " jumlah
            export NODE_ACTION="add_saldo"
            export T_NOMOR="$nomor"
            export T_JUMLAH="$jumlah"
            run_node_script
            read -p "Tekan Enter..." ;;
        6) menu_telegram ;;
        7) menu_backup ;;
        8)
            echo -e "\n${C_MAG}--- GANTI API DIGIFLAZZ ---${C_RST}"
            read -p "Username Digiflazz Baru: " user_api
            read -p "API Key Digiflazz Baru: " key_api
            export NODE_ACTION="set_digi"
            export D_USER="$user_api"
            export D_KEY="$key_api"
            run_node_script
            read -p "Tekan Enter untuk kembali..."
            ;;
        9)
            echo -e "\n${C_RED}⚠️ Reset Sesi akan mengeluarkan bot dari WhatsApp saat ini.${C_RST}"
            read -p "Yakin ingin mereset sesi? (y/n): " reset_sesi
            if [ "$reset_sesi" == "y" ]; then
                pm2 stop $BOT_NAME >/dev/null 2>&1
                rm -rf "$PROJECT_DIR/sesi_bot"
                echo -e "${C_GREEN}✅ Sesi berhasil dihapus. Silakan jalankan bot kembali (Menu 1).${C_RST}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        10)
            echo -e "\n${C_MAG}--- KIRIM PEMBERITAHUAN APLIKASI WEB ---${C_RST}"
            read -p "Judul Pemberitahuan: " notif_title
            read -p "Isi / Deskripsi: " notif_msg
            export NODE_ACTION="add_info"
            export I_TITLE="$notif_title"
            export I_MSG="$notif_msg"
            run_node_script
            read -p "Tekan Enter untuk kembali..."
            ;;
        11)
            echo -e "\n${C_MAG}--- SETUP GOPAY MERCHANT (QRIS DINAMIS) ---${C_RST}"
            read -p "Masukkan Gopay Token Anda: " gopay_token
            read -p "Masukkan Merchant ID (G88...): " gopay_mid
            read -p "Paste TEKS STRING QRIS Anda di sini: " qris_text
            export NODE_ACTION="set_qris"
            export Q_TOK="$gopay_token"
            export Q_MID="$gopay_mid"
            export Q_TXT="$qris_text"
            run_node_script
            read -p "Tekan Enter untuk kembali..."
            ;;
        12)
            echo -e "\n${C_MAG}--- SETUP DOMAIN & HTTPS ---${C_RST}"
            read -p "Masukkan Nama Domain Anda (contoh: fiqystore.com): " domain_name
            read -p "Masukkan Email Aktif (untuk SSL Let's Encrypt): " ssl_email
            if [ ! -z "$domain_name" ] && [ ! -z "$ssl_email" ]; then
                sudo apt install -y nginx certbot python3-certbot-nginx > /dev/null 2>&1
                cat <<EOF_NGINX | sudo tee /etc/nginx/sites-available/$domain_name
server {
    listen 80; server_name $domain_name;
    location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host \$host; proxy_cache_bypass \$http_upgrade; }
}
EOF_NGINX
                sudo ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
                sudo rm -f /etc/nginx/sites-enabled/default
                sudo nginx -t && sudo systemctl restart nginx
                sudo certbot --nginx -d $domain_name --non-interactive --agree-tos -m $ssl_email --redirect
                echo -e "\n${C_GREEN}✅ Berhasil diamankan di: https://$domain_name ${C_RST}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        13)
            echo -e "\n${C_MAG}--- GANTI FOTO BANNER PROMO ---${C_RST}"
            echo -e "${C_YELLOW}Note: Biarkan kosong jika tidak ingin mengubah slide tersebut.${C_RST}"
            read -p "Link Slide 1: " b1
            read -p "Link Slide 2: " b2
            read -p "Link Slide 3: " b3
            read -p "Link Slide 4: " b4
            export NODE_ACTION="set_banner"
            export B1="$b1"
            export B2="$b2"
            export B3="$b3"
            export B4="$b4"
            run_node_script
            read -p "Tekan Enter untuk kembali..."
            ;;
        14)
            echo -e "\n${C_MAG}--- KIRIM PESAN LANGSUNG JAPRI WA ---${C_RST}"
            read -p "Masukkan Nomor Tujuan (Awalan 62/08): " jp_num
            read -p "Masukkan Pesan: " jp_msg
            cd "$PROJECT_DIR"
            node -e "
                const fs = require('fs'); let num = '$jp_num'.replace(/[^0-9]/g, ''); if (num.startsWith('0')) num = '62' + num.slice(1);
                fs.appendFileSync('japri.txt', num + '|' + \`$jp_msg\` + '\n');
                console.log('\x1b[32m✅ Pesan Japri dimasukkan ke antrean pengiriman!\x1b[0m');
            "
            read -p "Tekan Enter untuk kembali..."
            ;;
        15)
            echo -e "\n${C_YELLOW}Fitur Import Excel Digiflazz segera hadir di update selanjutnya!${C_RST}"
            read -p "Tekan Enter untuk kembali..."
            ;;
        16)
            echo -e "\n${C_MAG}--- UPDATE SCRIPT DARI GITHUB ---${C_RST}"
            cd "$HOME"
            wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh
            chmod +x install.sh && ./install.sh
            exit 0
            ;;
        0) exit 0 ;;
        *) echo -e "${C_RED}❌ Pilihan tidak valid!${C_RST}"; sleep 1 ;;
    esac
done
EOF_MENU

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SUKSES V55 ULTIMATE! Silakan ketik 'menu' di terminal."
echo "=========================================================="
