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

echo "=========================================================="
echo "      MENGINSTAL DIGITAL FIKY STORE - NEON PREMIUM        "
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
echo "[3/5] Membangun Antarmuka Website (Desain Dashboard, Sidebar & Neon)..."

cat << 'EOF' > public/style.css
body {
    background-color: #f3f4f6; 
    margin: 0;
    font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
    transition: background-color 0.3s;
}

/* Latar Belakang Sirkuit Biru Neon */
.circuit-header {
    position: absolute;
    top: 0; left: 0; width: 100%; height: 40vh; 
    background: linear-gradient(135deg, #020617 0%, #1e3a8a 100%);
    background-image: radial-gradient(circle, rgba(56, 189, 248, 0.4) 1px, transparent 1px);
    background-size: 25px 25px;
    border-radius: 0 0 50% 50% / 0 0 10% 10%;
    z-index: -1;
    box-shadow: 0 10px 30px -10px rgba(30, 58, 138, 0.5);
}

.centered-modal-box {
    background-color: #002147; 
    padding: 3rem 1.5rem 2rem 1.5rem; 
    border-radius: 1.2rem; 
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.4), 0 10px 10px -5px rgba(0, 0, 0, 0.2); 
    width: 90%; max-width: 360px; 
    text-align: center; position: relative; z-index: 10;
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
    width: 50px; height: 50px; margin: 0 auto 10px auto; 
    display: flex; justify-content: center; align-items: center;
    border-radius: 50%; border: 2px solid #cbd5e1;
    background: radial-gradient(circle, #333333 0%, #000000 100%); 
    box-shadow: inset 0 0 5px rgba(255,255,255,0.2), 0 5px 10px rgba(0,0,0,0.5); 
    position: relative; z-index: 2;
}
.logo-f-small::before {
    content: "F"; font-size: 30px; font-family: "Times New Roman", Times, serif;
    font-weight: bold; color: #e2e8f0; 
    text-shadow: 1px 1px 2px rgba(0,0,0,0.9); 
    position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
}

.compact-input-box {
    width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; 
    border-radius: 0.5rem; margin-bottom: 0.85rem; font-size: 0.875rem; 
    outline: none; background-color: #ffffff; color: #0f172a;
}
.compact-input-box:focus { border-color: #38bdf8; box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.3); }
::placeholder { color: #94a3b8; font-size: 0.8rem; }
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

.wave-bg {
    position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background-image: url("data:image/svg+xml,%3Csvg width='100%25' height='100%25' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M0 40 Q 50 10, 100 40 T 200 40 T 300 40 T 400 40' fill='none' stroke='rgba(255,255,255,0.05)' stroke-width='2'/%3E%3Cpath d='M0 80 Q 50 50, 100 80 T 200 80 T 300 80 T 400 80' fill='none' stroke='rgba(255,255,255,0.03)' stroke-width='2'/%3E%3Cpath d='M0 120 Q 50 90, 100 120 T 200 120 T 300 120 T 400 120' fill='none' stroke='rgba(255,255,255,0.05)' stroke-width='2'/%3E%3C/svg%3E");
    background-size: cover; pointer-events: none; z-index: 1; border-radius: 1rem;
}

/* Toggle Switch CSS */
.toggle-checkbox:checked { right: 0; border-color: #fde047; }
.toggle-checkbox:checked + .toggle-label { background-color: #fde047; }
.toggle-checkbox { right: 50%; z-index: 1; transition: all 0.3s ease; }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-gray-50">
    <div class="circuit-header"></div>
    <div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
        <p class="text-xs text-gray-300 mb-6">Silahkan masukkan email/no HP dan password kamu!</p>
        <form id="loginForm">
            <div>
                <label class="compact-label">Email / No. HP</label>
                <input type="text" id="identifier" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <div>
                <label class="compact-label">Password</label>
                <input type="password" id="password" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <div class="text-right mb-5 mt-[-5px]">
                <a href="/forgot.html" class="compact-link-small">Lupa password?</a>
            </div>
            <button type="submit" class="btn-yellow">Login Sekarang</button>
        </form>
        <div class="mt-6 text-center text-xs text-gray-300">
            Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a>
        </div>
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
                if (res.ok) {
                    localStorage.setItem('user', JSON.stringify(data.user));
                    window.location.href = '/dashboard.html';
                } else { alert(data.error); }
            } catch (err) { alert('Terjadi kesalahan sistem.'); }
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
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-gray-50">
    <div class="circuit-header"></div>
    <div class="z-20 mb-[-42px]" id="logo-header"><div class="logo-f-metalik-box"></div></div>
    
    <div class="centered-modal-box pt-14" id="box-register">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-2">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2>
        <p class="text-xs text-gray-300 mb-4">Silahkan lengkapi data untuk mendaftar!</p>
        <form id="registerForm">
            <div>
                <label class="compact-label">Nama Lengkap</label>
                <input type="text" id="name" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <div>
                <label class="compact-label">Nomor WA Aktif</label>
                <input type="number" id="phone" class="compact-input-box" required placeholder="Ketik disini (08123...)">
            </div>
            <div>
                <label class="compact-label">Email</label>
                <input type="email" id="email" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <div>
                <label class="compact-label">Password</label>
                <input type="password" id="password" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <button type="submit" class="btn-green mt-1">Daftar Sekarang</button>
        </form>
        <div class="mt-4 text-center text-xs text-gray-300">
            Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a>
        </div>
    </div>
    
    <div class="centered-modal-box pt-14 hidden" id="box-otp">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2>
        <p class="text-xs text-gray-300 mb-5 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
        <form id="otpForm">
            <div>
                <label class="compact-label text-center">Kode OTP (4 Digit)</label>
                <input type="number" id="otpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX">
            </div>
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
                const res = await fetch('/api/auth/register', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ name, phone, email, password })
                });
                const data = await res.json();
                if (res.ok) {
                    registeredPhone = data.phone;
                    document.getElementById('box-register').classList.add('hidden');
                    document.getElementById('box-otp').classList.remove('hidden');
                    alert('OTP Terkirim! Silakan cek WhatsApp Anda.');
                } else { alert(data.error); }
            } catch (err) { alert('Gagal memproses pendaftaran.'); }
        });
        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const otp = document.getElementById('otpCode').value;
            try {
                const res = await fetch('/api/auth/verify', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phone: registeredPhone, otp })
                });
                const data = await res.json();
                if (res.ok) {
                    alert('Verifikasi Berhasil! Silakan Login.');
                    window.location.href = '/';
                } else { alert(data.error); }
            } catch (err) { alert('Gagal verifikasi OTP.'); }
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
</head>
<body class="flex flex-col items-center justify-center h-screen relative bg-gray-50">
    <div class="circuit-header"></div>
    <div class="z-20 mb-[-42px]"><div class="logo-f-metalik-box"></div></div>
    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2>
        <form id="requestOtpForm">
            <p class="text-xs text-gray-300 mb-5 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div><input type="number" id="phone" class="compact-input-box text-center" required placeholder="Ketik disini (08123...)"></div>
            <button type="submit" class="btn-yellow mt-2">Kirim OTP Reset</button>
        </form>
        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-5 border-gray-600">
            <div>
                <label class="compact-label text-center">Kode OTP (4 Digit)</label>
                <input type="number" id="otp" class="compact-input-box text-center text-xl tracking-[0.5em] font-bold" required placeholder="XXXX">
            </div>
            <div>
                <label class="compact-label text-center mt-2">Password Baru</label>
                <input type="password" id="newPassword" class="compact-input-box" required placeholder="Ketik disini">
            </div>
            <button type="submit" class="btn-green mt-3">Simpan Password Baru</button>
        </form>
        <div class="mt-6 text-center text-xs text-gray-300">
            Kembali ke <a href="/" class="compact-link-small">Login</a>
        </div>
    </div>
    <script>
        let resetPhone = '';
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const phone = document.getElementById('phone').value;
            try {
                const res = await fetch('/api/auth/forgot', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone }) });
                const data = await res.json();
                if (res.ok) {
                    resetPhone = data.phone;
                    document.getElementById('requestOtpForm').classList.add('hidden');
                    document.getElementById('resetForm').classList.remove('hidden');
                    alert('OTP Terkirim ke WA!');
                } else { alert(data.error); }
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

# HTML DASHBOARD PPOB PREMIUM + SIDEBAR HAMBURGER MENU
cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id" class="transition-colors duration-300">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { darkMode: 'class', }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-200 dark:bg-gray-900 font-sans transition-colors duration-300">

    <div id="sidebarOverlay" class="fixed inset-0 bg-black bg-opacity-60 z-[60] hidden transition-opacity" onclick="toggleSidebar()"></div>
    
    <div id="sidebar" class="fixed top-0 left-0 w-4/5 max-w-[320px] h-full bg-white dark:bg-gray-800 z-[70] transform -translate-x-full transition-transform duration-300 flex flex-col shadow-2xl">
        <div class="bg-[#002147] p-8 flex flex-col items-center justify-center text-white rounded-br-3xl">
            <div class="w-20 h-20 bg-white text-[#002147] rounded-full flex items-center justify-center text-3xl font-extrabold mb-3 shadow-lg" id="sidebarInitial">F</div>
            <h3 class="font-bold text-lg tracking-wide" id="sidebarName">Memuat...</h3>
            <p class="text-sm text-yellow-300 font-semibold mt-1" id="sidebarPhone">081xxx</p>
        </div>
        
        <div class="flex-1 overflow-y-auto py-4">
            <a href="#" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                <i class="fas fa-user-circle w-8 text-xl text-blue-500"></i> <span class="font-semibold">Profil Akun</span>
            </a>
            <a href="#" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                <i class="fas fa-history w-8 text-xl text-green-500"></i> <span class="font-semibold">Transaksi Saya</span>
            </a>
            <a href="#" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                <i class="fas fa-bell w-8 text-xl text-yellow-500"></i> <span class="font-semibold">Pemberitahuan</span>
            </a>
            <a href="#" class="flex items-center px-6 py-4 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition border-b border-gray-200 dark:border-gray-700">
                <i class="fas fa-headset w-8 text-xl text-purple-500"></i> <span class="font-semibold">Hubungi Admin</span>
            </a>
            
            <div class="flex items-center justify-between px-6 py-5 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition">
                <div class="flex items-center font-semibold"><i class="fas fa-moon w-8 text-xl text-indigo-500"></i> Mode Gelap</div>
                <div class="relative inline-block w-10 align-middle select-none transition duration-200 ease-in">
                    <input type="checkbox" name="toggle" id="darkModeToggle" class="toggle-checkbox absolute block w-5 h-5 rounded-full bg-white border-4 appearance-none cursor-pointer"/>
                    <label for="darkModeToggle" class="toggle-label block overflow-hidden h-5 rounded-full bg-gray-300 cursor-pointer"></label>
                </div>
            </div>
        </div>
        
        <div class="p-6">
            <button onclick="logout()" class="w-full py-3 border-2 border-red-500 text-red-500 rounded-xl font-bold hover:bg-red-500 hover:text-white transition shadow-sm">Keluar Akun</button>
        </div>
    </div>

    <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#121212] min-h-screen relative pb-20 shadow-2xl transition-colors duration-300">
        
        <div class="flex justify-between items-center p-4 bg-white dark:bg-[#1e1e1e] shadow-sm sticky top-0 z-50 transition-colors duration-300">
            <i class="fas fa-bars text-2xl text-[#002147] dark:text-white cursor-pointer hover:scale-110 transition" onclick="toggleSidebar()"></i>
            <h1 class="font-extrabold text-[#002147] dark:text-white tracking-wider text-sm">DIGITAL FIKY STORE</h1>
            <div class="bg-gray-100 dark:bg-gray-700 text-[10px] font-bold px-3 py-1.5 rounded-full text-[#002147] dark:text-white shadow-inner">
                1 Trx
            </div>
        </div>

        <div class="absolute top-0 left-0 w-full h-64 circuit-header" style="top: 60px;"></div>

        <div class="mx-4 mt-6 bg-[#002147] rounded-2xl p-5 text-white relative overflow-hidden shadow-2xl border-b-4 border-yellow-400">
            <div class="wave-bg"></div>
            
            <div class="text-center relative z-10">
                <div class="logo-f-small"></div>
                <h3 class="text-yellow-400 text-xs font-bold tracking-[0.2em] mb-3 border border-yellow-400 inline-block px-3 py-1 rounded-full">TOP UP SALDO</h3>
                
                <p class="text-xs text-gray-300 mb-1">Sisa Saldo Anda</p>
                <h2 class="text-3xl font-extrabold mb-6 tracking-tight" id="displaySaldo">Rp 0</h2>
                
                <div class="flex gap-4">
                    <button class="flex-1 border border-gray-400 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition">ISI SALDO</button>
                    <button class="flex-1 border border-gray-400 text-white rounded-full py-2.5 text-xs font-bold hover:bg-white hover:text-[#002147] transition">BANTUAN</button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-6 bg-white dark:bg-[#1e1e1e] p-5 rounded-2xl shadow-md border border-gray-100 dark:border-gray-800 transition-colors duration-300">
            <h3 class="font-bold text-[#002147] dark:text-white mb-5 text-sm border-b dark:border-gray-700 pb-2">Layanan Produk</h3>
            
            <div class="grid grid-cols-4 gap-y-6 gap-x-2">
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-yellow-100 text-yellow-500 rounded-2xl flex items-center justify-center text-2xl mb-2 shadow-sm"><i class="fas fa-mobile-alt"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300">Pulsa</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-blue-100 text-blue-500 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-wifi"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Paket<br>Data</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-green-100 text-green-500 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-phone-volume"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Paket<br>Telp</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-pink-100 text-pink-500 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-comment-dots"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Paket<br>SMS</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-orange-100 text-orange-500 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-lightbulb"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Token<br>PLN</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-teal-100 text-teal-500 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="far fa-calendar-check"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Masa<br>Aktif</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-gray-200 text-gray-600 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-sim-card"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Info<br>Kartu</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:opacity-80 transition">
                    <div class="w-12 h-12 bg-purple-100 text-purple-600 rounded-2xl flex items-center justify-center text-xl mb-2 shadow-sm"><i class="fas fa-ellipsis-h"></i></div>
                    <span class="text-[10px] font-bold text-[#002147] dark:text-gray-300 text-center leading-tight">Lainnya</span>
                </div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#002147] dark:bg-[#0a192f] rounded-t-3xl flex justify-around p-3 pb-4 text-white shadow-[0_-10px_20px_-5px_rgba(0,0,0,0.3)] z-50 transition-colors">
            <div class="flex flex-col items-center cursor-pointer text-yellow-400">
                <i class="fas fa-home text-xl mb-1"></i><span class="text-[10px] font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition">
                <i class="fas fa-file-alt text-xl mb-1"></i><span class="text-[10px] font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition">
                <i class="fas fa-bell text-xl mb-1"></i><span class="text-[10px] font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400 transition">
                <i class="fas fa-user text-xl mb-1"></i><span class="text-[10px] font-bold">PROFIL</span>
            </div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        
        // Inisialisasi Sidebar Data
        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        const initial = user.name ? user.name.charAt(0).toUpperCase() : 'U';
        document.getElementById('sidebarInitial').innerText = initial;

        function logout() { localStorage.removeItem('user'); window.location.href = '/'; }

        // Fetch Saldo
        fetch('/api/user/balance', {
            method: 'POST', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: user.phone })
        })
        .then(res => res.json())
        .then(data => { document.getElementById('displaySaldo').innerText = 'Rp ' + data.saldo.toLocaleString('id-ID'); })
        .catch(err => { document.getElementById('displaySaldo').innerText = 'Rp 0'; });

        // Fungsi Toggle Sidebar
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebarOverlay');
            if (sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
            } else {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            }
        }

        // Mode Gelap (Dark Mode)
        const darkModeToggle = document.getElementById('darkModeToggle');
        const htmlElement = document.documentElement;

        if (localStorage.getItem('darkMode') === 'true') {
            htmlElement.classList.add('dark');
            darkModeToggle.checked = true;
        }

        darkModeToggle.addEventListener('change', () => {
            if (darkModeToggle.checked) {
                htmlElement.classList.add('dark');
                localStorage.setItem('darkMode', 'true');
            } else {
                htmlElement.classList.remove('dark');
                localStorage.setItem('darkMode', 'false');
            }
        });
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS (LOGIK BOT + API WEB + GET SALDO)
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
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

const configFile = './config.json';
const dbFile = './database.json';
const produkFile = './produk.json';
const trxFile = './trx.json';
const webUsersFile = './web_users.json'; 

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(produkFile)) saveJSON(produkFile, {});
if (!fs.existsSync(trxFile)) saveJSON(trxFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});

let pairingRequested = false; 

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    let config = loadJSON(configFile);
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({
        version, auth: state, logger: pino({ level: 'silent' }), browser: Browsers.ubuntu('Chrome'), printQRInTerminal: false
    });

    if (!sock.authState.creds.registered && !pairingRequested) {
        pairingRequested = true;
        let phoneNumber = config.botNumber;
        if (!phoneNumber) process.exit(0);
        setTimeout(async () => {
            try {
                let formattedNumber = phoneNumber.replace(/[^0-9]/g, '');
                const code = await sock.requestPairingCode(formattedNumber);
                console.log(`\n🔑 KODE PAIRING:  ${code}  \n`);
            } catch (error) { pairingRequested = false; }
        }, 3000); 
    }

    sock.ev.on('creds.update', saveCreds);
    sock.ev.on('connection.update', (update) => {
        const { connection, lastDisconnect } = update;
        if (connection === 'close') {
            let reason = new Boom(lastDisconnect?.error)?.output?.statusCode;
            if (reason === DisconnectReason.loggedOut) process.exit(0);
            else { pairingRequested = false; setTimeout(startBot, 4000); }
        } else if (connection === 'open') {
            console.log('\n✅ BOT WA DIGITAL FIKY STORE BERHASIL TERHUBUNG!');
        }
    });

    global.waSocket = sock; 
}

const sendWhatsAppMessage = async (phone, message) => {
    try {
        if (!global.waSocket) return false;
        const formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
        await global.waSocket.sendMessage(formattedPhone + '@c.us', { text: message });
        return true;
    } catch (error) { return false; }
};

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (webUsers[formattedPhone] && webUsers[formattedPhone].isVerified) return res.status(400).json({ error: 'Nomor terdaftar.' });

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[formattedPhone] = { name, email, password, isVerified: false, otp }; saveJSON(webUsersFile, webUsers);
    const sent = await sendWhatsAppMessage(formattedPhone, `Halo *${name}*!\n\nKode OTP Anda: *${otp}*`);
    if(sent) res.json({ message: 'OTP Terkirim', phone: formattedPhone }); else res.status(500).json({ error: 'Gagal WA.' });
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].isVerified = true; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers);
        let db = loadJSON(dbFile);
        if (!db[phone]) { db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net' }; saveJSON(dbFile, db); }
        res.json({ message: 'Sukses!' });
    } else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => (p === formattedPhone || webUsers[p].email === identifier) && webUsers[p].password === password);

    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Belum verifikasi.' });
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: webUsers[foundPhone].name } });
    } else res.status(400).json({ error: 'Salah.' });
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (!webUsers[formattedPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[formattedPhone].otp = otp; saveJSON(webUsersFile, webUsers);
    const sent = await sendWhatsAppMessage(formattedPhone, `Kode OTP Reset: *${otp}*`);
    if(sent) res.json({ message: 'OTP Terkirim', phone: formattedPhone }); else res.status(500).json({ error: 'Gagal WA.' });
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].password = newPassword; webUsers[phone].otp = null; saveJSON(webUsersFile, webUsers);
        res.json({ message: 'Diubah!' });
    } else res.status(400).json({ error: 'OTP Salah.' });
});

app.post('/api/user/balance', (req, res) => {
    const { phone } = req.body;
    let db = loadJSON(dbFile);
    if (db[phone]) { res.json({ saldo: db[phone].saldo }); } else { res.json({ saldo: 0 }); }
});

if (require.main === module) {
    app.listen(3000, () => { console.log('🌐 Web Server berjalan di port 3000.'); });
    startBot().catch(err => console.error(err));
}
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
    echo "      🤖 PANEL DIGITAL FIKY STORE (V16) 🤖     "
    echo "==============================================="
    echo "--- MANAJEMEN BOT & WEB ---"
    echo "1. Setup No. Bot & Login Pairing"
    echo "2. Jalankan Bot (Latar Belakang/PM2)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo "5. 👥 Tambah Saldo Member (Utk Test Dashboard)"
    echo "6. Update Sistem (Tarik Kode Terbaru)"
    echo "0. Keluar"
    echo "==============================================="
    read -p "Pilih menu [0-6]: " choice

    case $choice in
        1) 
            cd "$HOME/$DIR_NAME"
            if [ ! -d "sesi_bot" ] || [ -z "$(ls -A sesi_bot 2>/dev/null)" ]; then
                read -p "📲 Masukkan Nomor WA Bot (Awali 628...): " nomor_bot
                if [ ! -z "$nomor_bot" ]; then
                    node -e "const fs=require('fs');let cfg=fs.existsSync('config.json')?JSON.parse(fs.readFileSync('config.json')):{};cfg.botNumber='$nomor_bot';fs.writeFileSync('config.json',JSON.stringify(cfg,null,2));"
                fi
            fi
            pm2 stop all > /dev/null 2>&1; fuser -k 3000/tcp > /dev/null 2>&1
            echo -e "\n⏳ Menjalankan proses login... (Tekan CTRL+C bila sudah selesai/ingin keluar)"
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
            read -p "ID Member (No WA yg dipakai daftar web, cth: 62812...): " nomor
            read -p "Jumlah Tambah Saldo: " jumlah
            node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(!db['$nomor']) db['$nomor']={saldo:0,jid:'$nomor@s.whatsapp.net'};db['$nomor'].saldo+=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));console.log('✅ Saldo ditambah ke database!');"
            read -p "Tekan Enter..." ;;
        6)
            echo "Mengambil update terbaru dari GitHub..."
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
echo "  SISTEM WEB & BOT BERHASIL DIPERBARUI!                   "
echo "  ------------------------------------------------------  "
echo "  Akses Web (Cek Browser) : http://$(wget -qO- eth0.me):3000"
echo "=========================================================="
