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
echo "   MENGINSTAL DIGITAL FIKY STORE - V38 (PRODUK DIGITAL)   "
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
echo "[3/5] Membangun Antarmuka Website..."

cat << 'EOF' > public/style.css
body {
    background-color: #fde047; margin: 0;
    font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
}
.centered-modal-box {
    background-color: #002147; padding: 3rem 1.5rem 2rem 1.5rem; border-radius: 1.2rem; 
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2); 
    width: 90%; max-width: 360px; text-align: center; position: relative; z-index: 10;
}
.logo-f-metalik-box {
    width: 85px; height: 85px; margin: 0 auto; display: flex; justify-content: center; align-items: center;
    border-radius: 50%; border: 3px solid #94a3b8; background: radial-gradient(circle, #333333 0%, #000000 100%); 
    box-shadow: inset 0 0 10px rgba(255,255,255,0.2), 0 10px 20px rgba(0,0,0,0.5); position: relative;
}
.logo-f-metalik-box::before {
    content: "F"; font-size: 55px; font-family: "Times New Roman", Times, serif; font-weight: bold; color: #e2e8f0; 
    text-shadow: 2px 2px 4px rgba(0,0,0,0.9), -1px -1px 1px rgba(255,255,255,0.3); position: absolute; top: 52%; left: 50%; transform: translate(-50%, -50%);
}
.compact-input-box {
    width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; border-radius: 0.5rem; margin-bottom: 0.85rem; font-size: 0.875rem; 
    outline: none; background-color: #ffffff; color: #0f172a;
}
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.compact-link-small:hover { text-decoration: underline; color: #fef08a; }
.btn-yellow {
    width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s;
}
.btn-yellow:hover { background-color: #facc15; }
.tech-bg {
    position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E");
    background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem;
}
.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Login - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head><body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]"><div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div><div class="centered-modal-box pt-14"><div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4"><h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1></div><h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2><form id="loginForm"><div><label class="compact-label">Email / No. HP</label><input type="text" id="identifier" class="compact-input-box" required placeholder="Ketik disini"></div><div><label class="compact-label">Password</label><div class="relative mb-[0.85rem]"><input type="password" id="password" class="compact-input-box !mb-0 pr-10" required placeholder="Ketik disini"><i class="fas fa-eye absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 cursor-pointer hover:text-gray-700 transition" onclick="togglePassword('password', this)"></i></div></div><div class="text-right mb-5 mt-[-5px]"><a href="/forgot.html" class="compact-link-small">Lupa password?</a></div><button type="submit" class="btn-yellow">Login Sekarang</button></form><div class="mt-6 text-center compact-text-small">Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a></div></div>
<div id="customAlert" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm">
    <div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-[85%] max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700 transform transition-transform scale-100">
        <div id="alertIcon" class="mb-4 text-6xl"></div>
        <h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3>
        <p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p>
        <button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-yellow-500 transition">OKE</button>
    </div>
</div>
<script>
    function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } }
    let alertCallback = null;
    function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; }
    function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); }

    document.getElementById('loginForm').addEventListener('submit', async (e) => { 
        e.preventDefault(); const identifier = document.getElementById('identifier').value; const password = document.getElementById('password').value; 
        try { 
            const res = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) }); 
            const data = await res.json(); 
            if (res.ok) { localStorage.setItem('user', JSON.stringify(data.user)); window.location.href = '/dashboard.html'; } else { showAlert('Login Gagal', data.error, false); } 
        } catch (err) { showAlert('Error', 'Gagal terhubung ke server.', false); } 
    });
</script></body></html>
EOF

cat << 'EOF' > public/register.html
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Daftar - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head><body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]"><div class="z-20 mb-[-42px]" id="logo-header"><div class="logo-f-metalik-box"></div></div><div class="centered-modal-box pt-14" id="box-register"><div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-2"><h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1></div><h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2><form id="registerForm"><div><label class="compact-label">Nama Lengkap</label><input type="text" id="name" class="compact-input-box" required placeholder="Ketik disini"></div><div><label class="compact-label">Nomor WA Aktif</label><input type="number" id="phone" class="compact-input-box" required placeholder="08123..."></div><div><label class="compact-label">Email</label><input type="email" id="email" class="compact-input-box" required placeholder="Ketik disini"></div><div><label class="compact-label">Password</label><div class="relative mb-[0.85rem]"><input type="password" id="password" class="compact-input-box !mb-0 pr-10" required placeholder="Ketik disini"><i class="fas fa-eye absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 cursor-pointer hover:text-gray-700 transition" onclick="togglePassword('password', this)"></i></div></div><button type="submit" class="btn-yellow mt-1">Daftar Sekarang</button></form><div class="mt-4 text-center compact-text-small">Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a></div></div><div class="centered-modal-box pt-14 hidden" id="box-otp"><h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2><p class="compact-text-small mb-5 text-center">4 Digit OTP dikirim ke WA Anda.</p><form id="otpForm"><div><label class="compact-label text-center">Kode OTP</label><input type="number" id="otpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX"></div><button type="submit" class="btn-yellow mt-4">Verifikasi OTP</button></form></div>
<div id="customAlert" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-[85%] max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-yellow-500 transition">OKE</button></div></div>
<script>
    function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } }
    let alertCallback = null;
    function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; }
    function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); }

    let registeredPhone = ''; 
    document.getElementById('registerForm').addEventListener('submit', async (e) => { 
        e.preventDefault(); const name = document.getElementById('name').value; const phone = document.getElementById('phone').value; const email = document.getElementById('email').value; const password = document.getElementById('password').value; 
        try { 
            const res = await fetch('/api/auth/register', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ name, phone, email, password }) }); 
            const data = await res.json(); 
            if (res.ok) { registeredPhone = data.phone; document.getElementById('box-register').classList.add('hidden'); document.getElementById('box-otp').classList.remove('hidden'); showAlert('Berhasil', 'OTP Terkirim ke WhatsApp Anda!', true); } 
            else { showAlert('Pendaftaran Gagal', data.error || 'Terjadi kesalahan.', false); } 
        } catch (err) { showAlert('Error', 'Sistem sedang sibuk atau offline.', false); } 
    }); 
    document.getElementById('otpForm').addEventListener('submit', async (e) => { 
        e.preventDefault(); const otp = document.getElementById('otpCode').value; 
        try { 
            const res = await fetch('/api/auth/verify', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: registeredPhone, otp }) }); 
            const data = await res.json();
            if (res.ok) { showAlert('Verifikasi Sukses!', 'OTP Berhasil! Pendaftaran Selesai.', true, () => { window.location.href = '/'; }); } 
            else { showAlert('Verifikasi Gagal', data.error || 'OTP Salah / Expired.', false); } 
        } catch (err) { showAlert('Error', 'Sistem sedang sibuk.', false); } 
    });
</script></body></html>
EOF

cat << 'EOF' > public/forgot.html
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Lupa Password - DIGITAL FIKY STORE</title><link rel="stylesheet" href="style.css"><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></head><body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]"><div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div><div class="centered-modal-box pt-14"><h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2><form id="requestOtpForm"><p class="compact-text-small mb-5 text-center">Masukkan Nomor WA.</p><input type="number" id="phone" class="compact-input-box text-center" required placeholder="08123..."><button type="submit" class="btn-yellow mt-2">Kirim OTP</button></form><form id="resetForm" class="hidden mt-4"><input type="number" id="otp" class="compact-input-box text-center font-bold" required placeholder="OTP 4 Digit"><div><label class="compact-label mt-2 text-left">Password Baru</label><div class="relative mb-[0.85rem]"><input type="password" id="newPassword" class="compact-input-box !mb-0 pr-10" required placeholder="Ketik disini"><i class="fas fa-eye absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 cursor-pointer hover:text-gray-700 transition" onclick="togglePassword('newPassword', this)"></i></div></div><button type="submit" class="btn-yellow mt-3">Simpan</button></form><div class="mt-6 text-center compact-text-small"><a href="/" class="compact-link-small">Kembali ke Login</a></div></div>
<div id="customAlert" class="fixed inset-0 z-[999] hidden flex items-center justify-center bg-black/60 backdrop-blur-sm"><div class="bg-[#0f172a] rounded-[1.5rem] p-6 w-[85%] max-w-[320px] text-center shadow-[0_10px_40px_rgba(0,0,0,0.5)] border border-gray-700"><div id="alertIcon" class="mb-4 text-6xl"></div><h3 class="text-xl font-bold text-white mb-2 tracking-wide" id="alertTitle">Pemberitahuan</h3><p class="text-sm text-gray-300 mb-6" id="alertMessage">Pesan</p><button onclick="closeAlert()" class="bg-[#facc15] text-[#0f172a] w-full py-3 rounded-xl font-bold tracking-widest shadow-md hover:bg-yellow-500 transition">OKE</button></div></div>
<script>
    function togglePassword(id, icon) { const el = document.getElementById(id); if(el.type === 'password') { el.type = 'text'; icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); } else { el.type = 'password'; icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); } }
    let alertCallback = null;
    function showAlert(title, msg, isSuccess, cb) { document.getElementById('alertTitle').innerText = title; document.getElementById('alertMessage').innerText = msg; document.getElementById('alertIcon').innerHTML = isSuccess ? '<i class="fas fa-check text-green-500"></i>' : '<i class="fas fa-times text-red-500"></i>'; document.getElementById('customAlert').classList.remove('hidden'); alertCallback = cb; }
    function closeAlert() { document.getElementById('customAlert').classList.add('hidden'); if(alertCallback) alertCallback(); }

    let resetPhone=''; 
    document.getElementById('requestOtpForm').addEventListener('submit', async(e)=>{
        e.preventDefault(); resetPhone=document.getElementById('phone').value; 
        try { 
            const res=await fetch('/api/auth/forgot', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({phone:resetPhone})}); 
            const data = await res.json(); 
            if(res.ok){ resetPhone = data.phone; document.getElementById('requestOtpForm').classList.add('hidden'); document.getElementById('resetForm').classList.remove('hidden'); showAlert('Berhasil', 'OTP Terkirim ke WhatsApp Anda!', true); }
            else{ showAlert('Gagal', data.error || 'Gagal mengirim OTP.', false); } 
        } catch(err) { showAlert('Error', 'Gagal terhubung ke server.', false); } 
    }); 
    
    document.getElementById('resetForm').addEventListener('submit', async(e)=>{
        e.preventDefault(); const otp=document.getElementById('otp').value; const newPassword=document.getElementById('newPassword').value; 
        try { 
            const res=await fetch('/api/auth/reset', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify({phone:resetPhone, otp, newPassword})}); 
            const data = await res.json();
            if(res.ok){ showAlert('Berhasil', 'Password berhasil diubah!', true, () => { window.location.href='/'; }); }
            else{ showAlert('Gagal', data.error || 'Kode OTP Salah.', false); } 
        } catch(err) { showAlert('Error', 'Gagal terhubung ke server.', false); } 
    });
</script></body></html>
EOF

# HTML DASHBOARD PPOB PREMIUM (4x2 GRID + PRODUK DIGITAL BARU)
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
            <div class="bg-white/10 text-[11px] font-bold px-3 py-1.5 rounded-full border border-white/20 shadow-sm flex items-center gap-1 text-gray-200">
                0 Trx
            </div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 ease-in-out flex">
            <div class="w-full bg-black bg-opacity-50" onclick="toggleSidebar()"></div>
            <div class="absolute top-0 left-0 w-3/4 max-w-[300px] h-full bg-white dark:bg-[#001229] shadow-2xl flex flex-col transition-colors">
                <div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white relative">
                    <button class="absolute top-3 right-4 text-gray-300 hover:text-white" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button>
                    <div class="w-20 h-20 bg-white rounded-full flex justify-center items-center text-[#002147] font-bold text-3xl mb-3 shadow-inner" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg tracking-wide" id="sidebarName">User Name</h3>
                    <p class="text-sm text-gray-300" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-gray-700 dark:text-gray-200">
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/profile.html'">
                            <i class="far fa-user text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Profil Akun</span>
                        </li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="location.href='/riwayat.html'">
                            <i class="far fa-clock text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Transaksi Saya</span>
                        </li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition">
                            <i class="far fa-bell text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Pemberitahuan</span>
                        </li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="window.open('https://wa.me/6282231154407', '_blank')">
                            <i class="fas fa-headset text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Hubungi Admin</span>
                        </li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition" onclick="toggleDarkMode()">
                            <div class="flex items-center gap-4">
                                <i class="far fa-moon text-xl w-6 text-center"></i> <span class="font-semibold text-sm">Mode Gelap</span>
                            </div>
                            <div class="w-10 h-5 bg-gray-300 dark:bg-blue-500 rounded-full relative transition-colors duration-300" id="darkModeToggleBg">
                                <div class="w-5 h-5 bg-white rounded-full absolute left-0 shadow-md transform transition-transform duration-300" id="darkModeToggleDot"></div>
                            </div>
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
                    <button class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition">ISI SALDO</button>
                    <button class="flex-1 border border-gray-500 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition">BANTUAN</button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-6 relative rounded-2xl h-[170px] overflow-hidden shadow-sm border border-gray-200 dark:border-gray-700 group bg-gray-200 dark:bg-gray-800">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-6">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Layanan Produk</h3>
            <div class="grid grid-cols-4 gap-y-4 gap-x-3">
                
                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-mobile-alt text-3xl text-blue-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PULSA</span>
                </div>
                
                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-globe text-3xl text-green-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">DATA</span>
                </div>
                
                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-gamepad text-3xl text-rose-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">GAME</span>
                </div>

                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-ticket-alt text-3xl text-amber-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">VOUCHER</span>
                </div>

                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-wallet text-3xl text-indigo-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">E-WALLET</span>
                </div>

                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-bolt text-3xl text-yellow-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1">PLN</span>
                </div>

                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="far fa-calendar-check text-3xl text-orange-500 dark:text-yellow-400"></i></div>
                    <span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">MASA<br>AKTIF</span>
                </div>

                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-sim-card text-3xl text-teal-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">PERDANA</span>
                </div>
            </div>
        </div>
        
        <div class="mx-4 mt-6 mb-8">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-4 text-[16px] tracking-wide ml-1">Produk Digital</h3>
            <div class="grid grid-cols-4 gap-y-4 gap-x-3">
                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-file-invoice text-3xl text-purple-500 dark:text-yellow-400"></i></div>
                    <span class="text-[9px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center">TAGIHAN</span>
                </div>
                <div class="bg-white dark:bg-[#0f172a] rounded-2xl p-2 flex flex-col items-center justify-center shadow-sm dark:shadow-none border border-gray-100 dark:border-gray-800 cursor-pointer hover:scale-95 transition-transform aspect-square">
                    <div class="h-8 flex items-center justify-center mb-1"><i class="fas fa-id-card text-3xl text-teal-500 dark:text-yellow-400"></i></div>
                    <span class="text-[8px] font-bold text-[#001229] dark:text-gray-200 tracking-wider mt-1 text-center leading-tight">SALDO<br>E-TOLL</span>
                </div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        const firstName = user.name.split(' ')[0];
        document.getElementById('headerGreeting').innerText = "Hai, " + firstName;
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase();

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); })
        .catch(err => { document.getElementById('displaySaldo').innerText = 'Rp 0'; });

        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); }

        let isDark = localStorage.getItem('darkMode') === 'true';
        const htmlRoot = document.getElementById('html-root');
        const dot = document.getElementById('darkModeToggleDot');
        const bg = document.getElementById('darkModeToggleBg');

        function applyDarkMode() {
            if (isDark) { htmlRoot.classList.add('dark'); dot.classList.add('translate-x-5'); bg.classList.add('bg-blue-500'); } 
            else { htmlRoot.classList.remove('dark'); dot.classList.remove('translate-x-5'); bg.classList.remove('bg-blue-500'); }
        }
        function toggleDarkMode() { isDark = !isDark; localStorage.setItem('darkMode', isDark); applyDarkMode(); }
        applyDarkMode();

        fetch('/api/banners')
        .then(res => res.json())
        .then(data => {
            if(data.banners && data.banners.length > 0 && data.banners[0] !== "") {
                const slider = document.getElementById('promoSlider');
                const dotsContainer = document.getElementById('promoDots');
                
                slider.innerHTML = data.banners.map((url, i) => `
                    <div class="w-full h-full shrink-0 snap-center relative flex items-center justify-center bg-[#002147]">
                        <img src="${url}" class="absolute inset-0 w-full h-full object-cover">
                    </div>
                `).join('');

                let dotsHTML = '';
                for(let i=0; i<data.banners.length; i++){
                    dotsHTML += `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} transition-opacity duration-300 dot-indicator shadow-sm"></div>`;
                }
                dotsContainer.innerHTML = dotsHTML;
            }
            
            const sliderElement = document.getElementById('promoSlider');
            let dots = document.querySelectorAll('.dot-indicator');
            let currentSlide = 0;
            let totalSlides = dots.length || 4;
            
            sliderElement.addEventListener('scroll', () => {
                let slideIndex = Math.round(sliderElement.scrollLeft / sliderElement.clientWidth);
                dots.forEach((dot, index) => {
                    dot.classList.toggle('opacity-100', index === slideIndex);
                    dot.classList.toggle('opacity-40', index !== slideIndex);
                });
                currentSlide = slideIndex;
            });

            setInterval(() => {
                currentSlide = (currentSlide + 1) % totalSlides;
                sliderElement.scrollTo({ left: currentSlide * sliderElement.clientWidth, behavior: 'smooth' });
            }, 3500);
        });
    </script>
</body>
</html>
EOF

# ==========================================
# FILE HALAMAN PROFIL
# ==========================================
cat << 'EOF' > public/profile.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-white dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl">
        <div class="bg-black text-white p-8 flex flex-col items-center relative rounded-b-[2.5rem] shadow-lg">
            <div class="flex items-center justify-center gap-3 mb-2 relative">
                <div class="w-8"></div>
                <div class="w-24 h-24 bg-gray-200 rounded-full flex justify-center items-center text-black font-bold text-4xl border-4 border-gray-400 shadow-xl" id="profileCircle">U</div>
                <div class="w-8 text-xl cursor-pointer hover:text-gray-300 transition flex items-center justify-center"><i class="fas fa-pencil-alt"></i></div>
            </div>
            <h2 class="text-xl font-bold tracking-wide mt-2" id="profileName">Nama Member</h2>
        </div>
        <div class="mt-6">
            <div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-envelope text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Email</div><div class="text-sm text-gray-500 dark:text-gray-400 font-medium" id="profileEmail">email@domain.com</div></div>
            <div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-phone-alt text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">No. Telp</div><div class="text-sm text-gray-500 dark:text-gray-400 font-medium" id="profilePhoneData">0888...</div></div>
            <div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-wallet text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Saldo Akun</div><div class="text-sm font-extrabold text-blue-600 dark:text-yellow-400 tracking-wide" id="profileSaldo">Rp 0</div></div>
            <div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800"><i class="fas fa-shopping-cart text-gray-800 dark:text-gray-300 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-200 ml-2 tracking-wide">Jumlah Transaksi</div><div class="text-[11px] font-bold text-gray-600 bg-gray-100 dark:bg-gray-800 dark:text-gray-300 px-3 py-1.5 rounded-full border border-gray-200 dark:border-gray-700">0 Trx</div></div>
            <div class="flex items-center px-6 py-4 border-b border-gray-100 dark:border-gray-800 cursor-pointer hover:bg-red-50 dark:hover:bg-red-900/20 transition" onclick="logout()"><i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i><div class="flex-1 text-sm font-bold text-red-600 ml-2 tracking-wide">Keluar Akun</div></div>
        </div>
        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>
    </div>
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        document.getElementById('profileName').innerText = user.name;
        document.getElementById('profilePhoneData').innerText = user.phone;
        document.getElementById('profileCircle').innerText = user.name.charAt(0).toUpperCase();
        document.getElementById('profileEmail').innerText = user.email || 'Belum diatur';
        function logout() { localStorage.removeItem('user'); window.location.href = '/'; }
        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('profileSaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); });
        if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark');
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/riwayat.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style> .hide-scrollbar::-webkit-scrollbar { display: none; } </style>
    <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900 font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40">
            <i class="fas fa-arrow-left text-xl cursor-pointer text-gray-300 hover:text-white mr-4" onclick="location.href='/dashboard.html'"></i>
            <h1 class="font-bold text-[17px] tracking-wide flex-1">Riwayat Transaksi</h1>
        </div>

        <div class="mx-4 mt-5 bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm border border-gray-100 dark:border-gray-700">
            <div class="relative mb-4">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                <input type="text" placeholder="Cari transaksi..." class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-xl py-2.5 pl-10 pr-4 text-sm outline-none focus:border-yellow-400 dark:text-gray-200 transition">
            </div>

            <div class="flex gap-2 overflow-x-auto hide-scrollbar pb-1">
                <button class="bg-[#001229] text-yellow-400 px-5 py-1.5 rounded-full text-xs font-bold shrink-0 border border-[#001229] shadow-sm">Semua</button>
                <button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Sukses</button>
                <button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Proses</button>
                <button class="bg-white dark:bg-gray-700 text-gray-600 dark:text-gray-300 px-4 py-1.5 rounded-full text-xs font-semibold shrink-0 border border-gray-200 dark:border-gray-600 hover:bg-gray-50">Gagal</button>
            </div>

            <div class="flex gap-2 mt-4 items-end">
                <div class="flex-1">
                    <label class="text-[10px] font-bold text-gray-500 mb-1 block">Dari</label>
                    <input type="date" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg py-1.5 px-2 text-xs outline-none text-gray-600 dark:text-gray-300">
                </div>
                <div class="flex-1">
                    <label class="text-[10px] font-bold text-gray-500 mb-1 block">Sampai</label>
                    <input type="date" class="w-full bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg py-1.5 px-2 text-xs outline-none text-gray-600 dark:text-gray-300">
                </div>
                <button class="bg-gray-100 dark:bg-gray-700 w-8 h-8 rounded-lg flex items-center justify-center text-gray-500 border border-gray-200 hover:bg-gray-200"><i class="fas fa-sync-alt text-xs"></i></button>
            </div>
        </div>

        <div class="flex flex-col items-center justify-center mt-12 mb-8">
            <div class="w-24 h-24 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4 shadow-inner">
                <i class="fas fa-receipt text-4xl text-gray-400"></i>
            </div>
            <h3 class="font-bold text-[#001229] dark:text-gray-100 text-lg">Belum Ada Transaksi</h3>
            <p class="text-xs text-gray-500 mt-2 text-center max-w-[200px]">Ayo mulai transaksi pertamamu sekarang dan nikmati berbagai promo menarik!</p>
            <button onclick="location.href='/dashboard.html'" class="mt-5 bg-[#001229] text-yellow-400 px-6 py-2.5 rounded-full text-xs font-bold shadow-md hover:bg-[#002147] transition">Transaksi Sekarang</button>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#001229] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.2)] z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-yellow-400"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold tracking-wide">PROFIL</span></div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        if(localStorage.getItem('darkMode') === 'true') document.getElementById('html-root').classList.add('dark');
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS (BACKEND & PENGIRIMAN WA BAILEYS FULL)
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

const sendWhatsAppMessage = async (phone, message) => {
    try {
        if (!global.waSocket) { return false; }
        const jid = phone + '@s.whatsapp.net';
        await global.waSocket.sendMessage(jid, { text: message });
        return true;
    } catch (error) { return false; }
};

app.get('/api/banners', (req, res) => {
    let cfg = loadJSON(configFile); res.json({ banners: cfg.banners });
});

app.post('/api/user/balance', (req, res) => {
    let db = loadJSON(dbFile); res.json({ saldo: db[req.body.phone]?.saldo || 0 });
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let fPhone = phone.toString().replace(/[^0-9]/g, '');
    if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor WA sudah terdaftar.' });
    }
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[fPhone] = { name, email, password, isVerified: false, otp };
    saveJSON(webUsersFile, webUsers);
    
    const pesan = `Halo *${name}*!\nSelamat datang di DIGITAL FIKY STORE.\n\nKode OTP Pendaftaran Anda: *${otp}*\n\n_Mohon jangan berikan kode ini kepada siapapun._`;
    const sent = await sendWhatsAppMessage(fPhone, pesan);
    
    if(sent) { res.json({ message: 'OTP Terkirim', phone: fPhone }); } 
    else { res.status(500).json({ error: 'Gagal mengirim OTP. Pastikan Bot WA sudah aktif di VPS.' }); }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let users = loadJSON(webUsersFile);
    
    let fPhone = phone.toString().replace(/[^0-9]/g, '');
    if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    let cleanOtp = otp.toString().trim();

    if (users[fPhone] && users[fPhone].otp === cleanOtp) {
        users[fPhone].isVerified = true; users[fPhone].otp = null; saveJSON(webUsersFile, users);
        let db = loadJSON(dbFile); if (!db[fPhone]) db[fPhone] = { saldo: 0 }; saveJSON(dbFile, db);
        res.json({ message: 'Verifikasi Sukses!' });
    } else { res.status(400).json({ error: 'Kode OTP Salah.' }); }
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let users = loadJSON(webUsersFile);
    
    let fPhone = identifier.toString().replace(/[^0-9]/g, '');
    if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    
    let foundPhone = Object.keys(users).find(p => (p === fPhone || users[p].email === identifier) && users[p].password === password);
    
    if (foundPhone) {
        if (!users[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' });
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: users[foundPhone].name, email: users[foundPhone].email } });
    } else { res.status(400).json({ error: 'Email/No HP atau Password salah.' }); }
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body;
    let users = loadJSON(webUsersFile);
    
    let fPhone = phone.toString().replace(/[^0-9]/g, '');
    if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    
    if (!users[fPhone]) return res.status(400).json({ error: 'Nomor HP tidak terdaftar.' });
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    users[fPhone].otp = otp; saveJSON(webUsersFile, users);
    
    const pesan = `Halo!\nSeseorang mencoba mereset password akun DIGITAL FIKY STORE Anda.\n\nKode OTP Reset Password: *${otp}*`;
    const sent = await sendWhatsAppMessage(fPhone, pesan);
    
    if(sent) { res.json({ message: 'OTP Terkirim', phone: fPhone }); } 
    else { res.status(500).json({ error: 'Gagal mengirim OTP. Bot offline.' }); }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let users = loadJSON(webUsersFile);
    
    let fPhone = phone.toString().replace(/[^0-9]/g, '');
    if (fPhone.startsWith('0')) fPhone = '62' + fPhone.slice(1);
    let cleanOtp = otp.toString().trim();

    if (users[fPhone] && users[fPhone].otp === cleanOtp) {
        users[fPhone].password = newPassword; users[fPhone].otp = null; saveJSON(webUsersFile, users);
        res.json({ message: 'Password berhasil diubah!' });
    } else { res.status(400).json({ error: 'Kode OTP Salah.' }); }
});

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
                    console.log(`\n=======================================================`);
                    console.log(`🔑 KODE PAIRING ANDA :  ${code}  `);
                    console.log(`=======================================================\n`);
                } catch (error) {}
            }, 3000); 
        }
    }
    
    sock.ev.on('creds.update', saveCreds);
    sock.ev.on('connection.update', (update) => {
        const { connection } = update;
        if(connection === 'close') { startBot(); } else if(connection === 'open') { console.log("✅ BOT WHATSAPP TERHUBUNG!"); }
    });
    global.waSocket = sock; 
}

if (require.main === module) {
    app.listen(3000, () => { console.log('🌐 Web Server berjalan di port 3000'); });
    startBot();
}
EOF

npm install --silent
npm install -g pm2 > /dev/null 2>&1

echo "[5/5] Memperbarui Panel Manajemen..."
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

C=$(tput setaf 6) # Cyan
Y=$(tput setaf 3) # Yellow
G=$(tput setaf 2) # Green
R=$(tput setaf 1) # Red
W=$(tput setaf 7) # White
B=$(tput bold)
N=$(tput sgr0)    # Reset

while true; do
    clear
    echo -e "${C}${B}╔═══════════════════════════════════════════════════╗${N}"
    echo -e "${C}${B}║${N} ${Y}⚡ DIGITAL FIKY STORE - VPS CONTROL PANEL (V38) ⚡${N} ${C}${B}║${N}"
    echo -e "${C}${B}╠═══════════════════════════════════════════════════╣${N}"
    echo -e "${C}${B}║${N} ${W}[ BOT & SERVER MANAGEMENT ]                       ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${G}1.${N} Setup Nomor Bot & Login Pairing WA            ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${G}2.${N} Jalankan Sistem (Start PM2)                   ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${R}3.${N} Hentikan Sistem (Stop PM2)                    ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${Y}4.${N} Lihat Log & Error System                      ${C}${B}║${N}"
    echo -e "${C}${B}╠═══════════════════════════════════════════════════╣${N}"
    echo -e "${C}${B}║${N} ${W}[ DATABASE & DASHBOARD ]                          ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${G}5.${N} 👥 Tambah / Ubah Saldo Member                 ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${G}6.${N} 🖼️ Ganti Foto Banner Promo (Slider)           ${C}${B}║${N}"
    echo -e "${C}${B}╠═══════════════════════════════════════════════════╣${N}"
    echo -e "${C}${B}║${N} ${W}[ SYSTEM UTILITIES ]                              ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${Y}7.${N} Update Script (Pull dari GitHub)              ${C}${B}║${N}"
    echo -e "${C}${B}║${N}  ${R}0.${N} Keluar / Exit Panel                           ${C}${B}║${N}"
    echo -e "${C}${B}╚═══════════════════════════════════════════════════╝${N}"
    echo -e ""
    read -p "${B}Pilih menu [0-7]: ${N}" choice

    case $choice in
        1) 
            cd "$HOME/$DIR_NAME"
            if [ ! -d "sesi_bot" ]; then
                read -p "📲 Masukkan Nomor WA Bot (Awali 628...): " nomor_bot
                if [ ! -z "$nomor_bot" ]; then node -e "const fs=require('fs');let cfg=fs.existsSync('config.json')?JSON.parse(fs.readFileSync('config.json')):{};cfg.botNumber='$nomor_bot';fs.writeFileSync('config.json',JSON.stringify(cfg,null,2));"; fi
            fi
            pm2 stop all > /dev/null 2>&1; fuser -k 3000/tcp > /dev/null 2>&1
            node index.js
            read -p "Tekan Enter untuk kembali..." ;;
        2) 
            cd "$HOME/$DIR_NAME"
            pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save
            echo "✅ Bot dan Web berjalan 24 jam!"
            read -p "Tekan Enter..." ;;
        3) pm2 stop $BOT_NAME; read -p "Tekan Enter..." ;;
        4) pm2 logs $BOT_NAME ;;
        5) 
            read -p "ID Member (No WA): " nomor
            read -p "Jumlah Saldo: " jumlah
            node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(!db['$nomor']) db['$nomor']={saldo:0};db['$nomor'].saldo+=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));console.log('✅ Saldo ditambah!');"
            read -p "Tekan Enter..." ;;
        6)
            echo "--- GANTI FOTO BANNER PROMO ---"
            echo "Masukkan Link URL langsung gambar (diakhiri .jpg atau .png)"
            echo "Tekan Enter saja jika tidak ingin mengubah slide tersebut."
            read -p "Link Slide 1: " b1
            read -p "Link Slide 2: " b2
            read -p "Link Slide 3: " b3
            read -p "Link Slide 4: " b4
            node -e "
                const fs = require('fs');
                let file = '$HOME/$DIR_NAME/config.json';
                let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
                if (!cfg.banners) cfg.banners = ['','','',''];
                if ('$b1'.trim()) cfg.banners[0] = '$b1'.trim();
                if ('$b2'.trim()) cfg.banners[1] = '$b2'.trim();
                if ('$b3'.trim()) cfg.banners[2] = '$b3'.trim();
                if ('$b4'.trim()) cfg.banners[3] = '$b4'.trim();
                fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
                console.log('\n✅ Foto banner berhasil diperbarui! Silakan restart (Menu 2).');
            "
            read -p "Tekan Enter untuk kembali..." ;;
        7)
            cd "$HOME"
            wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh
            chmod +x install.sh && ./install.sh
            exit 0 ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SUKSES! Silakan restart sistem (Menu 2)."
echo "=========================================================="
