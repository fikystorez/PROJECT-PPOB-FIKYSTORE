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
echo "[3/5] Membangun Antarmuka Website..."

cat << 'EOF' > public/style.css
body {
    background-color: #fde047; 
    margin: 0;
    font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
}

.centered-modal-box {
    background-color: #002147; 
    padding: 3rem 1.5rem 2rem 1.5rem; 
    border-radius: 1.2rem; 
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2); 
    width: 90%;
    max-width: 360px; 
    text-align: center;
    position: relative;
    z-index: 10;
}

.logo-f-metalik-box {
    width: 85px; height: 85px; margin: 0 auto; 
    display: flex; justify-content: center; align-items: center;
    border-radius: 50%; border: 3px solid #94a3b8;
    background: radial-gradient(circle, #333333 0%, #000000 100%); 
    box-shadow: inset 0 0 10px rgba(255,255,255,0.2), 0 10px 20px rgba(0,0,0,0.5); 
    position: relative;
}
.logo-f-metalik-box::before {
    content: "F"; font-size: 55px; font-family: "Times New Roman", Times, serif;
    font-weight: bold; color: #e2e8f0; 
    text-shadow: 2px 2px 4px rgba(0,0,0,0.9), -1px -1px 1px rgba(255,255,255,0.3); 
    position: absolute; top: 52%; left: 50%; transform: translate(-50%, -50%);
}

.logo-f-small {
    width: 45px; height: 45px; margin: 0 auto 10px auto; 
    display: flex; justify-content: center; align-items: center;
    border-radius: 50%; border: 2px solid #cbd5e1;
    background: radial-gradient(circle, #333333 0%, #000000 100%); 
    box-shadow: inset 0 0 5px rgba(255,255,255,0.2), 0 5px 10px rgba(0,0,0,0.5); 
    position: relative; z-index: 2;
}
.logo-f-small::before {
    content: "F"; font-size: 28px; font-family: "Times New Roman", Times, serif;
    font-weight: bold; color: #e2e8f0; 
    text-shadow: 1px 1px 2px rgba(0,0,0,0.9); 
    position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
}

.compact-input-box {
    width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; 
    border-radius: 0.5rem; margin-bottom: 0.85rem; font-size: 0.875rem; 
    outline: none; background-color: #ffffff; color: #0f172a;
}
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.compact-link-small:hover { text-decoration: underline; color: #fef08a; }

.btn-yellow {
    width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147;
    font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s;
}
.btn-yellow:hover { background-color: #facc15; }

.btn-green {
    width: 100%; padding: 0.625rem 1rem; background-color: #16a34a; color: #ffffff;
    font-weight: bold; font-size: 0.9rem; border-radius: 0.5rem; cursor: pointer; border: none; transition: all 0.2s;
}

.tech-bg {
    position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='none' stroke='rgba(255,255,255,0.06)' stroke-width='1.5'%3E%3Cpath d='M0 40h20l10-10h20l10 10h20'/%3E%3Cpath d='M20 40v20l10 10'/%3E%3Cpath d='M60 40V20L50 10'/%3E%3Ccircle cx='30' cy='30' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='50' cy='50' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='10' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3Ccircle cx='70' cy='40' r='2' fill='rgba(255,255,255,0.1)'/%3E%3C/g%3E%3C/svg%3E");
    background-size: 80px 80px; pointer-events: none; z-index: 1; border-radius: 1rem;
}

.hide-scrollbar::-webkit-scrollbar { display: none; }
.hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
EOF

# HTML LOGIN
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="z-20 mb-[-42px]">
        <div class="logo-f-metalik-box"></div>
    </div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
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
                const res = await fetch('/api/auth/login', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ identifier, password })
                });
                const data = await res.json();
                if (res.ok) { localStorage.setItem('user', JSON.stringify(data.user)); window.location.href = '/dashboard.html'; } else { alert(data.error); }
            } catch (err) { alert('Terjadi kesalahan sistem.'); }
        });
    </script>
</body>
</html>
EOF

# HTML REGISTER
cat << 'EOF' > public/register.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="z-20 mb-[-42px]" id="logo-header"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14" id="box-register">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-2">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2>
        <p class="compact-text-small mb-4">Silahkan lengkapi data untuk mendaftar!</p>
        <form id="registerForm">
            <div><label class="compact-label">Nama Lengkap</label><input type="text" id="name" class="compact-input-box" required placeholder="Ketik disini"></div>
            <div><label class="compact-label">Nomor WA Aktif</label><input type="number" id="phone" class="compact-input-box" required placeholder="Ketik disini (08123...)"></div>
            <div><label class="compact-label">Email</label><input type="email" id="email" class="compact-input-box" required placeholder="Ketik disini"></div>
            <div><label class="compact-label">Password</label><input type="password" id="password" class="compact-input-box" required placeholder="Ketik disini"></div>
            <button type="submit" class="btn-yellow mt-1">Daftar Sekarang</button>
        </form>
        <div class="mt-4 text-center compact-text-small">Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a></div>
    </div>
    <div class="centered-modal-box pt-14 hidden" id="box-otp">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2>
        <p class="compact-text-small mb-5 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
        <form id="otpForm">
            <div><label class="compact-label text-center">Kode OTP (4 Digit)</label><input type="number" id="otpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX"></div>
            <button type="submit" class="btn-yellow mt-4">Verifikasi OTP</button>
        </form>
    </div>
    <script>
        let registeredPhone = '';
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const name = document.getElementById('name').value;
            const phone = document.getElementById('phone').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            try {
                const res = await fetch('/api/auth/register', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ name, phone, email, password }) });
                const data = await res.json();
                if (res.ok) { registeredPhone = data.phone; document.getElementById('box-register').classList.add('hidden'); document.getElementById('box-otp').classList.remove('hidden'); alert('OTP Terkirim! Silakan cek WhatsApp Anda.'); } else { alert(data.error); }
            } catch (err) { alert('Gagal memproses pendaftaran.'); }
        });
        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const otp = document.getElementById('otpCode').value;
            try {
                const res = await fetch('/api/auth/verify', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: registeredPhone, otp }) });
                const data = await res.json();
                if (res.ok) { alert('Verifikasi Berhasil! Silakan Login.'); window.location.href = '/'; } else { alert(data.error); }
            } catch (err) { alert('Gagal verifikasi OTP.'); }
        });
    </script>
</body>
</html>
EOF

# HTML FORGOT
cat << 'EOF' > public/forgot.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lupa Password - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-[#fde047]">
    <div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2>
        <form id="requestOtpForm">
            <p class="compact-text-small mb-5 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div><input type="number" id="phone" class="compact-input-box text-center" required placeholder="Ketik disini (08123...)"></div>
            <button type="submit" class="btn-yellow mt-2">Kirim OTP Reset</button>
        </form>
        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-5 border-gray-600">
            <div><label class="compact-label text-center">Kode OTP (4 Digit)</label><input type="number" id="otp" class="compact-input-box text-center text-xl tracking-[0.5em] font-bold" required placeholder="XXXX"></div>
            <div><label class="compact-label text-center mt-2">Password Baru</label><input type="password" id="newPassword" class="compact-input-box" required placeholder="Ketik disini"></div>
            <button type="submit" class="btn-yellow mt-3">Simpan Password Baru</button>
        </form>
        <div class="mt-6 text-center compact-text-small">Kembali ke <a href="/" class="compact-link-small">Login</a></div>
    </div>
    <script>
        let resetPhone = '';
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const phone = document.getElementById('phone').value;
            try {
                const res = await fetch('/api/auth/forgot', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone }) });
                const data = await res.json();
                if (res.ok) { resetPhone = data.phone; document.getElementById('requestOtpForm').classList.add('hidden'); document.getElementById('resetForm').classList.remove('hidden'); alert('OTP Terkirim ke WA!'); } else { alert(data.error); }
            } catch (err) { alert('Gagal.'); }
        });
        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const otp = document.getElementById('otp').value;
            const newPassword = document.getElementById('newPassword').value;
            try {
                const res = await fetch('/api/auth/reset', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: resetPhone, otp, newPassword }) });
                if (res.ok) { alert('Password diubah!'); window.location.href = '/'; } else { alert(await res.json().error); }
            } catch (err) { alert('Gagal mereset.'); }
        });
    </script>
</body>
</html>
EOF

# HTML DASHBOARD PPOB PREMIUM
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
<body class="bg-gray-100 dark:bg-gray-900 font-sans transition-colors duration-300">
    <div class="max-w-md mx-auto bg-[#f4f6f9] dark:bg-gray-900 min-h-screen relative pb-24 shadow-2xl transition-colors duration-300 overflow-x-hidden">
        <div class="flex justify-between items-center p-4 bg-[#001229] text-white shadow-md sticky top-0 z-40">
            <div class="flex items-center gap-4">
                <i class="fas fa-bars text-xl cursor-pointer text-gray-300 hover:text-white" onclick="toggleSidebar()"></i>
                <h1 class="font-medium text-[17px] tracking-wide" id="headerGreeting">Hai, Member</h1>
            </div>
            <div class="bg-white/10 text-[11px] font-bold px-3 py-1.5 rounded-full border border-white/20">0 Trx</div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
            <div class="w-full bg-black bg-opacity-50" onclick="toggleSidebar()"></div>
            <div class="absolute top-0 left-0 w-3/4 max-w-[300px] h-full bg-white dark:bg-gray-900 shadow-2xl flex flex-col">
                <div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white relative">
                    <button class="absolute top-3 right-4 text-gray-300" onclick="toggleSidebar()"><i class="fas fa-times text-xl"></i></button>
                    <div class="w-20 h-20 bg-gray-300 rounded-full flex justify-center items-center text-gray-500 font-bold text-4xl mb-3 overflow-hidden shadow-inner">
                        <i class="fas fa-user mt-3"></i>
                    </div>
                    <h3 class="font-bold text-lg" id="sidebarName">User</h3>
                    <p class="text-sm text-gray-300" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-gray-700 dark:text-gray-200 text-sm">
                        <li class="px-6 py-4 border-b dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer" onclick="location.href='/profile.html'"><i class="far fa-user text-xl w-6"></i> Profil Akun</li>
                        <li class="px-6 py-4 border-b dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer"><i class="far fa-clock text-xl w-6"></i> Transaksi Saya</li>
                        <li class="px-6 py-4 border-b dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer"><i class="far fa-bell text-xl w-6"></i> Pemberitahuan</li>
                        <li class="px-6 py-4 border-b dark:border-gray-800 flex items-center gap-4 hover:bg-gray-50 cursor-pointer" onclick="window.open('https://wa.me/6282231154407', '_blank')"><i class="fas fa-headset text-xl w-6"></i> Hubungi Admin</li>
                        <li class="px-6 py-4 border-b dark:border-gray-800 flex items-center justify-between cursor-pointer" onclick="toggleDarkMode()">
                            <div class="flex items-center gap-4"><i class="far fa-moon text-xl w-6"></i> Mode Gelap</div>
                            <div class="w-10 h-5 bg-gray-300 dark:bg-blue-500 rounded-full relative"><div class="w-5 h-5 bg-white rounded-full absolute left-0 shadow-md transition-transform duration-300" id="darkModeToggleDot"></div></div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-5 bg-[#002147] rounded-3xl p-6 text-white relative overflow-hidden shadow-lg border-b-[5px] border-yellow-400">
            <div class="tech-bg opacity-70"></div> 
            <div class="text-center relative z-10">
                <p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p>
                <h2 class="text-4xl font-extrabold mb-6" id="displaySaldo">Rp 0</h2>
                <div class="flex gap-4"><button class="flex-1 border border-gray-500 text-white rounded-full py-2 text-xs font-bold">ISI SALDO</button><button class="flex-1 border border-gray-500 text-white rounded-full py-2 text-xs font-bold">BANTUAN</button></div>
            </div>
        </div>

        <div class="mx-4 mt-6 relative rounded-2xl h-[170px] overflow-hidden bg-gray-200 dark:bg-gray-800 shadow-sm"><div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div><div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div></div>

        <div class="mx-4 mt-6 bg-white dark:bg-gray-800 p-5 rounded-3xl shadow-sm border dark:border-gray-700 transition-colors mb-8">
            <h3 class="font-extrabold text-[#002147] dark:text-gray-100 mb-5 text-[15px]">Layanan Pilihan</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-2">
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-cyan-400 to-blue-600 text-white flex items-center justify-center text-xl shadow-lg shadow-blue-500/30 mb-2"><i class="fas fa-mobile-screen"></i></div><span class="text-[10px] font-bold dark:text-gray-200">PULSA</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-emerald-400 to-green-600 text-white flex items-center justify-center text-xl shadow-lg shadow-green-500/30 mb-2"><i class="fas fa-globe"></i></div><span class="text-[10px] font-bold dark:text-gray-200">DATA</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center text-xl shadow-lg shadow-orange-500/30 mb-2"><i class="fas fa-bolt"></i></div><span class="text-[10px] font-bold dark:text-gray-200">PLN</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-purple-400 to-pink-600 text-white flex items-center justify-center text-xl shadow-lg shadow-pink-500/30 mb-2"><i class="fas fa-gamepad"></i></div><span class="text-[10px] font-bold dark:text-gray-200">GAME</span></div>
                
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-indigo-400 to-purple-600 text-white flex items-center justify-center text-xl shadow-lg shadow-indigo-500/30 mb-2"><i class="fas fa-wallet"></i></div><span class="text-[10px] font-bold dark:text-gray-200">E-WALLET</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-rose-400 to-red-500 text-white flex items-center justify-center text-xl shadow-lg shadow-red-500/30 mb-2"><i class="fas fa-ticket-alt"></i></div><span class="text-[10px] font-bold dark:text-gray-200">VOUCHER</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-teal-400 to-cyan-600 text-white flex items-center justify-center text-xl shadow-lg shadow-cyan-500/30 mb-2"><i class="fas fa-phone-volume"></i></div><span class="text-[10px] font-bold dark:text-gray-200 text-center leading-tight mt-0.5">SMS<br>TELP</span></div>
                <div class="flex flex-col items-center cursor-pointer"><div class="w-[3.2rem] h-[3.2rem] rounded-[14px] bg-gradient-to-br from-gray-400 to-gray-600 text-white flex items-center justify-center text-xl shadow-lg shadow-gray-500/30 mb-2"><i class="fas fa-th-large"></i></div><span class="text-[10px] font-bold dark:text-gray-200">LAINNYA</span></div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-black rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-2xl z-40">
            <div class="flex flex-col items-center text-yellow-400 cursor-pointer" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">Home</span></div>
            <div class="flex flex-col items-center text-gray-400 cursor-pointer"><i class="fas fa-receipt text-xl"></i><span class="text-[10px] mt-1 font-bold">Riwayat</span></div>
            <div class="flex flex-col items-center text-gray-400 cursor-pointer"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">informasi</span></div>
            <div class="flex flex-col items-center text-gray-400 cursor-pointer" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">Profil</span></div>
        </div>
    </div>
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        document.getElementById('headerGreeting').innerText = "Hai, " + user.name.split(' ')[0];
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;

        function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); }
        function logout() { localStorage.removeItem('user'); window.location.href = '/'; }
        
        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); })
        .catch(err => { document.getElementById('displaySaldo').innerText = 'Rp 0'; });

        function toggleDarkMode() { 
            const isDark = document.getElementById('html-root').classList.toggle('dark');
            localStorage.setItem('darkMode', isDark);
            if(isDark) document.getElementById('darkModeToggleDot').classList.add('translate-x-5');
            else document.getElementById('darkModeToggleDot').classList.remove('translate-x-5');
        }
        if(localStorage.getItem('darkMode') === 'true') {
            document.getElementById('html-root').classList.add('dark');
            document.getElementById('darkModeToggleDot')?.classList.add('translate-x-5');
        }

        fetch('/api/banners').then(res => res.json()).then(data => {
            const slider = document.getElementById('promoSlider');
            if(data.banners && data.banners[0] !== "") {
                slider.innerHTML = data.banners.map(url => `<div class="w-full h-full shrink-0 snap-center"><img src="${url}" class="w-full h-full object-cover"></div>`).join('');
                document.getElementById('promoDots').innerHTML = data.banners.map((_, i) => `<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} transition-opacity duration-300 dot-indicator shadow-sm"></div>`).join('');
                
                let dots = document.querySelectorAll('.dot-indicator');
                let currentSlide = 0;
                slider.addEventListener('scroll', () => {
                    let slideIndex = Math.round(slider.scrollLeft / slider.clientWidth);
                    dots.forEach((dot, index) => { dot.classList.toggle('opacity-100', index === slideIndex); dot.classList.toggle('opacity-40', index !== slideIndex); });
                    currentSlide = slideIndex;
                });
                setInterval(() => { currentSlide = (currentSlide + 1) % data.banners.length; slider.scrollTo({ left: currentSlide * slider.clientWidth, behavior: 'smooth' }); }, 3500);
            }
        });
    </script>
</body>
</html>
EOF

# HTML HALAMAN PROFIL (NEW - 100% IDENTIK REFERENSI)
cat << 'EOF' > public/profile.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .tab-active { border-bottom: 2px solid #000; font-weight: bold; color: #000; }
    </style>
</head>
<body class="bg-white font-sans">
    <div class="max-w-md mx-auto min-h-screen relative pb-24 shadow-2xl">
        
        <div class="bg-black text-white pt-10 pb-8 flex flex-col items-center relative">
            <i class="fas fa-pencil-alt absolute top-6 right-6 text-lg cursor-pointer hover:text-yellow-400 transition"></i>
            
            <div class="w-[85px] h-[85px] bg-gray-300 rounded-full flex justify-center items-end overflow-hidden mb-3 shadow-lg border border-gray-600">
                <i class="fas fa-user text-[70px] text-gray-400 mt-2"></i>
            </div>
            
            <h2 class="text-[17px] font-medium tracking-wide" id="profileName">Nama Member</h2>
            <p class="text-[13px] text-gray-300 mt-1" id="profilePhone">08...</p>
        </div>

        <div class="flex border-b border-gray-200 text-center bg-white">
            <div class="flex-1 py-3.5 cursor-pointer text-gray-600 font-medium text-[13px] tracking-wide hover:bg-gray-50 transition">MENU</div>
            <div class="flex-1 py-3.5 cursor-pointer tab-active text-[13px] tracking-wide">PROFIL</div>
        </div>

        <div class="bg-white mt-1">
            <div class="flex items-center px-5 py-4 border-b border-gray-100">
                <i class="fas fa-envelope text-black text-lg w-8 text-center"></i>
                <div class="flex-1 ml-3 text-[14px] text-gray-800">Email</div>
                <div class="text-[13px] text-gray-500" id="profileEmail">email@gmail.com</div>
            </div>
            <div class="flex items-center px-5 py-4 border-b border-gray-100">
                <i class="fas fa-phone-alt text-black text-lg w-8 text-center"></i>
                <div class="flex-1 ml-3 text-[14px] text-gray-800">No.Telp</div>
                <div class="text-[13px] text-gray-500" id="profilePhoneData">08...</div>
            </div>
            <div class="flex items-center px-5 py-4 border-b border-gray-100">
                <i class="fas fa-wallet text-black text-lg w-8 text-center"></i>
                <div class="flex-1 ml-3 text-[14px] text-gray-800">Saldo Akun</div>
                <div class="text-[14px] font-bold text-blue-600 tracking-wide" id="profileSaldo">Rp 0</div>
            </div>
            <div class="flex items-center px-5 py-4 border-b border-gray-100">
                <i class="fas fa-exchange-alt text-black text-lg w-8 text-center"></i>
                <div class="flex-1 ml-3 text-[14px] text-gray-800">Jumlah Transaksi</div>
                <div class="text-[13px] text-gray-500">0 Trx</div>
            </div>
            <div class="flex items-center px-5 py-4 border-b border-gray-100 cursor-pointer hover:bg-red-50 transition" onclick="logout()">
                <i class="fas fa-sign-out-alt text-red-600 text-lg w-8 text-center"></i>
                <div class="flex-1 ml-3 text-[14px] font-bold text-red-600">Keluar</div>
            </div>
        </div>

        <div class="mt-10 pb-6 text-center">
            <p class="text-[11px] text-gray-500 mb-0.5">Powered by</p>
            <h3 class="text-[14px] font-bold text-black tracking-wide">Order Digital</h3>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-black rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-2xl z-40">
            <div class="flex flex-col items-center text-gray-400 cursor-pointer hover:text-yellow-400 transition" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">Home</span></div>
            <div class="flex flex-col items-center text-gray-400 cursor-pointer hover:text-yellow-400 transition"><i class="fas fa-receipt text-xl"></i><span class="text-[10px] mt-1 font-bold">Riwayat</span></div>
            <div class="flex flex-col items-center text-gray-400 cursor-pointer hover:text-yellow-400 transition"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">informasi</span></div>
            <div class="flex flex-col items-center text-yellow-400 cursor-pointer" onclick="location.href='/profile.html'"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">Profil</span></div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';

        document.getElementById('profileName').innerText = user.name;
        document.getElementById('profilePhone').innerText = user.phone;
        document.getElementById('profilePhoneData').innerText = user.phone;
        document.getElementById('profileEmail').innerText = user.email || 'fikyshoto@gmail.com';

        function logout() { localStorage.removeItem('user'); window.location.href = '/'; }

        fetch('/api/user/balance', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) })
        .then(res => res.json()).then(data => { document.getElementById('profileSaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); });
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

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.banners = configAwal.banners || ["https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=600&q=80"];
saveJSON(configFile, configAwal);

app.get('/api/banners', (req, res) => res.json({ banners: loadJSON(configFile).banners }));
app.post('/api/user/balance', (req, res) => res.json({ saldo: loadJSON(dbFile)[req.body.phone]?.saldo || 0 }));

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[fPhone] = { name, email, password, isVerified: false, otp };
    saveJSON(webUsersFile, webUsers);
    await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `OTP: *${otp}*` });
    res.json({ message: 'OTP Terkirim', phone: fPhone });
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let users = loadJSON(webUsersFile);
    if (users[phone] && users[phone].otp === otp) {
        users[phone].isVerified = true; saveJSON(webUsersFile, users);
        let db = loadJSON(dbFile); if (!db[phone]) db[phone] = { saldo: 0 }; saveJSON(dbFile, db);
        res.json({ message: 'Sukses' });
    } else res.status(400).json({ error: 'Salah' });
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let users = loadJSON(webUsersFile);
    let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let found = Object.keys(users).find(p => (p === fPhone || users[p].email === identifier) && users[p].password === password);
    if (found) res.json({ user: { phone: found, name: users[found].name, email: users[found].email } });
    else res.status(400).json({ error: 'Salah' });
});

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: Browsers.ubuntu('Chrome'), printQRInTerminal: false });
    sock.ev.on('creds.update', saveCreds);
    global.waSocket = sock; 
}

app.listen(3000, () => { console.log('🌐 Server Aktif.'); startBot(); });
EOF

npm install --silent
npm install -g pm2 > /dev/null 2>&1

echo "[5/5] Memperbarui Panel Manajemen..."
cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

while true; do clear
    echo "==============================================="
    echo "      🤖 PANEL DIGITAL FIKY STORE (V26) 🤖     "
    echo "==============================================="
    echo "1. Login Bot WA"
    echo "2. Jalankan Bot (PM2)"
    echo "3. Stop Bot (PM2)"
    echo "4. Cek Log"
    echo "5. Tambah Saldo Member"
    echo "6. Ganti Foto Banner"
    echo "7. Update Sistem"
    echo "0. Keluar"
    read -p "Pilih [0-7]: " choice
    case $choice in
        1) cd "$HOME/$DIR_NAME" && node index.js ;;
        2) pm2 start "$HOME/$DIR_NAME/index.js" --name $BOT_NAME && pm2 save ;;
        3) pm2 stop $BOT_NAME ;;
        4) pm2 logs $BOT_NAME ;;
        5) read -p "ID WA: " nomor && read -p "Saldo: " s && node -e "const fs=require('fs'); let db=JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')); db['$nomor']={saldo:parseInt('$s')}; fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));" ;;
        6) echo "Link Foto Banner..." ;;
        7) cd "$HOME" && wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh && chmod +x install.sh && ./install.sh ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
echo "=========================================================="
echo "  SUKSES! Silakan restart sistem (Menu 2)."
echo "=========================================================="
