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
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip nginx ufw -y > /dev/null 2>&1

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
body { background-color: #fde047; margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif; }
.centered-modal-box { background-color: #002147; padding: 2.5rem 1.5rem 2rem 1.5rem; border-radius: 1.2rem; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2); width: 90%; max-width: 360px; text-align: center; position: relative; z-index: 10; }
.brand-logo-text { font-size: 1.8rem; font-weight: 900; background: linear-gradient(135deg, #fde047 0%, #facc15 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-shadow: 0px 4px 10px rgba(0,0,0,0.4); margin-bottom: 1.5rem; letter-spacing: 1px; font-family: 'Arial Black', Impact, sans-serif; text-transform: uppercase; line-height: 1.1; }
.logo-f-small { width: 45px; height: 45px; margin: 0 auto 10px auto; display: flex; justify-content: center; align-items: center; border-radius: 50%; border: 2px solid #cbd5e1; background: radial-gradient(circle, #333333 0%, #000000 100%); box-shadow: inset 0 0 5px rgba(255,255,255,0.2), 0 5px 10px rgba(0,0,0,0.5); position: relative; z-index: 2; }
.logo-f-small::before { content: "F"; font-size: 28px; font-family: "Times New Roman", Times, serif; font-weight: bold; color: #e2e8f0; text-shadow: 1px 1px 2px rgba(0,0,0,0.9); position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
.compact-input-wrapper { position: relative; margin-bottom: 0.85rem; width: 100%; }
.compact-input-box { width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; border-radius: 0.5rem; font-size: 0.875rem; outline: none; background-color: #ffffff; color: #0f172a; margin-bottom: 0; }
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
.password-toggle { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #94a3b8; }
.password-toggle:hover { color: #0f172a; }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.compact-link-small:hover { text-decoration: underline; color: #fef08a; }
.btn-yellow { width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s; margin-top: 0.5rem;}
.btn-yellow:hover { background-color: #facc15; }
.tech-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E"); background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem; }
.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
.line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

/* Custom SweetAlert2 Styling */
.swal2-popup { background-color: #002147 !important; border-radius: 1.5rem !important; color: #ffffff !important; border: 1px solid rgba(255, 255, 255, 0.1) !important; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6) !important; width: 320px !important; padding: 1.5rem 1.25rem 1.25rem !important; }
.swal2-title { color: #fde047 !important; font-size: 1.25rem !important; font-weight: 800 !important; letter-spacing: 0.5px !important; margin: 0 0 0.5em !important; }
.swal2-html-container { color: #cbd5e1 !important; font-size: 0.85rem !important; line-height: 1.5 !important; margin: 0.5em 0.2em 1em !important; }
.swal2-confirm { background: linear-gradient(135deg, #facc15 0%, #fde047 100%) !important; color: #001229 !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(253, 224, 71, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-deny { background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%) !important; color: #ffffff !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-cancel { background: linear-gradient(135deg, #ef4444 0%, #f87171 100%) !important; color: #ffffff !important; border-radius: 0.5rem !important; font-weight: 800 !important; padding: 0.6rem 1.5rem !important; font-size: 0.85rem !important; box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3) !important; letter-spacing: 0.5px !important; }
.swal2-icon { transform: scale(0.7) !important; margin: 0 auto 0.5em !important; border-width: 3px !important; }
.slide-down { animation: slideDown 0.3s ease-out forwards; }
@keyframes slideDown { 0% { opacity: 0; transform: translateY(-10px); } 100% { opacity: 1; transform: translateY(0); } }
.animate-slide-up { animation: slideUp 0.3s ease-out forwards; }
@keyframes slideUp { 0% { opacity: 0; transform: scale(0.95) translateY(20px); } 100% { opacity: 1; transform: scale(1) translateY(0); } }
input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
.pb-safe { padding-bottom: calc(1rem + env(safe-area-inset-bottom)); }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="centered-modal-box">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
        <p class="compact-text-small mb-6" id="loginDesc">Silahkan masukkan email/no HP dan password kamu!</p>
        
        <form id="loginForm">
            <div class="compact-input-wrapper">
                <input type="text" id="identifier" class="compact-input-box" required placeholder="Email / No. HP">
            </div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" class="compact-input-box" required placeholder="Password">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('password', this)"></i>
            </div>
            <div class="text-right mb-5 mt-1" id="forgotLink"><a href="/forgot.html" class="text-[0.8rem] text-[#fde047] font-bold">Lupa password?</a></div>
            <button type="submit" class="btn-yellow">Login Sekarang</button>
        </form>

        <form id="otpLoginForm" class="hidden">
            <div class="compact-input-wrapper mb-5">
                <input type="number" id="loginOtpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX">
            </div>
            <button type="submit" class="btn-yellow">Verifikasi & Login</button>
        </form>

        <div class="mt-6 text-center compact-text-small" id="registerLink">Belum punya akun? <a href="/register.html" class="text-[0.8rem] text-[#fde047] font-bold">Daftar disini</a></div>
    </div>

    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { input.type = 'text'; el.classList.remove('fa-eye'); el.classList.add('fa-eye-slash'); } 
            else { input.type = 'password'; el.classList.remove('fa-eye-slash'); el.classList.add('fa-eye'); }
        }
        
        let loginPhone = '';

        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const identifier = document.getElementById('identifier').value; 
            const password = document.getElementById('password').value;
            Swal.fire({title: 'Memeriksa Data...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
            try {
                const res = await fetch('/api/auth/login-req', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ identifier, password }) });
                const data = await res.json();
                if (res.ok) { 
                    loginPhone = data.phone;
                    document.getElementById('loginForm').classList.add('hidden');
                    document.getElementById('forgotLink').classList.add('hidden');
                    document.getElementById('registerLink').classList.add('hidden');
                    document.getElementById('otpLoginForm').classList.remove('hidden');
                    document.getElementById('loginDesc').innerHTML = "Kode OTP Login 4 Digit telah dikirim ke WA Anda.";
                    Swal.fire({ icon: 'success', title: 'Aman!', text: 'Silakan cek WhatsApp Anda untuk kode OTP Login.', background: '#002147', color: '#fff' });
                } 
                else { Swal.fire({ icon: 'error', title: 'Gagal Login', text: data.error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Terjadi kesalahan sistem.', background: '#002147', color: '#fff' }); }
        });

        document.getElementById('otpLoginForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            const otp = document.getElementById('loginOtpCode').value;
            Swal.fire({title: 'Memverifikasi...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }});
            try {
                const res = await fetch('/api/auth/login-verify', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: loginPhone, otp }) });
                const data = await res.json();
                if (res.ok) { 
                    localStorage.setItem('user', JSON.stringify(data.user)); 
                    Swal.fire({ icon: 'success', title: 'Berhasil!', text: 'Login Sukses.', background: '#002147', color: '#fff', timer: 1500, showConfirmButton: false }).then(() => { window.location.href = '/dashboard.html'; }); 
                } 
                else { Swal.fire({ icon: 'error', title: 'OTP Salah', text: data.error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Gagal verifikasi OTP.', background: '#002147', color: '#fff' }); }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/register.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="centered-modal-box" id="box-register">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2>
        <p class="compact-text-small mb-4">Silahkan lengkapi data untuk mendaftar!</p>
        <form id="registerForm">
            <div class="compact-input-wrapper"><input type="text" id="name" class="compact-input-box" required placeholder="Nama Lengkap"></div>
            <div class="compact-input-wrapper"><input type="number" id="phone" class="compact-input-box" required placeholder="Nomor WA (08123...)"></div>
            <div class="compact-input-wrapper"><input type="email" id="email" class="compact-input-box" required placeholder="Email"></div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" class="compact-input-box" required placeholder="Password">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('password', this)"></i>
            </div>
            <button type="submit" class="btn-yellow mt-1">Daftar Sekarang</button>
        </form>
        <div class="mt-4 text-center compact-text-small">Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a></div>
    </div>
    <div class="centered-modal-box hidden" id="box-otp">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2>
        <p class="compact-text-small mb-5 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
        <form id="otpForm">
            <div class="compact-input-wrapper"><input type="number" id="otpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX"></div>
            <button type="submit" class="btn-yellow mt-4">Verifikasi OTP</button>
        </form>
    </div>
    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { input.type = 'text'; el.classList.remove('fa-eye'); el.classList.add('fa-eye-slash'); } 
            else { input.type = 'password'; el.classList.remove('fa-eye-slash'); el.classList.add('fa-eye'); }
        }
        let registeredPhone = '';
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const name = document.getElementById('name').value; const phone = document.getElementById('phone').value; const email = document.getElementById('email').value; const password = document.getElementById('password').value;
            try {
                const res = await fetch('/api/auth/register', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ name, phone, email, password }) });
                const data = await res.json();
                if (res.ok) {
                    registeredPhone = data.phone; document.getElementById('box-register').classList.add('hidden'); document.getElementById('box-otp').classList.remove('hidden');
                    Swal.fire({ icon: 'success', title: 'OTP Terkirim!', text: 'Silakan cek pesan WhatsApp Anda.', background: '#002147', color: '#fff' });
                } else { Swal.fire({ icon: 'error', title: 'Gagal Daftar', text: data.error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Gagal memproses pendaftaran.', background: '#002147', color: '#fff' }); }
        });
        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); const otp = document.getElementById('otpCode').value;
            try {
                const res = await fetch('/api/auth/verify', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: registeredPhone, otp }) });
                if (res.ok) { Swal.fire({ icon: 'success', title: 'Berhasil!', text: 'Akun terverifikasi. Silakan Login.', background: '#002147', color: '#fff' }).then(() => { window.location.href = '/'; }); } 
                else { Swal.fire({ icon: 'error', title: 'OTP Salah', text: (await res.json()).error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Gagal verifikasi OTP.', background: '#002147', color: '#fff' }); }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/forgot.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lupa Password - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="centered-modal-box">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2>
        <form id="requestOtpForm">
            <p class="compact-text-small mb-5 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div class="compact-input-wrapper"><input type="number" id="phone" class="compact-input-box text-center" required placeholder="Ketik disini (08123...)"></div>
            <button type="submit" class="btn-yellow mt-2">Kirim OTP Reset</button>
        </form>
        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-5 border-gray-600">
            <div class="compact-input-wrapper"><label class="compact-label text-center">Kode OTP (4 Digit)</label><input type="number" id="otp" class="compact-input-box text-center text-xl tracking-[0.5em] font-bold" required placeholder="XXXX"></div>
            <div class="compact-input-wrapper"><label class="compact-label text-center mt-2">Password Baru</label>
                <input type="password" id="newPassword" class="compact-input-box" required placeholder="Ketik disini">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('newPassword', this)" style="top:70%;"></i>
            </div>
            <button type="submit" class="btn-yellow mt-3">Simpan Password Baru</button>
        </form>
        <div class="mt-6 text-center compact-text-small">Kembali ke <a href="/" class="compact-link-small">Login</a></div>
    </div>
    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { input.type = 'text'; el.classList.remove('fa-eye'); el.classList.add('fa-eye-slash'); } 
            else { input.type = 'password'; el.classList.remove('fa-eye-slash'); el.classList.add('fa-eye'); }
        }
        let resetPhone = '';
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); const phone = document.getElementById('phone').value;
            try {
                const res = await fetch('/api/auth/forgot', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone }) });
                if (res.ok) {
                    resetPhone = (await res.json()).phone; document.getElementById('requestOtpForm').classList.add('hidden'); document.getElementById('resetForm').classList.remove('hidden');
                    Swal.fire({ icon: 'success', title: 'OTP Terkirim!', text: 'Cek WA Anda.', background: '#002147', color: '#fff' });
                } else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Kesalahan sistem.', background: '#002147', color: '#fff' }); }
        });
        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault(); const otp = document.getElementById('otp').value; const newPassword = document.getElementById('newPassword').value;
            try {
                const res = await fetch('/api/auth/reset', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: resetPhone, otp, newPassword }) });
                if (res.ok) { Swal.fire({ icon: 'success', title: 'Berhasil!', text: 'Password diubah.', background: '#002147', color: '#fff' }).then(() => { window.location.href = '/'; }); } 
                else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error, background: '#002147', color: '#fff' }); }
            } catch (err) { Swal.fire({ icon: 'error', title: 'Oops...', text: 'Kesalahan sistem.', background: '#002147', color: '#fff' }); }
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
                    <div class="w-[4.5rem] h-[4.5rem] bg-white rounded-full flex justify-center items-center text-[#001730] font-extrabold text-3xl mb-3 shadow-md border-2 border-gray-200 dark:border-none overflow-hidden" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg text-gray-800 dark:text-white tracking-wide" id="sidebarName">User Name</h3>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-[14px]">
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/profile.html'"><i class="far fa-user w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Profil Akun</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/riwayat.html'"><i class="far fa-clock w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Transaksi Saya</span></li>
                        <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342] transition" onclick="location.href='/mutasi.html'"><i class="fas fa-exchange-alt w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i> <span class="font-semibold text-gray-800 dark:text-gray-100">Mutasi Saldo</span></li>
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

        <div class="mx-4 mt-4 bg-[#002147] dark:bg-[#111c2e] rounded-[1.2rem] p-4 text-white relative overflow-hidden shadow-lg border border-[#1e3a8a] dark:border-gray-800 transition-colors">
            <div class="tech-bg opacity-30"></div> 
            <div class="relative z-10 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 rounded-xl bg-blue-500/20 flex items-center justify-center text-blue-400 shadow-sm border border-blue-400/20">
                        <i class="fas fa-wallet text-xl"></i>
                    </div>
                    <div class="flex flex-col">
                        <div class="flex items-center gap-2 mb-0.5">
                            <span class="text-xs text-gray-300 font-medium tracking-wide">Saldo Aktif</span>
                            <i class="fas fa-eye-slash text-gray-400 text-xs cursor-pointer hover:text-white transition" onclick="toggleSaldo()" id="eyeSaldo"></i>
                        </div>
                        <h2 class="text-[19px] font-extrabold tracking-tight mt-0.5" id="displaySaldo">Rp •••••••</h2>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <button class="w-10 h-10 rounded-full bg-white/10 border border-white/20 flex items-center justify-center text-white hover:bg-white/20 transition shadow-sm z-10 relative" onclick="bantuanAdmin()" title="Bantuan CS">
                        <i class="fas fa-headset text-[14px]"></i>
                    </button>
                    <button class="bg-yellow-400 text-[#001229] px-5 py-2.5 rounded-full text-[13px] font-extrabold shadow-md hover:bg-yellow-500 transition z-10 relative" onclick="openTopUp()">
                        Topup
                    </button>
                </div>
            </div>
        </div>

        <div id="bannerContainer" class="mx-4 mt-6 relative rounded-[1.2rem] h-[170px] overflow-hidden border border-gray-200 dark:border-gray-800 bg-white dark:bg-[#111c2e] shadow-sm hidden">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-4 bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-[1rem] p-3.5 shadow-sm flex justify-between items-center transition-colors">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center text-[#002147] dark:text-yellow-400 shadow-sm border border-blue-100 dark:border-blue-800/30">
                    <i class="far fa-calendar-alt text-[15px]"></i>
                </div>
                <div class="flex flex-col">
                    <span class="text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Tanggal</span>
                    <span class="text-xs font-extrabold text-gray-800 dark:text-gray-200 tracking-wide" id="realtimeDate">YYYY/MM/DD</span>
                </div>
            </div>
            <div class="h-8 w-px bg-gray-200 dark:bg-gray-700 mx-2"></div>
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Waktu</span>
                    <span class="text-xs font-extrabold text-gray-800 dark:text-gray-200 tracking-widest" id="realtimeClock">00:00:00</span>
                </div>
                <div class="w-9 h-9 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center text-[#002147] dark:text-yellow-400 shadow-sm border border-blue-100 dark:border-blue-800/30">
                    <i class="far fa-clock text-[15px]"></i>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-4">
            <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] tracking-wide ml-1 transition-colors">Layanan Produk</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pulsa'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-mobile-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PULSA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=data'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-globe"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">DATA</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/game.html'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-gamepad"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">GAME</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-ticket-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">VOUCHER</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=ewallet'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-wallet"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">E-WALLET</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pln'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-bolt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PLN</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=masaaktif'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-calendar-check"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase text-center leading-tight transition-colors">MASA<br>AKTIF</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="Swal.fire({icon: 'info', title: 'Menu', text: 'Fitur sedang dikembangkan.'})"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-sim-card"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">PERDANA</span></div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8">
            <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] tracking-wide ml-1 transition-colors">Produk Digital</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=tagihan'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-file-invoice-dollar"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase transition-colors">TAGIHAN</span></div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=etoll'"><div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60 transition-colors"><i class="fas fa-id-card"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 tracking-wide uppercase text-center leading-tight transition-colors">SALDO<br>E-TOLL</span></div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.1)] dark:shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.5)] z-40 transition-colors">
            <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
        </div>

        <div id="topupOverlay" class="fixed inset-0 bg-black/60 z-[110] hidden opacity-0 transition-opacity duration-300" onclick="closeTopUp()"></div>
        <div id="topupSheet" class="fixed bottom-0 left-0 right-0 bg-white dark:bg-[#050b14] z-[120] rounded-t-[2rem] shadow-[0_-10px_40px_rgba(0,0,0,0.3)] transform translate-y-full transition-transform duration-300 max-w-md mx-auto border-t border-gray-200 dark:border-gray-800 pb-safe">
            <div class="w-12 h-1.5 bg-gray-300 dark:bg-gray-700 rounded-full mx-auto my-3"></div>
            <div class="px-6 pb-6">
                <div class="flex justify-between items-center mb-5">
                    <h3 class="font-extrabold text-gray-800 dark:text-white text-[16px] tracking-wide">Isi Saldo</h3>
                    <i class="fas fa-times text-gray-400 hover:text-red-500 cursor-pointer text-xl" onclick="closeTopUp()"></i>
                </div>
                
                <div class="flex items-center gap-3 mb-4">
                    <div class="relative flex-1">
                        <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 font-bold text-sm">Rp</span>
                        <input type="number" id="inputNominal" class="w-full bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-700 rounded-xl py-3 pl-9 pr-3 text-gray-800 dark:text-white font-bold text-base focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 transition-colors shadow-sm" placeholder="Ketik nominal...">
                    </div>
                    <button onclick="prosesTopup()" class="bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-extrabold px-6 py-3 rounded-xl text-sm shadow-md hover:opacity-90 transition-opacity">OK</button>
                </div>
                
                <div class="flex justify-between gap-2 mb-6">
                    <button onclick="setNominal(10000)" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 text-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-[#002147] dark:hover:border-yellow-400 transition-colors text-sm shadow-sm">10K</button>
                    <button onclick="setNominal(20000)" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 text-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-[#002147] dark:hover:border-yellow-400 transition-colors text-sm shadow-sm">20K</button>
                    <button onclick="setNominal(50000)" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 text-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-[#002147] dark:hover:border-yellow-400 transition-colors text-sm shadow-sm">50K</button>
                    <button onclick="setNominal(100000)" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 text-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-[#002147] dark:hover:border-yellow-400 transition-colors text-sm shadow-sm">100K</button>
                </div>

                <div class="flex flex-col gap-3">
                    <div id="method-wa" onclick="selectMethod('wa')" class="flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-[1.2rem] cursor-pointer shadow-sm transition-all hover:border-[#002147] dark:hover:border-yellow-400">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-green-100/50 dark:bg-green-900/20 rounded-full flex items-center justify-center text-[#25D366] text-xl shrink-0"><i class="fab fa-whatsapp"></i></div>
                            <div class="flex flex-col">
                                <span class="font-bold text-gray-800 dark:text-white text-[13px]">Top Up Manual WhatsApp</span>
                                <span class="text-[10px] text-gray-500 dark:text-gray-400 leading-tight mt-0.5">Transfer dengan panduan admin</span>
                            </div>
                        </div>
                        <div id="radio-wa" class="w-5 h-5 rounded-full border-[3px] border-gray-300 dark:border-gray-600 transition-colors bg-transparent mr-1 shrink-0"></div>
                    </div>

                    <div id="method-qris" onclick="selectMethod('qris')" class="flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-[1.2rem] cursor-pointer shadow-sm transition-all hover:border-[#002147] dark:hover:border-yellow-400">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 bg-white rounded-full flex items-center justify-center p-2 border border-gray-200 dark:border-none shrink-0"><img src="https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg" class="w-full object-contain"></div>
                            <div class="flex flex-col">
                                <span class="font-bold text-gray-800 dark:text-white text-[13px]">Top Up Otomatis QRIS</span>
                                <span class="text-[10px] text-gray-500 dark:text-gray-400 leading-tight mt-0.5">Penting: Transfer wajib sesuai nominal<br>hingga 2 digit terakhir!</span>
                            </div>
                        </div>
                        <div id="radio-qris" class="w-5 h-5 rounded-full border-[3px] border-gray-300 dark:border-gray-600 transition-colors bg-transparent mr-1 shrink-0"></div>
                    </div>
                </div>

                <div class="mt-4">
                     <button onclick="location.href='/riwayat_topup.html'" class="w-full py-3.5 bg-yellow-400 text-[#001229] font-extrabold rounded-xl text-sm shadow-md hover:bg-yellow-500 transition-colors">Cek Riwayat Top Up</button>
                </div>
            </div>
        </div>

    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        
        document.getElementById('headerGreeting').innerText = "Hai, " + user.name; 
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        
        if(user.avatar) { document.getElementById('sidebarInitial').innerHTML = `<img src="${user.avatar}" class="w-full h-full rounded-full object-cover border-2 border-gray-200 dark:border-none">`; } 
        else { document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase(); }

        let qrisImageUrl = 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg';
        let selectedMethod = '';
        let timerInterval;
        let currentSaldo = 0;
        let isSaldoHidden = localStorage.getItem('hideSaldo') === 'true';

        function updateDateTime() {
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            
            const dateEl = document.getElementById('realtimeDate');
            const clockEl = document.getElementById('realtimeClock');
            
            if(dateEl) dateEl.innerText = `${year}/${month}/${date}`;
            if(clockEl) clockEl.innerText = `${hours}:${minutes}:${seconds}`;
        }
        setInterval(updateDateTime, 1000);
        updateDateTime();

        function updateSaldoDisplay() {
            const el = document.getElementById('displaySaldo');
            const eye = document.getElementById('eyeSaldo');
            if(isSaldoHidden) {
                el.innerText = 'Rp •••••••';
                eye.className = 'fas fa-eye-slash text-gray-400 text-xs cursor-pointer hover:text-white transition';
            } else {
                el.innerText = 'Rp ' + currentSaldo.toLocaleString('id-ID');
                eye.className = 'fas fa-eye text-gray-400 text-xs cursor-pointer hover:text-white transition';
            }
        }

        function toggleSaldo() {
            isSaldoHidden = !isSaldoHidden;
            localStorage.setItem('hideSaldo', isSaldoHidden);
            updateSaldoDisplay();
        }

        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); }

        function applyDarkMode() {
            const isDark = localStorage.getItem('darkMode') === 'true';
            const root = document.getElementById('html-root'); const dot = document.getElementById('darkModeToggleDot'); const bg = document.getElementById('darkModeToggleBg');
            if (isDark) { root.classList.add('dark'); if(dot) dot.classList.add('translate-x-5'); if(bg) bg.classList.replace('bg-gray-300', 'bg-blue-500'); } 
            else { root.classList.remove('dark'); if(dot) dot.classList.remove('translate-x-5'); if(bg) bg.classList.replace('bg-blue-500', 'bg-gray-300'); }
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
        .then(res => res.json()).then(data => { 
            currentSaldo = data.saldo; 
            updateSaldoDisplay(); 
        });

        fetch('/api/config').then(res => res.json()).then(data => {
            if(data.qrisUrl) qrisImageUrl = data.qrisUrl;
            if(data.banners && data.banners.length > 0 && data.banners[0] !== "") {
                document.getElementById('bannerContainer').classList.remove('hidden');
                const slider = document.getElementById('promoSlider'); const dotsContainer = document.getElementById('promoDots');
                slider.innerHTML = data.banners.map(url => `<div class="w-full h-full shrink-0 snap-center relative"><img src="${url}" class="absolute inset-0 w-full h-full object-cover"></div>`).join('');
                let dotsHTML = ''; for(let i=0; i<data.banners.length; i++) dotsHTML += `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} dot-indicator shadow-sm"></div>`;
                dotsContainer.innerHTML = dotsHTML;
                const sliderElement = document.getElementById('promoSlider'); let dots = document.querySelectorAll('.dot-indicator'); let currentSlide = 0;
                sliderElement.addEventListener('scroll', () => {
                    let slideIndex = Math.round(sliderElement.scrollLeft / sliderElement.clientWidth);
                    dots.forEach((dot, idx) => { dot.classList.toggle('opacity-100', idx === slideIndex); dot.classList.toggle('opacity-40', idx !== slideIndex); });
                    currentSlide = slideIndex;
                });
                setInterval(() => { currentSlide = (currentSlide + 1) % (dots.length||1); sliderElement.scrollTo({ left: currentSlide * sliderElement.clientWidth, behavior: 'smooth' }); }, 3500);
            }
        });

        function openTopUp() {
            const sheet = document.getElementById('topupSheet');
            const overlay = document.getElementById('topupOverlay');
            overlay.classList.remove('hidden');
            setTimeout(() => { overlay.classList.remove('opacity-0'); sheet.classList.remove('translate-y-full'); }, 10);
        }

        function closeTopUp() {
            const sheet = document.getElementById('topupSheet');
            const overlay = document.getElementById('topupOverlay');
            sheet.classList.add('translate-y-full');
            overlay.classList.add('opacity-0');
            setTimeout(() => { overlay.classList.add('hidden'); }, 300);
        }

        function setNominal(amount) { document.getElementById('inputNominal').value = amount; }

        function selectMethod(method) {
            selectedMethod = method;
            const rWa = document.getElementById('radio-wa'); const rQris = document.getElementById('radio-qris');
            const mWa = document.getElementById('method-wa'); const mQris = document.getElementById('method-qris');
            const isDark = localStorage.getItem('darkMode') === 'true';

            rWa.className = 'w-5 h-5 rounded-full border-[3px] border-gray-300 dark:border-gray-600 transition-colors bg-transparent mr-1 shrink-0';
            rQris.className = 'w-5 h-5 rounded-full border-[3px] border-gray-300 dark:border-gray-600 transition-colors bg-transparent mr-1 shrink-0';
            mWa.className = 'flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-[1.2rem] cursor-pointer shadow-sm transition-all hover:border-[#002147] dark:hover:border-yellow-400';
            mQris.className = 'flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-[1.2rem] cursor-pointer shadow-sm transition-all hover:border-[#002147] dark:hover:border-yellow-400';
            
            if(method === 'wa') {
                rWa.className = 'w-5 h-5 rounded-full border-[6px] border-[#002147] dark:border-yellow-400 bg-white dark:bg-[#050b14] transition-colors mr-1 shrink-0';
                mWa.classList.add(isDark ? 'border-yellow-400' : 'border-[#002147]'); mWa.classList.remove('border-gray-200', 'dark:border-gray-800');
            } else if(method === 'qris') {
                rQris.className = 'w-5 h-5 rounded-full border-[6px] border-[#002147] dark:border-yellow-400 bg-white dark:bg-[#050b14] transition-colors mr-1 shrink-0';
                mQris.classList.add(isDark ? 'border-yellow-400' : 'border-[#002147]'); mQris.classList.remove('border-gray-200', 'dark:border-gray-800');
            }
        }

        async function prosesTopup() {
            const nominalBase = parseInt(document.getElementById('inputNominal').value);
            const isDark = localStorage.getItem('darkMode') === 'true';
            const bgPopup = isDark ? '#0b1320' : '#ffffff';

            if(!nominalBase || nominalBase <= 0) return Swal.fire({icon:'warning', title:'Gagal', text:'Masukkan nominal yang valid!', background: bgPopup, color: isDark?'#fff':'#000'});
            if(!selectedMethod) return Swal.fire({icon:'warning', title:'Gagal', text:'Pilih metode WA atau QRIS di bawah!', background: bgPopup, color: isDark?'#fff':'#000'});

            const uniqueCode = Math.floor(Math.random() * 90) + 10; 
            const finalNominal = nominalBase + uniqueCode;

            if(selectedMethod === 'qris') {
                if(nominalBase < 10000) return Swal.fire({icon:'warning', title:'Gagal', text:'Minimal top up QRIS adalah Rp 10.000', background: bgPopup, color: isDark?'#fff':'#000'});
                
                closeTopUp(); 
                const formatted = 'Rp ' + finalNominal.toLocaleString('id-ID');

                await fetch('/api/topup/request', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ phone: user.phone, method: 'QRIS Otomatis', nominal: finalNominal }) });
                
                setTimeout(() => {
                    Swal.fire({
                        title: `<span class="font-bold ${isDark ? 'text-white' : 'text-gray-800'} text-lg">Scan QRIS</span>`,
                        html: `
                            <div class="flex flex-col items-center mt-2">
                                <p class="text-sm text-gray-500 dark:text-gray-400 mb-1">Total Pembayaran</p>
                                <p class="text-4xl text-yellow-500 font-extrabold mb-2">${formatted}</p>
                                <div class="bg-red-100 text-red-600 px-3 py-1 rounded-full text-xs font-bold mb-3 flex items-center gap-1 animate-pulse">
                                    <i class="far fa-clock"></i> Sisa Waktu: <span id="qrisTimer">05:00</span>
                                </div>
                                <div class="bg-white p-3 rounded-xl shadow-md mb-4 inline-block border border-gray-200">
                                    <img src="${qrisImageUrl}" alt="QRIS" class="w-48 h-48 object-cover rounded-lg">
                                </div>
                                <div class="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-3 w-full text-left">
                                    <p class="text-[11px] text-blue-600 dark:text-blue-400 m-0 leading-tight"><i class="fas fa-exclamation-triangle mr-1"></i><b>PENTING:</b> Pastikan transfer <b>TEPAT</b> sesuai nominal di atas (termasuk 2 digit terakhir) agar saldo masuk otomatis.</p>
                                </div>
                            </div>
                        `,
                        showDenyButton: true,
                        showCancelButton: true,
                        confirmButtonText: 'Sudah Transfer', 
                        denyButtonText: 'Cek Riwayat',
                        cancelButtonText: 'Tutup', 
                        confirmButtonColor: isDark ? '#facc15' : '#002147', 
                        denyButtonColor: '#3b82f6',
                        cancelButtonColor: '#ef4444', 
                        background: bgPopup, 
                        customClass: { 
                            confirmButton: isDark ? 'text-[#001229] font-bold' : 'text-white font-bold',
                            denyButton: 'text-white font-bold',
                            cancelButton: 'text-white font-bold'
                        },
                        didOpen: () => {
                            let timeLeft = 5 * 60;
                            const timerEl = document.getElementById('qrisTimer');
                            timerInterval = setInterval(() => {
                                timeLeft--;
                                let m = Math.floor(timeLeft / 60).toString().padStart(2, '0');
                                let s = (timeLeft % 60).toString().padStart(2, '0');
                                if(timerEl) timerEl.innerText = `${m}:${s}`;
                                if(timeLeft <= 0) {
                                    clearInterval(timerInterval);
                                    Swal.close();
                                    Swal.fire({icon: 'error', title: 'Waktu Habis', text: 'Sesi pembayaran QRIS Anda telah kedaluwarsa.', background: bgPopup, color: isDark?'#fff':'#000'}).then(() => { location.href = '/riwayat_topup.html'; });
                                }
                            }, 1000);
                        },
                        willClose: () => {
                            if(timerInterval) clearInterval(timerInterval);
                        }
                    }).then((res) => { 
                        if (res.isConfirmed) { 
                            Swal.fire({icon: 'success', title: 'Sedang Diproses', text: 'Sistem memverifikasi pembayaran Anda...', timer: 3000, showConfirmButton: false, background: bgPopup, color: isDark ? '#fff' : '#000'}).then(() => { location.href = '/riwayat_topup.html'; }); 
                        } else if (res.isDenied) {
                            location.href = '/riwayat_topup.html';
                        }
                    });
                }, 300);
            } else if(selectedMethod === 'wa') {
                closeTopUp(); 
                const formattedNominal = finalNominal.toLocaleString('id-ID');
                const text = encodeURIComponent(`Halo Admin DIGITAL FIKY STORE,\n\nSaya ingin Top Up Saldo Manual.\nNomor Akun: ${user.phone}\nNominal: *Rp ${formattedNominal}*\n\nMohon instruksi pembayarannya.`);
                fetch('/api/topup/request', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ phone: user.phone, method: 'Manual WhatsApp', nominal: finalNominal }) }).then(() => {
                    window.open(`https://wa.me/6282231154407?text=${text}`, '_blank');
                    setTimeout(() => { location.href = '/riwayat_topup.html'; }, 1000);
                });
            }
        }
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/info.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Pusat Informasi</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><link rel="stylesheet" href="style.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors"><div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 transition-colors"><i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i><h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white">Pusat Informasi</h1></div><div class="p-4" id="infoList"><div class="mt-20 flex flex-col items-center justify-center text-gray-400"><i class="fas fa-spinner fa-spin text-4xl mb-4"></i><p>Memuat informasi...</p></div></div><div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-sm z-40 transition-colors"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div></div></div><script>if (!localStorage.getItem('user')) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark'); fetch('/api/info').then(r => r.json()).then(data => { const list = document.getElementById('infoList'); if(data.info.length === 0) list.innerHTML = `<div class="mt-20 flex flex-col items-center justify-center text-gray-400 dark:text-gray-500"><i class="fas fa-bell-slash text-5xl mb-4 opacity-50"></i><p class="text-sm">Belum ada info terbaru.</p></div>`; else list.innerHTML = data.info.reverse().map(i => `<div class="relative bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-2xl p-5 mb-4 shadow-sm overflow-hidden transition-colors"><div class="absolute -right-2 top-4 text-7xl opacity-10 dark:opacity-20 select-none">📢</div><div class="flex justify-between items-start mb-3 relative z-10"><h3 class="font-bold text-[#002147] dark:text-yellow-400 text-[15px] pr-2">${i.judul}</h3><span class="text-[10px] text-gray-500 whitespace-nowrap bg-gray-100 dark:bg-black px-2 py-1 rounded-md border border-gray-200 dark:border-gray-800">${i.date}</span></div><p class="text-sm text-gray-600 dark:text-gray-300 leading-relaxed relative z-10">${i.isi}</p></div>`).join(''); });</script></body></html>
EOF

cat << 'EOF' > public/profile.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Profil</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><link rel="stylesheet" href="style.css"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors"><div class="bg-white dark:bg-[#050b14] p-8 pb-10 flex flex-col items-center relative rounded-b-[2rem] shadow-sm dark:shadow-lg transition-colors"><div class="w-24 h-24 bg-gray-100 dark:bg-[#1e293b] rounded-full flex justify-center items-center text-[#002147] dark:text-white font-extrabold text-4xl mt-2 mb-3 shadow-md dark:shadow-xl overflow-hidden border-2 border-transparent" id="profileCircle">U</div><div class="flex items-center gap-3"><h2 class="text-2xl font-bold tracking-wide text-gray-800 dark:text-gray-100" id="profileName">User Name</h2><i class="fas fa-pencil-alt text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 cursor-pointer transition text-lg" onclick="openEditModal()"></i></div></div><div class="mt-4 px-2"><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800"><i class="fas fa-envelope text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Email</div><div class="text-sm text-gray-500 dark:text-gray-400" id="profileEmail">-</div></div><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800"><i class="fas fa-phone-alt text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">No. Telp</div><div class="text-sm text-gray-500 dark:text-gray-400" id="profilePhoneData">08...</div></div><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800"><i class="fas fa-wallet text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Saldo Akun</div><div class="text-sm font-bold text-[#002147] dark:text-yellow-400" id="profileSaldo">Rp 0</div></div><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#1a2639]" onclick="location.href='/mutasi.html'"><i class="fas fa-exchange-alt text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Mutasi Saldo</div><i class="fas fa-chevron-right text-gray-400 text-sm"></i></div><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800"><i class="fas fa-shopping-cart text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Jumlah Transaksi</div><div class="text-sm text-gray-500 dark:text-gray-400">0 Trx</div></div><div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-800/50" onclick="toggleChangePassword()"><i class="fas fa-lock text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Ubah Password</div><i class="fas fa-chevron-down text-gray-400 text-sm transition-transform duration-300" id="cpwIcon"></i></div><div id="changePasswordBox" class="hidden px-6 py-5 border-b border-gray-200 dark:border-gray-800 bg-gray-100 dark:bg-[#070e18] slide-down"><div id="step1Cp"><p class="text-xs text-gray-600 dark:text-gray-400 mb-3 text-center">Klik tombol di bawah untuk menerima kode OTP ke WA Anda.</p><button class="w-full py-2.5 bg-white dark:bg-[#0b1320] hover:bg-gray-50 dark:hover:bg-gray-800 text-[#002147] dark:text-yellow-400 font-bold rounded-lg text-sm border border-gray-300 dark:border-gray-700 transition" onclick="requestOtpCp()"><i class="fab fa-whatsapp mr-2"></i>Kirim OTP ke WA</button></div><div id="step2Cp" class="hidden"><p class="text-xs text-green-600 dark:text-green-400 mb-4 text-center"><i class="fas fa-check-circle mr-1"></i>OTP terkirim ke WhatsApp.</p><label class="block text-[10px] text-gray-600 dark:text-gray-500 mb-1">Kode OTP</label><input type="number" id="cpOtp" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-2 text-gray-800 dark:text-white text-lg mb-3 focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 text-center tracking-[0.5em] font-bold" placeholder="XXXX"><label class="block text-[10px] text-gray-600 dark:text-gray-500 mb-1">Password Baru</label><div class="compact-input-wrapper mb-5"><input type="password" id="cpNewPassword" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-2 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 text-center" placeholder="Ketik password baru"><i class="fas fa-eye password-toggle" onclick="togglePassword('cpNewPassword', this)"></i></div><button class="w-full py-3 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-bold rounded-lg text-sm" onclick="submitChangePassword()">Simpan Password</button></div></div><div class="flex items-center px-4 py-5 cursor-pointer hover:bg-red-50 dark:hover:bg-gray-800/50 transition" onclick="logout()"><i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i><div class="flex-1 text-[15px] font-bold text-red-600 ml-2">Keluar Akun</div></div></div><div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-sm z-40 transition-colors"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div></div></div><div id="editProfileModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center bg-black/70"><div class="bg-white dark:bg-[#0b1320] w-[90%] max-w-[340px] rounded-[1.25rem] border border-gray-200 dark:border-gray-800 shadow-2xl relative p-6 animate-slide-up"><button onclick="closeEditModal()" class="absolute top-4 right-4 text-gray-400 hover:text-red-500"><i class="fas fa-times text-xl"></i></button><h3 class="text-center text-gray-800 dark:text-white font-bold text-lg mb-6">Ubah Profil</h3><div class="relative w-20 h-20 mx-auto mb-8"><div class="w-full h-full rounded-full border-2 border-[#002147] dark:border-yellow-400 flex items-center justify-center text-[#002147] dark:text-white text-3xl font-bold bg-gray-100 dark:bg-[#1e293b] overflow-hidden" id="editModalInitial">U</div><input type="file" id="avatarInput" accept="image/*" class="hidden" onchange="previewAvatar(event)"><div class="absolute bottom-0 right-0 bg-[#002147] dark:bg-yellow-400 rounded-full w-7 h-7 flex items-center justify-center text-white dark:text-[#0b1320] border-[3px] border-white dark:border-[#0b1320] cursor-pointer z-10" onclick="document.getElementById('avatarInput').click()"><i class="fas fa-camera text-[10px]"></i></div></div><div class="mb-4"><label class="block text-[10px] text-gray-500 mb-1">Email (Hanya Baca)</label><input type="email" id="editEmail" readonly class="w-full bg-gray-100 dark:bg-[#1e293b]/50 border border-gray-300 dark:border-gray-800 rounded-lg px-3 py-3 text-gray-500 dark:text-gray-400 text-sm focus:outline-none cursor-not-allowed"></div><div class="mb-4"><label class="block text-[10px] text-gray-500 mb-1">Nama Pengguna</label><input type="text" id="editName" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 transition-colors"></div><div class="mb-4"><label class="block text-[10px] text-gray-500 mb-1">Nomor Telepon</label><input type="number" id="editPhone" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 transition-colors"></div><div class="mb-6 hidden slide-down" id="editOtpContainer"><label class="block text-[10px] text-gray-500 dark:text-gray-400 mb-1 text-center">OTP dikirim ke WA baru</label><input type="number" id="editOtpInput" class="w-full bg-white dark:bg-[#0b1320] border border-green-500 dark:border-green-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-lg tracking-[0.5em] text-center font-bold focus:outline-none focus:border-green-400 transition-colors" placeholder="XXXX"></div><button id="btnSimpanProfil" onclick="saveProfile()" class="w-full py-3.5 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-bold rounded-xl mb-3 shadow-md transition">Simpan Profil</button><button onclick="deleteAccount()" class="w-full py-3.5 bg-red-50 dark:bg-[#3f161e] border border-red-200 dark:border-[#5c1a24] text-red-600 dark:text-red-500 font-bold rounded-xl transition hover:bg-red-100 dark:hover:bg-red-900/50">Hapus Akun</button></div></div><script>function togglePassword(id, el) { const input = document.getElementById(id); if (input.type === 'password') { input.type = 'text'; el.classList.remove('fa-eye'); el.classList.add('fa-eye-slash'); } else { input.type = 'password'; el.classList.remove('fa-eye-slash'); el.classList.add('fa-eye'); } } const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark'); function loadProfileData() { document.getElementById('profileName').innerText = user.name; document.getElementById('profilePhoneData').innerText = user.phone; document.getElementById('profileEmail').innerText = user.email || 'fikyshoto@gmail.com'; const pCircle = document.getElementById('profileCircle'); if(user.avatar) pCircle.innerHTML = `<img src="${user.avatar}" class="w-full h-full object-cover">`; else pCircle.innerText = user.name.charAt(0).toUpperCase(); } loadProfileData(); fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }).then(res => res.json()).then(data => { document.getElementById('profileSaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); }); function logout() { Swal.fire({ title: 'Keluar Akun?', text: "Apakah Anda yakin ingin keluar?", icon: 'warning', showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#002147', confirmButtonText: 'Ya, Keluar', cancelButtonText: 'Batal', background: localStorage.getItem('darkMode') === 'true' ? '#0b1320' : '#ffffff', color: localStorage.getItem('darkMode') === 'true' ? '#fff' : '#000' }).then((result) => { if (result.isConfirmed) { localStorage.removeItem('user'); window.location.href = '/'; } }); } let tempAvatarBase64 = null; function previewAvatar(event) { const file = event.target.files[0]; if(file) { const reader = new FileReader(); reader.onload = function(e) { tempAvatarBase64 = e.target.result; document.getElementById('editModalInitial').innerHTML = `<img src="${tempAvatarBase64}" class="w-full h-full object-cover">`; }; reader.readAsDataURL(file); } } function toggleChangePassword() { const box = document.getElementById('changePasswordBox'); const icon = document.getElementById('cpwIcon'); if(box.classList.contains('hidden')) { box.classList.remove('hidden'); icon.classList.replace('fa-chevron-down', 'fa-chevron-up'); } else { box.classList.add('hidden'); icon.classList.replace('fa-chevron-up', 'fa-chevron-down'); document.getElementById('step1Cp').classList.remove('hidden'); document.getElementById('step2Cp').classList.add('hidden'); } } async function requestOtpCp() { try { Swal.fire({title: 'Mengirim...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }}); const res = await fetch('/api/auth/forgot', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }); if (res.ok) { Swal.fire({ icon: 'success', title: 'Terkirim', text: 'OTP terkirim ke WA!', timer: 1500, showConfirmButton: false }); document.getElementById('step1Cp').classList.add('hidden'); document.getElementById('step2Cp').classList.remove('hidden'); } else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error }); } } catch(e) { Swal.fire({ icon: 'error', title: 'Error', text: 'Kesalahan jaringan.' }); } } async function submitChangePassword() { const otp = document.getElementById('cpOtp').value; const newPassword = document.getElementById('cpNewPassword').value; if(!otp || !newPassword) return Swal.fire({ icon: 'warning', title: 'Lengkapi Data', text: 'Wajib diisi.' }); try { Swal.fire({title: 'Menyimpan...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }}); const res = await fetch('/api/auth/reset', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone, otp, newPassword }) }); if (res.ok) { Swal.fire({ icon: 'success', title: 'Berhasil!', text: 'Password diubah.' }).then(() => { toggleChangePassword(); document.getElementById('cpOtp').value=''; document.getElementById('cpNewPassword').value=''; }); } else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error }); } } catch(e) { Swal.fire({ icon: 'error', title: 'Error', text: 'Kesalahan jaringan.' }); } } let isRequestingOtp = false; function openEditModal() { tempAvatarBase64 = user.avatar || null; const eCircle = document.getElementById('editModalInitial'); if(tempAvatarBase64) eCircle.innerHTML = `<img src="${tempAvatarBase64}" class="w-full h-full object-cover">`; else eCircle.innerText = user.name.charAt(0).toUpperCase(); document.getElementById('editEmail').value = user.email || 'fikyshoto@gmail.com'; document.getElementById('editName').value = user.name; document.getElementById('editPhone').value = user.phone.replace('62', '0'); document.getElementById('editProfileModal').classList.remove('hidden'); } function closeEditModal() { document.getElementById('editProfileModal').classList.add('hidden'); isRequestingOtp = false; document.getElementById('editOtpContainer').classList.add('hidden'); document.getElementById('btnSimpanProfil').innerText = 'Simpan Profil'; document.getElementById('btnSimpanProfil').classList.remove('bg-green-500', 'dark:bg-green-400'); document.getElementById('editOtpInput').value = ''; } async function saveProfile() { const oldPhone = user.phone; const newName = document.getElementById('editName').value; const rawPhone = document.getElementById('editPhone').value; const newPhone = rawPhone.startsWith('0') ? '62' + rawPhone.slice(1) : rawPhone; const otp = document.getElementById('editOtpInput').value; if(!newName || !rawPhone) return Swal.fire({icon:'warning', title:'Gagal', text:'Nama & No WA wajib diisi!'}); if(newPhone !== oldPhone && !isRequestingOtp) { Swal.fire({title: 'Mengirim OTP...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }}); try { const res = await fetch('/api/auth/request-update-otp', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ oldPhone, newPhone }) }); if(res.ok) { isRequestingOtp = true; document.getElementById('editOtpContainer').classList.remove('hidden'); document.getElementById('btnSimpanProfil').innerText = 'Verifikasi OTP & Simpan'; document.getElementById('btnSimpanProfil').classList.add('bg-green-500', 'dark:bg-green-400'); Swal.fire({icon:'success', title:'OTP Terkirim!', text:'Silakan cek WA di nomor yang baru.'}); } else { Swal.fire({icon:'error', title:'Gagal', text: (await res.json()).error}); } } catch(e) { Swal.fire({icon:'error', title:'Oops', text:'Kesalahan jaringan.'}); } return; } if(newPhone !== oldPhone && isRequestingOtp && !otp) return Swal.fire({icon:'warning', title:'Gagal', text:'Masukkan kode OTP 4 digit!'}); Swal.fire({title: 'Menyimpan...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }}); try { const res = await fetch('/api/auth/update', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ oldPhone, newPhone, newName, otp, avatar: tempAvatarBase64 }) }); if(res.ok) { user.name = newName; user.phone = (await res.json()).phone || newPhone; user.avatar = tempAvatarBase64; localStorage.setItem('user', JSON.stringify(user)); Swal.fire({icon:'success', title:'Berhasil', text:'Profil diperbarui!'}).then(() => { location.reload(); }); } else { Swal.fire({icon:'error', title:'Gagal', text: (await res.json()).error}); } } catch(e) { Swal.fire({icon:'error', title:'Oops', text:'Kesalahan jaringan.'}); } } function deleteAccount() { Swal.fire({ title: 'Hapus Akun Permanen?', text: "Akun dan sisa saldo Anda akan hangus!", icon: 'error', showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#002147', confirmButtonText: 'Ya, Hapus!', background: localStorage.getItem('darkMode') === 'true' ? '#0b1320' : '#ffffff', color: localStorage.getItem('darkMode') === 'true' ? '#fff' : '#000' }).then(async (result) => { if (result.isConfirmed) { Swal.fire({title: 'Menghapus...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }}); try { const res = await fetch('/api/auth/delete', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }); if(res.ok) { localStorage.removeItem('user'); Swal.fire({icon:'success', title:'Terhapus', text:'Akun dihapus.'}).then(() => { location.href = '/'; }); } } catch(e) { Swal.fire({icon:'error', title:'Error', text:'Gagal menghapus.'}); } } }); }</script></body></html>
EOF

cat << 'EOF' > public/riwayat.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Riwayat Transaksi - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors"><div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 transition-colors border-b border-gray-200 dark:border-gray-800"><i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i><h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white">Riwayat Transaksi</h1></div><div class="mx-4 mt-4 bg-white dark:bg-[#111c2e] p-4 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm transition-colors"><div class="relative mb-4"><i class="fas fa-search absolute left-3.5 top-3 text-gray-400 text-sm"></i><input type="text" class="w-full bg-gray-50 dark:bg-[#1a2639] border border-gray-300 dark:border-gray-700 text-gray-800 dark:text-gray-200 rounded-xl py-2.5 pl-10 pr-4 text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400 transition" placeholder="Cari transaksi..."></div><div class="flex justify-between mb-4 gap-2"><div class="flex-1 bg-[#002147] dark:bg-[#0b1320] text-white dark:text-yellow-400 border border-transparent dark:border-gray-700 text-center py-2 rounded-full text-[11px] font-bold cursor-pointer">Semua</div><div class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-transparent text-center py-2 rounded-full text-[11px] font-bold cursor-pointer hover:bg-gray-100 dark:hover:text-white transition">Sukses</div><div class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-transparent text-center py-2 rounded-full text-[11px] font-bold cursor-pointer hover:bg-gray-100 dark:hover:text-white transition">Proses</div><div class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-transparent text-center py-2 rounded-full text-[11px] font-bold cursor-pointer hover:bg-gray-100 dark:hover:text-white transition">Gagal</div></div><div class="flex items-end gap-2"><div class="flex-1"><label class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-1.5 ml-1 block">Dari</label><div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-xl px-3 py-2.5 flex justify-between items-center text-gray-500 dark:text-gray-400 cursor-pointer"><span class="text-xs">&nbsp;</span><i class="fas fa-chevron-down text-[10px]"></i></div></div><div class="flex-1"><label class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-1.5 ml-1 block">Sampai</label><div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-xl px-3 py-2.5 flex justify-between items-center text-gray-500 dark:text-gray-400 cursor-pointer"><span class="text-xs">&nbsp;</span><i class="fas fa-chevron-down text-[10px]"></i></div></div><div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 w-10 h-10 rounded-xl flex items-center justify-center text-gray-500 dark:text-gray-400 cursor-pointer hover:bg-gray-100 dark:hover:text-white transition"><i class="fas fa-sync-alt text-sm"></i></div></div></div><div class="px-4 mt-4" id="historyContainer"><div class="mt-14 flex flex-col items-center justify-center text-center px-6"><i class="fas fa-spinner fa-spin text-4xl mb-4 text-gray-400"></i></div></div><div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.1)] z-40 transition-colors"><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div><div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div><div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 transition" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark'); fetch('/api/user/transactions', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }).then(res => res.json()).then(data => { const container = document.getElementById('historyContainer'); if(data.transactions.length === 0) { container.innerHTML = `<div class="mt-10 flex flex-col items-center justify-center text-center px-6"><div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800 transition-colors"><i class="fas fa-receipt text-gray-400 text-4xl"></i></div><h2 class="text-gray-800 dark:text-white font-bold text-lg tracking-wide mb-2 transition-colors">Belum Ada Transaksi</h2><p class="text-gray-500 dark:text-gray-400 text-[13px] leading-relaxed mb-8 px-2 transition-colors">Ayo mulai transaksi pertamamu sekarang dan nikmati berbagai promo menarik!</p><button class="bg-[#002147] text-white dark:bg-[#0b1320] dark:text-yellow-400 border border-transparent dark:border-gray-700 font-bold py-3 px-8 rounded-full shadow-lg hover:opacity-90 transition" onclick="location.href='/dashboard.html'">Transaksi Sekarang</button></div>`; } else { window.trxData = data.transactions.reverse(); container.innerHTML = window.trxData.map((item, index) => { let statusColor = item.status === 'Proses' ? 'text-yellow-600 dark:text-yellow-400 bg-yellow-100 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-800' : (item.status === 'Sukses' ? 'text-green-600 dark:text-green-400 bg-green-100 dark:bg-green-900/30 border-green-200 dark:border-green-800' : 'text-red-600 dark:text-red-400 bg-red-100 dark:bg-red-900/30 border-red-200 dark:border-red-800'); return `<div onclick="showDetailTrx(${index})" class="bg-white dark:bg-[#111c2e] p-4 rounded-2xl mb-3 border border-gray-200 dark:border-gray-800 shadow-sm flex justify-between items-center transition-colors cursor-pointer hover:shadow-md hover:border-[#002147] dark:hover:border-yellow-400"><div class="flex items-center gap-3"><div class="w-10 h-10 rounded-full bg-gray-100 dark:bg-[#0b1320] flex items-center justify-center text-gray-500 dark:text-gray-400 text-lg"><i class="fas fa-box"></i></div><div><h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${item.produk}</h4><p class="text-[10px] text-gray-500">${item.date}</p></div></div><div class="text-right"><p class="font-extrabold text-[14px] text-[#002147] dark:text-yellow-400 mb-1">Rp ${item.harga.toLocaleString('id-ID')}</p><span class="text-[9px] font-bold px-2 py-0.5 rounded border ${statusColor} uppercase tracking-wider">${item.status}</span></div></div>`; }).join(''); } }).catch(err => { document.getElementById('historyContainer').innerHTML = `<div class="mt-20 text-center text-red-500">Gagal memuat data.</div>`; }); window.showDetailTrx = function(index) { const item = window.trxData[index]; const isDark = localStorage.getItem('darkMode') === 'true'; const bgPopup = isDark ? '#0b1320' : '#ffffff'; const textColor = isDark ? 'text-gray-200' : 'text-gray-800'; const mutedColor = isDark ? 'text-gray-400' : 'text-gray-500'; const borderColor = isDark ? 'border-gray-800' : 'border-gray-200'; let statusColor = item.status === 'Proses' ? 'text-yellow-500' : (item.status === 'Sukses' ? 'text-green-500' : 'text-red-500'); Swal.fire({ title: `<span class="font-bold ${isDark ? 'text-white' : 'text-gray-800'} text-lg">Detail Transaksi</span>`, html: `<div class="text-left mt-2 space-y-3 text-sm"><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Tanggal</span><span class="font-medium ${textColor} text-right">${item.date}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">ID Transaksi</span><span class="font-medium ${textColor} text-right">${item.id}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Produk</span><span class="font-medium ${textColor} text-right">${item.produk}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Nominal</span><span class="font-medium ${textColor} text-right">${item.nominal}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">No Tujuan</span><span class="font-medium ${textColor} text-right">${item.no_tujuan}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Status</span><span class="font-bold ${statusColor} text-right uppercase">${item.status}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">SN / Ref</span><span class="font-medium ${textColor} text-right">${item.sn_ref || '-'}</span></div><div class="mt-5 text-center"><p class="${mutedColor} text-xs mb-1">Total Harga</p><p class="text-3xl font-extrabold ${textColor}">Rp ${item.harga.toLocaleString('id-ID')}</p></div></div>`, showConfirmButton: true, confirmButtonText: 'Tutup', confirmButtonColor: isDark ? '#facc15' : '#002147', background: bgPopup, customClass: { confirmButton: isDark ? 'text-[#001229] font-bold px-8' : 'text-white font-bold px-8' } }); }</script></body></html>
EOF

cat << 'EOF' > public/riwayat_topup.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Riwayat Top Up - DIGITAL FIKY STORE</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors"><div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 transition-colors border-b border-gray-200 dark:border-gray-800"><i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i><h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white">Riwayat Top Up</h1></div><div class="px-4 mt-6" id="historyContainer"><div class="mt-14 flex flex-col items-center justify-center text-center px-6"><i class="fas fa-spinner fa-spin text-4xl mb-4 text-gray-400"></i></div></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark'); fetch('/api/topup/history', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }).then(res => res.json()).then(data => { const container = document.getElementById('historyContainer'); if(data.history.length === 0) { container.innerHTML = `<div class="mt-14 flex flex-col items-center justify-center text-center px-6"><div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800 transition-colors"><i class="fas fa-wallet text-gray-400 text-4xl"></i></div><h2 class="text-gray-800 dark:text-white font-bold text-lg tracking-wide mb-2 transition-colors">Belum Ada Top Up</h2><p class="text-gray-500 dark:text-gray-400 text-[13px] leading-relaxed mb-8 px-2 transition-colors">Anda belum melakukan pengisian saldo. Ayo isi saldo sekarang!</p><button class="bg-[#002147] text-white dark:bg-[#0b1320] dark:text-yellow-400 border border-transparent dark:border-gray-700 font-bold py-3 px-8 rounded-full shadow-lg hover:opacity-90 transition" onclick="location.href='/dashboard.html'">Top Up Sekarang</button></div>`; } else { window.topupData = data.history.reverse(); container.innerHTML = window.topupData.map((item, index) => { let isExpired = item.status === 'Expired'; let statusColor = item.status === 'Proses' ? 'text-yellow-600 dark:text-yellow-400 bg-yellow-100 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-800' : (item.status === 'Sukses' ? 'text-green-600 dark:text-green-400 bg-green-100 dark:bg-green-900/30 border-green-200 dark:border-green-800' : 'text-red-600 dark:text-red-400 bg-red-100 dark:bg-red-900/30 border-red-200 dark:border-red-800'); let iconMethod = item.method.includes('QRIS') ? '<i class="fas fa-qrcode"></i>' : (item.method.includes('Admin') ? '<i class="fas fa-check-circle"></i>' : '<i class="fab fa-whatsapp"></i>'); let titleText = item.method.includes('Admin') ? 'Saldo ditambah oleh Admin Fiky Store' : `Top Up ${item.method}`; return `<div onclick="showDetailTopup(${index})" class="bg-white dark:bg-[#111c2e] p-4 rounded-2xl mb-3 border border-gray-200 dark:border-gray-800 shadow-sm flex justify-between items-center transition-colors cursor-pointer hover:shadow-md hover:border-[#002147] dark:hover:border-yellow-400 ${isExpired ? 'opacity-70' : ''}"><div class="flex items-center gap-3"><div class="w-10 h-10 rounded-full bg-gray-100 dark:bg-[#0b1320] flex items-center justify-center text-gray-500 dark:text-gray-400 text-lg">${iconMethod}</div><div><h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${titleText}</h4><p class="text-[10px] text-gray-500">${item.date}</p></div></div><div class="text-right"><p class="font-extrabold text-[14px] text-[#002147] dark:text-yellow-400 mb-1">Rp ${item.nominal.toLocaleString('id-ID')}</p><span class="text-[9px] font-bold px-2 py-0.5 rounded border ${statusColor} uppercase tracking-wider">${item.status}</span></div></div>`; }).join(''); } }).catch(err => { document.getElementById('historyContainer').innerHTML = `<div class="mt-20 text-center text-red-500">Gagal memuat data.</div>`; }); window.showDetailTopup = function(index) { const item = window.topupData[index]; const isDark = localStorage.getItem('darkMode') === 'true'; const bgPopup = isDark ? '#0b1320' : '#ffffff'; const textColor = isDark ? 'text-gray-200' : 'text-gray-800'; const mutedColor = isDark ? 'text-gray-400' : 'text-gray-500'; const borderColor = isDark ? 'border-gray-800' : 'border-gray-200'; let statusColor = item.status === 'Proses' ? 'text-yellow-500' : (item.status === 'Sukses' ? 'text-green-500' : 'text-red-500'); let titleText = item.method.includes('Admin') ? 'Saldo ditambah oleh Admin Fiky Store' : `Top Up Saldo`; Swal.fire({ title: `<span class="font-bold ${isDark ? 'text-white' : 'text-gray-800'} text-lg">Detail Top Up</span>`, html: `<div class="text-left mt-2 space-y-3 text-sm"><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Waktu</span><span class="font-medium ${textColor} text-right">${item.date}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Nominal</span><span class="font-medium ${textColor} text-right">Rp ${item.nominal.toLocaleString('id-ID')}</span></div><div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Status</span><span class="font-bold ${statusColor} text-right uppercase">${item.status}</span></div><div class="mt-5 text-center"><p class="${mutedColor} text-xs mb-1">Total Bayar</p><p class="text-3xl font-extrabold ${textColor}">Rp ${item.nominal.toLocaleString('id-ID')}</p></div></div>`, showConfirmButton: true, confirmButtonText: 'Tutup', confirmButtonColor: isDark ? '#facc15' : '#002147', background: bgPopup, customClass: { confirmButton: isDark ? 'text-[#001229] font-bold px-8' : 'text-white font-bold px-8' } }); }</script></body></html>
EOF

cat << 'EOF' > public/mutasi.html
<!DOCTYPE html><html lang="id" id="html-root"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Mutasi Saldo</title><script src="https://cdn.tailwindcss.com"></script><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"><script>tailwind.config = { darkMode: 'class' }</script></head><body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300"><div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors"><div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 transition-colors"><i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="history.back()"></i><h1 class="text-[18px] font-bold tracking-wide text-gray-800 dark:text-white">Mutasi Saldo</h1></div><div class="px-4 mt-4" id="mutasiList"><div class="mt-20 flex flex-col items-center justify-center text-gray-400"><i class="fas fa-spinner fa-spin text-4xl mb-4"></i><p>Memuat data mutasi...</p></div></div></div><script>const user = JSON.parse(localStorage.getItem('user')); if (!user) window.location.href = '/'; if(localStorage.getItem('darkMode') === 'true' || localStorage.getItem('darkMode') === null) document.getElementById('html-root').classList.add('dark'); fetch('/api/user/mutasi', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) }).then(res => res.json()).then(data => { const list = document.getElementById('mutasiList'); if(data.mutasi.length === 0) { list.innerHTML = `<div class="mt-20 flex flex-col items-center justify-center text-center px-6"><div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800 transition-colors"><i class="fas fa-exchange-alt text-gray-400 text-4xl"></i></div><h2 class="text-gray-800 dark:text-white font-bold text-lg tracking-wide mb-2 transition-colors">Belum Ada Mutasi</h2><p class="text-gray-500 dark:text-gray-400 text-[13px] leading-relaxed">Catatan uang masuk dan keluar akan tampil di sini.</p></div>`; } else { list.innerHTML = data.mutasi.reverse().map(m => `<div class="flex items-center justify-between p-4 bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-2xl mb-3 shadow-sm transition-colors"><div class="flex items-center gap-3"><div class="w-10 h-10 rounded-full ${m.type === 'in' ? 'bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400' : 'bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400'} flex items-center justify-center text-lg shrink-0"><i class="fas ${m.type === 'in' ? 'fa-arrow-down' : 'fa-arrow-up'}"></i></div><div><h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${m.desc}</h4><p class="text-[10px] text-gray-500">${m.date}</p></div></div><div class="text-right"><span class="font-bold text-[14px] ${m.type === 'in' ? 'text-green-600 dark:text-green-500' : 'text-red-600 dark:text-red-500'}">${m.type === 'in' ? '+' : '-'} Rp ${m.amount.toLocaleString('id-ID')}</span></div></div>`).join(''); } }).catch(err => { list.innerHTML = `<div class="mt-20 text-center text-red-500">Gagal memuat data mutasi.</div>`; });</script></body></html>
EOF

# ==========================================
# FILE NODE.JS (API + LOCAL HYBRID EXACT MATCH)
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
const axios = require('axios');
const crypto = require('crypto');

const app = express();
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

const configFile = './config.json';
const dbFile = './database.json';
const webUsersFile = './web_users.json'; 
const infoFile = './info.json'; 
const localProductsFile = './local_products.json';

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : (file===infoFile || file===localProductsFile ? [] : {});
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.qrisUrl = configAwal.qrisUrl || "https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg";
if (!configAwal.hasOwnProperty('banners')) {
    configAwal.banners = [
        "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80",
        "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80"
    ];
}
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});
if (!fs.existsSync(infoFile)) saveJSON(infoFile, []);
if (!fs.existsSync(localProductsFile)) saveJSON(localProductsFile, []);

app.get('/api/config', (req, res) => { let cfg = loadJSON(configFile); res.json({ banners: cfg.banners, qrisUrl: cfg.qrisUrl }); });
app.get('/api/info', (req, res) => res.json({ info: loadJSON(infoFile) }));
app.post('/api/user/balance', (req, res) => res.json({ saldo: loadJSON(dbFile)[req.body.phone]?.saldo || 0 }));
app.post('/api/user/mutasi', (req, res) => { let db = loadJSON(dbFile); res.json({ mutasi: db[req.body.phone]?.mutasi || [] }); });

let digiCache = { time: 0, data: [] };

app.post('/api/products', async (req, res) => {
    const { type, brand, category } = req.body;
    let config = loadJSON(configFile);
    let filtered = [];
    
    if(config.digiUser && config.digiKey) {
        try {
            if (Date.now() - digiCache.time > 300000 || digiCache.data.length === 0) { 
                let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + "pricelist").digest('hex');
                let digiRes = await axios.post('https://api.digiflazz.com/v1/price-list', {
                    cmd: 'prepaid', username: config.digiUser, sign: sign
                });
                if(digiRes.data && digiRes.data.data) {
                    digiCache.data = digiRes.data.data;
                    digiCache.time = Date.now();
                }
            }

            let products = digiCache.data;
            filtered = products.filter(p => p.buyer_product_status === true && p.seller_product_status === true);

            if (type === 'pulsa') {
                filtered = filtered.filter(p => p.category === 'Pulsa' && p.brand.toLowerCase() === brand.toLowerCase());
            } else if (type === 'data') {
                filtered = filtered.filter(p => p.category === 'Data' && p.brand.toLowerCase() === brand.toLowerCase());
                if (category) {
                    const keywords = category.toLowerCase().split(' ');
                    filtered = filtered.filter(p => keywords.every(kw => p.product_name.toLowerCase().includes(kw)));
                }
            } else if (type === 'ewallet' || type === 'etoll') {
                filtered = filtered.filter(p => p.category === 'E-Money' && p.brand.toLowerCase().includes(brand.toLowerCase()));
            } else if (type === 'pln') {
                filtered = filtered.filter(p => p.category === 'PLN');
            } else if (type === 'masaaktif') {
                filtered = filtered.filter(p => p.category === 'Masa Aktif' && p.brand.toLowerCase() === brand.toLowerCase());
            } else if (type === 'game') {
                filtered = filtered.filter(p => p.category === 'Games' && p.brand.toLowerCase() === brand.toLowerCase());
            }
        } catch(e) {
            console.log("Digiflazz Error:", e.message);
        }
    }

    let markupTiers = config.markupTiers || { tier1: 0, tier2: 0, tier3: 0, tier4: 0 };
    let getMarkup = (price) => {
        if (price < 10000) return parseInt(markupTiers.tier1) || 0;
        if (price <= 50000) return parseInt(markupTiers.tier2) || 0;
        if (price <= 100000) return parseInt(markupTiers.tier3) || 0;
        return parseInt(markupTiers.tier4) || 0;
    };

    let localProducts = loadJSON(localProductsFile);
    let myLocals = localProducts.filter(p => {
        if(p.type !== type) return false;
        if(brand && !p.brand.toLowerCase().includes(brand.toLowerCase()) && !brand.toLowerCase().includes(p.brand.toLowerCase())) return false;
        if(type === 'data' && category) {
            // V99 FIX: Exact match category untuk produk lokal
            if (p.category && p.category.toLowerCase().trim() === category.toLowerCase().trim()) return true;
            let kw = category.toLowerCase().split(' ');
            return kw.every(k => p.name.toLowerCase().includes(k) || (p.category && p.category.toLowerCase().includes(k)));
        }
        return true;
    });

    let combined = [
        ...filtered.map(p => ({
            sku: p.buyer_sku_code,
            name: p.product_name,
            desc: p.desc,
            price: p.price + getMarkup(p.price),
            isLocal: false
        })),
        ...myLocals.map(p => ({
            sku: p.sku,
            name: p.name,
            desc: p.desc,
            price: p.price + getMarkup(p.price), 
            isLocal: (p.isDigi === true) ? false : true
        }))
    ];

    combined.sort((a, b) => a.price - b.price);
    res.json({ data: combined });
});

app.post('/api/transaction/create', async (req, res) => {
    try {
        const { phone, target, sku, name, price, isLocal } = req.body;
        let db = loadJSON(dbFile);
        let config = loadJSON(configFile);

        console.log(`[TRX API] Memulai TRX: ${phone} -> ${sku} (isLocal: ${isLocal})`);

        if (!db[phone]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
        if (db[phone].saldo < price) return res.status(400).json({ error: 'Saldo tidak mencukupi. Silakan Top Up terlebih dahulu.' });

        if (!db[phone].mutasi) db[phone].mutasi = [];
        if (!db[phone].transactions) db[phone].transactions = [];
        if (!db[phone].topup) db[phone].topup = [];

        db[phone].saldo -= price;
        let ref_id = 'TRX' + Date.now();
        let dateStr = new Date().toLocaleString('id-ID');
        let trxStatus = 'Proses';
        let sn_ref = '';

        if (!isLocal && config.digiUser && config.digiKey) {
            try {
                let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + ref_id).digest('hex');
                let isDev = (config.digiKey || '').toLowerCase().startsWith('dev');

                let digiPayload = {
                    username: config.digiUser,
                    buyer_sku_code: sku,
                    customer_no: target,
                    ref_id: ref_id,
                    sign: sign
                };

                if (isDev) {
                    digiPayload.testing = true;
                }

                console.log(`[DIGIFLAZZ] Mengirim Data:`, JSON.stringify(digiPayload));

                let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload);
                let digiData = digiRes.data.data;
                console.log(`[DIGIFLAZZ] Response:`, digiData.status);

                if (digiData.status === 'Gagal') {
                    db[phone].saldo += price; // Auto Refund
                    saveJSON(dbFile, db);
                    return res.status(400).json({ error: digiData.message || 'Transaksi gagal dari server provider. Saldo dikembalikan.' });
                } else if (digiData.status === 'Sukses') {
                    trxStatus = 'Sukses';
                    sn_ref = digiData.sn || '';
                } else {
                    trxStatus = 'Proses';
                    sn_ref = digiData.sn || '';
                }
            } catch(e) {
                db[phone].saldo += price; // Auto Refund
                saveJSON(dbFile, db);
                
                let msgErr = 'Gagal terhubung ke provider.';
                if (e.response && e.response.data) {
                    if (e.response.data.data && e.response.data.data.message) {
                        msgErr = e.response.data.data.message;
                    } else if (e.response.data.message) {
                        msgErr = e.response.data.message;
                    }
                } else if (e.message) {
                    msgErr = e.message;
                }
                
                console.log(`[DIGIFLAZZ] Axios Error:`, msgErr);
                return res.status(400).json({ error: msgErr + ' (Saldo dikembalikan otomatis)' });
            }
        }

        db[phone].mutasi.push({ id: ref_id, type: 'out', amount: price, desc: `Beli ${name}`, date: dateStr });
        
        db[phone].transactions.push({ 
            id: ref_id, sku: sku, isLocal: isLocal, produk: name, 
            nominal: price, no_tujuan: target, status: trxStatus, 
            sn_ref: sn_ref, harga: price, date: dateStr 
        });
        saveJSON(dbFile, db);
        
        try {
            let msg = `*TRANSAKSI ${trxStatus.toUpperCase()}* 🚀\n\n📦 Produk: ${name}\n📱 Tujuan: ${target}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n🔖 SN: ${sn_ref || '-'}\n\n💳 Sisa Saldo: Rp ${db[phone].saldo.toLocaleString('id-ID')}\n\nTerima kasih telah menggunakan DIGITAL FIKY STORE!`;
            global.waSocket?.sendMessage(db[phone].jid || phone + '@s.whatsapp.net', { text: msg });
        } catch(err) {}

        res.json({ message: 'Transaksi berhasil diproses.' });
    } catch (fatalErr) {
        console.error("FATAL ERROR DI TRANSAKSI:", fatalErr);
        res.status(500).json({ error: 'Terjadi kesalahan sistem internal: ' + fatalErr.message });
    }
});

// ===============================================
// BACKGROUND ROBOT: AUTO CHECKER TRANSAKSI PROSES
// ===============================================
setInterval(async () => {
    let db = loadJSON(dbFile);
    let config = loadJSON(configFile);
    let changed = false;

    if(!config.digiUser || !config.digiKey) return;

    for (let phone in db) {
        let user = db[phone];
        if (!user.transactions) continue;

        for (let i = 0; i < user.transactions.length; i++) {
            let trx = user.transactions[i];
            
            if (trx.status === 'Proses' && !trx.isLocal && trx.sku) {
                try {
                    let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + trx.id).digest('hex');
                    let isDev = (config.digiKey || '').toLowerCase().startsWith('dev');
                    
                    let digiPayload = {
                        username: config.digiUser,
                        buyer_sku_code: trx.sku,
                        customer_no: trx.no_tujuan,
                        ref_id: trx.id,
                        sign: sign
                    };
                    
                    if (isDev) digiPayload.testing = true;

                    let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload);
                    let digiData = digiRes.data.data;

                    if (digiData.status === 'Sukses') {
                        trx.status = 'Sukses';
                        trx.sn_ref = digiData.sn || trx.sn_ref;
                        changed = true;
                        console.log(`[AUTO-CHECK] TRX Sukses: ${trx.id}`);
                        
                        try { global.waSocket?.sendMessage(user.jid || phone+'@s.whatsapp.net', { text: `✅ *TRANSAKSI SUKSES*\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}\n\nTerima kasih!` }); } catch(e){}
                        
                    } else if (digiData.status === 'Gagal') {
                        trx.status = 'Gagal';
                        trx.sn_ref = digiData.sn || digiData.message || 'Gagal dari Pusat';
                        
                        // AUTO REFUND
                        user.saldo += trx.harga;
                        user.mutasi.push({ id: 'REF'+Date.now(), type: 'in', amount: trx.harga, desc: `Refund: ${trx.produk}`, date: new Date().toLocaleString('id-ID') });
                        changed = true;
                        console.log(`[AUTO-CHECK] TRX Gagal & Refunded: ${trx.id}`);
                        
                        try { global.waSocket?.sendMessage(user.jid || phone+'@s.whatsapp.net', { text: `❌ *TRANSAKSI GAGAL*\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n⚠️ Alasan: ${digiData.message || 'Gangguan Server'}\n\n💰 Saldo Rp ${trx.harga.toLocaleString('id-ID')} telah dikembalikan.` }); } catch(e){}
                    }
                } catch(e) {
                    // Abaikan jika error jaringan saat mengecek
                }
            }
        }
    }
    if (changed) saveJSON(dbFile, db);
}, 20000); // Jalan setiap 20 detik
// ===============================================

app.post('/api/topup/request', (req, res) => {
    const { phone, method, nominal } = req.body; let db = loadJSON(dbFile);
    if (!db[phone]) db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    if (!db[phone].topup) db[phone].topup = [];
    const expiry = method === 'QRIS Otomatis' ? Date.now() + 5*60*1000 : null; 
    const newTopup = { id: 'TU' + Date.now(), method, nominal, status: 'Proses', date: new Date().toLocaleString('id-ID'), expiry };
    db[phone].topup.push(newTopup); saveJSON(dbFile, db); res.json({ message: 'Top up direkam' });
});

app.post('/api/topup/history', (req, res) => { 
    let db = loadJSON(dbFile); 
    let history = db[req.body.phone]?.topup || [];
    let changed = false;
    let now = Date.now();
    history.forEach(t => { if (t.status === 'Proses' && t.method === 'QRIS Otomatis' && t.expiry && now > t.expiry) { t.status = 'Expired'; changed = true; }});
    if (changed) saveJSON(dbFile, db); res.json({ history: history }); 
});

app.post('/api/user/transactions', (req, res) => { let db = loadJSON(dbFile); res.json({ transactions: db[req.body.phone]?.transactions || [] }); });

app.post('/api/admin/add_balance', async (req, res) => {
    const { identifier, amount } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    let targetPhone = null;
    if(identifier.includes('@')){
        for(let p in webUsers){ if(webUsers[p].email === identifier){ targetPhone = p; break; } }
    } else { targetPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier; }
    if(!targetPhone || !webUsers[targetPhone]) return res.json({ success: false, message: '\n❌ Member tidak ditemukan di database!' });

    if(!db[targetPhone]) db[targetPhone] = { saldo: 0, jid: targetPhone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    if(!db[targetPhone].mutasi) db[targetPhone].mutasi = [];
    if(!db[targetPhone].topup) db[targetPhone].topup = [];
    
    db[targetPhone].saldo += parseInt(amount); const dateStr = new Date().toLocaleString('id-ID');
    db[targetPhone].mutasi.push({ id: 'TRX'+Date.now(), type: 'in', amount: parseInt(amount), desc: 'Penambahan oleh Admin', date: dateStr });
    db[targetPhone].topup.push({ id: 'TU'+Date.now(), method: 'Admin Fiky Store', nominal: parseInt(amount), status: 'Sukses', date: dateStr });
    saveJSON(dbFile, db);
    try { await global.waSocket?.sendMessage(targetPhone + '@c.us', { text: `Halo *${webUsers[targetPhone].name}*! 👋\n\n🎉 Saldo Anda berhasil ditambah oleh Admin sebesar *Rp ${parseInt(amount).toLocaleString('id-ID')}*.\n💰 Sisa Saldo: *Rp ${db[targetPhone].saldo.toLocaleString('id-ID')}*.\n\nSelamat bertransaksi! 🚀` }); } catch(e) {}
    res.json({ success: true, message: `\n✅ Saldo ${webUsers[targetPhone].name} berhasil ditambah!` });
});

app.post('/api/auth/login-req', async (req, res) => {
    const { identifier, password } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => (p === fPhone || webUsers[p].email === identifier) && webUsers[p].password === password);
    
    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP saat pendaftaran.' });
        const otp = Math.floor(1000 + Math.random() * 9000).toString();
        webUsers[foundPhone].loginOtp = otp; webUsers[foundPhone].loginOtpExpiry = Date.now() + 5 * 60 * 1000; saveJSON(webUsersFile, webUsers);
        try { await global.waSocket?.sendMessage(foundPhone + '@c.us', { text: `Halo *${webUsers[foundPhone].name}*! 👋\n\nAda percobaan masuk ke akun DIGITAL FIKY STORE Anda.\n\nBerikut kode OTP Login Anda:\n*${otp}*\n\n⏳ _Berlaku 5 menit._\n⚠️ _Jangan bagikan kode ini!_` }); } catch(e) {}
        res.json({ message: 'OTP Terkirim', phone: foundPhone });
    } else { res.status(400).json({ error: 'Email/No HP atau Password salah.' }); }
});

app.post('/api/auth/login-verify', (req, res) => {
    const { phone, otp } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].loginOtp === otp) {
        if(Date.now() > webUsers[phone].loginOtpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        delete webUsers[phone].loginOtp; delete webUsers[phone].loginOtpExpiry; saveJSON(webUsersFile, webUsers);
        res.json({ message: 'Login sukses', user: { phone: phone, name: webUsers[phone].name, email: webUsers[phone].email, avatar: webUsers[phone].avatar || null } });
    } else { res.status(400).json({ error: 'Kode OTP Salah.' }); }
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) return res.status(400).json({ error: 'Nomor terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); 
    webUsers[fPhone] = { name, email, password, isVerified: false, otp, otpExpiry: Date.now() + 5 * 60 * 1000, avatar: null }; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Kode OTP Daftar Anda:\n*${otp}*\n\n⏳ Berlaku 5 menit.` }); res.json({ message: 'OTP Terkirim', phone: fPhone }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        if(Date.now() > webUsers[phone].otpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        webUsers[phone].isVerified = true; webUsers[phone].otp = null; delete webUsers[phone].otpExpiry; saveJSON(webUsersFile, webUsers);
        let db = loadJSON(dbFile); if (!db[phone]) { db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] }; saveJSON(dbFile, db); } res.json({ message: 'Sukses!' });
    } else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (!webUsers[fPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fPhone].otp = otp; webUsers[fPhone].otpExpiry = Date.now() + 5 * 60 * 1000; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Kode OTP Reset Password:\n*${otp}*\n\n⏳ Berlaku 5 menit.` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) { 
        if(Date.now() > webUsers[phone].otpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        webUsers[phone].password = newPassword; webUsers[phone].otp = null; delete webUsers[phone].otpExpiry; saveJSON(webUsersFile, webUsers); res.json({ message: 'Diubah!' }); 
    } else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/auth/request-update-otp', async (req, res) => {
    const { oldPhone, newPhone } = req.body; let webUsers = loadJSON(webUsersFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (webUsers[fNew] && fNew !== fOld) return res.status(400).json({ error: 'Nomor baru sudah terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    if(webUsers[fOld]) { 
        webUsers[fOld].updateOtp = otp; webUsers[fOld].updateOtpExpiry = Date.now() + 5 * 60 * 1000; saveJSON(webUsersFile, webUsers); 
        try { await global.waSocket?.sendMessage(fNew + '@c.us', { text: `Kode OTP Ganti Nomor:\n*${otp}*\n\n⏳ Berlaku 5 menit.` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); } 
    } else res.status(400).json({ error: 'Akun tidak ditemukan.' });
});

app.post('/api/auth/update', (req, res) => {
    const { oldPhone, newPhone, newName, otp, avatar } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    if (fOld !== fNew) {
        if (webUsers[fNew]) return res.status(400).json({ error: 'Nomor sudah dipakai.' });
        if (webUsers[fOld].updateOtp !== otp) return res.status(400).json({ error: 'Kode OTP Salah.' });
        if (Date.now() > webUsers[fOld].updateOtpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        webUsers[fNew] = { ...webUsers[fOld], name: newName, avatar: avatar || webUsers[fOld].avatar }; 
        delete webUsers[fNew].updateOtp; delete webUsers[fNew].updateOtpExpiry; delete webUsers[fOld];
        if (db[fOld]) { db[fNew] = { ...db[fOld], jid: fNew + '@s.whatsapp.net' }; delete db[fOld]; }
    } else { webUsers[fOld].name = newName; if(avatar !== undefined) webUsers[fOld].avatar = avatar; }
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
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: ['Ubuntu', 'Chrome', '20.0.0'], printQRInTerminal: false, connectTimeoutMs: 60000, defaultQueryTimeoutMs: 0, keepAliveIntervalMs: 10000, emitOwnEvents: true });
    if (!sock.authState.creds.registered) { 
        let config = loadJSON(configFile); 
        if (config.botNumber) { 
            setTimeout(async () => { try { const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, '')); console.log(`\n🔑 KODE PAIRING ANDA :  ${code}  \n`); } catch (error) {} }, 5000); 
        } 
    }
    sock.ev.on('connection.update', (update) => {
        const { connection, lastDisconnect } = update;
        if (connection === 'close') {
            const shouldReconnect = (lastDisconnect.error)?.output?.statusCode !== DisconnectReason.loggedOut;
            if (shouldReconnect) setTimeout(startBot, 3000);
        } else if (connection === 'open') { console.log('\n✅ BOT WHATSAPP BERHASIL TERHUBUNG!\n'); }
    });
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

# Konfigurasi Warna Terminal
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

while true; do clear
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${YELLOW}           💎 PANEL DIGITAL FIKY STORE (V99) 💎       ${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo ""
    echo -e "${PURPLE}[ 🤖 MANAJEMEN BOT WHATSAPP ]${NC}"
    echo -e "  ${GREEN}1.${NC} Setup No. Bot & Login Pairing"
    echo -e "  ${GREEN}2.${NC} Jalankan Bot (Latar Belakang/PM2)"
    echo -e "  ${GREEN}3.${NC} Hentikan Bot (PM2)"
    echo -e "  ${GREEN}4.${NC} Lihat Log / Error Bot"
    echo -e "  ${GREEN}5.${NC} Reset Sesi & Ganti Nomor Bot"
    echo ""
    echo -e "${PURPLE}[ 📱 MANAJEMEN APLIKASI & WEB ]${NC}"
    echo -e "  ${GREEN}6.${NC} 💰 Manajemen Saldo Member"
    echo -e "  ${GREEN}7.${NC} 🖼️ Manajemen Banner Promo"
    echo -e "  ${GREEN}8.${NC} 📲 Ganti Foto QRIS Top Up"
    echo -e "  ${GREEN}9.${NC} 📢 Manajemen Pusat Informasi"
    echo -e "  ${GREEN}10.${NC} 📈 Seting Keuntungan (Markup Harga)"
    echo -e "  ${GREEN}11.${NC} 📦 Manajemen Produk (Katalog Manual & API)"
    echo ""
    echo -e "${PURPLE}[ 🌐 MANAJEMEN SERVER & API ]${NC}"
    echo -e "  ${GREEN}12.${NC} Setup Domain (Nginx + Cloudflare + UFW Firewall)"
    echo -e "  ${GREEN}13.${NC} 🔌 Setup API Digiflazz"
    echo -e "  ${GREEN}14.${NC} 🔍 Cek Saldo & Koneksi Digiflazz"
    echo -e "  ${GREEN}15.${NC} 🔄 Refresh Katalog Digiflazz (Hapus Cache API)"
    echo ""
    echo -e "${PURPLE}[ ⚙️ SISTEM ]${NC}"
    echo -e "  ${YELLOW}16.${NC} Update Sistem (Tarik Kode Terbaru)"
    echo -e "  ${RED}0.${NC} Keluar"
    echo -e "${CYAN}======================================================${NC}"
    read -p "Pilih menu [0-16]: " choice

    case $choice in
        1) cd "$HOME/$DIR_NAME" && node index.js ;;
        2) cd "$HOME/$DIR_NAME" && pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save ;;
        3) pm2 stop $BOT_NAME ;;
        4) pm2 logs $BOT_NAME ;;
        5) 
            pm2 stop $BOT_NAME 2>/dev/null
            rm -rf "$HOME/$DIR_NAME/sesi_bot"
            echo -e "${GREEN}Sesi WhatsApp berhasil dihapus!${NC}"
            echo -e "Apakah Anda ingin mengganti Nomor Bot juga? (y/n)"
            read -p "Pilih: " ganti_nomor
            if [[ "$ganti_nomor" == "y" || "$ganti_nomor" == "Y" ]]; then
                read -p "Masukkan Nomor WA Bot Baru (Awalan 62, contoh: 62812...): " newbotnum
                if [ ! -z "$newbotnum" ]; then
                    node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};cfg.botNumber='$newbotnum';fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('Nomor Bot diperbarui!');"
                fi
            fi
            echo -e "${YELLOW}Silakan pilih Menu No. 1 untuk mulai pairing ulang.${NC}"
            read -p "Tekan Enter untuk kembali..."
            ;;
        6)
            while true; do
                clear
                echo -e "${CYAN}===============================================${NC}"
                echo -e "${YELLOW}          💰 MANAJEMEN SALDO MEMBER            ${NC}"
                echo -e "${CYAN}===============================================${NC}"
                echo "1. 📋 Daftar Semua Member & Saldo"
                echo "2. 🔍 Cek Saldo Member Spesifik"
                echo "3. ➕ Tambah Saldo Member (Kirim Notif WA)"
                echo "4. ➖ Kurangi Saldo Member"
                echo -e "${RED}0. Kembali ke Menu Utama${NC}"
                echo -e "${CYAN}===============================================${NC}"
                read -p "Pilih [0-4]: " saldomenu
                case $saldomenu in
                    1)
                        node -e "const fs=require('fs');const db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};const users=fs.existsSync('$HOME/$DIR_NAME/web_users.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/web_users.json')):{};console.log('\n======================================================');console.log('📋 DAFTAR MEMBER DIGITAL FIKY STORE');console.log('======================================================');let count=0;for(let phone in users){if(users[phone].isVerified){let saldo=db[phone]?db[phone].saldo:0;console.log('- '+users[phone].name+' ('+phone+') ['+users[phone].email+'] : Rp '+saldo.toLocaleString('id-ID'));count++;}}if(count===0)console.log('Belum ada member terverifikasi.');console.log('======================================================\n');"
                        read -p "Tekan Enter..." ;;
                    2)
                        read -p "ID Member (No WA / Email): " nomor
                        node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/database.json';let uf='$HOME/$DIR_NAME/web_users.json';let db=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):{};let users=fs.existsSync(uf)?JSON.parse(fs.readFileSync(uf)):{};let input='$nomor';let targetPhone=null;if(input.includes('@')){for(let p in users){if(users[p].email===input){targetPhone=p;break;}}}else{targetPhone=input.startsWith('0')?'62'+input.slice(1):input;}if(targetPhone && db[targetPhone]){let n=users[targetPhone]?users[targetPhone].name:targetPhone;console.log('\n✅ Saldo '+n+' ('+targetPhone+') saat ini: Rp '+db[targetPhone].saldo.toLocaleString('id-ID'));}else{console.log('\n❌ Member tidak ditemukan!');}"
                        read -p "Tekan Enter..." ;;
                    3)
                        read -p "ID Member (No WA / Email): " nomor
                        read -p "Jumlah Tambah Saldo: " jumlah
                        node -e "const http=require('http');const data=JSON.stringify({identifier:'$nomor',amount:parseInt('$jumlah')});const req=http.request({hostname:'localhost',port:3000,path:'/api/admin/add_balance',method:'POST',headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(data)}},res=>{let body='';res.on('data',c=>body+=c);res.on('end',()=>{try{console.log(JSON.parse(body).message);}catch(e){}});});req.on('error',e=>console.log('\n❌ Server web belum berjalan (pm2 belum start)'));req.write(data);req.end();"
                        read -p "Tekan Enter..." ;;
                    4)
                        read -p "ID Member (No WA / Email): " nomor
                        read -p "Jumlah Kurangi Saldo: " jumlah
                        node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/database.json';let uf='$HOME/$DIR_NAME/web_users.json';let db=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};let users=fs.existsSync(uf)?JSON.parse(fs.readFileSync(uf)):{};let input='$nomor';let targetPhone=null;if(input.includes('@')){for(let p in users){if(users[p].email===input){targetPhone=p;break;}}}else{targetPhone=input.startsWith('0')?'62'+input.slice(1):input;}if(!targetPhone || !db[targetPhone]){console.log('\n❌ Member tidak ditemukan!');}else{if(!db[targetPhone].mutasi)db[targetPhone].mutasi=[];db[targetPhone].saldo-=parseInt('$jumlah');db[targetPhone].mutasi.push({id:'TRX'+Date.now(),type:'out',amount:parseInt('$jumlah'),desc:'Pengurangan oleh Admin',date:new Date().toLocaleString('id-ID')});fs.writeFileSync(file,JSON.stringify(db,null,2));let n=users[targetPhone]?users[targetPhone].name:targetPhone;console.log('\n✅ Saldo '+n+' berhasil dikurangi!');}"
                        read -p "Tekan Enter..." ;;
                    0) break ;;
                esac
            done
            ;;
        7)
            while true; do
                clear
                echo -e "${CYAN}===============================================${NC}"
                echo -e "${YELLOW}          🖼️ MANAJEMEN BANNER PROMO            ${NC}"
                echo -e "${CYAN}===============================================${NC}"
                echo "1. 👁️ Lihat Banner Saat Ini"
                echo "2. ➕ Tambah Banner Baru"
                echo "3. ➖ Hapus Banner"
                echo "4. ❌ Kosongkan Semua Banner (Sembunyikan UI)"
                echo -e "${RED}0. Kembali ke Menu Utama${NC}"
                echo -e "${CYAN}===============================================${NC}"
                read -p "Pilih [0-4]: " bannermenu
                case $bannermenu in
                    1)
                        node -e "const fs=require('fs');let c=fs.existsSync('$HOME/$DIR_NAME/config.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/config.json')):{};if(!c.banners||c.banners.length===0)console.log('\n❌ Tidak ada banner saat ini.');else {console.log('\nDaftar Banner:');c.banners.forEach((b,i)=>console.log('['+i+'] '+b));}"
                        read -p "Tekan Enter..." ;;
                    2)
                        read -p "Masukkan URL Gambar Banner Baru: " urlbanner
                        if [ ! -z "$urlbanner" ]; then
                            node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/config.json';let c=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):{};if(!c.banners)c.banners=[];c.banners.push('$urlbanner');fs.writeFileSync(f,JSON.stringify(c,null,2));console.log('\n✅ Banner berhasil ditambahkan!');"
                        fi
                        read -p "Tekan Enter..." ;;
                    3)
                        node -e "const fs=require('fs');let c=fs.existsSync('$HOME/$DIR_NAME/config.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/config.json')):{};if(!c.banners||c.banners.length===0)console.log('\n❌ Tidak ada banner saat ini.');else {console.log('\nDaftar Banner:');c.banners.forEach((b,i)=>console.log('['+i+'] '+b));}"
                        read -p "Masukkan nomor banner yang mau dihapus: " hapusid
                        if [ ! -z "$hapusid" ]; then
                            node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/config.json';let c=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):{};if(c.banners && c.banners['$hapusid']){c.banners.splice('$hapusid',1);fs.writeFileSync(f,JSON.stringify(c,null,2));console.log('\n✅ Banner berhasil dihapus!');}else{console.log('\n❌ Nomor banner tidak valid.');}"
                        fi
                        read -p "Tekan Enter..." ;;
                    4)
                        node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/config.json';let c=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):{};c.banners=[];fs.writeFileSync(f,JSON.stringify(c,null,2));console.log('\n✅ Semua banner dihapus! Kolom banner otomatis disembunyikan di aplikasi.');"
                        read -p "Tekan Enter..." ;;
                    0) break ;;
                esac
            done
            ;;
        8) read -p "Masukkan Link URL Gambar QRIS: " qrisurl && node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};if('$qrisurl'.trim())cfg.qrisUrl='$qrisurl'.trim();fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('QRIS diperbarui!');"; read -p "Tekan Enter..." ;;
        9) while true; do clear; echo -e "${CYAN}--- 📢 PUSAT INFORMASI ---${NC}"; echo "1. Tambah Info Baru"; echo "2. Hapus Info"; echo -e "${RED}0. Kembali${NC}"; read -p "Pilih: " infomenu; case $infomenu in 1) read -p "Judul: " judul; read -p "Isi: " isi; node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];d.push({judul:'$judul',isi:'$isi',date:new Date().toLocaleDateString('id-ID')});fs.writeFileSync(f,JSON.stringify(d,null,2));"; echo -e "${GREEN}Berhasil!${NC}"; read -p "Enter...";; 2) node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(d.length===0)console.log('Kosong.');else{d.forEach((x,i)=>console.log('['+i+'] '+x.judul));}"; read -p "Nomor yg dihapus: " hapusid; if [ ! -z "$hapusid" ]; then node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/info.json';let d=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(d['$hapusid']){d.splice('$hapusid',1);fs.writeFileSync(f,JSON.stringify(d,null,2));console.log('Dihapus!');}"; fi; read -p "Enter...";; 0) break;; esac; done ;;
        10)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}       📈 SETING KEUNTUNGAN (MARKUP HARGA)     ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo -e "Atur margin keuntungan per transaksi bertingkat."
            echo ""
            read -p "Markup untuk modal DI BAWAH Rp 10.000 (cth: 1000): " m1
            read -p "Markup untuk modal Rp 10.000 - Rp 50.000 (cth: 1500): " m2
            read -p "Markup untuk modal Rp 50.001 - Rp 100.000 (cth: 2000): " m3
            read -p "Markup untuk modal DI ATAS Rp 100.000 (cth: 3000): " m4
            node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};cfg.markupTiers={tier1:parseInt('$m1')||0,tier2:parseInt('$m2')||0,tier3:parseInt('$m3')||0,tier4:parseInt('$m4')||0};fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('\n✅ Markup Bertingkat berhasil disimpan!');"
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter untuk kembali..."
            ;;
        11)
            while true; do
                clear
                echo -e "${CYAN}===============================================${NC}"
                echo -e "${YELLOW}       📦 MANAJEMEN PRODUK LOKAL / HYBRID      ${NC}"
                echo -e "${CYAN}===============================================${NC}"
                echo "Gunakan menu ini untuk menambahkan produk Digiflazz"
                echo "yang tidak muncul otomatis, agar terhubung ke API."
                echo ""
                echo "1. ➕ Tambah Produk"
                echo "2. 📋 Daftar Produk"
                echo "3. ➖ Hapus Produk"
                echo -e "${RED}0. Kembali ke Menu Utama${NC}"
                echo -e "${CYAN}===============================================${NC}"
                read -p "Pilih [0-3]: " prodmenu
                case $prodmenu in
                    1)
                        echo -e "\n--- TAMBAH PRODUK BARU ---"
                        echo -e "\nPilih Tipe Produk:"
                        echo "1. pulsa"
                        echo "2. data"
                        echo "3. ewallet"
                        echo "4. etoll"
                        echo "5. game"
                        echo "6. pln"
                        echo "7. masaaktif"
                        read -p "Masukkan Angka [1-7]: " type_choice

                        case $type_choice in
                            1) p_type="pulsa" ;;
                            2) p_type="data" ;;
                            3) p_type="ewallet" ;;
                            4) p_type="etoll" ;;
                            5) p_type="game" ;;
                            6) p_type="pln" ;;
                            7) p_type="masaaktif" ;;
                            *) echo -e "${RED}Pilihan tidak valid! Batal menambahkan.${NC}"; read -p "Tekan Enter..."; continue ;;
                        esac
                        
                        echo -e "\nFormat Brand: XL, TELKOMSEL, DANA, MOBILE LEGENDS, dll"
                        read -p "Provider / Brand: " p_brand
                        read -p "Kategori Sub (Khusus 'data', PASTIKAN SAMA PERSIS DENGAN NAMA MENU KATEGORI): " p_cat
                        read -p "Nama Produk (Tampil di Web): " p_name
                        read -p "Harga MODAL (Akan otomatis ditambah Markup): " p_price
                        read -p "SKU Digiflazz (WAJIB VALID, cth: C15GB): " p_sku
                        read -p "Deskripsi Singkat: " p_desc
                        
                        if [ ! -z "$p_name" ] && [ ! -z "$p_price" ]; then
                            node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];data.push({id:'LOC'+Date.now(),type:'$p_type'.toLowerCase(),brand:'$p_brand',category:'$p_cat',name:'$p_name',price:parseInt('$p_price')||0,sku:'$p_sku',desc:'$p_desc',isDigi:true});fs.writeFileSync(f,JSON.stringify(data,null,2));console.log('\n✅ Produk berhasil ditambahkan & terhubung ke API!');"
                        else
                            echo -e "${RED}Nama dan Harga wajib diisi!${NC}"
                        fi
                        read -p "Tekan Enter..." ;;
                    2)
                        node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];console.log('\n📋 DAFTAR PRODUK LOKAL/HYBRID:');if(data.length===0)console.log('Belum ada produk.');data.forEach((p,i)=>console.log('['+i+'] '+p.name+' | SKU: '+p.sku));console.log('');"
                        read -p "Tekan Enter..." ;;
                    3)
                        node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(data.length===0)console.log('\nBelum ada produk.');else data.forEach((p,i)=>console.log('['+i+'] '+p.name));"
                        read -p "Masukkan Nomor Produk yang mau dihapus: " del_id
                        if [ ! -z "$del_id" ]; then
                            node -e "const fs=require('fs');let f='$HOME/$DIR_NAME/local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(data['$del_id']){data.splice('$del_id',1);fs.writeFileSync(f,JSON.stringify(data,null,2));console.log('\n✅ Produk berhasil dihapus!');}else{console.log('\n❌ Nomor tidak valid.');}"
                        fi
                        read -p "Tekan Enter..." ;;
                    0) break ;;
                esac
            done
            ;;
        12)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}        🌐 SETUP DOMAIN (NGINX + UFW)          ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo -e "Pastikan Domain/Subdomain Anda sudah di-pointing"
            echo -e "ke IP VPS ini melalui Cloudflare (A Record)."
            echo -e "Di Cloudflare, pastikan menu SSL/TLS di set ke mode: ${RED}Flexible${NC}"
            echo ""
            read -p "Masukkan Nama Domain LENGKAP (cth: digital.myfiky.store): " domain_name
            if [ ! -z "$domain_name" ]; then
                echo -e "\n${YELLOW}Menginstal Nginx & Membuka Port Firewall...${NC}"
                apt-get install nginx ufw -y > /dev/null 2>&1
                ufw allow 80/tcp > /dev/null 2>&1
                ufw allow 443/tcp > /dev/null 2>&1
                
                echo -e "${YELLOW}Mengonfigurasi Server Block untuk $domain_name...${NC}"
                cat << EOFNGINX > /etc/nginx/sites-available/$domain_name
server {
    listen 80;
    server_name $domain_name;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOFNGINX
                ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
                rm -f /etc/nginx/sites-enabled/default
                nginx -t && systemctl restart nginx
                echo -e "${GREEN}✅ Domain $domain_name berhasil dikonfigurasi!${NC}"
                echo -e "Silakan akses website melalui: http://$domain_name (atau HTTPS jika via Cloudflare)"
            else
                echo -e "${RED}❌ Domain tidak boleh kosong!${NC}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        13)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}             🔌 SETUP API DIGIFLAZZ            ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo -e "Kredensial bisa diambil dari Dashboard Digiflazz."
            echo -e "${RED}PENTING: WAJIB MASUKKAN PRODUCTION KEY!${NC}"
            echo -e "Jika memasukkan Development Key (awalan dev-), transaksi tidak akan memotong saldo."
            echo ""
            read -p "Masukkan Username Digiflazz: " digi_user
            read -p "Masukkan API Key (Bukan Dev Key): " digi_key
            if [ ! -z "$digi_user" ] && [ ! -z "$digi_key" ]; then
                node -e "const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};cfg.digiUser='$digi_user';cfg.digiKey='$digi_key';fs.writeFileSync(file,JSON.stringify(cfg,null,2));console.log('\n✅ Data API Digiflazz berhasil disimpan!');"
                pm2 restart $BOT_NAME > /dev/null 2>&1
                echo -e "${GREEN}Sistem berhasil di-restart untuk menerapkan API.${NC}"
            else
                echo -e "${RED}❌ Username dan API Key wajib diisi!${NC}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        14)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}         🔍 CEK SALDO & KONEKSI DIGIFLAZZ      ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            node -e "const axios=require('axios');const crypto=require('crypto');const fs=require('fs');let file='$HOME/$DIR_NAME/config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};if(!cfg.digiUser||!cfg.digiKey){console.log('❌ Kredensial API belum diseting di Opsi 13!');process.exit(1);} let sign = crypto.createHash('md5').update(cfg.digiUser + cfg.digiKey + 'depo').digest('hex'); axios.post('https://api.digiflazz.com/v1/cek-saldo', {cmd:'deposit',username:cfg.digiUser,sign:sign}).then(r=>{console.log('✅ KONEKSI BERHASIL!');console.log('💰 Saldo Digiflazz Anda: Rp '+r.data.data.deposit.toLocaleString('id-ID'));}).catch(e=>{console.log('❌ KONEKSI GAGAL!');console.log(e.response?e.response.data:e.message);});"
            echo ""
            read -p "Tekan Enter untuk kembali..."
            ;;
        15)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}        🔄 REFRESH KATALOG DIGIFLAZZ           ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo -e "Menghapus cache sistem dan menarik data terbaru dari Digiflazz..."
            pm2 restart $BOT_NAME > /dev/null 2>&1
            echo -e "${GREEN}✅ Katalog berhasil di-refresh! Silakan cek web Anda.${NC}"
            read -p "Tekan Enter untuk kembali..."
            ;;
        16) 
            echo -e "${RED}PERINGATAN: Jangan lakukan Update Sistem kecuali file di Github sudah diperbarui ke versi V99!${NC}"
            echo "Jika di GitHub Anda scriptnya masih versi lama, Web Anda akan kembali rusak!"
            read -p "Lanjutkan Update Sistem dari GitHub? (y/n): " confirm_pull
            if [[ "$confirm_pull" == "y" || "$confirm_pull" == "Y" ]]; then
                cd "$HOME" && wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh && chmod +x install.sh && ./install.sh && exit 0
            fi
            ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
pm2 restart digital-fiky-bot > /dev/null 2>&1
echo "=========================================================="
echo "  SISTEM WEB & BOT BERHASIL DIPERBARUI SECARA PENUH!      "
echo "  Ketik 'menu' di terminal untuk membuka panel manajemen  "
echo "=========================================================="
