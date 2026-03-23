#!/bin/bash
# ==========================================
# INSTALLER DIGITAL FIKY STORE - V50 ULTIMATE
# ==========================================

if [ "$EUID" -ne 0 ]; then echo "Jalankan sebagai root (sudo su)"; exit; fi
if command -v dos2unix > /dev/null 2>&1; then dos2unix "$0" > /dev/null 2>&1; fi

DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

C_RED="\e[31m"
C_GREEN="\e[32m"
C_YELLOW="\e[33m"
C_CYAN="\e[36m"
C_MAG="\e[35m"
C_RST="\e[0m"
C_BOLD="\e[1m"

echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
echo -e "${C_YELLOW}${C_BOLD}   🚀 MENGINSTALL DIGITAL FIKY STORE - V50 ULTIMATE   ${C_RST}"
echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"

# Buka Port Firewall (Sesuai Referensi)
sudo ufw allow 3000/tcp > /dev/null 2>&1 || true
sudo ufw allow 80/tcp > /dev/null 2>&1 || true
sudo ufw allow 443/tcp > /dev/null 2>&1 || true

echo "[1/5] Memperbarui sistem & menginstal Node.js, Zip, Curl..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip -y > /dev/null 2>&1
if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1
fi

echo "[2/5] Membuat direktori dan modul enkripsi..."
mkdir -p "$HOME/$DIR_NAME/public"
cd "$HOME/$DIR_NAME"

# PACKAGE JSON
cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "5.0.0",
  "main": "index.js",
  "dependencies": {
    "@whiskeysockets/baileys": "^6.7.5",
    "@hapi/boom": "^10.0.1",
    "axios": "^1.6.8",
    "body-parser": "^1.20.2",
    "express": "^4.19.2",
    "pino": "^8.20.0",
    "xlsx": "^0.18.5"
  }
}
EOF

# MODUL ENKRIPSI AES-256 (Dari Referensimu)
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
                let parsed = JSON.parse(raw); module.exports.save(file, parsed); return parsed;
            }
            return JSON.parse(decrypt(raw));
        } catch(e) { return defaultData; }
    },
    save: (file, data) => { fs.writeFileSync(file, encrypt(JSON.stringify(data, null, 2))); }
};
EOF

echo "[3/5] Membangun Antarmuka Website (Fiky Store UI)..."
# CSS
cat << 'EOF' > public/style.css
body{background-color:#fde047;margin:0;font-family:ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;}.centered-modal-box{background-color:#002147;padding:3rem 1.5rem 2rem 1.5rem;border-radius:1.2rem;box-shadow:0 20px 25px -5px rgba(0,0,0,0.3),0 10px 10px -5px rgba(0,0,0,0.2);width:90%;max-width:360px;text-align:center;position:relative;z-index:10;}.logo-f-metalik-box{width:85px;height:85px;margin:0 auto;display:flex;justify-content:center;align-items:center;border-radius:50%;border:3px solid #94a3b8;background:radial-gradient(circle,#333333 0%,#000000 100%);box-shadow:inset 0 0 10px rgba(255,255,255,0.2),0 10px 20px rgba(0,0,0,0.5);position:relative;}.logo-f-metalik-box::before{content:"F";font-size:55px;font-family:"Times New Roman",Times,serif;font-weight:bold;color:#e2e8f0;text-shadow:2px 2px 4px rgba(0,0,0,0.9),-1px -1px 1px rgba(255,255,255,0.3);position:absolute;top:52%;left:50%;transform:translate(-50%,-50%);}.compact-input-box{width:100%;padding:0.6rem 0.75rem;border:1px solid #334155;border-radius:0.5rem;margin-bottom:0.85rem;font-size:0.875rem;outline:none;background-color:#ffffff;color:#0f172a;}.compact-input-box:focus{border-color:#fde047;box-shadow:0 0 0 3px rgba(253,224,71,0.3);}::placeholder{color:#94a3b8;font-size:0.8rem;}.compact-text-small{font-size:0.8rem;color:#cbd5e1;}.compact-label{font-size:0.8rem;font-weight:bold;color:#f8fafc;margin-bottom:0.25rem;display:block;text-align:left;}.compact-link-small{font-size:0.8rem;color:#fde047;text-decoration:none;font-weight:bold;}.compact-link-small:hover{text-decoration:underline;color:#fef08a;}.btn-yellow{width:100%;padding:0.625rem 1rem;background-color:#fde047;color:#002147;font-weight:bold;font-size:0.9rem;border-radius:0.5rem;cursor:pointer;border:none;transition:all 0.2s;}.btn-yellow:hover{background-color:#facc15;}.tech-bg{position:absolute;top:0;left:0;right:0;bottom:0;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E");background-size:80px 80px;pointer-events:none;z-index:1;border-radius:1rem;}.hide-scrollbar::-webkit-scrollbar{display:none;}.hide-scrollbar{-ms-overflow-style:none;scrollbar-width:none;}.modal-enter{transform:translateY(0) !important;opacity:1 !important;}
EOF

# HTML AUTH
cat << 'EOF' > public/index.html
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Login - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head><body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]"><div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div><div class="centered-modal-box pt-14"><div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4"><h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1></div><h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2><form id="loginForm"><div><label class="compact-label">Email / No. HP</label><input type="text" id="identifier" class="compact-input-box" required placeholder="Ketik disini"></div><div><label class="compact-label">Password</label><div class="relative mb-[0.85rem]"><input type="password" id="password" class="compact-input-box !mb-0 pr-10" required placeholder="Ketik disini"><i class="fas fa-eye absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 cursor-pointer hover:text-gray-700 transition" onclick="togglePassword('password', this)"></i></div></div><div class="text-right mb-5 mt-[-5px]"><a href="/forgot.html" class="compact-link-small">Lupa password?</a></div><button type="submit" class="btn-yellow" id="btnLogin">Login Sekarang</button></form><div class="mt-6 text-center compact-text-small">Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a></div></div><div id="customAlert" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700 transform transition-transform scale-100"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#001229] dark:bg-[#facc15] text-yellow-400 dark:text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-[#002147] dark:hover:bg-yellow-500 transition">OKE</button></div></div><script>function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } } let alertCallback = null; function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; } function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); } document.getElementById('loginForm').addEventListener('submit', async (e) => { e.preventDefault(); document.getElementById('btnLogin').innerText = 'Memproses...'; const identifier = document.getElementById('identifier').value; const password = document.getElementById('password').value; try { const res = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) }); const data = await res.json(); if (res.ok && data.success) { localStorage.setItem('user', JSON.stringify(data.data)); window.location.href = '/dashboard.html'; } else { showAlert('Login Gagal', data.message || 'Error', false); document.getElementById('btnLogin').innerText = 'Login Sekarang'; } } catch (err) { showAlert('Error', 'Gagal terhubung ke server.', false); document.getElementById('btnLogin').innerText = 'Login Sekarang'; } });</script></body></html>
EOF

# DASHBOARD HTML (Dengan Navigasi Provider)
cat << 'EOF' > public/dashboard.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Dashboard - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl transition-colors duration-300 overflow-x-hidden"><div class="flex justify-between items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40 transition-colors"><div class="flex items-center gap-4"><i class="fas fa-bars text-xl cursor-pointer text-gray-300 hover:text-white transition" onclick="toggleSidebar()"></i><h1 class="font-medium text-[17px] tracking-wide" id="headerGreeting">Hai, Member</h1></div><div class="bg-white/10 text-[11px] font-bold px-3 py-1.5 rounded-full border border-white/20 shadow-sm flex items-center gap-1 text-gray-200" id="top-trx-badge">0 Trx</div></div><div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 ease-in-out flex"><div class="w-full bg-black bg-opacity-50" onclick="toggleSidebar()"></div><div class="absolute top-0 left-0 w-3/4 max-w-[300px] h-full bg-white dark:bg-[#001229] shadow-2xl flex flex-col transition-colors"><div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white relative"><button class="absolute top-3 right-4 text-gray-300 hover:text-white" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button><div class="w-20 h-20 bg-white rounded-full flex justify-center items-center text-[#002147] font-bold text-3xl mb-3 shadow-inner overflow-hidden" id="sidebarInitial">U</div><h3 class="font-bold text-lg tracking-wide" id="sidebarName">User Name</h3><p class="text-sm text-gray-300" id="sidebarPhone">08...</p></div><div class="flex-1 overflow-y-auto py-2"><ul class="text-gray-700 dark:text-gray-200"><li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/profile.html'"><i class="far fa-user text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Profil Akun</span></li><li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/riwayat.html'"><i class="far fa-clock text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Transaksi Saya</span></li><li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/info.html'"><i class="far fa-bell text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Pusat Informasi</span></li><li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="bantuanWA()"><i class="fas fa-headset text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Hubungi Admin</span></li><li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="toggleDarkMode()"><div class="flex items-center gap-4"><i class="far fa-moon text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Mode Gelap</span></div><div class="w-10 h-5 bg-gray-300 dark:bg-blue-500 rounded-full relative transition-colors duration-300" id="darkModeToggleBg"><div class="w-5 h-5 bg-white rounded-full absolute left-0 shadow-md transform transition-transform duration-300" id="darkModeToggleDot"></div></div></li></ul></div></div></div><div class="mx-4 mt-5 bg-[#002147] rounded-3xl p-6 text-white relative overflow-hidden shadow-lg border-b-[5px] border-yellow-400"><div class="tech-bg opacity-70"></div> <div class="text-center relative z-10"><p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p><h2 class="text-4xl font-extrabold mb-6 tracking-tight drop-shadow-md" id="displaySaldo">Rp 0</h2><div class="flex gap-4"><button onclick="openTopupModal()" class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition shadow-md">ISI SALDO</button><button onclick="bantuanWA()" class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition shadow-md">BANTUAN</button></div></div></div><div class="mx-4 mt-6 relative rounded-2xl h-[170px] overflow-hidden shadow-sm border border-gray-200 dark:border-gray-700 group bg-gray-200 dark:bg-gray-800"><div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div><div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div></div><div class="mx-4 mt-6"><h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Layanan Produk</h3><div class="grid grid-cols-4 gap-y-4 gap-x-3"><div onclick="location.href='/provider.html?type=pulsa'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-mobile-alt text-3xl text-blue-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PULSA</span></div><div onclick="location.href='/provider.html?type=data'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-globe text-3xl text-green-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">DATA</span></div><div onclick="location.href='/provider.html?type=game'" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-gamepad text-3xl text-rose-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">GAME</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur pembelian Voucher sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-ticket-alt text-3xl text-amber-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">VOUCHER</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur top up E-Wallet sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-wallet text-3xl text-indigo-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">E-WALLET</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur Token PLN sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-bolt text-3xl text-yellow-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PLN</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur Masa Aktif sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="far fa-calendar-check text-3xl text-orange-500 dark:text-yellow-400"></i></div><span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">MASA<br>AKTIF</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur Perdana sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-sim-card text-3xl text-teal-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">PERDANA</span></div></div></div><div class="mx-4 mt-6 mb-8"><h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Produk Digital</h3><div class="grid grid-cols-4 gap-y-4 gap-x-3"><div onclick="showAlert('Segera Hadir!', 'Fitur pembayaran Tagihan sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-file-invoice text-3xl text-purple-500 dark:text-yellow-400"></i></div><span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">TAGIHAN</span></div><div onclick="showAlert('Segera Hadir!', 'Fitur Saldo E-Toll sedang dalam tahap pengembangan.', false)" class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square"><div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-id-card text-3xl text-teal-500 dark:text-yellow-400"></i></div><span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">SALDO<br>E-TOLL</span></div></div></div><div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40"><div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div></div></div><div id="customAlert" class="fixed inset-0 z-[1001] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700 transform transition-transform scale-100"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-yellow-500 transition">OKE</button></div></div><div id="topupModal" class="fixed inset-0 z-[998] hidden flex items-end sm:items-center justify-center bg-black/60 backdrop-blur-sm transition-all duration-300"><div class="bg-white dark:bg-[#0f172a] w-full max-w-md rounded-t-[2rem] sm:rounded-[1.5rem] p-6 shadow-2xl border-t border-gray-200 dark:border-gray-700 transform transition-transform duration-300 translate-y-full" id="topupModalContent"><div class="flex justify-between items-center mb-5"><h3 class="text-lg font-extrabold text-[#001229] dark:text-white">Isi Saldo</h3><button onclick="closeTopupModal()" class="text-gray-400 hover:text-red-500"><i class="fas fa-times text-xl"></i></button></div><div class="mb-4"><label class="text-[11px] font-bold text-gray-500 block mb-2 ml-1">Nominal Top Up</label><div class="relative"><span class="absolute left-4 top-1/2 transform -translate-y-1/2 font-bold text-[#001229] dark:text-gray-300">Rp</span><input type="number" id="topupNominal" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-3 pl-12 pr-4 text-lg font-bold text-[#001229] dark:text-white outline-none focus:border-yellow-400 transition" placeholder="0"></div></div><div class="grid grid-cols-4 gap-2 mb-6"><button onclick="setNominal(10000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 dark:hover:text-yellow-400 border border-transparent hover:border-yellow-400 transition">10k</button><button onclick="setNominal(20000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 dark:hover:text-yellow-400 border border-transparent hover:border-yellow-400 transition">20k</button><button onclick="setNominal(50000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 dark:hover:text-yellow-400 border border-transparent hover:border-yellow-400 transition">50k</button><button onclick="setNominal(100000)" class="bg-gray-100 dark:bg-gray-800 text-xs font-bold py-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-yellow-50 dark:hover:text-yellow-400 border border-transparent hover:border-yellow-400 transition">100k</button></div><label class="text-[11px] font-bold text-gray-500 block mb-2 ml-1">Metode Pembayaran</label><div class="space-y-3 mb-6"><label class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition method-label" id="lbl-qris"><div class="flex items-center gap-3"><div class="w-10 h-10 bg-blue-50 dark:bg-blue-900/30 rounded-full flex items-center justify-center"><i class="fas fa-qrcode text-xl text-blue-500 dark:text-yellow-400"></i></div><div><p class="text-sm font-bold text-[#001229] dark:text-white">QRIS Otomatis</p><p class="text-[10px] text-gray-500">Bebas biaya admin</p></div></div><input type="radio" name="paymentMethod" value="qris" class="hidden" onchange="selectMethod('qris')"><div class="w-5 h-5 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center radio-indicator" id="radio-qris"><div class="w-2.5 h-2.5 bg-yellow-400 rounded-full hidden inner-dot"></div></div></label><label class="flex items-center justify-between p-3 border border-gray-200 dark:border-gray-700 rounded-xl cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800 transition method-label" id="lbl-manual"><div class="flex items-center gap-3"><div class="w-10 h-10 bg-green-50 dark:bg-green-900/30 rounded-full flex items-center justify-center"><i class="fab fa-whatsapp text-xl text-green-500"></i></div><div><p class="text-sm font-bold text-[#001229] dark:text-white">Transfer Manual (WA)</p><p class="text-[10px] text-gray-500">Konfirmasi ke Admin</p></div></div><input type="radio" name="paymentMethod" value="manual" class="hidden" onchange="selectMethod('manual')"><div class="w-5 h-5 rounded-full border-2 border-gray-300 dark:border-gray-600 flex items-center justify-center radio-indicator" id="radio-manual"><div class="w-2.5 h-2.5 bg-yellow-400 rounded-full hidden inner-dot"></div></div></label></div><button onclick="processTopup()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-3.5 rounded-xl font-bold tracking-wide shadow-lg hover:bg-[#002147] dark:hover:bg-yellow-500 transition text-sm">Lanjutkan Pembayaran</button></div></div><div id="qrisModal" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm p-4"><div class="bg-white dark:bg-[#0f172a] rounded-[1.5rem] p-6 w-full max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-100 dark:border-gray-700 relative"><button onclick="closeQrisModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-white"><i class="fas fa-times text-xl"></i></button><h3 class="text-lg font-extrabold text-[#001229] dark:text-white mb-1">Pembayaran QRIS</h3><p class="text-[11px] text-gray-500 dark:text-gray-400 mb-4">Scan kode QR di bawah ini</p><div class="bg-white p-2 rounded-xl inline-block mb-4 shadow-sm border border-gray-200"><img id="qrisImg" src="" class="w-48 h-48 object-cover rounded-lg"></div><p class="text-xs font-bold text-gray-500 dark:text-gray-400 mb-1">Total Pembayaran</p><h2 class="text-2xl font-extrabold text-blue-600 dark:text-yellow-400 mb-5 tracking-wide" id="qrisAmountDisplay">Rp 0</h2><button onclick="confirmQris()" class="w-full bg-[#001229] dark:bg-yellow-400 text-yellow-400 dark:text-[#001229] py-3 rounded-xl font-bold tracking-wide shadow-md hover:bg-[#002147] dark:hover:bg-yellow-500 transition text-sm">Saya Sudah Bayar</button></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; document.getElementById('headerGreeting').innerText = "Hai, " + user.name; document.getElementById('sidebarName').innerText = user.name; document.getElementById('sidebarPhone').innerText = user.phone; if (user.photo) { document.getElementById('sidebarInitial').innerHTML = `<img src="${user.photo}" class="w-full h-full object-cover">`; } else { document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase(); } function refreshUser() { fetch('/api/user/' + user.phone).then(r=>r.json()).then(d=>{ if(d.success) { localStorage.setItem('user', JSON.stringify(d.data)); document.getElementById('displaySaldo').innerText = 'Rp ' + d.data.saldo.toLocaleString('id-ID'); document.getElementById('top-trx-badge').innerText = (d.data.trx_count || 0) + ' Trx'; } }); } refreshUser(); function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); } let isDark = localStorage.getItem('darkMode') === 'true'; const htmlRoot = document.getElementById('html-root'); const dot = document.getElementById('darkModeToggleDot'); const bg = document.getElementById('darkModeToggleBg'); function applyDarkMode() { if (isDark) { htmlRoot.classList.add('dark'); dot.classList.add('translate-x-5'); bg.classList.add('bg-blue-500'); } else { htmlRoot.classList.remove('dark'); dot.classList.remove('translate-x-5'); bg.classList.remove('bg-blue-500'); } } function toggleDarkMode() { isDark = !isDark; localStorage.setItem('darkMode', isDark); applyDarkMode(); } applyDarkMode(); fetch('/api/banners').then(res => res.json()).then(data => { if(data.success && data.data && data.data.length > 0 && data.data[0] !== "") { const slider = document.getElementById('promoSlider'); const dotsContainer = document.getElementById('promoDots'); slider.innerHTML = data.data.map((url) => `<div class="w-full h-full shrink-0 snap-center relative flex items-center justify-center bg-[#002147]"><img src="${url}" class="absolute inset-0 w-full h-full object-cover"></div>`).join(''); dotsContainer.innerHTML = data.data.map((_, i) => `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} transition-opacity duration-300 dot-indicator shadow-sm"></div>`).join(''); const el = document.getElementById('promoSlider'); let dots = document.querySelectorAll('.dot-indicator'); let cur = 0; el.addEventListener('scroll', () => { let idx = Math.round(el.scrollLeft / el.clientWidth); dots.forEach((d, i) => { d.classList.toggle('opacity-100', i === idx); d.classList.toggle('opacity-40', i !== idx); }); cur = idx; }); setInterval(() => { cur = (cur + 1) % dots.length; el.scrollTo({ left: cur * el.clientWidth, behavior: 'smooth' }); }, 3500); } }); function bantuanWA() { const adminNumber = "6282231154407"; const text = `Halo Admin, saya butuh bantuan terkait aplikasi Digital Fiky Store.\n\nNama: ${user.name}\nNo HP: ${user.phone}`; window.open(`https://wa.me/${adminNumber}?text=${encodeURIComponent(text)}`, '_blank'); } let selectedMethod = ''; function openTopupModal() { document.getElementById('topupModal').classList.remove('hidden'); setTimeout(() => document.getElementById('topupModalContent').classList.add('modal-enter'), 10); } function closeTopupModal() { document.getElementById('topupModalContent').classList.remove('modal-enter'); setTimeout(() => document.getElementById('topupModal').classList.add('hidden'), 300); } function setNominal(val) { document.getElementById('topupNominal').value = val; } function selectMethod(method) { selectedMethod = method; document.querySelectorAll('.method-label').forEach(el => el.classList.remove('border-yellow-400', 'bg-yellow-50', 'dark:bg-gray-800')); document.querySelectorAll('.radio-indicator').forEach(el => el.classList.remove('border-yellow-400')); document.querySelectorAll('.inner-dot').forEach(el => el.classList.add('hidden')); document.getElementById('lbl-' + method).classList.add('border-yellow-400', 'bg-yellow-50', 'dark:bg-gray-800'); document.getElementById('radio-' + method).classList.add('border-yellow-400'); document.querySelector(`#radio-${method} .inner-dot`).classList.remove('hidden'); } let alertCallback = null; function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-tools text-yellow-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; } function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); } async function processTopup() { const nom = document.getElementById('topupNominal').value; if(!nom || nom < 10000) return showAlert('Peringatan', 'Minimal Top Up adalah Rp 10.000', false); if(!selectedMethod) return showAlert('Peringatan', 'Silakan pilih metode pembayaran', false); if(selectedMethod === 'manual') { const adminWA = "6282231154407"; const text = `Halo Admin, saya ingin *Top Up Saldo* (Manual).\n\nNama: ${user.name}\nNo Akun: ${user.phone}\nNominal: *Rp ${parseInt(nom).toLocaleString('id-ID')}*\n\nMohon instruksi pembayarannya.`; closeTopupModal(); window.open(`https://wa.me/${adminWA}?text=${encodeURIComponent(text)}`, '_blank'); } else if (selectedMethod === 'qris') { closeTopupModal(); try { let r = await fetch('/api/topup', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({phone: user.phone, nominal: nom})}); let d = await r.json(); if(d.success) { document.getElementById('qrisAmountDisplay').innerText = 'Rp ' + parseInt(d.total).toLocaleString('id-ID'); document.getElementById('qrisImg').src = d.qris; document.getElementById('qrisModal').classList.remove('hidden'); } else { showAlert('Gagal', d.message || 'Sistem QRIS belum diatur Admin', false); } } catch(e){ showAlert('Error', 'Kesalahan jaringan', false); } } } function closeQrisModal() { document.getElementById('qrisModal').classList.add('hidden'); } function confirmQris() { closeQrisModal(); showAlert('Diproses', 'Sistem sedang mengecek pembayaran QRIS Anda secara otomatis. Saldo akan bertambah jika sukses.', true); }</script></body></html>
EOF

# ==========================================
# FILE NODE.JS (V50 ULTIMATE BACKEND - MENGGABUNGKAN SEMUA FITUR TENDO & FIKY)
# ==========================================
echo "[4/5] Mengatur sistem Backend Ultimate..."
cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, Browsers, fetchLatestBaileysVersion, jidNormalizedUser } = require('@whiskeysockets/baileys');
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

// MENCEGAH AKSES FILE JSON LANGSUNG DARI BROWSER (SECURITY)
app.use((req, res, next) => {
    if (req.path.endsWith('.json')) return res.status(403).json({success: false, message: 'Akses Ditolak'});
    next();
});

const configFile = './config.json';
const dbFile = './database.json';
const webUsersFile = './web_users.json'; // Deprecated in V50, now using database.json for all user data
const infoFile = './info.json'; 
const trxFile = './trx.json';
const produkFile = './produk.json';
const globalStatsFile = './global_stats.json';
const topupFile = './topup.json';

const loadJSON = (file) => crypt.load(file, file === infoFile ? [] : {});
const saveJSON = (file, data) => crypt.save(file, data);

// INISIALISASI DB JIKA KOSONG
loadJSON(dbFile); loadJSON(produkFile); loadJSON(trxFile); loadJSON(globalStatsFile); loadJSON(topupFile);

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

// ==========================================
// FUNGSI KONVERSI QRIS DINAMIS (ANTI GAGAL)
// ==========================================
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

// ==========================================
// ENDPOINT API (MERGED)
// ==========================================
app.get('/api/banners', (req, res) => res.json({ success: true, data: loadJSON(configFile).banners }));
app.get('/api/info', (req, res) => res.json({ data: loadJSON(infoFile).reverse() }));

// Login, Register, User Update dari versi Fiky sebelumnya diadaptasi dengan fiky_crypt dan dbFile tunggal
app.get('/api/user/:phone', (req, res) => {
    let db = loadJSON(dbFile); let p = req.params.phone;
    if(db[p]) { let data = {...db[p]}; delete data.password; res.json({success: true, data}); }
    else res.json({success: false});
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

// ==========================================
// BACKGROUND TASKS (POLLING)
// ==========================================

// Cek GoPay (QRIS Dinamis) Tiap 30 Detik
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

// Cek Transaksi Digiflazz
setInterval(async () => {
    let trxs = loadJSON(trxFile); let keys = Object.keys(trxs); if (keys.length === 0) return;
    let cfg = loadJSON(configFile); let userAPI = (cfg.digiflazzUsername || '').trim(); let keyAPI = (cfg.digiflazzApiKey || '').trim();
    if (!userAPI || !keyAPI) return;

    for (let ref of keys) {
        let trx = trxs[ref]; let signCheck = crypto.createHash('md5').update(userAPI + keyAPI + ref).digest('hex');
        try {
            const cekRes = await axios.post('https://api.digiflazz.com/v1/transaction', { username: userAPI, buyer_sku_code: trx.sku, customer_no: trx.tujuan, ref_id: ref, sign: signCheck });
            const resData = cekRes.data.data;
            if (resData.status === 'Sukses' || resData.status === 'Gagal') {
                let db = loadJSON(dbFile); let senderNum = trx.jid.split('@')[0]; let msg = '';
                if(resData.status === 'Sukses') {
                    msg = `✅ *STATUS: SUKSES*\n\n📦 Produk: ${trx.nama}\n📱 Tujuan: ${trx.tujuan}\n🔑 SN: ${resData.sn || '-'}`;
                    if (db[senderNum] && db[senderNum].history) {
                        let hist = db[senderNum].history.find(h => h.ref_id === ref);
                        if (hist) { hist.status = 'Sukses'; hist.sn = resData.sn || '-'; saveJSON(dbFile, db); }
                    }
                } else {
                    if (db[senderNum]) { 
                        db[senderNum].saldo += trx.harga; 
                        if(db[senderNum].history) {
                            let hist = db[senderNum].history.find(h => h.ref_id === ref);
                            if (hist) hist.status = 'Gagal';
                        }
                        saveJSON(dbFile, db); 
                    }
                    msg = `❌ *STATUS: GAGAL*\n\n📦 Produk: ${trx.nama}\nAlasan: ${resData.message}\n_💰 Saldo dikembalikan._`;
                }
                delete trxs[ref]; saveJSON(trxFile, trxs);
                globalSock.sendMessage(trx.jid, { text: msg }).catch(e => {}); 
            } else if (Date.now() - trx.tanggal > 24 * 60 * 60 * 1000) { delete trxs[ref]; saveJSON(trxFile, trxs); }
        } catch (err) {}
        await new Promise(r => setTimeout(r, 2000)); 
    }
}, 15000); 

// Japri WA Queue
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

// Auto Backup Telegram
function doBackupAndSend() {
    let cfg = loadJSON(configFile);
    if (!cfg.teleToken || !cfg.teleChatId) return;
    exec(`[ -d "/etc/letsencrypt" ] && sudo tar -czf ssl_backup.tar.gz -C / etc/letsencrypt 2>/dev/null; rm -f backup.zip && zip backup.zip config.json database.json trx.json produk.json global_stats.json topup.json info.json ssl_backup.tar.gz 2>/dev/null`, (err) => {
        if (!err) exec(`curl -s -F chat_id="${cfg.teleChatId}" -F document=@"backup.zip" -F caption="📦 Auto-Backup Fiky Store" https://api.telegram.org/bot${cfg.teleToken}/sendDocument`);
    });
}
if (configAwal.autoBackup) setInterval(doBackupAndSend, (configAwal.backupInterval || 720) * 60 * 1000); 

// Baileys Start
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

# ==========================================
# 5. MEMPERBARUI PANEL MENU BASH TERMINAL SULTAN
# ==========================================
echo "[5/5] Memperbarui Panel Manajemen Terminal..."
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
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
                echo -e "\n${C_MAG}--- PENGATURAN BOT TELEGRAM ---${C_RST}"
                read -p "Masukkan Token Bot Telegram: " token
                read -p "Masukkan Chat ID Anda: " chatid
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let config = crypt.load('config.json');
                    config.teleToken = '$token';
                    config.teleChatId = '$chatid';
                    crypt.save('config.json', config);
                    console.log('\x1b[32m\n✅ Data Telegram berhasil disimpan!\x1b[0m');
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            2)
                echo -e "\n${C_MAG}--- SET AUTO BACKUP ---${C_RST}"
                read -p "Aktifkan Auto-Backup ke Telegram? (y/n): " set_auto
                if [ "$set_auto" == "y" ] || [ "$set_auto" == "Y" ]; then
                    status="true"
                    read -p "Berapa MENIT sekali bot harus backup? (Contoh: 60): " menit
                    if ! [[ "$menit" =~ ^[0-9]+$ ]]; then menit=720; fi
                    echo -e "\n${C_GREEN}✅ Auto-Backup DIAKTIFKAN setiap $menit menit!${C_RST}"
                else
                    status="false"
                    menit=720
                    echo -e "\n${C_RED}❌ Auto-Backup DIMATIKAN!${C_RST}"
                fi
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let config = crypt.load('config.json');
                    config.autoBackup = $status;
                    config.backupInterval = parseInt('$menit');
                    crypt.save('config.json', config);
                "
                read -p "Tekan Enter untuk kembali..."
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
                cd "$HOME/$DIR_NAME"
                rm -f backup.zip
                if [ -d "/etc/letsencrypt" ]; then sudo tar -czf ssl_backup.tar.gz -C / etc/letsencrypt 2>/dev/null; fi
                zip backup.zip config.json database.json trx.json produk.json info.json topup.json global_stats.json ssl_backup.tar.gz 2>/dev/null
                echo -e "${C_GREEN}✅ File backup.zip berhasil dikompresi!${C_RST}"
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    const { exec } = require('child_process');
                    let config = crypt.load('config.json');
                    if(config.teleToken && config.teleChatId) {
                        console.log('\x1b[36m⏳ Sedang mengirim ke Telegram...\x1b[0m');
                        let cmd = \`curl -s -F chat_id=\"\${config.teleChatId}\" -F document=@\"backup.zip\" -F caption=\"📦 Manual Backup Data\" https://api.telegram.org/bot\${config.teleToken}/sendDocument\`;
                        exec(cmd, (err) => {
                            if(err) console.log('\x1b[31m❌ Gagal mengirim ke Telegram.\x1b[0m');
                            else console.log('\x1b[32m✅ File Backup berhasil mendarat di Telegram!\x1b[0m');
                        });
                    } else { console.log('\x1b[33m⚠️ Token Telegram belum diisi.\x1b[0m'); }
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            2)
                echo -e "\n${C_RED}${C_BOLD}⚠️ PERHATIAN: Restore akan MENIMPA database Anda saat ini!${C_RST}"
                read -p "Apakah Anda yakin ingin melanjutkan? (y/n): " yakin
                if [ "$yakin" == "y" ] || [ "$yakin" == "Y" ]; then
                    read -p "🔗 Masukkan Direct Link file ZIP Backup Anda: " linkzip
                    if [ ! -z "$linkzip" ]; then
                        cd "$HOME/$DIR_NAME"
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

menu_produk() {
    while true; do
        clear
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "${C_YELLOW}${C_BOLD}             🛒 MANAJEMEN PRODUK BOT 🛒             ${C_RST}"
        echo -e "${C_CYAN}${C_BOLD}======================================================${C_RST}"
        echo -e "  ${C_GREEN}[1]${C_RST} Tambah Produk Baru Manual"
        echo -e "  ${C_GREEN}[2]${C_RST} Edit Produk"
        echo -e "  ${C_GREEN}[3]${C_RST} Hapus Produk"
        echo -e "  ${C_GREEN}[4]${C_RST} Lihat Daftar Produk"
        echo -e "  ${C_GREEN}[5]${C_RST} 🚀 Import Massal via File Digiflazz (.xlsx / .csv)"
        echo -e "  ${C_GREEN}[6]${C_RST} ⚙️ Atur Margin Keuntungan Import (Auto-Pricing)"
        echo -e "${C_CYAN}------------------------------------------------------${C_RST}"
        echo -e "  ${C_RED}[0]${C_RST} Kembali ke Panel Utama"
        echo -e "${C_CYAN}======================================================${C_RST}"
        echo -ne "${C_YELLOW}Pilih menu [0-6]: ${C_RST}"
        read prodchoice

        case $prodchoice in
            1)
                echo -e "\n${C_MAG}--- TAMBAH PRODUK BARU MANUAL ---${C_RST}"
                echo -e "${C_CYAN}Pilih Kategori Utama:${C_RST}"
                echo "1. Pulsa         6. PLN"
                echo "2. Data          7. Tagihan"
                echo "3. Game          8. E-Toll"
                echo "4. Voucher       9. Lainnya"
                echo "5. E-Wallet"
                read -p "👉 Masukkan Nomor Kategori [1-9]: " cat_idx
                
                brand_idx="1"
                if [ "$cat_idx" == "1" ] || [ "$cat_idx" == "2" ] || [ "$cat_idx" == "4" ]; then
                    echo -e "\n${C_CYAN}Pilih Provider:${C_RST}"
                    echo "1. Telkomsel | 2. XL | 3. Axis | 4. Indosat | 5. Tri | 6. Smartfren | 7. By.U"
                    read -p "👉 Masukkan Nomor Provider [1-7]: " brand_idx
                elif [ "$cat_idx" == "5" ]; then
                    echo -e "\n${C_CYAN}Pilih E-Wallet:${C_RST}"
                    echo "1. Gopay | 2. Dana | 3. Shopee Pay | 4. OVO | 5. LinkAja"
                    read -p "👉 Masukkan Nomor E-Wallet [1-5]: " brand_idx
                elif [ "$cat_idx" == "3" ]; then
                    echo -e "\n${C_CYAN}Pilih Game:${C_RST}"
                    echo "1. Mobile Legends | 2. Free Fire | 3. PUBG"
                    read -p "👉 Masukkan Nomor Game [1-3]: " brand_idx
                fi
                
                echo ""
                read -p "Kode Produk (Contoh: TSEL10): " kode
                read -p "Nama Produk (Contoh: Telkomsel 10K): " nama
                read -p "Harga Jual (Contoh: 12000): " harga
                read -p "Deskripsi Produk (Opsional): " deskripsi
                
                export TMP_CAT_IDX="$cat_idx"
                export TMP_BRAND_IDX="$brand_idx"
                export TMP_KODE="$kode"
                export TMP_NAMA="$nama"
                export TMP_HARGA="$harga"
                export TMP_DESC="$deskripsi"
                
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    const catMap = {'1':'Pulsa', '2':'Data', '3':'Game', '4':'Voucher', '5':'E-Money', '6':'PLN', '7':'Tagihan', '8':'E-Toll', '9':'Lainnya'};
                    const brandMap = {
                        'Pulsa': {'1':'Telkomsel', '2':'XL', '3':'Axis', '4':'Indosat', '5':'Tri', '6':'Smartfren', '7':'By.U'},
                        'Data': {'1':'Telkomsel', '2':'XL', '3':'Axis', '4':'Indosat', '5':'Tri', '6':'Smartfren', '7':'By.U'},
                        'Voucher': {'1':'Telkomsel', '2':'XL', '3':'Axis', '4':'Indosat', '5':'Tri', '6':'Smartfren', '7':'By.U'},
                        'E-Money': {'1':'Go Pay', '2':'Dana', '3':'Shopee Pay', '4':'OVO', '5':'LinkAja'},
                        'Game': {'1':'Mobile Legends', '2':'Free Fire', '3':'PUBG'}
                    };
                    
                    let catName = catMap[process.env.TMP_CAT_IDX] || 'Lainnya';
                    let brandName = (brandMap[catName] && brandMap[catName][process.env.TMP_BRAND_IDX]) ? brandMap[catName][process.env.TMP_BRAND_IDX] : 'Lainnya';
                    
                    let produk = crypt.load('produk.json');
                    let key = process.env.TMP_KODE.toUpperCase().replace(/\s+/g, '');
                    produk[key] = { 
                        nama: process.env.TMP_NAMA, 
                        harga: parseInt(process.env.TMP_HARGA),
                        deskripsi: process.env.TMP_DESC,
                        kategori: catName,
                        brand: brandName
                    };
                    crypt.save('produk.json', produk);
                    console.log('\x1b[32m\n✅ Produk [' + key + '] berhasil ditambahkan ke ' + catName + ' - ' + brandName + '!\x1b[0m');
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            2)
                echo -e "\n${C_CYAN}--- DAFTAR PRODUK UNTUK DIEDIT ---${C_RST}"
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json');
                    let keys = Object.keys(produk);
                    if(keys.length === 0) { console.log('\x1b[33mBelum ada produk.\x1b[0m'); process.exit(1); }
                    keys.forEach((k, i) => {
                        let brand = produk[k].brand || 'Lainnya';
                        console.log((i + 1) + '. [' + brand + '] [' + k + '] ' + produk[k].nama);
                    });
                "
                if [ $? -eq 1 ]; then read -p "Tekan Enter untuk kembali..."; continue; fi
                
                echo ""
                read -p "👉 Masukkan NOMOR URUT produk yg ingin diedit: " no_edit
                export NO_EDIT="$no_edit"
                
                eval $(node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json'); let keys = Object.keys(produk);
                    let idx = parseInt(process.env.NO_EDIT) - 1;
                    if(isNaN(idx) || idx < 0 || idx >= keys.length) { console.log('export VALID=false'); } else {
                        let k = keys[idx]; let p = produk[k];
                        console.log('export VALID=true');
                        console.log('export OLD_KODE=\"' + k + '\"');
                        console.log('export OLD_NAMA=\"' + p.nama.replace(/[\"$\\\\]/g, '\\\\$&') + '\"');
                        console.log('export OLD_HARGA=\"' + p.harga + '\"');
                    }
                ")

                if [ "$VALID" != "true" ]; then
                    echo -e "${C_RED}\n❌ Nomor produk tidak valid!${C_RST}"
                    read -p "Tekan Enter untuk kembali..."
                    continue
                fi

                echo -e "\n${C_MAG}--- EDIT PRODUK : $OLD_NAMA ---${C_RST}"
                echo -e "${C_YELLOW}💡 Biarkan kosong (tekan Enter) jika Anda TIDAK INGIN mengubah datanya.${C_RST}"
                
                read -p "Kode Baru [$OLD_KODE]: " new_kode
                read -p "Nama Baru [$OLD_NAMA]: " new_nama
                read -p "Harga Baru [$OLD_HARGA]: " new_harga
                read -p "Deskripsi Baru (Ketik - untuk menghapus): " new_desc
                
                export NEW_KODE="${new_kode:-$OLD_KODE}"
                export NEW_NAMA="$new_nama"
                export NEW_HARGA="$new_harga"
                export NEW_DESC="$new_desc"
                
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json');
                    let oldKey = process.env.OLD_KODE;
                    let newKey = process.env.NEW_KODE.toUpperCase().replace(/\s+/g, '');
                    let item = produk[oldKey];
                    
                    if (process.env.NEW_NAMA && process.env.NEW_NAMA.trim() !== '') item.nama = process.env.NEW_NAMA;
                    if (process.env.NEW_HARGA && process.env.NEW_HARGA.trim() !== '') item.harga = parseInt(process.env.NEW_HARGA);
                    if (process.env.NEW_DESC && process.env.NEW_DESC.trim() !== '') {
                        if (process.env.NEW_DESC.trim() === '-') delete item.deskripsi;
                        else item.deskripsi = process.env.NEW_DESC;
                    }
                    if(!item.brand) item.brand = 'Lainnya';
                    
                    if (oldKey !== newKey) { produk[newKey] = item; delete produk[oldKey]; } else { produk[oldKey] = item; }
                    crypt.save('produk.json', produk);
                    console.log('\x1b[32m\n✅ Perubahan pada produk berhasil disimpan!\x1b[0m');
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            3)
                echo -e "\n${C_CYAN}--- DAFTAR PRODUK UNTUK DIHAPUS ---${C_RST}"
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json');
                    let keys = Object.keys(produk);
                    if(keys.length === 0) { console.log('\x1b[33mBelum ada produk.\x1b[0m'); process.exit(1); }
                    keys.forEach((k, i) => { console.log((i + 1) + '. [' + (produk[k].brand||'Lainnya') + '] [' + k + '] ' + produk[k].nama); });
                "
                if [ $? -eq 1 ]; then read -p "Tekan Enter untuk kembali..."; continue; fi
                
                echo -e "\n${C_RED}⚠️ Hati-hati, produk yang dihapus tidak bisa dikembalikan!${C_RST}"
                read -p "👉 Masukkan NOMOR URUT produk yg ingin dihapus: " no_del
                export NO_DEL="$no_del"

                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json'); let keys = Object.keys(produk);
                    let idx = parseInt(process.env.NO_DEL) - 1;
                    if(isNaN(idx) || idx < 0 || idx >= keys.length) { console.log('\x1b[31m\n❌ Nomor urut produk tidak valid!\x1b[0m'); } else {
                        let key = keys[idx]; let nama = produk[key].nama; delete produk[key]; crypt.save('produk.json', produk);
                        console.log('\x1b[32m\n✅ Produk [' + key + '] ' + nama + ' berhasil dihapus dari database!\x1b[0m');
                    }
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            4)
                echo -e "\n${C_CYAN}--- DAFTAR PRODUK TOKO ---${C_RST}"
                node -e "
                    const crypt = require('./fiky_crypt.js');
                    let produk = crypt.load('produk.json'); let keys = Object.keys(produk);
                    if(keys.length === 0) { console.log('\x1b[33mBelum ada produk.\x1b[0m'); } else {
                        let cats = ['Pulsa', 'Data', 'Game', 'Voucher', 'E-Money', 'PLN', 'Tagihan', 'E-Toll', 'Lainnya'];
                        let count = 0;
                        cats.forEach(c => {
                            let catKeys = keys.filter(k => (produk[k].kategori || 'Lainnya') === c);
                            if(catKeys.length > 0) {
                                console.log('\n\x1b[33m=== KATEGORI: ' + c.toUpperCase() + ' ===\x1b[0m');
                                let brands = [...new Set(catKeys.map(k => produk[k].brand || 'Lainnya'))];
                                brands.forEach(b => {
                                    console.log('\x1b[35m>> Provider: ' + b.toUpperCase() + '\x1b[0m');
                                    let brandKeys = catKeys.filter(k => (produk[k].brand || 'Lainnya') === b);
                                    brandKeys.forEach(k => {
                                        count++;
                                        console.log(count + '. [' + k + '] ' + produk[k].nama + ' - Rp ' + produk[k].harga.toLocaleString('id-ID'));
                                    });
                                });
                            }
                        });
                        console.log('\n\x1b[32mTotal Produk Keseluruhan: ' + keys.length + '\x1b[0m');
                    }
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            5)
                echo -e "\n${C_MAG}--- IMPORT PRODUK VIA EXCEL (.XLSX) / CSV ---${C_RST}"
                echo -e "Sistem Import Cerdas Digiflazz. Pastikan file ada di $(pwd)"
                read -p "Apakah Anda ingin MENGHAPUS produk lama agar bersih? (y/n): " wipe_data
                export WIPE_DATA="$wipe_data"
                read -p "Masukkan nama file lengkap (contoh: produk.xlsx): " nama_file_excel
                if [ ! -f "$nama_file_excel" ]; then
                    echo -e "${C_RED}❌ File tidak ditemukan!${C_RST}"
                else
                    export EXCEL_PATH="$nama_file_excel"
                    node -e "
                        const crypt = require('./fiky_crypt.js'); const xlsx = require('xlsx');
                        try {
                            let config = crypt.load('config.json');
                            let margins = config.margin || { under100: 50, under1000: 200, under5000: 500, under50000: 1000, under100000: 1500, above: 2000 };
                            const workbook = xlsx.readFile(process.env.EXCEL_PATH);
                            const sheet_name = workbook.SheetNames[0];
                            const rawData = xlsx.utils.sheet_to_json(workbook.Sheets[sheet_name]);
                            
                            let produk = {}; if (process.env.WIPE_DATA.toLowerCase() !== 'y') produk = crypt.load('produk.json');
                            let added = 0;
                            
                            rawData.forEach(row => {
                                let keys = Object.keys(row);
                                let getColStrict = (keywords) => keys.find(k => keywords.includes(k.toLowerCase().trim()));
                                let kodeCol = getColStrict(['buyer_sku_code', 'sku', 'kode produk', 'kode']) || keys.find(k => k.toLowerCase().includes('kode'));
                                let namaCol = getColStrict(['product_name', 'nama produk', 'produk', 'nama']) || keys.find(k => k.toLowerCase().includes('nama'));
                                let hargaCol = getColStrict(['price', 'harga']) || keys.find(k => k.toLowerCase().includes('harga'));
                                let statusCol = getColStrict(['buyer_product_status', 'status']);
                                let descCol = getColStrict(['desc', 'deskripsi']);
                                let brandCol = getColStrict(['brand', 'provider', 'operator']);
                                
                                if(!kodeCol || !namaCol || !hargaCol) return;
                                if(statusCol) { let stat = row[statusCol].toString().toLowerCase(); if(stat !== 'normal' && stat !== 'aktif' && stat !== 'active') return; }

                                let kode = row[kodeCol].toString().trim(); let nama = row[namaCol].toString().trim(); let hargaAwal = parseInt(row[hargaCol]);
                                let deskripsi = descCol && row[descCol] ? row[descCol].toString().trim() : 'Proses Otomatis';
                                if(isNaN(hargaAwal)) return;

                                let kategori = 'Lainnya'; let nLower = ' ' + nama.toLowerCase() + ' '; let nUpper = nama.toUpperCase();
                                if (/\b(perdana|aktivasi|kpk)\b/.test(nLower)) kategori = 'Aktivasi Perdana';
                                else if (/\b(voucher|vcr|voc|gesek)\b/.test(nLower)) kategori = 'Voucher';
                                else if (/\b(gopay|ovo|dana|shopee|linkaja|isaku|brizzi|e-toll|etoll|e-money|saldo)\b/.test(nLower)) kategori = 'E-Money';
                                else if (/\b(free fire|ff|mobile legend|mlbb|ml|pubg|diamond|uc|cp|valorant|genshin)\b/.test(nLower)) kategori = 'Game';
                                else if (/\b(pln|token listrik)\b/.test(nLower)) kategori = 'PLN';
                                else if (/\b(masa aktif)\b/.test(nLower)) kategori = 'Masa Aktif';
                                else if (/\b(sms|telpon|telepon|nelpon)\b/.test(nLower)) kategori = 'Paket SMS & Telpon';
                                else if (/\b(gb|mb|data|kuota|internet|combo|xtra|flash|paket|omg|aigo|unlimited)\b/.test(nLower)) kategori = 'Data';
                                else if (/\b(pulsa|promo|reguler)\b/.test(nLower)) kategori = 'Pulsa';
                                else { if (/\b(TELKOMSEL|TSEL|AS|SIMPATI|XL|AXIS|INDOSAT|IM3|TRI|THREE|SMARTFREN|BY\.U)\b/.test(nUpper)) kategori = 'Pulsa'; }

                                let brand = 'Lainnya';
                                if (brandCol && row[brandCol]) { brand = row[brandCol].toString().trim(); }
                                else {
                                    if (kategori === 'E-Money') { if (/\b(gopay)\b/.test(nLower)) brand = 'Go Pay'; else if (/\b(ovo)\b/.test(nLower)) brand = 'OVO'; else if (/\b(dana)\b/.test(nLower)) brand = 'Dana'; else if (/\b(shopee)\b/.test(nLower)) brand = 'ShopeePay'; else if (/\b(linkaja)\b/.test(nLower)) brand = 'LinkAja'; }
                                    else if (kategori === 'Game') { if (/\b(free fire|ff)\b/.test(nLower)) brand = 'Free Fire'; else if (/\b(mobile legend|mlbb|ml)\b/.test(nLower)) brand = 'Mobile Legends'; else if (/\b(pubg|uc)\b/.test(nLower)) brand = 'PUBG'; }
                                    else if (kategori === 'PLN') { brand = 'PLN'; }
                                    else { if (/\b(BY\.U|BYU)\b/.test(nUpper)) brand = 'By.U'; else if (/\b(TELKOMSEL|TSEL|AS|SIMPATI)\b/.test(nUpper)) brand = 'Telkomsel'; else if (/\b(XL)\b/.test(nUpper)) brand = 'XL'; else if (/\b(AXIS)\b/.test(nUpper)) brand = 'Axis'; else if (/\b(INDOSAT|ISAT|IM3)\b/.test(nUpper)) brand = 'Indosat'; else if (/\b(TRI|THREE|BIMA)\b/.test(nUpper)) brand = 'Tri'; else if (/\b(SMARTFREN)\b/.test(nUpper)) brand = 'Smartfren'; }
                                }

                                let margin = 0;
                                if(kategori === 'Pulsa') margin = 1000;
                                else {
                                    if(hargaAwal < 100) margin = margins.under100; else if(hargaAwal < 1000) margin = margins.under1000; else if(hargaAwal < 5000) margin = margins.under5000; else if(hargaAwal < 50000) margin = margins.under50000; else if(hargaAwal < 100000) margin = margins.under100000; else margin = margins.above;
                                }

                                produk[kode] = { nama: nama, harga: hargaAwal + margin, kategori: kategori, brand: brand, deskripsi: deskripsi }; added++;
                            });
                            crypt.save('produk.json', produk);
                            console.log('\x1b[32m\n✅ Berhasil mengimport ' + added + ' produk ke dalam database!\x1b[0m');
                        } catch(err) { console.log('\x1b[31m❌ Gagal memproses file: ' + err.message + '\x1b[0m'); }
                    "
                fi
                read -p "Tekan Enter untuk kembali..."
                ;;
            6)
                echo -e "\n${C_MAG}--- ATUR MARGIN KEUNTUNGAN IMPORT ---${C_RST}"
                echo -e "${C_YELLOW}Tentukan nominal keuntungan (Rp) untuk masing-masing harga modal.${C_RST}"
                read -p "1. Modal di bawah Rp 100: " m_100
                read -p "2. Modal di bawah Rp 1.000: " m_1000
                read -p "3. Modal di bawah Rp 5.000: " m_5000
                read -p "4. Modal di bawah Rp 50.000: " m_50000
                read -p "5. Modal di bawah Rp 100.000: " m_100000
                read -p "6. Modal di atas Rp 100.000: " m_max
                node -e "
                    const crypt = require('./fiky_crypt.js'); let config = crypt.load('config.json');
                    config.margin = { under100: parseInt('$m_100')||0, under1000: parseInt('$m_1000')||0, under5000: parseInt('$m_5000')||0, under50000: parseInt('$m_50000')||0, under100000: parseInt('$m_100000')||0, above: parseInt('$m_max')||0 };
                    crypt.save('config.json', config);
                    console.log('\x1b[32m\n✅ Konfigurasi Margin Keuntungan Berhasil Disimpan!\x1b[0m');
                "
                read -p "Tekan Enter untuk kembali..."
                ;;
            0) break ;;
            *) echo -e "${C_RED}❌ Pilihan tidak valid!${C_RST}"; sleep 1 ;;
        esac
    done
}

# ==========================================
# UTAMA
# ==========================================
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
    echo -e "  ${C_GREEN}[6]${C_RST}  🛒 Manajemen Produk & Harga (XLSX/CSV Import)"
    echo -e "  ${C_GREEN}[7]${C_RST}  ⚙️ Pengaturan Bot Telegram (Auto-Backup)"
    echo -e "  ${C_GREEN}[8]${C_RST}  💾 Backup & Restore Database"
    echo -e "  ${C_GREEN}[9]${C_RST}  🔌 Ganti API Digiflazz"
    echo -e "  ${C_GREEN}[10]${C_RST} 🔄 Ganti Akun Bot WA (Reset Sesi)"
    echo -e "  ${C_GREEN}[11]${C_RST} 📢 Kirim Pemberitahuan ke Website"
    echo -e "  ${C_GREEN}[12]${C_RST} 💬 Kirim Pesan Langsung (Japri) WA"
    echo -e "  ${C_GREEN}[13]${C_RST} 💳 Setup GoPay Merchant API (QRIS Dinamis)"
    echo -e "  ${C_GREEN}[14]${C_RST} 🌍 Setup Domain & HTTPS (SSL)"
    echo -e "  ${C_GREEN}[15]${C_RST} 🖼️ Ganti Foto Banner Promo"
    echo -e "${C_CYAN}======================================================${C_RST}"
    echo -e "  ${C_RED}[0]${C_RST}  Keluar dari Panel"
    echo -e "${C_CYAN}======================================================${C_RST}"
    echo -ne "${C_YELLOW}Pilih menu [0-15]: ${C_RST}"
    read choice

    case $choice in
        1) 
            cd "$HOME/$DIR_NAME"
            if [ ! -d "sesi_bot" ]; then
                read -p "📲 Masukkan Nomor WA Bot (Awali 628...): " nomor_bot
                if [ ! -z "$nomor_bot" ]; then node -e "const crypt=require('./fiky_crypt.js');let cfg=crypt.load('config.json');cfg.botNumber='$nomor_bot';crypt.save('config.json',cfg);"; fi
            fi
            pm2 stop $BOT_NAME > /dev/null 2>&1; fuser -k $PORT/tcp > /dev/null 2>&1
            echo -e "\n${C_MAG}⏳ Menjalankan bot... (Tekan CTRL+C untuk mematikan dan kembali ke menu)${C_RST}"
            node index.js
            read -p "Tekan Enter untuk kembali..." ;;
        2) 
            cd "$HOME/$DIR_NAME"
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
            cd "$HOME/$DIR_NAME"
            node -e "
                const crypt=require('./fiky_crypt.js'); 
                let db=crypt.load('database.json');
                let target = Object.keys(db).find(k => k === '$nomor' || (db[k].email === '$nomor'));
                if(!target) { console.log('❌ Akun tidak ditemukan!'); }
                else { 
                    db[target].saldo += parseInt('$jumlah'); 
                    if(db[target].saldo < 0) db[target].saldo = 0;
                    crypt.save('database.json', db); 
                    console.log('✅ Saldo berhasil diubah!'); 
                }
            "
            read -p "Tekan Enter..." ;;
        6) menu_produk ;;
        7) menu_telegram ;;
        8) menu_backup ;;
        9)
            echo -e "\n${C_MAG}--- GANTI API DIGIFLAZZ ---${C_RST}"
            read -p "Username Digiflazz Baru: " user_api
            read -p "API Key Digiflazz Baru: " key_api
            cd "$HOME/$DIR_NAME"
            node -e "
                const crypt = require('./fiky_crypt.js');
                let config = crypt.load('config.json');
                if('$user_api' !== '') config.digiflazzUsername = '$user_api'.trim();
                if('$key_api' !== '') config.digiflazzApiKey = '$key_api'.trim();
                crypt.save('config.json', config);
                console.log('\x1b[32m\n✅ Konfigurasi Digiflazz berhasil disimpan!\x1b[0m');
            "
            read -p "Tekan Enter untuk kembali..."
            ;;
        10)
            echo -e "\n${C_RED}⚠️ Reset Sesi akan mengeluarkan bot dari WhatsApp saat ini.${C_RST}"
            read -p "Yakin ingin mereset sesi? (y/n): " reset_sesi
            if [ "$reset_sesi" == "y" ]; then pm2 stop $BOT_NAME >/dev/null 2>&1; rm -rf "$HOME/$DIR_NAME/sesi_bot"; echo -e "${C_GREEN}✅ Sesi berhasil dihapus.${C_RST}"; fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        11)
            echo -e "\n${C_MAG}--- KIRIM PEMBERITAHUAN APLIKASI WEB ---${C_RST}"
            read -p "Judul Pemberitahuan: " notif_title
            read -p "Isi / Deskripsi: " notif_msg
            cd "$HOME/$DIR_NAME"
            node -e "
                const crypt = require('./fiky_crypt.js');
                let infos = crypt.load('info.json'); if(!Array.isArray(infos)) infos = [];
                const tgl = new Date().toLocaleDateString('id-ID', {day:'numeric', month:'short', year:'numeric'});
                infos.push({ title: \`$notif_title\`, content: \`$notif_msg\`, date: tgl });
                crypt.save('info.json', infos); console.log('\x1b[32m✅ Info berhasil ditambahkan!\x1b[0m');
            "
            read -p "Tekan Enter untuk kembali..."
            ;;
        12)
            echo -e "\n${C_MAG}--- KIRIM PESAN LANGSUNG JAPRI WA ---${C_RST}"
            echo -e "${C_YELLOW}Catatan: Bot WA harus dalam keadaan hidup (Menu 2).${C_RST}"
            read -p "Masukkan Nomor Tujuan (Awalan 62/08): " jp_num
            read -p "Masukkan Pesan: " jp_msg
            cd "$HOME/$DIR_NAME"
            node -e "
                const fs = require('fs'); let num = '$jp_num'.replace(/[^0-9]/g, ''); if (num.startsWith('0')) num = '62' + num.slice(1);
                fs.appendFileSync('japri.txt', num + '|' + \`$jp_msg\` + '\n');
                console.log('\x1b[32m✅ Pesan Japri dimasukkan ke antrean!\x1b[0m');
            "
            read -p "Tekan Enter untuk kembali..."
            ;;
        13)
            echo -e "\n${C_MAG}--- SETUP GOPAY MERCHANT (QRIS DINAMIS) ---${C_RST}"
            echo -e "${C_YELLOW}Merubah QRIS Statis Anda menjadi Dinamis otomatis!${C_RST}"
            read -p "Masukkan Gopay Token Anda: " gopay_token
            read -p "Masukkan Merchant ID (G88...): " gopay_mid
            read -p "Paste TEKS STRING QRIS Anda di sini: " qris_text
            cd "$HOME/$DIR_NAME"
            node -e "
                const crypt = require('./fiky_crypt.js'); let config = crypt.load('config.json');
                if ('$gopay_token' !== '') config.gopayToken = '$gopay_token'.trim();
                if ('$gopay_mid' !== '') config.gopayMerchantId = '$gopay_mid'.trim();
                if ('$qris_text' !== '') config.qrisText = '$qris_text'.trim();
                crypt.save('config.json', config);
                console.log('\x1b[32m\n✅ Konfigurasi GoPay berhasil disimpan!\x1b[0m');
            "
            read -p "Tekan Enter untuk kembali..."
            ;;
        14)
            echo -e "\n${C_MAG}--- SETUP DOMAIN & HTTPS ---${C_RST}"
            read -p "Masukkan Nama Domain Anda (contoh: fiqystore.com): " domain_name
            read -p "Masukkan Email Aktif (untuk SSL): " ssl_email
            if [ ! -z "$domain_name" ] && [ ! -z "$ssl_email" ]; then
                sudo apt install -y nginx certbot python3-certbot-nginx > /dev/null 2>&1
                cat <<EOF | sudo tee /etc/nginx/sites-available/$domain_name
server { listen 80; server_name $domain_name; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host \$host; proxy_cache_bypass \$http_upgrade; } }
EOF
                sudo ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
                sudo rm -f /etc/nginx/sites-enabled/default
                sudo nginx -t && sudo systemctl restart nginx
                sudo certbot --nginx -d $domain_name --non-interactive --agree-tos -m $ssl_email --redirect
                echo -e "\n${C_GREEN}✅ Berhasil diamankan di: https://$domain_name ${C_RST}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        15)
            echo "--- GANTI FOTO BANNER PROMO ---"
            read -p "Link Slide 1: " b1; read -p "Link Slide 2: " b2; read -p "Link Slide 3: " b3; read -p "Link Slide 4: " b4
            cd "$HOME/$DIR_NAME"
            node -e "
                const crypt = require('./fiky_crypt.js'); let config = crypt.load('config.json');
                if (!config.banners) config.banners = ['','','',''];
                if ('$b1'.trim()) config.banners[0] = '$b1'.trim(); if ('$b2'.trim()) config.banners[1] = '$b2'.trim();
                if ('$b3'.trim()) config.banners[2] = '$b3'.trim(); if ('$b4'.trim()) config.banners[3] = '$b4'.trim();
                crypt.save('config.json', config); console.log('\n✅ Foto banner diperbarui!');
            "
            read -p "Tekan Enter..."
            ;;
        0) exit 0 ;;
        *) echo -e "${C_RED}❌ Pilihan tidak valid!${C_RST}"; sleep 1 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SUKSES V50 ULTIMATE! Silakan ketik 'menu' di terminal."
echo "=========================================================="
