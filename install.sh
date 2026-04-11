#!/bin/bash
# ==========================================================
# DIGITAL FIKY STORE - V166 (PERFECT MASTERPIECE + THEME LIGHT/DARK)
# PART 1: SETUP, STYLE, DAN AUTENTIKASI
# ==========================================================

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
echo "    MENGINSTAL DIGITAL FIKY STORE V166 (PART 1)           "
echo "=========================================================="

echo "[1/10] Memperbarui sistem dan menginstal Node.js..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip nginx ufw -y > /dev/null 2>&1

if ! command -v node > /dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
  apt install -y nodejs > /dev/null 2>&1
fi
npm install -g pm2 > /dev/null 2>&1

echo "[2/10] Membuat direktori aplikasi dan web..."
mkdir -p "$HOME/$DIR_NAME/public/banners"
mkdir -p "$HOME/$DIR_NAME/public/info_images"
cd "$HOME/$DIR_NAME"

cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.6.6",
  "description": "Aplikasi PPOB DIGITAL FIKY STORE",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@hapi/boom": "^10.0.1",
    "@whiskeysockets/baileys": "^6.7.5",
    "axios": "^1.6.8",
    "body-parser": "^1.20.2",
    "express": "^4.19.2",
    "form-data": "^4.0.0",
    "multer": "^1.4.5-lts.1",
    "pino": "^8.20.0"
  }
}
EOF

echo "[3/10] Membangun Antarmuka CSS (DUAL THEME SUPPORT)..."

cat << 'EOF' > public/style.css
body { 
    margin: 0; 
    font-family: ui-sans-serif, system-ui, -apple-system, sans-serif; 
}

/* MARQUEE KUNING MAIZE */
.marquee-wrapper {
    width: 100%;
    overflow: hidden;
    white-space: nowrap;
    box-sizing: border-box;
    display: flex;
    align-items: center;
}

.marquee-text {
    display: inline-block;
    padding-left: 100%;
    animation: marquee-anim 15s linear infinite;
    font-weight: 900;
    font-size: 12px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
}

@keyframes marquee-anim {
    0% { transform: translate(0, 0); }
    100% { transform: translate(-100%, 0); }
}

.brand-logo-text { 
    font-size: 1.8rem; 
    font-weight: 900; 
    background: linear-gradient(135deg, #eab308 0%, #ca8a04 100%); 
    -webkit-background-clip: text; 
    -webkit-text-fill-color: transparent; 
    margin-bottom: 1rem; 
    letter-spacing: 1px; 
    text-transform: uppercase; 
}

.dark .brand-logo-text {
    background: linear-gradient(135deg, #fde047 0%, #facc15 100%); 
    -webkit-background-clip: text; 
    -webkit-text-fill-color: transparent; 
}

.compact-input-wrapper { 
    position: relative; 
    margin-bottom: 0.85rem; 
    width: 100%; 
}

.password-toggle { 
    position: absolute; 
    right: 15px; 
    top: 50%; 
    transform: translateY(-50%); 
    cursor: pointer; 
}

.hide-scrollbar::-webkit-scrollbar { 
    display: none; 
}

.hide-scrollbar { 
    -ms-overflow-style: none; 
    scrollbar-width: none; 
}

.swal2-popup { 
    border-radius: 1.5rem !important; 
    width: 320px !important; 
    padding: 1.5rem 1.25rem 1.25rem !important; 
}

.swal2-title { 
    font-size: 1.25rem !important; 
    font-weight: 800 !important; 
}

.swal2-html-container { 
    font-size: 0.85rem !important; 
}

.swal2-confirm { 
    border-radius: 0.75rem !important; 
    font-weight: 900 !important; 
}

.swal2-cancel { 
    border-radius: 0.75rem !important; 
    font-weight: 800 !important; 
}

.pb-safe { 
    padding-bottom: calc(1rem + env(safe-area-inset-bottom)); 
}
EOF

echo "[4/10] Membangun Halaman Autentikasi (DUAL THEME UNCOMPRESSED)..."

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { darkMode: 'class' };
        if (localStorage.getItem('theme') === 'light') { 
            document.documentElement.classList.remove('dark'); 
        } else { 
            document.documentElement.classList.add('dark'); 
        }
    </script>
</head>
<body class="bg-slate-50 dark:bg-[#0b1320] flex flex-col min-h-screen transition-colors duration-300">
    <div class="bg-white dark:bg-[#111c2e] border border-slate-200 dark:border-[#1e293b] p-8 rounded-[1.2rem] shadow-xl w-[90%] max-w-[340px] text-center mx-auto mt-[10vh]">
        <h1 class="brand-logo-text !mb-2">DIGITAL FIKY STORE</h1>
        
        <div class="overflow-hidden w-full mb-6 border-y border-slate-200 dark:border-[#1e293b] py-1.5 bg-slate-100 dark:bg-[#0b1320] shadow-inner rounded-md">
            <div class="marquee-wrapper h-4">
                <span class="marquee-text text-yellow-600 dark:text-[#facc15] text-[10px] tracking-wider">🚀 WELCOME TO DIGITAL FIKY STORE - PUSAT PPOB TERMURAH, CEPAT, AMAN, DAN TERPERCAYA 🚀</span>
            </div>
        </div>

        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-1">LOGIN AKUN</h2>
        <p class="text-[0.8rem] text-slate-500 dark:text-gray-400 mb-6">Silahkan masukkan email/no HP dan password kamu!</p>
        
        <form id="loginForm">
            <div class="compact-input-wrapper">
                <input type="text" id="identifier" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Email / No. HP">
            </div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Password">
                <i class="fas fa-eye password-toggle text-slate-400 dark:text-slate-500" onclick="togglePassword('password', this)"></i>
            </div>
            <div class="text-right mb-5 mt-1">
                <a href="/forgot.html" class="text-[0.8rem] font-bold text-yellow-600 dark:text-[#facc15] hover:underline">Lupa password?</a>
            </div>
            <button type="submit" class="w-full py-2.5 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-black rounded-xl cursor-pointer hover:opacity-90 shadow-md transition-all">Login Sekarang</button>
        </form>

        <div class="mt-6 text-center text-[0.8rem] text-slate-500 dark:text-slate-400">
            Belum punya akun? <a href="/register.html" class="font-bold text-yellow-600 dark:text-[#facc15] hover:underline">Daftar disini</a>
        </div>
    </div>

    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const registeredPhone = urlParams.get('phone');
            
            if (registeredPhone) { 
                document.getElementById('identifier').value = registeredPhone; 
            } else { 
                const savedPhone = localStorage.getItem('savedPhone'); 
                if (savedPhone) {
                    document.getElementById('identifier').value = savedPhone; 
                }
            }
        }

        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.replace('fa-eye', 'fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.replace('fa-eye-slash', 'fa-eye'); 
            }
        }
        
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const identifier = document.getElementById('identifier').value; 
            const password = document.getElementById('password').value;
            
            localStorage.setItem('savedPhone', identifier);
            
            const bgSwal = document.documentElement.classList.contains('dark') ? '#111c2e' : '#ffffff';
            const textSwal = document.documentElement.classList.contains('dark') ? '#ffffff' : '#0f172a';

            Swal.fire({ 
                title: 'Memeriksa Data...', 
                allowOutsideClick: false, 
                background: bgSwal, 
                color: textSwal, 
                didOpen: () => { 
                    Swal.showLoading(); 
                } 
            });
            
            try {
                const res = await fetch('/api/auth/login', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ identifier, password }) 
                });
                
                const data = await res.json();
                
                if (res.ok) { 
                    localStorage.setItem('user', JSON.stringify(data.user)); 
                    window.location.href = '/dashboard.html';
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal', 
                        text: data.error, 
                        background: bgSwal, 
                        color: textSwal 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Kesalahan sistem.', 
                    background: bgSwal, 
                    color: textSwal 
                }); 
            }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/register.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { darkMode: 'class' };
        if (localStorage.getItem('theme') === 'light') { 
            document.documentElement.classList.remove('dark'); 
        } else { 
            document.documentElement.classList.add('dark'); 
        }
    </script>
</head>
<body class="bg-slate-50 dark:bg-[#0b1320] flex flex-col min-h-screen transition-colors duration-300">
    <div class="bg-white dark:bg-[#111c2e] border border-slate-200 dark:border-[#1e293b] p-8 rounded-[1.2rem] shadow-xl w-[90%] max-w-[340px] text-center mx-auto mt-10" id="box-register">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-1">DAFTAR AKUN</h2>
        <p class="text-[0.8rem] text-slate-500 dark:text-gray-400 mb-4">Silahkan lengkapi data untuk mendaftar!</p>
        
        <form id="registerForm">
            <div class="compact-input-wrapper">
                <input type="text" id="name" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Nama Lengkap">
            </div>
            <div class="compact-input-wrapper">
                <input type="number" id="phone" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Nomor WA (08123...)">
            </div>
            <div class="compact-input-wrapper">
                <input type="email" id="email" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Email">
            </div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Password">
                <i class="fas fa-eye password-toggle text-slate-400 dark:text-slate-500" onclick="togglePassword('password', this)"></i>
            </div>
            <button type="submit" class="w-full py-2.5 mt-2 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-black rounded-xl cursor-pointer hover:opacity-90 shadow-md transition-all">Daftar Sekarang</button>
        </form>

        <div class="mt-5 text-center text-[0.8rem] text-slate-500 dark:text-slate-400">
            Sudah punya akun? <a href="/" class="font-bold text-yellow-600 dark:text-[#facc15] hover:underline">Login disini</a>
        </div>
    </div>

    <div class="bg-white dark:bg-[#111c2e] border border-slate-200 dark:border-[#1e293b] p-8 rounded-[1.2rem] shadow-xl w-[90%] max-w-[340px] text-center mx-auto mt-16 hidden" id="box-otp">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-1">VERIFIKASI WA</h2>
        <p class="text-[0.8rem] text-slate-500 dark:text-gray-400 mb-5">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
        
        <form id="otpForm">
            <div class="compact-input-wrapper">
                <input type="number" id="otpCode" class="w-full p-3 border border-slate-300 dark:border-[#1e293b] rounded-xl outline-none bg-slate-50 dark:bg-[#0b1320] text-yellow-600 dark:text-[#facc15] text-center text-2xl tracking-[0.5em] font-extrabold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="XXXX">
            </div>
            <button type="submit" class="w-full py-3 mt-4 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-black rounded-xl cursor-pointer hover:opacity-90 shadow-md transition-all">Verifikasi OTP</button>
        </form>
    </div>

    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.replace('fa-eye', 'fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.replace('fa-eye-slash', 'fa-eye'); 
            }
        }
        
        let registeredPhone = '';
        const bgSwal = document.documentElement.classList.contains('dark') ? '#111c2e' : '#ffffff';
        const textSwal = document.documentElement.classList.contains('dark') ? '#ffffff' : '#0f172a';

        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const name = document.getElementById('name').value; 
            const phone = document.getElementById('phone').value; 
            const email = document.getElementById('email').value; 
            const password = document.getElementById('password').value;
            
            Swal.fire({ 
                title: 'Memproses...', 
                allowOutsideClick: false, 
                background: bgSwal, 
                color: textSwal, 
                didOpen: () => { 
                    Swal.showLoading(); 
                } 
            });
            
            try {
                const res = await fetch('/api/auth/register', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ name, phone, email, password }) 
                });
                
                const data = await res.json();
                
                if (res.ok) {
                    registeredPhone = data.phone; 
                    document.getElementById('box-register').classList.add('hidden'); 
                    document.getElementById('box-otp').classList.remove('hidden'); 
                    Swal.close();
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal Daftar', 
                        text: data.error, 
                        background: bgSwal, 
                        color: textSwal 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gagal memproses.', 
                    background: bgSwal, 
                    color: textSwal 
                }); 
            }
        });

        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            
            const otp = document.getElementById('otpCode').value;
            
            Swal.fire({ 
                title: 'Verifikasi...', 
                allowOutsideClick: false, 
                background: bgSwal, 
                color: textSwal, 
                didOpen: () => { 
                    Swal.showLoading(); 
                } 
            });
            
            try {
                const res = await fetch('/api/auth/verify', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ phone: registeredPhone, otp }) 
                });
                
                const data = await res.json();
                
                if (res.ok) { 
                    Swal.fire({ 
                        icon: 'success', 
                        title: 'Berhasil!', 
                        text: 'Akun aktif.', 
                        background: bgSwal, 
                        color: textSwal 
                    }).then(() => { 
                        window.location.href = '/?phone=' + registeredPhone; 
                    }); 
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'OTP Salah', 
                        text: data.error, 
                        background: bgSwal, 
                        color: textSwal 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gagal verifikasi.', 
                    background: bgSwal, 
                    color: textSwal 
                }); 
            }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/forgot.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lupa Password - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { darkMode: 'class' };
        if (localStorage.getItem('theme') === 'light') { 
            document.documentElement.classList.remove('dark'); 
        } else { 
            document.documentElement.classList.add('dark'); 
        }
    </script>
</head>
<body class="bg-slate-50 dark:bg-[#0b1320] flex flex-col min-h-screen transition-colors duration-300">
    <div class="bg-white dark:bg-[#111c2e] border border-slate-200 dark:border-[#1e293b] p-8 rounded-[1.2rem] shadow-xl w-[90%] max-w-[340px] text-center mx-auto mt-16">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-slate-800 dark:text-white mb-1">RESET PASSWORD</h2>
        
        <form id="requestOtpForm">
            <p class="text-[0.8rem] text-slate-500 dark:text-gray-400 mb-5">Masukkan Nomor WA Anda untuk reset password.</p>
            <div class="compact-input-wrapper">
                <input type="number" id="phone" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15] text-center" required placeholder="08123...">
            </div>
            <button type="submit" class="w-full py-2.5 mt-2 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-black rounded-xl cursor-pointer hover:opacity-90 shadow-md transition-all">Kirim OTP Reset</button>
        </form>

        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-5 border-slate-200 dark:border-[#1e293b]">
            <div class="compact-input-wrapper">
                <label class="block text-[11px] text-slate-500 dark:text-gray-400 font-bold mb-1 text-center">Kode OTP</label>
                <input type="number" id="otp" class="w-full p-3 border border-slate-300 dark:border-[#1e293b] rounded-xl outline-none bg-slate-50 dark:bg-[#0b1320] text-yellow-600 dark:text-[#facc15] text-center text-xl tracking-[0.5em] font-extrabold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="XXXX">
            </div>
            <div class="compact-input-wrapper mt-3">
                <label class="block text-[11px] text-slate-500 dark:text-gray-400 font-bold mb-1 text-center">Password Baru</label>
                <input type="password" id="newPassword" class="w-full p-2.5 border border-slate-300 dark:border-[#1e293b] rounded-xl text-sm outline-none bg-slate-50 dark:bg-[#0b1320] text-slate-800 dark:text-white font-bold focus:border-yellow-500 dark:focus:border-[#facc15]" required placeholder="Ketik disini">
                <i class="fas fa-eye password-toggle text-slate-400 dark:text-slate-500" onclick="togglePassword('newPassword', this)" style="top:70%;"></i>
            </div>
            <button type="submit" class="w-full py-2.5 mt-3 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-black rounded-xl cursor-pointer hover:opacity-90 shadow-md transition-all">Simpan Password</button>
        </form>

        <div class="mt-6 text-center text-[0.8rem] text-slate-500 dark:text-slate-400">
            <a href="/" class="font-bold text-yellow-600 dark:text-[#facc15] hover:underline">Kembali ke Login</a>
        </div>
    </div>

    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.replace('fa-eye', 'fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.replace('fa-eye-slash', 'fa-eye'); 
            }
        }
        
        let resetPhone = '';
        const bgSwal = document.documentElement.classList.contains('dark') ? '#111c2e' : '#ffffff';
        const textSwal = document.documentElement.classList.contains('dark') ? '#ffffff' : '#0f172a';
        
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            const phone = document.getElementById('phone').value;
            
            Swal.fire({ 
                title: 'Memproses...', 
                allowOutsideClick: false, 
                background: bgSwal, 
                color: textSwal, 
                didOpen: () => { 
                    Swal.showLoading(); 
                } 
            });
            
            try {
                const res = await fetch('/api/auth/forgot', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ phone }) 
                });
                
                const data = await res.json();
                
                if (res.ok) { 
                    resetPhone = data.phone; 
                    document.getElementById('requestOtpForm').classList.add('hidden'); 
                    document.getElementById('resetForm').classList.remove('hidden'); 
                    Swal.close(); 
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal', 
                        text: data.error, 
                        background: bgSwal, 
                        color: textSwal 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gangguan server', 
                    background: bgSwal, 
                    color: textSwal 
                }); 
            }
        });

        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            
            const otp = document.getElementById('otp').value; 
            const newPassword = document.getElementById('newPassword').value;
            
            Swal.fire({ 
                title: 'Memproses...', 
                allowOutsideClick: false, 
                background: bgSwal, 
                color: textSwal, 
                didOpen: () => { 
                    Swal.showLoading(); 
                } 
            });
            
            try {
                const res = await fetch('/api/auth/reset', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ phone: resetPhone, otp, newPassword }) 
                });
                
                if (res.ok) { 
                    Swal.fire({ 
                        icon: 'success', 
                        title: 'Berhasil!', 
                        text: 'Password diubah.', 
                        background: bgSwal, 
                        color: textSwal 
                    }).then(() => { 
                        window.location.href = '/'; 
                    }); 
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal', 
                        text: 'OTP Salah.', 
                        background: bgSwal, 
                        color: textSwal 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gangguan server', 
                    background: bgSwal, 
                    color: textSwal 
                }); 
            }
        });
    </script>
</body>
</html>
EOF

echo "[PART 1 SELESAI DITULIS!]"
echo "[5/10] Membangun Halaman Dashboard & Operator (FULL UNCOMPRESSED)..."

cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { darkMode: 'class' };
        if (localStorage.getItem('theme') === 'light') { 
            document.documentElement.classList.remove('dark'); 
        } else { 
            document.documentElement.classList.add('dark'); 
        }
    </script>
</head>
<body class="bg-slate-50 dark:bg-[#0b1320] font-sans transition-colors duration-300 text-slate-800 dark:text-white">
    <div class="max-w-md mx-auto bg-slate-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden transition-colors duration-300">
        
        <div id="maintenanceBanner" class="hidden bg-red-600 text-white text-center py-2 px-4 text-xs font-bold shadow-md z-50 sticky top-0">
            <i class="fas fa-tools mr-1 animate-pulse"></i> SISTEM SEDANG MAINTENANCE (23:00 - 00:30 WIB). TRANSAKSI DITUTUP.
        </div>

        <div class="flex justify-between items-center p-4 bg-slate-50 dark:bg-[#0b1320] sticky z-40 top-0 transition-colors duration-300" id="headerMain">
            <i class="fas fa-bars text-xl cursor-pointer text-slate-500 dark:text-gray-300 hover:text-orange-500 dark:hover:text-[#facc15] shrink-0 transition-colors" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></i>
            
            <div class="marquee-wrapper border-l border-r border-slate-300 dark:border-[#1e293b] mx-3 px-2 h-6">
                <span class="marquee-text text-yellow-600 dark:text-[#facc15]">WELCOME TO THE DIGITAL FIKY STORE - PUSAT PPOB TERMURAH & TERPERCAYA - TRANSAKSI CEPAT AMAN</span>
            </div>

            <div class="text-[10px] font-extrabold text-orange-600 dark:text-[#facc15] bg-white dark:bg-[#111c2e] border border-orange-200 dark:border-[#facc15]/30 px-3 py-1.5 rounded-full shrink-0 shadow-sm transition-colors" id="headTrx">
                0 Trx
            </div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
            <div class="w-full bg-black/60 backdrop-blur-sm" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></div>
            <div class="absolute top-0 left-0 w-[80%] max-w-[300px] h-full bg-white dark:bg-[#0b1320] shadow-2xl flex flex-col border-r border-slate-200 dark:border-[#1e293b] transition-colors duration-300">
                <div class="p-8 pb-4 flex flex-col items-center relative border-b border-slate-200 dark:border-[#1e293b]">
                    <button class="absolute top-5 right-5 text-slate-400 dark:text-gray-400 hover:text-red-500" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                    <div class="w-[4.5rem] h-[4.5rem] bg-slate-100 dark:bg-[#111c2e] rounded-full flex justify-center items-center text-orange-500 dark:text-[#facc15] font-extrabold text-3xl mb-3 shadow-md overflow-hidden border border-slate-200 dark:border-[#1e293b] transition-colors" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg text-slate-800 dark:text-white" id="sidebarName">User</h3>
                    <p class="text-sm text-slate-500 dark:text-gray-400" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-[14px]">
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="location.href='/profile.html'">
                            <i class="far fa-user w-6 text-center text-lg text-orange-500 dark:text-[#facc15]"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100">Profil Akun</span>
                        </li>
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="location.href='/riwayat.html'">
                            <i class="far fa-clock w-6 text-center text-lg text-orange-500 dark:text-[#facc15]"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100">Riwayat Transaksi</span>
                        </li>
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="location.href='/mutasi.html'">
                            <i class="fas fa-exchange-alt w-6 text-center text-lg text-orange-500 dark:text-[#facc15]"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100">Mutasi Saldo</span>
                        </li>
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="location.href='/info.html'">
                            <i class="far fa-bell w-6 text-center text-lg text-orange-500 dark:text-[#facc15]"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100">Pusat Informasi</span>
                        </li>
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="bantuanAdmin()">
                            <i class="fas fa-headset w-6 text-center text-lg text-orange-500 dark:text-[#facc15]"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100">Hubungi Admin</span>
                        </li>
                        <li class="px-6 py-4 border-b border-slate-100 dark:border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-slate-50 dark:hover:bg-[#111c2e] transition-colors" onclick="toggleTheme()">
                            <i class="fas fa-moon w-6 text-center text-lg text-indigo-500 dark:text-[#facc15]" id="themeIcon"></i>
                            <span class="font-semibold text-slate-700 dark:text-gray-100" id="themeText">Tema Gelap</span>
                        </li>
                    </ul>
                </div>
                <div class="p-6">
                    <button onclick="logout()" class="w-full py-3 border border-red-500 text-red-500 font-bold rounded-xl hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                        Keluar Akun
                    </button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-4 bg-white dark:bg-[#111c2e] rounded-[1.2rem] p-4 text-slate-800 dark:text-white relative overflow-hidden shadow-md border border-slate-200 dark:border-[#1e293b] transition-colors duration-300">
            <div class="relative z-10 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-11 h-11 rounded-xl bg-slate-50 dark:bg-[#0b1320] flex items-center justify-center text-orange-500 dark:text-[#facc15] border border-orange-200 dark:border-[#facc15]/20 transition-colors shadow-sm">
                        <i class="fas fa-wallet text-lg"></i>
                    </div>
                    <div class="flex flex-col">
                        <div class="flex items-center gap-2 mb-0.5">
                            <span class="text-[11px] text-slate-500 dark:text-gray-400 font-bold tracking-wide uppercase">
                                Saldo Aktif 
                            </span>
                        </div>
                        <h2 class="text-[18px] font-black mt-0.5 text-slate-800 dark:text-white" id="displaySaldo">Rp •••••••</h2>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <button class="w-9 h-9 rounded-full bg-slate-50 dark:bg-[#0b1320] flex items-center justify-center text-orange-500 dark:text-[#facc15] border border-slate-200 dark:border-[#1e293b] hover:bg-slate-100 dark:hover:bg-[#1a2639] transition-colors z-10 shadow-sm" onclick="bantuanAdmin()">
                        <i class="fas fa-headset text-[15px]"></i>
                    </button>
                    <button class="bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] px-4 py-2 rounded-full text-[11px] font-extrabold shadow-md hover:opacity-90 z-10 relative transition-colors" onclick="openTopUp()">
                        Topup
                    </button>
                </div>
            </div>
        </div>

        <div id="bannerContainer" class="mx-4 mt-6 relative rounded-[1.2rem] h-[150px] overflow-hidden border border-slate-200 dark:border-[#1e293b] hidden shadow-md">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-5 bg-white dark:bg-[#111c2e] border border-slate-200 dark:border-[#1e293b] rounded-[1rem] p-3.5 shadow-sm flex justify-between items-center transition-colors duration-300">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-slate-50 dark:bg-[#0b1320] flex items-center justify-center text-orange-500 dark:text-[#facc15] shadow-sm border border-slate-200 dark:border-[#1e293b] transition-colors">
                    <i class="far fa-calendar-alt text-[14px]"></i>
                </div>
                <div class="flex flex-col">
                    <span class="text-[9px] text-slate-400 dark:text-gray-400 font-bold uppercase mb-0.5">Tanggal</span>
                    <span class="text-[11px] font-extrabold text-slate-700 dark:text-gray-200" id="realtimeDate">YYYY/MM/DD</span>
                </div>
            </div>
            <div class="h-8 w-px bg-slate-200 dark:bg-[#1e293b] mx-2 transition-colors"></div>
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="text-[9px] text-slate-400 dark:text-gray-400 font-bold uppercase mb-0.5">Waktu</span>
                    <span class="text-[11px] font-extrabold text-slate-700 dark:text-gray-200 tracking-widest" id="realtimeClock">00:00:00</span>
                </div>
                <div class="w-9 h-9 rounded-full bg-slate-50 dark:bg-[#0b1320] flex items-center justify-center text-orange-500 dark:text-[#facc15] shadow-sm border border-slate-200 dark:border-[#1e293b] transition-colors">
                    <i class="far fa-clock text-[14px]"></i>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-4">
            <h3 class="font-extrabold text-slate-800 dark:text-white mb-4 text-[15px] ml-1 transition-colors tracking-wide">Layanan Produk PPOB</h3>
            <div class="grid grid-cols-3 gap-y-6 gap-x-3">
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pulsa'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">PULSA</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=data'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-globe"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">DATA</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/game.html'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-gamepad"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">GAME</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=voucher'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-ticket-alt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">VOUCHER</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=smstelpon'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-phone-square-alt"></i>
                    </div>
                    <span class="text-[10px] font-bold text-slate-700 dark:text-gray-300 text-center leading-tight mt-1">SMS & TELP</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pln'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">PLN</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=masaaktif'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <span class="text-[10px] font-bold text-slate-700 dark:text-gray-300 text-center leading-tight mt-1">MASA AKTIF</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=perdana'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-sim-card"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 text-center">PERDANA</span>
                </div>
                
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=ewallet'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-orange-500 dark:text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300">E-WALLET</span>
                </div>

            </div>
        </div>

        <div class="mx-4 mt-8 mb-4">
            <h3 class="font-extrabold text-slate-800 dark:text-white mb-4 text-[15px] ml-1 transition-colors tracking-wide">Layanan VPN Premium</h3>
            <div class="grid grid-cols-3 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="comingSoon()">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-indigo-500 dark:text-indigo-400 flex flex-col items-center justify-center shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors relative">
                        <i class="fas fa-network-wired text-[28px]"></i>
                        <span class="absolute -bottom-2.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-[8px] font-extrabold px-2 py-0.5 rounded-md border border-red-200 dark:border-red-800 shadow-sm">Kosong</span>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 mt-1">SSH</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="comingSoon()">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-teal-500 dark:text-teal-400 flex flex-col items-center justify-center shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors relative">
                        <i class="fas fa-server text-[28px]"></i>
                        <span class="absolute -bottom-2.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-[8px] font-extrabold px-2 py-0.5 rounded-md border border-red-200 dark:border-red-800 shadow-sm">Kosong</span>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 mt-1">VMESS</span>
                </div>
                 <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="comingSoon()">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-sky-500 dark:text-sky-400 flex flex-col items-center justify-center shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors relative">
                        <i class="fas fa-bolt text-[28px]"></i>
                        <span class="absolute -bottom-2.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-[8px] font-extrabold px-2 py-0.5 rounded-md border border-red-200 dark:border-red-800 shadow-sm">Kosong</span>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 mt-1">VLESS</span>
                </div>
                 <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="comingSoon()">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-rose-500 dark:text-rose-400 flex flex-col items-center justify-center shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors relative">
                        <i class="fas fa-user-ninja text-[28px]"></i>
                        <span class="absolute -bottom-2.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-[8px] font-extrabold px-2 py-0.5 rounded-md border border-red-200 dark:border-red-800 shadow-sm">Kosong</span>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 mt-1">TROJAN</span>
                </div>
                 <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="comingSoon()">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-purple-500 dark:text-purple-400 flex flex-col items-center justify-center shadow-sm mb-2 border border-slate-200 dark:border-[#1e293b] transition-colors relative">
                        <i class="fas fa-rocket text-[28px]"></i>
                        <span class="absolute -bottom-2.5 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 text-[8px] font-extrabold px-2 py-0.5 rounded-md border border-red-200 dark:border-red-800 shadow-sm">Kosong</span>
                    </div>
                    <span class="text-[11px] font-bold text-slate-700 dark:text-gray-300 mt-1">ZIVPN</span>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8">
            <h3 class="font-extrabold text-slate-800 dark:text-white mb-2 text-[15px] ml-1 transition-colors tracking-wide">Komunitas & Update</h3>
            <p class="text-[11px] text-slate-500 dark:text-gray-400 mb-4 ml-1 transition-colors">Gabung ke saluran resmi kami untuk mendapatkan info promo, event, dan update terbaru langsung dari Digital Fiky Store!</p>
            <div class="grid grid-cols-2 gap-3">
                <div class="bg-gradient-to-br from-white to-slate-50 dark:from-[#111c2e] dark:to-[#0b1320] border border-slate-200 dark:border-[#1e293b] rounded-2xl p-4 flex items-center cursor-pointer hover:shadow-md transition-all" onclick="bukaLinkKomunitas('tele')">
                    <i class="fab fa-telegram text-[32px] text-blue-500 mr-3 drop-shadow-sm"></i>
                    <div class="flex flex-col">
                        <h4 class="font-extrabold text-[12px] text-slate-800 dark:text-white transition-colors">Telegram</h4>
                        <p class="text-[9px] font-bold text-slate-500 dark:text-gray-400 mt-0.5 uppercase tracking-wide transition-colors">Join Channel</p>
                    </div>
                </div>
                <div class="bg-gradient-to-br from-white to-slate-50 dark:from-[#111c2e] dark:to-[#0b1320] border border-slate-200 dark:border-[#1e293b] rounded-2xl p-4 flex items-center cursor-pointer hover:shadow-md transition-all" onclick="bukaLinkKomunitas('wa')">
                    <i class="fab fa-whatsapp text-[32px] text-green-500 mr-3 drop-shadow-sm"></i>
                    <div class="flex flex-col">
                        <h4 class="font-extrabold text-[12px] text-slate-800 dark:text-white transition-colors">WhatsApp</h4>
                        <p class="text-[9px] font-bold text-slate-500 dark:text-gray-400 mt-0.5 uppercase tracking-wide transition-colors">Join Saluran</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8 bg-white dark:bg-[#111c2e] rounded-2xl border border-slate-200 dark:border-[#1e293b] shadow-sm p-4 transition-colors duration-300">
            <div class="flex justify-between items-center mb-4">
                <h3 class="font-extrabold text-slate-800 dark:text-white text-[13px] tracking-wide">Statistik Penjualan Toko</h3>
                <span class="text-[8px] bg-slate-100 dark:bg-[#1e293b] text-yellow-600 dark:text-[#facc15] px-2 py-0.5 rounded-full font-bold uppercase tracking-wider animate-pulse border border-yellow-200 dark:border-[#facc15]/30">Realtime</span>
            </div>
            <div class="grid grid-cols-4 gap-2">
                <div class="bg-slate-50 dark:bg-[#0b1320] p-2.5 rounded-xl border border-slate-200 dark:border-[#1e293b] text-center transition-colors">
                    <p class="text-[9px] text-slate-500 dark:text-gray-400 font-extrabold mb-1 uppercase">Hari Ini</p>
                    <p class="text-[13px] font-black text-orange-500 dark:text-[#facc15]" id="statToday">0</p>
                </div>
                <div class="bg-slate-50 dark:bg-[#0b1320] p-2.5 rounded-xl border border-slate-200 dark:border-[#1e293b] text-center transition-colors">
                    <p class="text-[9px] text-slate-500 dark:text-gray-400 font-extrabold mb-1 uppercase">Minggu Ini</p>
                    <p class="text-[13px] font-black text-green-500 dark:text-green-400" id="statWeek">0</p>
                </div>
                <div class="bg-slate-50 dark:bg-[#0b1320] p-2.5 rounded-xl border border-slate-200 dark:border-[#1e293b] text-center transition-colors">
                    <p class="text-[9px] text-slate-500 dark:text-gray-400 font-extrabold mb-1 uppercase">Bulan Ini</p>
                    <p class="text-[13px] font-black text-orange-500 dark:text-[#facc15]" id="statMonth">0</p>
                </div>
                <div class="bg-slate-50 dark:bg-[#0b1320] p-2.5 rounded-xl border border-slate-200 dark:border-[#1e293b] text-center transition-colors">
                    <p class="text-[9px] text-slate-500 dark:text-gray-400 font-extrabold mb-1 uppercase">Semua</p>
                    <p class="text-[13px] font-black text-purple-500 dark:text-purple-400" id="statAll">0</p>
                </div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#0b1320] border-t border-slate-200 dark:border-[#1e293b] flex justify-around p-3 pb-4 shadow-2xl z-40 transition-colors duration-300">
            <div class="flex flex-col items-center cursor-pointer text-orange-500 dark:text-[#facc15]">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-slate-400 dark:text-gray-400 hover:text-orange-500 dark:hover:text-[#facc15] transition-colors" onclick="location.href='/riwayat.html'">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-slate-400 dark:text-gray-400 hover:text-orange-500 dark:hover:text-[#facc15] transition-colors" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-slate-400 dark:text-gray-400 hover:text-orange-500 dark:hover:text-[#facc15] transition-colors" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>

        <div id="topupOverlay" class="fixed inset-0 bg-black/60 z-[110] hidden opacity-0 transition-opacity" onclick="closeTopUp()"></div>
        <div id="topupSheet" class="fixed bottom-0 left-0 right-0 bg-white dark:bg-[#111c2e] z-[120] rounded-t-[2rem] transform translate-y-full transition-transform max-w-md mx-auto pb-safe border-t border-slate-200 dark:border-[#1e293b]">
            <div class="w-12 h-1.5 bg-slate-300 dark:bg-gray-700 rounded-full mx-auto my-3"></div>
            <div class="px-6 pb-6">
                <div class="flex justify-between mb-5">
                    <h3 class="font-extrabold text-slate-800 dark:text-white transition-colors">Isi Saldo</h3>
                    <i class="fas fa-times text-slate-400 dark:text-gray-400 text-xl cursor-pointer hover:text-red-500" onclick="closeTopUp()"></i>
                </div>
                
                <div class="relative w-full mb-4">
                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 dark:text-gray-500 font-bold">Rp</span>
                    <input type="number" id="inputNominal" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] rounded-xl py-3 pl-10 pr-4 text-slate-800 dark:text-white font-bold focus:outline-none focus:border-yellow-400 dark:focus:border-[#facc15] transition-colors" placeholder="Ketik nominal...">
                </div>

                <div class="grid grid-cols-5 gap-2 mb-6">
                    <button onclick="document.getElementById('inputNominal').value=1000" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] text-slate-700 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-yellow-400 dark:hover:border-[#facc15] text-[11px] transition-colors">1K</button>
                    <button onclick="document.getElementById('inputNominal').value=5000" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] text-slate-700 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-yellow-400 dark:hover:border-[#facc15] text-[11px] transition-colors">5K</button>
                    <button onclick="document.getElementById('inputNominal').value=10000" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] text-slate-700 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-yellow-400 dark:hover:border-[#facc15] text-[11px] transition-colors">10K</button>
                    <button onclick="document.getElementById('inputNominal').value=50000" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] text-slate-700 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-yellow-400 dark:hover:border-[#facc15] text-[11px] transition-colors">50K</button>
                    <button onclick="document.getElementById('inputNominal').value=100000" class="w-full bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] text-slate-700 dark:text-white font-extrabold py-2.5 rounded-xl hover:border-yellow-400 dark:hover:border-[#facc15] text-[11px] transition-colors">100K</button>
                </div>

                <div class="flex flex-col gap-3 mb-6">
                    
                    <div onclick="selM('qris')" id="m-qris" class="flex items-center justify-between bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] p-3 rounded-xl cursor-pointer transition-colors">
                        <div class="flex items-center gap-3">
                            <i class="fas fa-qrcode text-2xl text-slate-800 dark:text-white"></i>
                            <div class="flex flex-col">
                                <span class="font-bold text-sm text-slate-800 dark:text-white">Otomatis QRIS Dinamis</span>
                                <span class="text-[10px] text-slate-500 dark:text-gray-500 leading-tight">Otomatis masuk (Nominal instan)</span>
                            </div>
                        </div>
                        <div id="r-qris" class="w-5 h-5 rounded-full border-[3px] border-slate-300 dark:border-gray-600 bg-transparent shrink-0 transition-colors"></div>
                    </div>
                    
                    <div onclick="selM('wa')" id="m-wa" class="flex items-center justify-between bg-slate-50 dark:bg-[#0b1320] border border-slate-200 dark:border-[#1e293b] p-3 rounded-xl cursor-pointer transition-colors">
                        <div class="flex items-center gap-3">
                            <i class="fab fa-whatsapp text-2xl text-green-500"></i>
                            <div class="flex flex-col">
                                <span class="font-bold text-sm text-slate-800 dark:text-white">Manual WA</span>
                                <span class="text-[10px] text-slate-500 dark:text-gray-500 leading-tight">Transfer ke admin</span>
                            </div>
                        </div>
                        <div id="r-wa" class="w-5 h-5 rounded-full border-[3px] border-slate-300 dark:border-gray-600 bg-transparent shrink-0 transition-colors"></div>
                    </div>

                </div>

                <button onclick="prosesTopup()" class="w-full py-3.5 bg-yellow-400 dark:bg-[#facc15] text-slate-900 dark:text-[#0b1320] font-extrabold rounded-xl shadow-md hover:bg-yellow-500 mb-3 transition-colors">Lanjutkan Pembayaran</button>
            </div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) { 
            window.location.href = '/'; 
        }
        
        function toggleTheme() {
            const html = document.documentElement;
            if(html.classList.contains('dark')) {
                html.classList.remove('dark'); 
                localStorage.setItem('theme', 'light');
                document.getElementById('themeIcon').className = 'fas fa-sun w-6 text-center text-lg text-orange-500';
                document.getElementById('themeText').innerText = 'Tema Terang';
            } else {
                html.classList.add('dark'); 
                localStorage.setItem('theme', 'dark');
                document.getElementById('themeIcon').className = 'fas fa-moon w-6 text-center text-lg text-[#facc15]';
                document.getElementById('themeText').innerText = 'Tema Gelap';
            }
        }
        
        window.addEventListener('DOMContentLoaded', () => {
            if(localStorage.getItem('theme') === 'light') {
                const icon = document.getElementById('themeIcon');
                const txt = document.getElementById('themeText');
                if(icon) icon.className = 'fas fa-sun w-6 text-center text-lg text-orange-500';
                if(txt) txt.innerText = 'Tema Terang';
            }
        });

        function comingSoon() {
            const bgSwal = document.documentElement.classList.contains('dark') ? '#111c2e' : '#ffffff';
            const textSwal = document.documentElement.classList.contains('dark') ? '#ffffff' : '#0f172a';
            
            Swal.fire({
                icon: 'info',
                title: 'Segera Hadir!',
                text: 'Fitur VPN Premium sedang dalam tahap pengembangan. Nantikan segera!',
                background: bgSwal,
                color: textSwal,
                confirmButtonColor: document.documentElement.classList.contains('dark') ? '#facc15' : '#facc15'
            });
        }

        function isMaintenance() {
            const tzStr = new Date().toLocaleString("en-US", {timeZone: "Asia/Jakarta"}); 
            const nowWIB = new Date(tzStr); 
            const h = nowWIB.getHours(); 
            const m = nowWIB.getMinutes();
            if (h >= 23 || (h === 0 && m <= 30)) {
                return true; 
            }
            return false;
        }

        if(isMaintenance()) {
            const mb = document.getElementById('maintenanceBanner'); 
            if(mb) mb.classList.remove('hidden');
            
            const hm = document.getElementById('headerMain'); 
            if(hm) hm.classList.remove('top-0');
        }

        document.getElementById('sidebarName').innerText = user.name;
        document.getElementById('sidebarPhone').innerText = user.phone;
        
        if(user.avatar) { 
            document.getElementById('sidebarInitial').innerHTML = `<img src="${user.avatar}" class="w-full h-full rounded-full object-cover border-2 border-transparent">`; 
        } else { 
            document.getElementById('sidebarInitial').innerText = user.name.charAt(0).toUpperCase(); 
        }

        let linkTele = 'https://t.me/digitalfikystore_channel'; 
        let linkWa = 'https://whatsapp.com/channel/digitalfikystore';
        let sel = ''; 
        let curSal = 0; 
        
        function updateDateTime() {
            const tzStr = new Date().toLocaleString("en-US", {timeZone: "Asia/Jakarta"}); 
            const now = new Date(tzStr);
            const year = now.getFullYear(); 
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0'); 
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0'); 
            const seconds = String(now.getSeconds()).padStart(2, '0');
            
            if(document.getElementById('realtimeDate')) {
                document.getElementById('realtimeDate').innerText = `${year}/${month}/${date}`;
            }
            if(document.getElementById('realtimeClock')) {
                document.getElementById('realtimeClock').innerText = `${hours}:${minutes}:${seconds}`;
            }
        }
        setInterval(updateDateTime, 1000); 
        updateDateTime();

        function updSal() {
            const el = document.getElementById('displaySaldo'); 
            el.innerText = 'Rp ' + curSal.toLocaleString('id-ID'); 
        }

        function logout() {
            const bgSwal = document.documentElement.classList.contains('dark') ? '#0b1320' : '#ffffff';
            const textSwal = document.documentElement.classList.contains('dark') ? '#ffffff' : '#0f172a';
            
            Swal.fire({
                title: 'Keluar Akun?', 
                text: 'Apakah kamu yakin ingin keluar?', 
                icon: 'warning', 
                showCancelButton: true, 
                background: bgSwal, 
                color: textSwal, 
                confirmButtonColor: '#d33', 
                cancelButtonColor: '#64748b'
            }).then(r => { 
                if(r.isConfirmed) { 
                    localStorage.removeItem('user'); 
                    window.location.href = '/'; 
                } 
            });
        }
        
        function bantuanAdmin() { 
            window.open(`https://wa.me/6282231154407?text=` + encodeURIComponent(`Halo Admin DIGITAL FIKY STORE, saya butuh bantuan.`), '_blank'); 
        }
        
        function bukaLinkKomunitas(tipe) { 
            if(tipe === 'tele') window.open(linkTele, '_blank'); 
            if(tipe === 'wa') window.open(linkWa, '_blank'); 
        }

        fetch('/api/user/balance', { 
            method: 'POST', 
            headers: {'Content-Type': 'application/json'}, 
            body: JSON.stringify({phone: user.phone}) 
        })
        .then(r => r.json())
        .then(d => { 
            curSal = d.saldo; 
            updSal(); 
        });

        fetch('/api/user/transactions', { 
            method: 'POST', 
            headers: {'Content-Type': 'application/json'}, 
            body: JSON.stringify({phone: user.phone}) 
        })
        .then(r => r.json())
        .then(d => { 
            document.getElementById('headTrx').innerText = (d.transactions || []).length + ' Trx'; 
        });
        
        fetch('/api/global-stats')
        .then(r => r.json())
        .then(d => {
            document.getElementById('statToday').innerText = d.today || 0; 
            document.getElementById('statWeek').innerText = d.week || 0;
            document.getElementById('statMonth').innerText = d.month || 0; 
            document.getElementById('statAll').innerText = d.all || 0;
        })
        .catch(e => {});

        fetch('/api/config')
        .then(r => r.json())
        .then(d => {
            if(d.linkTele) linkTele = d.linkTele; 
            if(d.linkWa) linkWa = d.linkWa;
            
            if(d.banners && d.banners.length > 0) {
                const bc = document.getElementById('bannerContainer');
                if(bc) {
                    bc.classList.remove('hidden');
                    const s = document.getElementById('promoSlider'); 
                    const dc = document.getElementById('promoDots');
                    
                    s.innerHTML = d.banners.map(fileName => `<div class="w-full h-full shrink-0 snap-center relative"><img src="/banners/${decodeURIComponent(fileName)}" class="absolute inset-0 w-full h-full object-cover"></div>`).join('');
                    
                    let dH = ''; 
                    for(let i = 0; i < d.banners.length; i++) { 
                        dH += `<div class="w-2 h-2 rounded-full bg-white opacity-${i === 0 ? '100' : '40'} dot-indicator shadow-sm"></div>`; 
                    }
                    dc.innerHTML = dH;
                    
                    let dots = document.querySelectorAll('.dot-indicator'); 
                    let cS = 0;
                    
                    s.addEventListener('scroll', () => {
                        let sI = Math.round(s.scrollLeft / s.clientWidth);
                        dots.forEach((dt, i) => { 
                            dt.classList.toggle('opacity-100', i === sI); 
                            dt.classList.toggle('opacity-40', i !== sI); 
                        });
                        cS = sI;
                    });
                    
                    setInterval(() => { 
                        cS = (cS + 1) % (dots.length || 1); 
                        s.scrollTo({ left: cS * s.clientWidth, behavior: 'smooth' }); 
                    }, 3500);
                }
            }
        });

        function openTopUp() { 
            document.getElementById('topupOverlay').classList.remove('hidden'); 
            setTimeout(() => { 
                document.getElementById('topupOverlay').classList.remove('opacity-0'); 
                document.getElementById('topupSheet').classList.remove('translate-y-full'); 
            }, 10); 
        }
        
        function closeTopUp() { 
            document.getElementById('topupSheet').classList.add('translate-y-full'); 
            document.getElementById('topupOverlay').classList.add('opacity-0'); 
            setTimeout(() => {
                document.getElementById('topupOverlay').classList.add('hidden');
            }, 300); 
        }
        
        function selM(m) {
            sel = m;
            const isDark = document.documentElement.classList.contains('dark');
            const borderColorUnsel = isDark ? 'border-gray-600' : 'border-slate-300';
            const borderColorSel = isDark ? 'border-[#facc15]' : 'border-yellow-400';
            const bgSel = isDark ? 'bg-[#0b1320]' : 'bg-slate-50';

            ['wa','qris'].forEach(x => {
                document.getElementById('r-' + x).className = `w-5 h-5 rounded-full border-[3px] ${borderColorUnsel} bg-transparent shrink-0 transition-colors`;
                document.getElementById('m-' + x).classList.remove('border-yellow-400', 'border-[#facc15]');
            });
            document.getElementById('r-' + m).className = `w-5 h-5 rounded-full border-[6px] ${borderColorSel} ${bgSel} shrink-0 transition-colors`;
            
            if(isDark) { 
                document.getElementById('m-' + m).classList.add('border-[#facc15]'); 
            } else { 
                document.getElementById('m-' + m).classList.add('border-yellow-400'); 
            }
        }

        async function prosesTopup() {
            const n = parseInt(document.getElementById('inputNominal').value);
            const bg = document.documentElement.classList.contains('dark') ? '#0b1320' : '#ffffff'; 
            const c = document.documentElement.classList.contains('dark') ? '#fff' : '#0f172a';
            
            if(isMaintenance()) {
                return Swal.fire({ icon: 'error', title: 'MAINTENANCE', text: 'Sistem Maintenance.', background: bg, color: c });
            }
            
            if(!n || n <= 0) {
                return Swal.fire({ icon: 'warning', title: 'Gagal', text: 'Isi nominal valid!', background: bg, color: c });
            }
            
            if(!sel) {
                return Swal.fire({ icon: 'warning', title: 'Gagal', text: 'Pilih metode pembayaran!', background: bg, color: c });
            }
            
            const fn = n + Math.floor(Math.random() * 90) + 10;
            
            if(sel === 'qris') {
                if(n < 1000) {
                    return Swal.fire({ icon: 'warning', title: 'Gagal', text: 'Minimal Rp 1.000', background: bg, color: c });
                }
                
                closeTopUp();
                Swal.fire({ title: 'Membuat QRIS...', allowOutsideClick: false, background: bg, color: c, didOpen: () => Swal.showLoading() });
                
                try {
                    let res = await fetch('/api/topup/request', { 
                        method: 'POST', 
                        headers: {'Content-Type': 'application/json'}, 
                        body: JSON.stringify({phone: user.phone, method: 'QRIS Otomatis', nominal: fn}) 
                    });
                    
                    let data = await res.json();
                    
                    if(res.ok) {
                        Swal.close();
                        let finalQrisImg = data.qris_string ? `https://api.qrserver.com/v1/create-qr-code/?size=500x500&margin=2&data=${encodeURIComponent(data.qris_string)}` : 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg';
                        
                        let timerBg = document.documentElement.classList.contains('dark') ? 'bg-[#1e293b]' : 'bg-slate-100';
                        let timerText = document.documentElement.classList.contains('dark') ? 'text-[#facc15]' : 'text-orange-500';
                        let timerBorder = document.documentElement.classList.contains('dark') ? 'border-[#facc15]/30' : 'border-orange-300';
                        let btnColor = document.documentElement.classList.contains('dark') ? 'bg-[#1e293b] text-[#facc15]' : 'bg-slate-100 text-orange-600';
                        let primaryBtn = document.documentElement.classList.contains('dark') ? 'bg-[#facc15] text-[#0b1320]' : 'bg-yellow-400 text-slate-900';
                        let labelHarga = document.documentElement.classList.contains('dark') ? 'text-[#38bdf8]' : 'text-blue-600';

                        let htmlContent = `
                        <div class="flex flex-col items-center pb-2">
                            <div class="w-full text-center mb-4 mt-2">
                                <p class="text-slate-500 dark:text-gray-400 text-[11px] font-bold mb-1.5 uppercase">Sisa Waktu Pembayaran</p>
                                <div class="${timerBg} ${timerText} font-black text-3xl py-2 rounded-xl border ${timerBorder} shadow-sm tracking-wider w-3/4 mx-auto transition-colors" id="qrisTimerModal">10 : 00</div>
                            </div>
                            <div class="bg-white p-3 rounded-2xl inline-block mb-4 shadow-md border border-slate-200">
                                <img id="qris-image-target" src="${finalQrisImg}" class="w-48 h-48 object-contain" style="image-rendering: crisp-edges;">
                            </div>
                            <div class="flex gap-3 w-full mb-4">
                                <button onclick="shareQRISImg()" class="flex-1 py-3 ${btnColor} border border-slate-200 dark:border-[#334155] font-extrabold rounded-xl hover:opacity-80 transition text-[13px] flex items-center justify-center gap-2"><i class="fas fa-share-alt"></i> Bagikan</button>
                                <button onclick="downloadQRISImg()" class="flex-1 py-3 ${btnColor} border border-slate-200 dark:border-[#334155] font-extrabold rounded-xl hover:opacity-80 transition text-[13px] flex items-center justify-center gap-2"><i class="fas fa-download"></i> Unduh</button>
                            </div>
                            <div class="text-center w-full mb-6">
                                <p class="text-slate-500 dark:text-gray-400 text-[10px] font-bold uppercase tracking-wider mb-1">Transfer TEPAT SEBESAR:</p>
                                <p class="${labelHarga} font-black text-3xl mb-1.5 drop-shadow-md">Rp ${fn.toLocaleString('id-ID')}</p>
                                <p class="text-[#ef4444] text-[11px] font-bold bg-red-500/10 border border-red-500/30 py-1.5 px-3 rounded-lg inline-block">Wajib persis agar otomatis masuk.</p>
                            </div>
                            <button onclick="window.location.href='/riwayat_topup.html'" class="w-full py-3.5 ${primaryBtn} font-extrabold rounded-xl shadow-md hover:opacity-90 transition text-[14px]">Cek Riwayat Topup</button>
                        </div>`;

                        setTimeout(() => {
                            Swal.fire({
                                title: `<span class="text-slate-800 dark:text-white font-extrabold text-lg uppercase tracking-wide">Scan QRIS Dinamis</span>`,
                                html: htmlContent, 
                                showConfirmButton: false, 
                                showCloseButton: true, 
                                background: bg, 
                                color: c,
                                didOpen: () => {
                                    let t = 600; 
                                    let tmr = document.getElementById('qrisTimerModal');
                                    timerInterval = setInterval(() => { 
                                        t--; 
                                        let m = Math.floor(t / 60).toString().padStart(2, '0'); 
                                        let s = (t % 60).toString().padStart(2, '0'); 
                                        if(tmr) tmr.innerText = `${m} : ${s}`; 
                                        if(t <= 0) { 
                                            clearInterval(timerInterval); 
                                            Swal.close(); 
                                            location.href = '/riwayat_topup.html'; 
                                        } 
                                    }, 1000);
                                }, 
                                willClose: () => clearInterval(timerInterval)
                            });
                        }, 300);
                        
                    } else { 
                        Swal.fire({ icon: 'error', title: 'Gagal', text: data.error || 'Terjadi kesalahan sistem.', background: bg, color: c }); 
                    }
                } catch(e) { 
                    Swal.fire({ icon: 'error', title: 'Gagal', text: 'Jaringan bermasalah.', background: bg, color: c }); 
                }
            } else {
                closeTopUp();
                fetch('/api/topup/request', { 
                    method: 'POST', 
                    headers: {'Content-Type': 'application/json'}, 
                    body: JSON.stringify({phone: user.phone, method: 'Manual WA', nominal: fn}) 
                }).then(() => {
                    window.open(`https://wa.me/6282231154407?text=` + encodeURIComponent(`Halo Admin DIGITAL FIKY STORE, saya mau Top Up Saldo Manual.\nNomor Akun: ${user.phone}\nNominal: *Rp ${fn.toLocaleString('id-ID')}*\n\nMohon instruksi selanjutnya.`), '_blank');
                    setTimeout(() => location.href = '/riwayat_topup.html', 1000);
                });
            }
        }

        window.shareQRISImg = async function() {
            let imgUrl = document.getElementById('qris-image-target').src;
            try {
                let res = await fetch(imgUrl); 
                let blob = await res.blob();
                let file = new File([blob], 'QRIS_Topup.jpg', { type: 'image/jpeg' });
                if (navigator.canShare && navigator.canShare({ files: [file] })) { 
                    await navigator.share({ title: 'QRIS Topup', files: [file] }); 
                } else { 
                    Swal.fire('Gagal', 'Browser tidak mendukung. Gunakan Unduh.', 'error'); 
                }
            } catch(e) {}
        }
        
        window.downloadQRISImg = async function() {
            let imgUrl = document.getElementById('qris-image-target').src;
            try {
                let res = await fetch(imgUrl); 
                let blob = await res.blob(); 
                let url = window.URL.createObjectURL(blob);
                let a = document.createElement('a'); 
                a.href = url; 
                a.download = 'QRIS_Topup_' + Date.now() + '.jpg';
                document.body.appendChild(a); 
                a.click(); 
                window.URL.revokeObjectURL(url); 
                document.body.removeChild(a);
            } catch(e) {}
        }
    </script>
</body>
</html>
EOF

echo "[PART 1 SELESAI DITULIS!]"
// selesai
echo "[8/10] Menulis logika Backend Node.js (SUPER UNCOMPRESSED - NOTIF 2 JALUR & TOPIK TELEGRAM)..."

cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, fetchLatestBaileysVersion } = require('@whiskeysockets/baileys');
const fs = require('fs');
const pino = require('pino');
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const axios = require('axios');
const crypto = require('crypto');
const FormData = require('form-data');
const { exec } = require('child_process');

const app = express();

// ==========================================
// PENGATURAN EXPRESS & MIDLEWARE
// ==========================================
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ==========================================
// DATABASE & KONFIGURASI FILE
// ==========================================
const configFile = './config.json';
const dbFile = './database.json';
const webUsersFile = './web_users.json'; 
const localProductsFile = './local_products.json';
const digiCacheFile = './digi_cache.json'; 
const infoFile = './info.json';

const loadJSON = (file) => {
    if (fs.existsSync(file)) {
        return JSON.parse(fs.readFileSync(file));
    } else {
        if (file === localProductsFile || file === infoFile) {
            return [];
        }
        return {};
    }
};

const saveJSON = (file, data) => {
    fs.writeFileSync(file, JSON.stringify(data, null, 2));
};

let configAwal = loadJSON(configFile);
if (!configAwal.botName) {
    configAwal.botName = "DIGITAL FIKY STORE";
}
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});
if (!fs.existsSync(localProductsFile)) saveJSON(localProductsFile, []);
if (!fs.existsSync(digiCacheFile)) saveJSON(digiCacheFile, { time: 0, data: [] }); 
if (!fs.existsSync(infoFile)) saveJSON(infoFile, []);

// ==========================================
// FUNGSI SENSOR DATA KHUSUS TESTIMONI PUBLIK
// ==========================================
function censorName(name) {
    if (!name) return 'Hamba Allah';
    return name; // NAMA TIDAK DISENSOR SESUAI REQUEST BOSS
}

function censorEmail(email) {
    if (!email || !email.includes('@')) {
        return 'Belum diatur';
    }
    let parts = email.split('@');
    let namePart = parts[0];
    let domainPart = parts[1];
    if (namePart.length <= 3) {
        return namePart + '***@' + domainPart;
    }
    return namePart.substring(0, 4) + '***@' + domainPart;
}

function censorWa(wa) {
    if (!wa) {
        return '080000000000';
    }
    if (wa.length <= 8) {
        return wa;
    }
    return wa.substring(0, 4) + '****' + wa.substring(wa.length - 3);
}

function censorTarget(target) {
    if (!target) {
        return '-';
    }
    if (target.length <= 5) {
        return target;
    }
    return target.substring(0, 4) + 'xxxx' + target.substring(target.length - 2);
}

// ==========================================
// FUNGSI AUTO MAINTENANCE (FIX TIMEZONE WIB)
// ==========================================
function isMaintenance() {
    const tzStr = new Date().toLocaleString("en-US", {timeZone: "Asia/Jakarta"});
    const nowWIB = new Date(tzStr);
    const h = nowWIB.getHours();
    const m = nowWIB.getMinutes();
    
    if (h >= 23 || (h === 0 && m <= 30)) { 
        return true; 
    }
    return false;
}

// ==========================================
// PENGIRIMAN NOTIFIKASI 2 JALUR (ADMIN & PUBLIK)
// ==========================================
const sendTeleAdmin = async (message) => {
    let cfg = loadJSON(configFile);
    if (!cfg.teleTokenAdmin || !cfg.teleChatAdmin) {
        return;
    }
    try { 
        await axios.post(`https://api.telegram.org/bot${cfg.teleTokenAdmin}/sendMessage`, { 
            chat_id: cfg.teleChatAdmin, 
            text: message, 
            parse_mode: 'Markdown' 
        }); 
    } catch(e) {
        try { 
            await axios.post(`https://api.telegram.org/bot${cfg.teleTokenAdmin}/sendMessage`, { 
                chat_id: cfg.teleChatAdmin, 
                text: message 
            }); 
        } catch(err) {}
    }
};

const broadcastPublik = async (message, type, status) => {
    let cfg = loadJSON(configFile);
    
    // 1. Kirim ke Grup Telegram (Mendukung Thread / Topic) - Kirim Semua Status (Proses/Sukses/Gagal)
    if (cfg.teleTokenPublik && cfg.teleChatPublik) {
        let payload = { 
            chat_id: cfg.teleChatPublik, 
            text: message, 
            parse_mode: 'Markdown' 
        };
        
        // Jika type = topup dan ID topik topup diisi di menu, maka kirim ke topik tersebut
        if (type === 'topup' && cfg.teleTopicTopup) {
            payload.message_thread_id = cfg.teleTopicTopup;
        }
        
        // Jika type = trx dan ID topik trx diisi di menu, maka kirim ke topik tersebut
        if (type === 'trx' && cfg.teleTopicTrx) {
            payload.message_thread_id = cfg.teleTopicTrx;
        }
        
        try { 
            await axios.post(`https://api.telegram.org/bot${cfg.teleTokenPublik}/sendMessage`, payload); 
        } catch(e) {
            // Hapus parse_mode jika error karakter markdown
            delete payload.parse_mode;
            try { 
                await axios.post(`https://api.telegram.org/bot${cfg.teleTokenPublik}/sendMessage`, payload); 
            } catch(err) {}
        }
    }

    // 2. Kirim ke Saluran WhatsApp (HANYA STATUS SUKSES SESUAI REQUEST BOSS)
    if (status === 'Sukses' && cfg.waChannelId && global.waSocket) {
        try {
            await global.waSocket.sendMessage(cfg.waChannelId, { text: message });
        } catch(e) {}
    }
};

// ==========================================
// API DASAR & INFORMASI
// ==========================================
app.get('/api/config', (req, res) => { 
    let cfg = loadJSON(configFile);
    res.json({ 
        banners: cfg.banners || [], 
        linkTele: cfg.linkTele || 'https://t.me/digitalfikystore_channel',
        linkWa: cfg.linkWa || 'https://whatsapp.com/channel/digitalfikystore'
    }); 
});

app.get('/api/info', (req, res) => { 
    res.json({ info: loadJSON(infoFile) }); 
});

app.post('/api/user/balance', (req, res) => { 
    let db = loadJSON(dbFile); 
    res.json({ saldo: db[req.body.phone]?.saldo || 0 }); 
});

app.post('/api/user/mutasi', (req, res) => { 
    let db = loadJSON(dbFile); 
    res.json({ mutasi: db[req.body.phone]?.mutasi || [] }); 
});

app.post('/api/user/transactions', (req, res) => { 
    let db = loadJSON(dbFile); 
    res.json({ transactions: db[req.body.phone]?.transactions || [] }); 
});

app.get('/api/global-stats', (req, res) => {
    let db = loadJSON(dbFile); 
    const tzStr = new Date().toLocaleString("en-US", {timeZone: "Asia/Jakarta"});
    let now = new Date(tzStr);
    
    let todayStr = now.toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }).split(' ')[0]; 
    let startOfWeek = new Date(now); 
    startOfWeek.setDate(now.getDate() - now.getDay()); 
    
    let tToday = 0;
    let tWeek = 0;
    let tMonth = 0;
    let tAll = 0;
    
    for (let phone in db) {
        let userTrx = db[phone].transactions || [];
        userTrx.forEach(trx => {
            if(trx.status === 'Sukses' || trx.status === 'Proses') {
                tAll++; 
                let trxDateStr = trx.date.split(',')[0].split(' ')[0]; 
                let dParts = trxDateStr.split('/');
                let trxDateObj = new Date(dParts[2], parseInt(dParts[1])-1, dParts[0]);
                
                if(trxDateStr === todayStr) {
                    tToday++;
                }
                if(trxDateObj >= startOfWeek && trxDateObj <= now) {
                    tWeek++;
                }
                if(trxDateObj.getMonth() === now.getMonth() && trxDateObj.getFullYear() === now.getFullYear()) {
                    tMonth++;
                }
            }
        });
    }
    
    res.json({ today: tToday, week: tWeek, month: tMonth, all: tAll });
});

app.post('/api/admin/broadcast', (req, res) => {
    const { judul, message } = req.body; 
    let infoData = loadJSON(infoFile);
    let dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'});
    
    infoData.push({ 
        judul: judul || "📢 PENGUMUMAN RESMI", 
        isi: message, 
        date: dateStr 
    });
    
    saveJSON(infoFile, infoData); 
    res.json({ success: true, message: "Broadcast ditambahkan ke Pusat Informasi." });
});

app.post('/api/admin/broadcast-sosmed', async (req, res) => {
    const { message, target } = req.body;
    let config = loadJSON(configFile);
    let successInfo = [];

    if (target === 'all' || target === 'tele') {
        if (config.teleChatPublik && config.teleTokenPublik) {
            let tkn = config.teleTokenPublik;
            try {
                await axios.post(`https://api.telegram.org/bot${tkn}/sendMessage`, { 
                    chat_id: config.teleChatPublik, 
                    text: message, 
                    parse_mode: 'Markdown' 
                });
                successInfo.push('Telegram: Berhasil');
            } catch (e) {
                try {
                    await axios.post(`https://api.telegram.org/bot${tkn}/sendMessage`, { 
                        chat_id: config.teleChatPublik, 
                        text: message 
                    });
                    successInfo.push('Telegram: Berhasil (Mode Teks)');
                } catch(err) { 
                    successInfo.push('Telegram: Gagal'); 
                }
            }
        } else { 
            successInfo.push('Telegram: Belum diatur ID-nya'); 
        }
    }

    if (target === 'all' || target === 'wa') {
        if (config.waChannelId && global.waSocket) {
            try {
                await global.waSocket.sendMessage(config.waChannelId, { text: message });
                successInfo.push('WhatsApp: Berhasil');
            } catch (e) { 
                successInfo.push('WhatsApp: Gagal'); 
            }
        } else { 
            successInfo.push('WhatsApp: Belum diatur/Bot Mati'); 
        }
    }

    res.json({ success: true, message: "Laporan Broadcast: " + successInfo.join(' | ') });
});

// ==========================================
// PULL CATALOG DIGIFLAZZ & PRODUK LOKAL
// ==========================================
app.post('/api/products', async (req, res) => {
    const { type, brand, category } = req.body; 
    let config = loadJSON(configFile); 
    let digiCache = loadJSON(digiCacheFile); 
    let filtered = [];
    
    if (config.digiUser && config.digiKey) {
        let timeDiff = Date.now() - digiCache.time;
        if (timeDiff > 300000 || !digiCache.data || digiCache.data.length === 0) { 
            try {
                let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + "pricelist").digest('hex');
                let digiRes = await axios.post('https://api.digiflazz.com/v1/price-list', { 
                    cmd: 'prepaid', 
                    username: config.digiUser, 
                    sign: sign 
                }, { timeout: 8000 });
                
                if (digiRes.data && digiRes.data.data) { 
                    digiCache.data = digiRes.data.data; 
                    digiCache.time = Date.now(); 
                    saveJSON(digiCacheFile, digiCache); 
                }
            } catch(e) { 
                digiCache.time = Date.now(); 
                saveJSON(digiCacheFile, digiCache); 
            }
        }
        
        let products = digiCache.data || []; 
        const safeBrand = brand ? brand.toLowerCase() : '';
        
        if (type === 'pulsa') { 
            filtered = products.filter(p => p.category === 'Pulsa' && p.brand.toLowerCase() === safeBrand); 
        } 
        else if (type === 'data') { 
            filtered = products.filter(p => p.category === 'Data' && p.brand.toLowerCase() === safeBrand); 
            if (category) { 
                const kw = category.toLowerCase().split(' '); 
                filtered = filtered.filter(p => kw.every(k => p.product_name.toLowerCase().includes(k))); 
            } 
        } 
        else if (type === 'ewallet' || type === 'etoll') { 
            filtered = products.filter(p => p.category === 'E-Money' && p.brand.toLowerCase().includes(safeBrand)); 
        } 
        else if (type === 'game') { 
            filtered = products.filter(p => p.category === 'Games' && p.brand.toLowerCase() === safeBrand); 
            if (category) { 
                const isWDP = category.toLowerCase().includes('weekly') || category.toLowerCase().includes('pass'); 
                const isMember = category.toLowerCase().includes('member'); 
                if (isWDP || isMember) { 
                    filtered = filtered.filter(p => p.product_name.toLowerCase().includes('pass') || p.product_name.toLowerCase().includes('weekly') || p.product_name.toLowerCase().includes('member')); 
                } else { 
                    filtered = filtered.filter(p => !p.product_name.toLowerCase().includes('pass') && !p.product_name.toLowerCase().includes('weekly') && !p.product_name.toLowerCase().includes('member')); 
                } 
            } 
        } 
        else if (type === 'pln') { 
            filtered = products.filter(p => p.category === 'PLN'); 
        } 
        else if (type === 'masaaktif') { 
            filtered = products.filter(p => p.category === 'Masa Aktif' && p.brand.toLowerCase() === safeBrand); 
        } 
        else if (type === 'voucher') { 
            filtered = products.filter(p => p.category === 'Voucher' && p.brand.toLowerCase() === safeBrand); 
        } 
        else if (type === 'perdana') { 
            filtered = products.filter(p => p.category === 'Perdana' && p.brand.toLowerCase() === safeBrand); 
        } 
        else if (type === 'smstelpon') { 
            filtered = products.filter(p => p.category === 'Paket SMS & Nelpon' && p.brand.toLowerCase() === safeBrand); 
        }
    }

    let markupRules = config.markupRules || { m1:0, m2:0, m3:0, m4:0, m5:0, m6:0, m7:0, m8:0, m9:0, m10:0, m11:0, m12:0, m13:0, m14:0 };
    
    let getMarkup = (price) => { 
        if(price<=100) return markupRules.m1; 
        if(price<=500) return markupRules.m2; 
        if(price<=1000) return markupRules.m3; 
        if(price<=3000) return markupRules.m4; 
        if(price<=5000) return markupRules.m5; 
        if(price<=10000) return markupRules.m6; 
        if(price<=15000) return markupRules.m7; 
        if(price<=25000) return markupRules.m8; 
        if(price<=50000) return markupRules.m9; 
        if(price<=70000) return markupRules.m10; 
        if(price<=100000) return markupRules.m11; 
        if(price<=120000) return markupRules.m12; 
        if(price<=150000) return markupRules.m13; 
        return markupRules.m14; 
    };
    
    let localProducts = loadJSON(localProductsFile);
    let myLocals = localProducts.filter(p => { 
        if (p.type !== type) return false; 
        if (brand && p.brand) { 
            if (p.brand.toLowerCase() !== brand.toLowerCase()) return false; 
        } else if (brand && !p.brand) { 
            return false; 
        } 
        
        if ((type === 'data' || type === 'game') && category) { 
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
            isLocal: false, 
            is_open: (p.buyer_product_status === true && p.seller_product_status === true) 
        })), 
        ...myLocals.map(p => ({ 
            sku: p.sku, 
            name: p.name, 
            desc: p.desc, 
            price: p.price + getMarkup(p.price), 
            isLocal: (p.isDigi === true) ? false : true, 
            is_open: true 
        })) 
    ];
    
    combined.sort((a, b) => a.price - b.price); 
    res.json({ data: combined });
});

// ==========================================
// TRANSAKSI LOGIC (PULSA/DATA/GAME DLL)
// ==========================================
app.post('/api/transaction/create', async (req, res) => {
    try {
        const { phone, target, sku, name, price, isLocal } = req.body;
        if (isMaintenance()) {
            return res.status(400).json({ error: 'Sistem sedang Maintenance Otomatis. Transaksi ditutup sementara.' });
        }
        
        let db = loadJSON(dbFile); 
        let config = loadJSON(configFile); 
        let webUsers = loadJSON(webUsersFile); 
        let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
        
        if (!db[phone]) {
            return res.status(400).json({ error: 'Akun tidak ditemukan.' });
        }
        if (db[phone].saldo < price) {
            return res.status(400).json({ error: 'Saldo tidak mencukupi.' });
        }
        
        if (!db[phone].mutasi) {
            db[phone].mutasi = []; 
        }
        if (!db[phone].transactions) {
            db[phone].transactions = [];
        }
        
        let salSebelum = db[phone].saldo;
        let salSesudah = salSebelum - price;
        db[phone].saldo = salSesudah; 
        
        let ref_id = 'TRX' + Date.now(); 
        let dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'}); 
        let trxStatus = 'Proses'; 
        let sn_ref = '-';

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
                
                let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload, { timeout: 8000 }); 
                let digiData = digiRes.data.data;
                
                if (digiData.status === 'Gagal') { 
                    db[phone].saldo += price; 
                    saveJSON(dbFile, db); 
                    return res.status(400).json({ error: digiData.message || 'Gagal dari provider.' }); 
                } else if (digiData.status === 'Sukses') { 
                    trxStatus = 'Sukses'; 
                    sn_ref = digiData.sn || '-'; 
                } else { 
                    trxStatus = 'Proses'; 
                    sn_ref = digiData.sn || '-'; 
                }
            } catch(e) { 
                db[phone].saldo += price; 
                saveJSON(dbFile, db); 
                return res.status(400).json({ error: 'Koneksi ke Digiflazz Timeout. Saldo dikembalikan otomatis.' }); 
            }
        }
        
        db[phone].mutasi.push({ 
            id: ref_id, 
            type: 'out', 
            amount: price, 
            desc: `Beli ${name}`, 
            date: dateStr 
        });
        
        db[phone].transactions.push({ 
            id: ref_id, 
            sku: sku, 
            isLocal: isLocal, 
            produk: name, 
            nominal: price, 
            no_tujuan: target, 
            status: trxStatus, 
            sn_ref: sn_ref, 
            harga: price, 
            date: dateStr 
        });
        
        saveJSON(dbFile, db);
        
        let uName = uData.name || 'Hamba Allah';
        let uEmail = uData.email || 'Belum diatur';
        
        let emojiStatus = trxStatus === 'Sukses' ? '✅' : (trxStatus === 'Proses' ? '⏳' : '❌');
        let txtStatus = trxStatus.toUpperCase();
        
        let adminMsg = `${emojiStatus} *TRANSAKSI PRODUK (${txtStatus})* ${emojiStatus}\n\n👤 Nama: ${uName}\n✉️ Email: ${uEmail}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${name}\n📱 Tujuan: ${target}\n🔖 SN: ${sn_ref}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSesudah.toLocaleString('id-ID')}`;
        sendTeleAdmin(adminMsg); 
        
        let publikMsg = `${emojiStatus} *TRANSAKSI PRODUK (${txtStatus})* ${emojiStatus}\n\n👤 Nama: ${censorName(uName)}\n✉️ Email: ${censorEmail(uEmail)}\n📱 WA: ${censorWa(phone)}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${name}\n📱 Tujuan: ${censorTarget(target)}\n🔖 SN: ${sn_ref}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSesudah.toLocaleString('id-ID')}`;
        broadcastPublik(publikMsg, 'trx', trxStatus);
        
        res.json({ message: 'Transaksi berhasil diproses.' });
    } catch (e) { 
        res.status(500).json({ error: 'Terjadi kesalahan internal.' }); 
    }
});

// INTERVAL PENGECEKAN STATUS TRANSAKSI DIGIFLAZZ
setInterval(async () => {
    let db = loadJSON(dbFile); 
    let config = loadJSON(configFile); 
    let webUsers = loadJSON(webUsersFile); 
    let changed = false;
    
    if (!config.digiUser || !config.digiKey) return;
    
    for (let phone in db) {
        let user = db[phone]; 
        if (!user.transactions) continue;
        
        let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
        
        for (let i = 0; i < user.transactions.length; i++) {
            let trx = user.transactions[i];
            if (trx.status === 'Proses' && !trx.isLocal && trx.sku) {
                try {
                    let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + trx.id).digest('hex');
                    let digiPayload = { 
                        username: config.digiUser, 
                        buyer_sku_code: trx.sku, 
                        customer_no: trx.no_tujuan, 
                        ref_id: trx.id, 
                        sign: sign 
                    };
                    
                    let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload, { timeout: 10000 }); 
                    let digiData = digiRes.data.data;
                    
                    let salSebelumInfo = user.saldo + trx.harga;
                    let uName = uData.name || 'Hamba Allah';
                    let uEmail = uData.email || 'Belum diatur';
                    let dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'});
                    
                    if (digiData.status === 'Sukses') { 
                        trx.status = 'Sukses'; 
                        trx.sn_ref = digiData.sn || trx.sn_ref || '-'; 
                        changed = true; 
                        
                        let adminMsg = `✅ *TRANSAKSI PRODUK (SUKSES)* ✅\n\n👤 Nama: ${uName}\n✉️ Email: ${uEmail}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}\n💰 Harga: Rp ${(trx.harga || 0).toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelumInfo.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${(user.saldo).toLocaleString('id-ID')}`;
                        sendTeleAdmin(adminMsg); 
                        
                        let publikMsg = `✅ *TRANSAKSI PRODUK (SUKSES)* ✅\n\n👤 Nama: ${censorName(uName)}\n✉️ Email: ${censorEmail(uEmail)}\n📱 WA: ${censorWa(phone)}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${censorTarget(trx.no_tujuan)}\n🔖 SN: ${trx.sn_ref}\n💰 Harga: Rp ${(trx.harga || 0).toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelumInfo.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${(user.saldo).toLocaleString('id-ID')}`;
                        broadcastPublik(publikMsg, 'trx', 'Sukses');
                    } 
                    else if (digiData.status === 'Gagal') { 
                        trx.status = 'Gagal'; 
                        trx.sn_ref = digiData.sn || digiData.message || 'Gagal Pusat'; 
                        user.saldo += trx.harga; 
                        
                        user.mutasi.push({ 
                            id: 'REF'+Date.now(), 
                            type: 'in', 
                            amount: trx.harga, 
                            desc: `Refund: ${trx.produk}`, 
                            date: dateStr 
                        }); 
                        changed = true; 
                        
                        let adminMsg = `❌ *TRANSAKSI PRODUK (GAGAL)* ❌\n\n👤 Nama: ${uName}\n✉️ Email: ${uEmail}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}\n💰 Harga: Rp ${(trx.harga || 0).toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelumInfo.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${(user.saldo).toLocaleString('id-ID')}`;
                        sendTeleAdmin(adminMsg); 
                        
                        let publikMsg = `❌ *TRANSAKSI PRODUK (GAGAL)* ❌\n\n👤 Nama: ${censorName(uName)}\n✉️ Email: ${censorEmail(uEmail)}\n📱 WA: ${censorWa(phone)}\n⌚ Waktu: ${dateStr}\n\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${censorTarget(trx.no_tujuan)}\n🔖 SN: ${trx.sn_ref}\n💰 Harga: Rp ${(trx.harga || 0).toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelumInfo.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${(user.saldo).toLocaleString('id-ID')}`;
                        broadcastPublik(publikMsg, 'trx', 'Gagal');
                    }
                } catch(e) {
                    // Abaikan error jaringan
                }
            }
        }
    }
    if (changed) {
        saveJSON(dbFile, db);
    }
}, 20000); 

// ==========================================
// 🛠️ GENERATOR QRIS DINAMIS (RUMUS CRC16 CCITT)
// ==========================================
function convertCRC16(str) {
    let crc = 0xFFFF;
    for (let c = 0; c < str.length; c++) {
        crc ^= str.charCodeAt(c) << 8;
        for (let i = 0; i < 8; i++) {
            if (crc & 0x8000) {
                crc = (crc << 1) ^ 0x1021;
            } else {
                crc = crc << 1;
            }
        }
    }
    let hex = (crc & 0xFFFF).toString(16).toUpperCase();
    return hex.padStart(4, '0');
}

function generateDynamicQris(staticQris, amount) {
    try {
        let qrisWithoutCRC = staticQris.substring(0, staticQris.indexOf("6304"));
        if(!qrisWithoutCRC) {
            return staticQris;
        }
        
        let amountStr = amount.toString();
        let amountLen = amountStr.length.toString().padStart(2, '0');
        let tag54 = "54" + amountLen + amountStr;
        let rawQris = qrisWithoutCRC + tag54 + "6304";
        let newCrc = convertCRC16(rawQris);
        
        return rawQris + newCrc;
    } catch (e) {
        return staticQris;
    }
}

// ==========================================
// 💰 FUNGSI AUTO-QRIS CHECKER (UPDATE API BHM TERBARU) 💰
// ==========================================
setInterval(async () => {
    let db = loadJSON(dbFile);
    let config = loadJSON(configFile);
    let webUsers = loadJSON(webUsersFile);
    let changed = false;

    if (!config.bhmToken) return;

    let pendingQris = [];
    for (let phone in db) {
        if (db[phone].topup) {
            db[phone].topup.forEach(t => {
                if (t.status === 'Proses' && t.method === 'QRIS Otomatis') {
                    pendingQris.push({ phone, topup: t });
                }
            });
        }
    }

    if (pendingQris.length > 0) {
        try {
            // Menggunakan Endpoint Terbaru (dengan Fallback)
            let endpoint = config.bhmMerchantId 
                ? `http://gopay.bhm.biz.id/v1/gopay/merchants/${config.bhmMerchantId}/transactions` 
                : `http://gopay.bhm.biz.id/v1/gopay/transactions`;
                
            let res = await axios.get(endpoint, {
                headers: { 'Authorization': `Bearer ${config.bhmToken}` },
                timeout: 10000
            }).catch(async () => {
                return await axios.get('http://gopay.bhm.biz.id/api/transactions', {
                    headers: { 'Authorization': `Bearer ${config.bhmToken}` },
                    timeout: 10000
                });
            });
            
            // MENYESUAIKAN DENGAN STRUKTUR BARU BHM (CCTV: res.data.items)
            let rawData = res.data;
            let txs = [];
            if (rawData && Array.isArray(rawData.items)) {
                txs = rawData.items;
            } else if (rawData && rawData.data && Array.isArray(rawData.data.items)) {
                txs = rawData.data.items;
            } else if (Array.isArray(rawData)) {
                txs = rawData;
            } else if (rawData && Array.isArray(rawData.data)) {
                txs = rawData.data;
            }

            if (!Array.isArray(txs) || txs.length === 0) return;
            
            for (let p of pendingQris) {
                let targetNominal = parseInt(p.topup.nominal);
                
                let matchTx = txs.find(tx => {
                    // MEMBACA FORMAT HARGA BARU "1030.00" -> 1030
                    let txAmountStr = String(tx.amount || tx.gross_amount || 0);
                    let amount = parseInt(parseFloat(txAmountStr));
                    
                    // MEMBACA STATUS BARU "settlement"
                    let isCredit = (tx.status && tx.status.toLowerCase() === 'settlement') || (tx.type && tx.type.toLowerCase() === 'credit') || amount > 0;
                    
                    return amount === targetNominal && isCredit;
                });

                if (matchTx) {
                    if (!config.processedGopay) {
                        config.processedGopay = [];
                    }
                    
                    // MEMBACA ID BARU "external_id"
                    let refId = matchTx.external_id || matchTx.transaction_id || matchTx.id || Date.now().toString();
                    
                    if (refId && !config.processedGopay.includes(refId)) {
                        config.processedGopay.push(refId);
                        if(config.processedGopay.length > 500) {
                            config.processedGopay.shift();
                        }
                        saveJSON(configFile, config);

                        // RECORD SALDO SEBELUM & SESUDAH
                        let salSebelum = db[p.phone].saldo;
                        let salSesudah = salSebelum + targetNominal;

                        p.topup.status = 'Sukses';
                        p.topup.saldo_sebelum = salSebelum;
                        p.topup.saldo_sesudah = salSesudah;

                        db[p.phone].saldo = salSesudah;
                        db[p.phone].mutasi.push({ 
                            id: 'TU' + Date.now(), 
                            type: 'in', 
                            amount: targetNominal, 
                            desc: 'Topup QRIS Dinamis (GoPay)', 
                            date: new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'}) 
                        });
                        changed = true;

                        let uData = webUsers[p.phone] || {name: 'Hamba Allah', email: 'Belum diatur'};
                        let dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'});
                        let depositAsli = targetNominal - (p.topup.kode_unik || 0);
                        
                        let uName = uData.name || 'Hamba Allah';
                        let uEmail = uData.email || 'Belum diatur';
                        
                        // NOTIF ADMIN FULL
                        let adminMsg = `✅ *TOP UP SALDO (SUKSES)* ✅\n\n👤 Nama: ${uName}\n✉️ Email: ${uEmail}\n📱 WA: ${p.phone}\n⌚ Waktu: ${dateStr}\n🏦 Metode: QRIS Dinamis\n\n💰 Jumlah Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Kode Unik: ${p.topup.kode_unik || 0}\n💵 Total Saldo Diterima: Rp ${targetNominal.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSesudah.toLocaleString('id-ID')}`;
                        sendTeleAdmin(adminMsg);
                        
                        // NOTIF TESTIMONI SENSOR (PUBLIK) DENGAN NAMA TIDAK DISENSOR
                        let testiMsg = `✅ *TOP UP SALDO (SUKSES)* ✅\n\n👤 Nama: ${censorName(uName)}\n✉️ Email: ${censorEmail(uEmail)}\n📱 WA: ${censorWa(p.phone)}\n⌚ Waktu: ${dateStr}\n🏦 Metode: QRIS Dinamis\n\n💰 Jumlah Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Kode Unik: ${p.topup.kode_unik || 0}\n💵 Total Saldo Diterima: Rp ${targetNominal.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSesudah.toLocaleString('id-ID')}`;
                        broadcastPublik(testiMsg, 'topup', 'Sukses');
                    }
                }
            }
        } catch (e) {
            // Abaikan error fetch API
        }
    }

    if (changed) {
        saveJSON(dbFile, db);
    }
}, 20000); 

// ==========================================
// FUNGSI AUTO BACKUP SUPER LENGKAP
// ==========================================
function startAutoBackup() {
    let config = loadJSON(configFile); 
    if (!config.teleTokenAdmin || !config.teleChatAdmin || !config.autoBackupHours || config.autoBackupHours <= 0) return;
    
    setInterval(() => {
        let zipName = `AutoBackup_FikyStore_${Date.now()}.zip`;
        
        // Backup semua database + config + folder gambar banner dan info
        let cmd = `zip -r ${zipName} database.json web_users.json config.json local_products.json info.json public/banners public/info_images`;
        
        exec(cmd, async (err) => {
            if (!err) { 
                const form = new FormData(); 
                form.append('chat_id', config.teleChatAdmin); 
                form.append('caption', `⏳ *AUTO BACKUP SYSTEM (${config.autoBackupHours} Jam)*\n\nSeluruh Data, Konfigurasi API, dan Gambar Banner/Info telah diamankan.\nTanggal: ${new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'})}`); 
                form.append('document', fs.createReadStream(zipName)); 
                form.append('parse_mode', 'Markdown');
                
                try { 
                    await axios.post(`https://api.telegram.org/bot${config.teleTokenAdmin}/sendDocument`, form, { headers: form.getHeaders() }); 
                } catch(e) {
                    // Abaikan jika error kirim
                } 
                
                fs.unlinkSync(zipName); 
            }
        });
    }, config.autoBackupHours * 60 * 60 * 1000);
}
setTimeout(startAutoBackup, 15000); 

// ==========================================
// API TOPUP LOGIC (GENERATE QRIS DINAMIS)
// ==========================================
app.post('/api/topup/request', (req, res) => {
    const { phone, method, nominal } = req.body; 
    let config = loadJSON(configFile);
    
    if (isMaintenance()) {
        return res.status(400).json({ error: 'Sistem sedang Maintenance Otomatis.' });
    }
    
    let db = loadJSON(dbFile); 
    let webUsers = loadJSON(webUsersFile); 
    let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
    
    if (!db[phone]) {
        db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    }
    if (!db[phone].topup) {
        db[phone].topup = [];
    }
    
    let expiry = null;
    let finalQrisString = null;

    if (method === 'QRIS Otomatis') {
        expiry = Date.now() + 10 * 60 * 1000; 
        
        if (config.qrisStringCode && config.qrisStringCode !== '') {
            finalQrisString = generateDynamicQris(config.qrisStringCode, nominal);
        } else {
            return res.status(400).json({ error: 'Admin belum menyetting String QRIS di panel VPS. Hubungi Admin.' });
        }
    }

    let dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'});
    let newRef = 'TP-' + Date.now();
    let salSebelum = db[phone].saldo;
    let kodeUnik = nominal % 1000;
    let depositAsli = nominal - kodeUnik;
    
    const newTopup = { 
        id: newRef, 
        method: method, 
        nominal: nominal, 
        status: 'Proses', 
        date: dateStr, 
        expiry: expiry, 
        saldo_sebelum: salSebelum, 
        kode_unik: kodeUnik,
        nama: uData.name, 
        email: uData.email, 
        wa: phone
    };
    
    db[phone].topup.push(newTopup); 
    saveJSON(dbFile, db); 
    
    let uName = uData.name || 'Hamba Allah';
    let uEmail = uData.email || 'Belum diatur';
    
    let msgAdmin = `⏳ *TOP UP SALDO (PROSES)* ⏳\n\n👤 Nama: ${uName}\n✉️ Email: ${uEmail}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n🏦 Metode: ${method}\n\n💰 Jumlah Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Kode Unik: ${kodeUnik}\n💵 Total Saldo Diterima: Rp ${nominal.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSebelum.toLocaleString('id-ID')} (Pending)`;
    sendTeleAdmin(msgAdmin); 
    
    let msgPublik = `⏳ *TOP UP SALDO (PROSES)* ⏳\n\n👤 Nama: ${censorName(uName)}\n✉️ Email: ${censorEmail(uEmail)}\n📱 WA: ${censorWa(phone)}\n⌚ Waktu: ${dateStr}\n🏦 Metode: ${method}\n\n💰 Jumlah Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Kode Unik: ${kodeUnik}\n💵 Total Saldo Diterima: Rp ${nominal.toLocaleString('id-ID')}\n\n💳 Riwayat Saldo\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSebelum.toLocaleString('id-ID')} (Pending)`;
    broadcastPublik(msgPublik, 'topup', 'Proses');
    
    res.json({ message: 'Top up direkam', qris_string: finalQrisString, ref_id: newRef });
});

app.post('/api/topup/history', (req, res) => { 
    let db = loadJSON(dbFile); 
    let history = db[req.body.phone]?.topup || []; 
    let changed = false; 
    let now = Date.now();
    
    history.forEach(t => { 
        if (t.status === 'Proses' && t.method === 'QRIS Otomatis' && t.expiry && now > t.expiry) { 
            t.status = 'Expired'; 
            changed = true; 
        } 
    });
    
    if (changed) saveJSON(dbFile, db); 
    
    res.json({ history: history }); 
});

app.get('/api/admin/backup', async (req, res) => {
    let config = loadJSON(configFile);
    if (!config.teleTokenAdmin || !config.teleChatAdmin) {
        return res.status(400).json({ error: "Token/Chat ID Admin belum disetting." });
    }
    
    let zipName = `ManualBackup_FikyStore_${Date.now()}.zip`;
    let cmd = `zip -r ${zipName} database.json web_users.json config.json local_products.json info.json public/banners public/info_images`;
    
    exec(cmd, async (err) => {
        if(err) {
            return res.status(500).json({ error: "Gagal membuat file ZIP." });
        }
        
        const form = new FormData(); 
        form.append('chat_id', config.teleChatAdmin); 
        form.append('caption', `📦 *BACKUP MANUAL FULL SYSTEM*\n\nSemua Data dan Gambar telah diamankan.`); 
        form.append('document', fs.createReadStream(zipName));
        
        try { 
            await axios.post(`https://api.telegram.org/bot${config.teleTokenAdmin}/sendDocument`, form, { headers: form.getHeaders() }); 
            fs.unlinkSync(zipName); 
            res.json({ message: "Backup sukses!" }); 
        } catch(e) { 
            res.status(500).json({ error: "Gagal mengirim ke Telegram." }); 
        }
    });
});

app.post('/api/admin/balance', async (req, res) => {
    const { identifier, amount, action } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let db = loadJSON(dbFile); 
    
    let targetPhone = identifier.includes('@') ? Object.keys(webUsers).find(p => webUsers[p].email === identifier) : (identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier);
    
    if(!targetPhone || !webUsers[targetPhone]) {
        return res.json({ success: false, message: '\n❌ Member tidak ditemukan!' });
    }
    
    if(!db[targetPhone]) db[targetPhone] = { saldo: 0, mutasi: [], topup: [], transactions: [] };
    if(!db[targetPhone].mutasi) db[targetPhone].mutasi = []; 
    if(!db[targetPhone].topup) db[targetPhone].topup = [];
    
    const dateStr = new Date().toLocaleString('id-ID', {timeZone: 'Asia/Jakarta'});
    let salSebelum = db[targetPhone].saldo;

    if (action === 'add') { 
        let nominalLengkap = parseInt(amount);
        let salSesudah = salSebelum + nominalLengkap;
        db[targetPhone].saldo = salSesudah; 
        
        db[targetPhone].mutasi.push({ 
            id: 'TRX'+Date.now(), 
            type: 'in', 
            amount: nominalLengkap, 
            desc: 'Penambahan oleh Admin', 
            date: dateStr 
        }); 
        
        db[targetPhone].topup.push({ 
            id: 'TU'+Date.now(), 
            method: 'Admin Fiky Store', 
            nominal: nominalLengkap, 
            status: 'Sukses', 
            date: dateStr,
            saldo_sebelum: salSebelum, 
            saldo_sesudah: salSesudah, 
            kode_unik: 0,
            nama: webUsers[targetPhone].name, 
            email: webUsers[targetPhone].email, 
            wa: targetPhone
        }); 
        
        saveJSON(dbFile, db); 
        
        sendTeleAdmin(`✅ *TOP UP BERHASIL (DARI ADMIN)*\n\n👤 Nama: ${webUsers[targetPhone].name}\n📱 WA: ${targetPhone}\n💰 Masuk: Rp ${nominalLengkap.toLocaleString('id-ID')}\n📉 Saldo Sebelum: Rp ${salSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${salSesudah.toLocaleString('id-ID')}`); 
        
        res.json({ success: true, message: `\n✅ Saldo berhasil ditambah!` }); 
    } 
    else if (action === 'reduce') { 
        db[targetPhone].saldo -= parseInt(amount); 
        db[targetPhone].mutasi.push({ 
            id: 'TRX'+Date.now(), 
            type: 'out', 
            amount: parseInt(amount), 
            desc: 'Penarikan oleh Admin', 
            date: dateStr 
        }); 
        saveJSON(dbFile, db); 
        
        res.json({ success: true, message: `\n✅ Saldo berhasil dikurangi!` }); 
    }
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    
    let foundPhone = Object.keys(webUsers).find(p => (p === fPhone || webUsers[p].email === identifier) && webUsers[p].password === password);
    
    if (foundPhone) { 
        if (!webUsers[foundPhone].isVerified) {
            return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' });
        }
        res.json({ 
            message: 'Login sukses', 
            user: { 
                phone: foundPhone, 
                name: webUsers[foundPhone].name, 
                email: webUsers[foundPhone].email, 
                avatar: webUsers[foundPhone].avatar || null 
            } 
        }); 
    } else { 
        res.status(400).json({ error: 'Email/No HP atau Password salah.' }); 
    }
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor sudah terdaftar.' });
    }
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); 
    webUsers[fPhone] = { 
        name, 
        email, 
        password, 
        isVerified: false, 
        otp, 
        otpExpiry: Date.now() + 300000, 
        avatar: null 
    }; 
    
    saveJSON(webUsersFile, webUsers);
    
    try { 
        await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Halo kak *${name}* 👋\n\nTerima kasih telah mendaftar di *DIGITAL FIKY STORE* 👑\n\nKode OTP Anda:\n\n*${otp}*\n\n⏳ _Berlaku selama 5 menit._` }); 
        res.json({ message: 'OTP Terkirim', phone: fPhone }); 
    } catch(e) { 
        res.status(500).json({ error: 'Gagal kirim WA. Pastikan bot di VPS jalan.' }); 
    }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body; 
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp && String(webUsers[phone].otp) === String(otp)) {
        if (Date.now() > webUsers[phone].otpExpiry) {
            return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        }
        
        webUsers[phone].isVerified = true; 
        delete webUsers[phone].otp; 
        delete webUsers[phone].otpExpiry; 
        saveJSON(webUsersFile, webUsers);
        
        let db = loadJSON(dbFile); 
        if (!db[phone]) { 
            db[phone] = { saldo: 0, mutasi: [], topup: [], transactions: [] }; 
            saveJSON(dbFile, db); 
        }
        
        sendTeleAdmin(`🎊 *MEMBER BARU BERGABUNG* 🎊\n\n👤 Nama: ${webUsers[phone].name}\n✉️ Email: ${webUsers[phone].email}\n📱 WA: ${phone}`); 
        res.json({ message: 'Sukses!' });
    } else { 
        res.status(400).json({ error: 'OTP Salah / Sesi tidak valid.' }); 
    }
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    
    if (!webUsers[fPhone]) {
        return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    }
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); 
    webUsers[fPhone].otp = otp; 
    webUsers[fPhone].otpExpiry = Date.now() + 300000; 
    saveJSON(webUsersFile, webUsers);
    
    try { 
        await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Permintaan reset password *DIGITAL FIKY STORE*.\n\nKode OTP:\n\n*${otp}*\n\n⏳ _Berlaku 5 menit._` }); 
        res.json({ message: 'OTP Terkirim' }); 
    } catch(e) { 
        res.status(500).json({ error: 'Gagal kirim WA.' }); 
    }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body; 
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp && String(webUsers[phone].otp) === String(otp)) {
        if(Date.now() > webUsers[phone].otpExpiry) {
            return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        }
        
        webUsers[phone].password = newPassword; 
        delete webUsers[phone].otp; 
        delete webUsers[phone].otpExpiry; 
        saveJSON(webUsersFile, webUsers); 
        res.json({ message: 'Diubah!' });
    } else { 
        res.status(400).json({ error: 'OTP Salah.' }); 
    }
});

app.post('/api/auth/request-update-otp', async (req, res) => {
    const { oldPhone, newPhone } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; 
    let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    
    if (webUsers[fNew] && fNew !== fOld) {
        return res.status(400).json({ error: 'Nomor baru sudah terdaftar.' });
    }
    if(!webUsers[fOld]) {
        return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    }
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); 
    webUsers[fOld].updateOtp = otp; 
    webUsers[fOld].updateOtpExpiry = Date.now() + 300000; 
    saveJSON(webUsersFile, webUsers); 
    
    try { 
        await global.waSocket?.sendMessage((fNew !== fOld ? fNew : fOld) + '@c.us', { text: `Kode OTP verifikasi ubah keamanan akun *DIGITAL FIKY STORE*:\n\n*${otp}*\n\n⏳ _Berlaku 5 menit._` }); 
        res.json({ message: 'OTP Terkirim' }); 
    } catch(e) { 
        res.status(500).json({ error: 'Gagal kirim WA.' }); 
    } 
});

app.post('/api/auth/update', (req, res) => {
    const { oldPhone, newPhone, newName, otp, avatar, newPassword } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let db = loadJSON(dbFile); 
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; 
    let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    
    if (!webUsers[fOld]) {
        return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    }
    
    let isSecureChange = (fOld !== fNew) || (newPassword && newPassword.trim() !== '');
    
    if (isSecureChange) {
        if (fOld !== fNew && webUsers[fNew]) return res.status(400).json({ error: 'Nomor sudah dipakai.' });
        if (String(webUsers[fOld].updateOtp) !== String(otp)) return res.status(400).json({ error: 'Kode OTP Salah.' });
        if (Date.now() > webUsers[fOld].updateOtpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        
        if (fOld !== fNew) { 
            webUsers[fNew] = { ...webUsers[fOld], name: newName, avatar: avatar || webUsers[fOld].avatar }; 
            if (newPassword) webUsers[fNew].password = newPassword; 
            delete webUsers[fNew].updateOtp; 
            delete webUsers[fNew].updateOtpExpiry; 
            delete webUsers[fOld]; 
            
            if (db[fOld]) { 
                db[fNew] = { ...db[fOld], jid: fNew + '@s.whatsapp.net' }; 
                delete db[fOld]; 
            } 
        } else { 
            webUsers[fOld].name = newName; 
            if(avatar !== undefined) webUsers[fOld].avatar = avatar; 
            if (newPassword) webUsers[fOld].password = newPassword; 
            delete webUsers[fOld].updateOtp; 
            delete webUsers[fOld].updateOtpExpiry; 
        }
    } else { 
        webUsers[fOld].name = newName; 
        if(avatar !== undefined) webUsers[fOld].avatar = avatar; 
    }
    
    saveJSON(webUsersFile, webUsers); 
    saveJSON(dbFile, db); 
    res.json({ message: 'Profil diperbarui.', phone: fNew });
});

app.post('/api/auth/delete', (req, res) => {
    const { phone } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let db = loadJSON(dbFile);
    
    if(webUsers[phone]) delete webUsers[phone]; 
    if(db[phone]) delete db[phone];
    
    saveJSON(webUsersFile, webUsers); 
    saveJSON(dbFile, db); 
    res.json({ message: 'Akun dihapus.' });
});

// START BAILEYS BOT
async function startBot() {
    try {
        const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
        const { version } = await fetchLatestBaileysVersion();
        const sock = makeWASocket({ 
            version, 
            auth: state, 
            logger: pino({ level: 'silent' }), 
            browser: ['Ubuntu', 'Chrome', '20.0.0'], 
            printQRInTerminal: false 
        });
        
        if (!sock.authState.creds.registered) { 
            let config = loadJSON(configFile); 
            if (config.botNumber) { 
                setTimeout(async () => { 
                    try { 
                        const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, '')); 
                        console.log(`\n🔑 KODE PAIRING: ${code}\n`); 
                    } catch (e) {
                        // Abaikan error pairing
                    } 
                }, 5000); 
            } 
        }
        
        sock.ev.on('connection.update', (update) => { 
            const { connection } = update; 
            if (connection === 'close') { 
                setTimeout(startBot, 3000); 
            } else if (connection === 'open') { 
                console.log('\n✅ BOT WA TERHUBUNG!\n'); 
            } 
        });
        
        sock.ev.on('creds.update', saveCreds); 
        global.waSocket = sock; 
    } catch (e) {
        // Abaikan error init bot
    }
}

app.get('*', (req, res) => {
    let reqPath = req.path;
    if (!reqPath.includes('.') && reqPath !== '/') {
        let altPath = path.join(__dirname, 'public', reqPath + '.html');
        if (fs.existsSync(altPath)) {
            return res.sendFile(altPath);
        }
    }
    if (reqPath.endsWith('.html')) {
        let pagePath = path.join(__dirname, 'public', reqPath);
        if (fs.existsSync(pagePath)) {
            return res.sendFile(pagePath);
        }
    }
    res.status(404).send(`<div style="background-color:#0b1320; color:#facc15; text-align:center; padding-top:50px; height:100vh;"><h1>FILE TIDAK DITEMUKAN (404)</h1></div>`); 
});

if (require.main === module) { 
    app.listen(3000, () => { 
        console.log('🌐 Web berjalan di port 3000'); 
    }); 
    startBot(); 
}
EOF

echo "[PART 5 SELESAI DITULIS!]"
echo "[9/10] Membangun Panel Manajemen VPS Terlengkap (Menu Diringkas)..."

cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' 

while true; do 
    clear
    echo -e "${YELLOW}Sedang memuat data Saldo Digiflazz...${NC}"
    
    cd "$HOME/$DIR_NAME"
    SALDO_DIGI=$(node -e "
        const fs = require('fs');
        let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {};
        if (!cfg.digiUser || !cfg.digiKey) {
            console.log('Belum Disetting');
        } else {
            const axios = require('axios'); const crypto = require('crypto');
            let sign = crypto.createHash('md5').update(cfg.digiUser + cfg.digiKey + 'depo').digest('hex');
            axios.post('https://api.digiflazz.com/v1/cek-saldo', { cmd: 'deposit', username: cfg.digiUser, sign: sign }, {timeout: 5000})
            .then(r => { if (r.data && r.data.data && r.data.data.deposit !== undefined) console.log('Rp ' + r.data.data.deposit.toLocaleString('id-ID')); else console.log('Error/Invalid Key'); })
            .catch(e => { console.log('Gangguan/Timeout'); });
        }
    " 2>/dev/null)

    clear
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${YELLOW}         💎 PANEL DIGITAL FIKY STORE (V166) 💎        ${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo -e "   💰 SALDO DIGIFLAZZ: ${GREEN}$SALDO_DIGI${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${PURPLE}[ 🤖 MANAJEMEN BOT WHATSAPP ]${NC}"
    echo -e "  ${GREEN}1.${NC} Setup No. Bot & Login Pairing"
    echo -e "  ${GREEN}2.${NC} Jalankan Bot (Latar Belakang/PM2)"
    echo -e "  ${YELLOW}3.${NC} 🛠️ Install & Perbarui Sistem Bot WA"
    echo -e "  ${GREEN}4.${NC} Lihat Log / Error Bot"
    echo -e "  ${GREEN}5.${NC} Reset Sesi & Ganti Nomor Bot"
    echo -e "  ${GREEN}6.${NC} 📢 Broadcast Pengumuman (App, WA Channel, Telegram)"
    echo -e "${PURPLE}[ 📱 MANAJEMEN APLIKASI & WEB ]${NC}"
    echo -e "  ${GREEN}7.${NC} 💰 Manajemen Saldo Member"
    echo -e "  ${GREEN}8.${NC} 🖼️ Sinkronisasi Gambar Banner Lokal"
    echo -e "  ${GREEN}9.${NC} 📈 Seting Keuntungan 14 Tier"
    echo -e "  ${GREEN}10.${NC} 📦 Manajemen Produk (Lokal)"
    echo -e "  ${YELLOW}11.${NC} 🔗 Setup Link Komunitas & ID Saluran Sosmed"
    echo -e "${PURPLE}[ 🌐 MANAJEMEN SERVER & API ]${NC}"
    echo -e "  ${GREEN}12.${NC} Setup Domain (Nginx + Cloudflare + UFW Firewall)"
    echo -e "  ${GREEN}13.${NC} 🔌 Setup API Digiflazz (Untuk Produk)"
    echo -e "  ${YELLOW}14.${NC} 💸 Setup API BHM GoPay (Untuk AUTO QRIS DINAMIS)"
    echo -e "  ${GREEN}15.${NC} 🔄 Refresh Katalog Digiflazz (Hapus Cache API)"
    echo -e "${PURPLE}[ 🛡️ PUSAT KOMANDO NOTIFIKASI & BACKUP ]${NC}"
    echo -e "  ${GREEN}16.${NC} ⚙️ Setup Telegram Bot & Topik Grup (Admin & Publik)"
    echo -e "  ${GREEN}17.${NC} 💾 BACKUP & RESTORE DATA FULL"
    echo -e "  ${GREEN}18.${NC} ⏳ Setting Auto-Backup System (Tiap X Jam)"
    echo -e "${CYAN}======================================================${NC}"
    echo -e "  ${RED}0.${NC} Keluar Keluar"
    echo -e "${CYAN}======================================================${NC}"
    read -p "Pilih menu [0-18]: " choice

    case $choice in
        1) 
            clear
            read -p "Masukkan Nomor WA Bot (Awalan 62, cth: 62812...): " botnum
            if [ ! -z "$botnum" ]; then
                pm2 stop $BOT_NAME > /dev/null 2>&1; cd "$HOME/$DIR_NAME"
                node -e "const fs = require('fs'); let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {}; cfg.botNumber = '$botnum'; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2));"
                echo -e "${GREEN}Meminta kode pairing ke WhatsApp...${NC}"
                node index.js
            fi
            ;;
        2) 
            cd "$HOME/$DIR_NAME"
            pm2 delete $BOT_NAME 2>/dev/null
            pm2 start index.js --name "$BOT_NAME"
            pm2 save
            echo -e "${GREEN}Sistem berjalan!${NC}"
            read -p "Tekan Enter..." 
            ;;
        3) 
            cd "$HOME/$DIR_NAME"
            rm -rf node_modules package-lock.json
            npm install
            pm2 restart $BOT_NAME > /dev/null 2>&1
            echo -e "${GREEN}✅ Pembaruan selesai!${NC}"
            read -p "Tekan Enter..." 
            ;;
        4) 
            pm2 logs $BOT_NAME 
            ;;
        5) 
            pm2 stop $BOT_NAME 2>/dev/null
            rm -rf "$HOME/$DIR_NAME/sesi_bot"
            echo -e "${GREEN}Sesi WA dihapus.${NC}"
            read -p "Tekan Enter..." 
            ;;
        6)
            clear
            echo "1. Web Info | 2. Tele Channel | 3. WA Channel | 4. SEMUA"
            read -p "Target Broadcast [1-4]: " bc_target
            read -p "Judul Pesan (Hanya App): " b_judul
            read -p "Isi Pengumuman: " b_isi
            
            if [ ! -z "$b_isi" ]; then
                cd "$HOME/$DIR_NAME"
                node -e "
                const http = require('http'); 
                const reqCall = (path, data) => { 
                    const req = http.request({
                        hostname:'localhost', 
                        port:3000, 
                        path, 
                        method:'POST', 
                        headers:{'Content-Type':'application/json'}
                    }, r => { 
                        r.on('data', c => console.log(JSON.parse(c.toString()).message || 'Berhasil')); 
                    }); 
                    req.write(data); 
                    req.end(); 
                };
                if('$bc_target'==='1'||'$bc_target'==='4') reqCall('/api/admin/broadcast', JSON.stringify({judul: '$b_judul', message: '$b_isi'}));
                if('$bc_target'==='2'||'$bc_target'==='4') reqCall('/api/admin/broadcast-sosmed', JSON.stringify({target: 'tele', message: '$b_isi'}));
                if('$bc_target'==='3'||'$bc_target'==='4') reqCall('/api/admin/broadcast-sosmed', JSON.stringify({target: 'wa', message: '$b_isi'}));
                "
            fi
            read -p "Tekan Enter..."
            ;;
        7)
            clear
            echo -e "${YELLOW}         💰 MANAJEMEN SALDO MEMBER             ${NC}"
            echo "1. Cek Semua Saldo Member"
            echo "2. Tambah Saldo Member"
            echo "3. Kurangi Saldo Member"
            echo "0. Kembali"
            read -p "Pilih [0-3]: " s_menu
            if [ "$s_menu" == "1" ]; then
                cd "$HOME/$DIR_NAME"
                node -e "
                const fs = require('fs'); 
                const db = fs.existsSync('./database.json') ? JSON.parse(fs.readFileSync('./database.json')) : {}; 
                const users = fs.existsSync('./web_users.json') ? JSON.parse(fs.readFileSync('./web_users.json')) : {}; 
                console.log('\n--- DAFTAR SALDO MEMBER ---'); 
                for (let p in users) { 
                    if (users[p].isVerified) {
                        let em = users[p].email || 'Tidak ada email';
                        console.log('- ' + users[p].name + ' | ' + em + ' | (' + p + ') | Rp ' + (db[p] ? db[p].saldo.toLocaleString('id-ID') : 0)); 
                    }
                } 
                console.log('---------------------------\n');
                "
                read -p "Tekan Enter..."
            elif [ "$s_menu" == "2" ]; then
                read -p "No WA Member (Awalan 62...): " no_mem
                read -p "Jumlah Tambah Saldo: " jm_mem
                cd "$HOME/$DIR_NAME"; node -e "const http = require('http'); const data = JSON.stringify({ identifier: '$no_mem', amount: parseInt('$jm_mem'), action: 'add' }); const req = http.request({ hostname: 'localhost', port: 3000, path: '/api/admin/balance', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } }, res => { res.on('data', c => console.log(JSON.parse(c.toString()).message || 'Berhasil')); }); req.write(data); req.end();"
                read -p "Tekan Enter..."
            elif [ "$s_menu" == "3" ]; then
                read -p "No WA Member (Awalan 62...): " no_mem
                read -p "Jumlah Kurangi Saldo: " jm_mem
                cd "$HOME/$DIR_NAME"; node -e "const http = require('http'); const data = JSON.stringify({ identifier: '$no_mem', amount: parseInt('$jm_mem'), action: 'reduce' }); const req = http.request({ hostname: 'localhost', port: 3000, path: '/api/admin/balance', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } }, res => { res.on('data', c => console.log(JSON.parse(c.toString()).message || 'Berhasil')); }); req.write(data); req.end();"
                read -p "Tekan Enter..."
            fi
            ;;
        8)
            clear
            echo -e "${YELLOW}      🖼️ SINKRONISASI GAMBAR BANNER LOKAL     ${NC}"
            echo "1. Sinkronisasi"
            echo "2. Hapus Semua Banner"
            read -p "Pilih [1-2]: " b_menu
            if [ "$b_menu" == "1" ]; then
                cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); const path = './public/banners'; if (!fs.existsSync(path)) fs.mkdirSync(path, {recursive:true}); let rawFiles = fs.readdirSync(path).filter(f => f.match(/\.(jpg|jpeg|png|gif)$/i)); rawFiles.forEach(f => { if (f.includes(' ')) fs.renameSync(path + '/' + f, path + '/' + f.replace(/ /g, '_')); }); let finalFiles = fs.readdirSync(path).filter(f => f.match(/\.(jpg|jpeg|png|gif)$/i)); let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {}; cfg.banners = finalFiles; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ Berhasil menyinkronkan ' + finalFiles.length + ' banner!');"
                pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Tekan Enter..."
            elif [ "$b_menu" == "2" ]; then
                cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {}; cfg.banners = []; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ Semua banner telah disembunyikan.');"
                pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Tekan Enter..."
            fi
            ;;
        9)
            clear
            echo -e "${YELLOW}  📈 SETING KEUNTUNGAN 14 TIER      ${NC}"
            read -p "1. Laba untuk modal Rp 0 - 100         : " m1
            read -p "2. Laba untuk modal Rp 100 - 500       : " m2
            read -p "3. Laba untuk modal Rp 500 - 1.000     : " m3
            read -p "4. Laba untuk modal Rp 1.000 - 3.000   : " m4
            read -p "5. Laba untuk modal Rp 3.000 - 5.000   : " m5
            read -p "6. Laba untuk modal Rp 5.000 - 10.000  : " m6
            read -p "7. Laba untuk modal Rp 10.000 - 15.000 : " m7
            read -p "8. Laba untuk modal Rp 15.000 - 25.000 : " m8
            read -p "9. Laba untuk modal Rp 25.000 - 50.000 : " m9
            read -p "10. Laba untuk modal Rp 50.000 - 70.000: " m10
            read -p "11. Laba untuk modal Rp 70k - 100.000  : " m11
            read -p "12. Laba untuk modal Rp 100k - 120.000 : " m12
            read -p "13. Laba untuk modal Rp 120k - 150.000 : " m13
            read -p "14. Laba untuk modal Rp > 150.000      : " m14
            cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); let file = './config.json'; let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {}; cfg.markupRules = { m1: parseInt('$m1')||0, m2: parseInt('$m2')||0, m3: parseInt('$m3')||0, m4: parseInt('$m4')||0, m5: parseInt('$m5')||0, m6: parseInt('$m6')||0, m7: parseInt('$m7')||0, m8: parseInt('$m8')||0, m9: parseInt('$m9')||0, m10: parseInt('$m10')||0, m11: parseInt('$m11')||0, m12: parseInt('$m12')||0, m13: parseInt('$m13')||0, m14: parseInt('$m14')||0 }; fs.writeFileSync(file, JSON.stringify(cfg, null, 2)); console.log('\n✅ Tingkatan Keuntungan Berhasil Disimpan!');"
            pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Tekan Enter..."
            ;;
        10)
            clear
            echo "1. Tambah Produk LOKAL | 2. Hapus Produk LOKAL"
            read -p "Pilih: " pr_menu
            if [ "$pr_menu" == "1" ]; then
                read -p "Tipe (pulsa/data/game/dll): " tp
                read -p "Brand (XL/DANA/FREE FIRE): " p_brand
                read -p "Kategori Sub: " p_cat
                read -p "Nama Produk: " p_name
                read -p "Harga Modal: " p_price
                read -p "SKU Digiflazz: " p_sku
                cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); let f = './local_products.json'; let data = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f)) : []; data.push({ id: 'LOC' + Date.now(), type: '$tp', brand: '$p_brand', category: '$p_cat', name: '$p_name', price: parseInt('$p_price') || 0, sku: '$p_sku', isDigi: true }); fs.writeFileSync(f, JSON.stringify(data, null, 2)); console.log('✅ Produk Ditambahkan!');"
                read -p "Tekan Enter..."
            elif [ "$pr_menu" == "2" ]; then
                cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); let data = fs.existsSync('./local_products.json') ? JSON.parse(fs.readFileSync('./local_products.json')) : []; data.forEach((p, i) => console.log('[' + i + '] ' + p.name));"
                read -p "Masukkan Nomor Produk yg mau dihapus: " del_id
                if [ ! -z "$del_id" ]; then
                    node -e "const fs = require('fs'); let f = './local_products.json'; let data = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f)) : []; data.splice(parseInt('$del_id'), 1); fs.writeFileSync(f, JSON.stringify(data, null, 2)); console.log('✅ Dihapus!');"
                fi
                read -p "Tekan Enter..."
            fi
            ;;
        11)
            clear
            echo "Kosongkan jika tidak ingin mengubah data saat ini."
            read -p "Link Telegram Channel : " new_tele
            read -p "Link WhatsApp Saluran : " new_wa
            cd "$HOME/$DIR_NAME"
            node -e "const fs = require('fs'); let file = './config.json'; let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {}; if ('$new_tele'!=='') cfg.linkTele = '$new_tele'; if ('$new_wa'!=='') cfg.linkWa = '$new_wa'; fs.writeFileSync(file, JSON.stringify(cfg, null, 2)); console.log('\n✅ Data Sosial Media diperbarui!');"
            read -p "Tekan Enter..."
            ;;
        12)
            clear
            read -p "Masukkan Nama Domain LENGKAP (cth: digital.myfiky.store): " domain_name
            if [ ! -z "$domain_name" ]; then
                cat << EOFNGINX > /etc/nginx/sites-available/$domain_name
server { listen 80; server_name $domain_name; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host \$host; proxy_cache_bypass \$http_upgrade; proxy_set_header X-Real-IP \$remote_addr; proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; proxy_set_header X-Forwarded-Proto \$scheme; } }
EOFNGINX
                ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
                rm -f /etc/nginx/sites-enabled/default
                nginx -t && systemctl restart nginx
                echo -e "${GREEN}✅ Domain $domain_name berhasil dikonfigurasi!${NC}"
            fi
            read -p "Tekan Enter..."
            ;;
        13)
            clear
            read -p "Username Digiflazz: " digi_user
            read -p "API Key Digiflazz: " digi_key
            cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {}; cfg.digiUser = '$digi_user'; cfg.digiKey = '$digi_key'; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ API Digiflazz Disimpan!');"
            pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Tekan Enter..." 
            ;;
        14)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW} 💸 SETUP API GOPAY & QRIS OTOMATIS (BHM BIZ)  ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            read -p "Masukkan API Token BHM Biz Anda: " bhm_token
            read -p "Masukkan Merchant ID (Angka, cth: 123): " bhm_mid
            read -p "Masukkan Nomor HP GoPay (08...): " bhm_phone

            if [ ! -z "$bhm_token" ] && [ ! -z "$bhm_phone" ] && [ ! -z "$bhm_mid" ]; then
                echo -e "\n${CYAN}>> Mengirim Request OTP ke nomor $bhm_phone...${NC}"
                req_otp=$(curl -sS -X POST http://gopay.bhm.biz.id/v1/gopay/merchants/connect/request-otp -H 'Content-Type: application/json' -d "{\"phone\":\"$bhm_phone\"}")
                echo -e "${YELLOW}Respon Server: $req_otp${NC}"
                
                read -p "Masukkan 4 Digit OTP dari WA/SMS Gojek: " gopay_otp
                if [ ! -z "$gopay_otp" ]; then
                    echo -e "\n${CYAN}>> Memverifikasi OTP...${NC}"
                    ver_otp=$(curl -sS -X POST http://gopay.bhm.biz.id/v1/gopay/merchants/$bhm_mid/connect/verify-otp -H "Authorization: Bearer $bhm_token" -H 'Content-Type: application/json' -d "{\"otp\":\"$gopay_otp\"}")
                    echo -e "${YELLOW}Respon Server: $ver_otp${NC}"
                fi
            fi

            echo -e "\n${CYAN}Siapkan TEKS STRING dari QRIS Statis Anda.${NC}"
            read -p "Paste TEKS STRING QRIS Anda di sini: " qris_string
            
            cd "$HOME/$DIR_NAME"
            node -e "const fs = require('fs'); let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {}; if ('$bhm_token'!=='') cfg.bhmToken = '$bhm_token'; if ('$bhm_mid'!=='') cfg.bhmMerchantId = '$bhm_mid'; if ('$qris_string'!=='') cfg.qrisStringCode = '$qris_string'; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('\n✅ Data API BHM & QRIS Tersimpan!');"
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
        15)
            clear
            cd "$HOME/$DIR_NAME"; node -e "const fs = require('fs'); if (fs.existsSync('./digi_cache.json')) { fs.unlinkSync('./digi_cache.json'); console.log('✅ Cache Katalog dihapus!'); } else { console.log('✅ Cache bersih.'); }"
            pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Tekan Enter..." 
            ;;
        16)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}      ⚙️ SETUP TELEGRAM BOT & TOPIK GRUP        ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            
            echo -e "\n${GREEN}>> 1. PENGATURAN BOT ADMIN (Bisa dikosongkan jika tidak mau ubah)${NC}"
            read -p "Token Bot Admin: " t_admin
            read -p "Chat ID Admin (Bisa ID Pribadi/Grup): " c_admin
            
            if [ ! -z "$t_admin" ] && [ ! -z "$c_admin" ]; then
                cd "$HOME/$DIR_NAME"
                node -e "const fs=require('fs'); let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{}; cfg.teleTokenAdmin='$t_admin'; cfg.teleChatAdmin='$c_admin'; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2));"
                echo -e "${GREEN}✅ Bot Admin Tersimpan!${NC}"
            fi

            echo -e "\n${GREEN}>> 2. PENGATURAN BOT PUBLIK (Bisa dikosongkan)${NC}"
            read -p "Token Bot Publik: " t_pub
            read -p "Chat ID Grup Telegram Publik (Contoh: -100123...): " c_pub
            read -p "ID Topik/Thread Top Up di Grup: " t_topup
            read -p "ID Topik/Thread Transaksi di Grup: " t_trx
            read -p "ID Saluran WhatsApp: " w_pub
            
            if [ ! -z "$t_pub" ] || [ ! -z "$w_pub" ]; then
                cd "$HOME/$DIR_NAME"
                node -e "
                const fs=require('fs'); 
                let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{}; 
                if('$t_pub'!=='') cfg.teleTokenPublik='$t_pub'; 
                if('$c_pub'!=='') cfg.teleChatPublik='$c_pub'; 
                if('$t_topup'!=='') cfg.teleTopicTopup='$t_topup'; 
                if('$t_trx'!=='') cfg.teleTopicTrx='$t_trx'; 
                if('$w_pub'!=='') cfg.waChannelId='$w_pub'; 
                fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2));
                "
                echo -e "${GREEN}✅ Pengaturan Bot Publik & Topik Tersimpan!${NC}"
            fi

            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
        17)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}           💾 BACKUP & RESTORE DATA FULL         ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "1. Lakukan Backup Manual (Kirim ke Telegram Admin)"
            echo "2. Restore Data dari URL File ZIP"
            read -p "Pilih [1-2]: " br_menu
            
            if [ "$br_menu" == "1" ]; then
                echo "Memproses Backup Manual FULL (DB + Gambar + Config)..."
                cd "$HOME/$DIR_NAME"
                node -e "
                const axios=require('axios'); const fs=require('fs'); const FormData=require('form-data'); const {exec}=require('child_process');
                let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};
                if(!cfg.teleTokenAdmin || !cfg.teleChatAdmin) { console.log('❌ Token/Chat ID Bot Admin belum disetting (Buka Menu 16)'); process.exit(); }
                let zipName='Backup_FikyStore_'+Date.now()+'.zip';
                exec('zip -r '+zipName+' database.json web_users.json config.json local_products.json info.json public/banners public/info_images', (err) => {
                    const form=new FormData(); form.append('chat_id', cfg.teleChatAdmin); form.append('document', fs.createReadStream(zipName)); form.append('caption', '📦 *MANUAL BACKUP FULL SYSTEM*\\n\\nTanggal: '+new Date().toLocaleString('id-ID',{timeZone:'Asia/Jakarta'})); form.append('parse_mode', 'Markdown');
                    axios.post('https://api.telegram.org/bot'+cfg.teleTokenAdmin+'/sendDocument', form, {headers:form.getHeaders()}).then(()=>{ console.log('✅ File Backup Terkirim ke Telegram Admin Anda!'); fs.unlinkSync(zipName); }).catch(e=>console.log('❌ Gagal Mengirim. Pastikan Token/Chat ID Benar!'));
                });
                "
                read -p "Tunggu sebentar lalu tekan Enter..." 
            elif [ "$br_menu" == "2" ]; then
                read -p "Masukkan Direct Link (URL) File ZIP Backup: " link_zip
                if [ ! -z "$link_zip" ]; then
                    cd "$HOME/$DIR_NAME" 
                    wget -qO restore.zip "$link_zip"
                    if [ -f "restore.zip" ]; then
                        unzip -o restore.zip && rm -f restore.zip
                        pm2 restart all > /dev/null 2>&1
                        echo -e "${GREEN}✅ Restore Data Selesai! Sistem sudah memuat data lama Anda.${NC}"
                    fi
                fi
                read -p "Tekan Enter..."
            fi
            ;;
        18)
            clear
            read -p "Berapa Jam Sekali Sistem Melakukan Auto-Backup FULL?: " tele_jam
            cd "$HOME/$DIR_NAME"
            node -e "const fs=require('fs'); let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{}; cfg.autoBackupHours=parseFloat('$tele_jam'); fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ Auto Backup diset: ' + '$tele_jam' + ' Jam!');"
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
        0) exit 0 ;;
        *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
    esac
done
EOF

chmod +x /usr/bin/menu

# ==========================================
# MENAMBAHKAN AUTO MENU KE BASHRC 
# (Agar menu langsung muncul saat login VPS)
# ==========================================
if ! grep -q "/usr/bin/menu" ~/.bashrc; then
    echo "clear" >> ~/.bashrc
    echo "/usr/bin/menu" >> ~/.bashrc
fi

echo "[PART 6 SELESAI DITULIS!]"
echo "[10/10] Menyelesaikan instalasi dan menyalakan Mesin Autopilot V166..."

cd "$HOME/$DIR_NAME"

echo "Menginstal npm dan menjalankan node module..."
npm install --silent > /dev/null 2>&1

# MENGHENTIKAN PROSES LAMA JIKA ADA
pm2 stop $BOT_NAME > /dev/null 2>&1
pm2 delete $BOT_NAME > /dev/null 2>&1

# MENJALANKAN SISTEM BARU DI BACKGROUND
pm2 start index.js --name "$BOT_NAME"
pm2 save > /dev/null 2>&1
pm2 startup > /dev/null 2>&1

# MEMBERSIHKAN SAMPAH CACHE BIAR VPS RINGAN
npm cache clean --force > /dev/null 2>&1

clear
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[1;33m       🚀 INSTALASI DIGITAL FIKY STORE V166 SELESAI! 🚀      \033[0m"
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[0;36mFITUR BARU DI V166 (THE PERFECT MASTERPIECE):\033[0m"
echo -e "  ✅ \033[1;33mPISAH NOTIF & TOPIK TELEGRAM\033[0m Notif Top Up & Trx dipisah di grup Tele!"
echo -e "  ✅ \033[1;33mFORMAT NOTIF SAMA PERSIS\033[0m Admin & Publik sama (Admin tanpa sensor)."
echo -e "  ✅ \033[1;33mNOTIF WA HANYA SUKSES\033[0m Bot saluran WA tidak akan mengirim notif 'Proses'!"
echo -e "  ✅ \033[1;33mDESAIN PROFIL ELEGAN\033[0m Sesuai ukuran awal font dan ikon original."
echo -e "  ✅ \033[1;33mAUTO MENU VPS LOGIN\033[0m Langsung muncul panel saat masuk VPS!"
echo -e "  ✅ \033[1;33mFULL UNCOMPRESSED\033[0m Kode rapi jali, gampang dibaca!"
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[1;37mMEMBUKA PANEL MENU OTOMATIS DALAM 2 DETIK...\033[0m"
sleep 2

# MEMANGGIL MENU OTOMATIS SETELAH INSTALL SELESAI
/usr/bin/menu

// selesai
