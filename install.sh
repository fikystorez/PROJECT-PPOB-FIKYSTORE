#!/bin/bash
# ==========================================================
# DIGITAL FIKY STORE - V166 (PERFECT OXFORD + FULL UNCOMPRESSED)
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

echo "[1/8] Memperbarui sistem dan menginstal Node.js..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip nginx ufw -y > /dev/null 2>&1

if ! command -v node > /dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
  apt install -y nodejs > /dev/null 2>&1
fi
npm install -g pm2 > /dev/null 2>&1

echo "[2/8] Membuat direktori aplikasi dan web..."
mkdir -p "$HOME/$DIR_NAME/public/banners"
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

echo "[3/8] Membangun Antarmuka CSS (FULL UNCOMPRESSED)..."

cat << 'EOF' > public/style.css
body { 
    background-color: #fde047; 
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
    color: #facc15; 
}

@keyframes marquee-anim {
    0% { transform: translate(0, 0); }
    100% { transform: translate(-100%, 0); }
}

.centered-modal-box { 
    background-color: #111c2e; 
    padding: 2.5rem 1.5rem 2rem 1.5rem; 
    border-radius: 1.2rem; 
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3); 
    width: 90%; 
    max-width: 360px; 
    text-align: center; 
    position: relative; 
    z-index: 10; 
    margin: auto; 
    margin-top: 10vh; 
}

.brand-logo-text { 
    font-size: 1.8rem; 
    font-weight: 900; 
    background: linear-gradient(135deg, #fde047 0%, #facc15 100%); 
    -webkit-background-clip: text; 
    -webkit-text-fill-color: transparent; 
    margin-bottom: 1rem; 
    letter-spacing: 1px; 
    text-transform: uppercase; 
}

.compact-input-wrapper { 
    position: relative; 
    margin-bottom: 0.85rem; 
    width: 100%; 
}

.compact-input-box { 
    width: 100%; 
    padding: 0.6rem 0.75rem; 
    border: 1px solid #334155; 
    border-radius: 0.5rem; 
    font-size: 0.875rem; 
    outline: none; 
    background-color: #ffffff; 
    color: #0f172a; 
}

.compact-input-box:focus { 
    border-color: #fde047; 
    box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); 
}

.password-toggle { 
    position: absolute; 
    right: 12px; 
    top: 50%; 
    transform: translateY(-50%); 
    cursor: pointer; 
    color: #94a3b8; 
}

.compact-text-small { 
    font-size: 0.8rem; 
    color: #cbd5e1; 
}

.compact-link-small { 
    font-size: 0.8rem; 
    color: #fde047; 
    text-decoration: none; 
    font-weight: bold; 
}

.btn-yellow { 
    width: 100%; 
    padding: 0.625rem 1rem; 
    background-color: #fde047; 
    color: #002147; 
    font-weight: bold; 
    border-radius: 0.5rem; 
    cursor: pointer; 
    border: none; 
    margin-top: 0.5rem; 
    transition: all 0.2s; 
}

.btn-yellow:hover { 
    background-color: #facc15; 
}

.hide-scrollbar::-webkit-scrollbar { 
    display: none; 
}

.hide-scrollbar { 
    -ms-overflow-style: none; 
    scrollbar-width: none; 
}

.swal2-popup { 
    background-color: #111c2e !important; 
    border-radius: 1.5rem !important; 
    color: #ffffff !important; 
    width: 320px !important; 
    padding: 1.5rem 1.25rem 1.25rem !important; 
}

.swal2-title { 
    color: #fde047 !important; 
    font-size: 1.25rem !important; 
    font-weight: 800 !important; 
}

.swal2-html-container { 
    color: #cbd5e1 !important; 
    font-size: 0.85rem !important; 
}

.swal2-confirm { 
    background: linear-gradient(135deg, #facc15 0%, #fde047 100%) !important; 
    color: #001229 !important; 
    border-radius: 0.5rem !important; 
    font-weight: 800 !important; 
}

.swal2-cancel { 
    background: linear-gradient(135deg, #ef4444 0%, #f87171 100%) !important; 
    color: #ffffff !important; 
    border-radius: 0.5rem !important; 
    font-weight: 800 !important; 
}

.pb-safe { 
    padding-bottom: calc(1rem + env(safe-area-inset-bottom)); 
}
EOF

echo "[4/8] Membangun Halaman Autentikasi (FULL UNCOMPRESSED)..."

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
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
    <div class="centered-modal-box !pt-8">
        <h1 class="brand-logo-text !mb-2">DIGITAL FIKY STORE</h1>
        
        <div class="overflow-hidden w-full mb-6 border-y border-[#1e293b] py-1.5 bg-[#0b1320] shadow-inner rounded-md">
            <div class="marquee-wrapper h-4">
                <span class="marquee-text text-[#facc15] text-[10px] tracking-wider">🚀 WELCOME TO DIGITAL FIKY STORE - PUSAT PPOB TERMURAH, CEPAT, AMAN, DAN TERPERCAYA 🚀</span>
            </div>
        </div>

        <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
        <p class="compact-text-small mb-6" id="loginDesc">Silahkan masukkan email/no HP dan password kamu!</p>
        
        <form id="loginForm">
            <div class="compact-input-wrapper">
                <input type="text" id="identifier" name="username" autocomplete="username" class="compact-input-box" required placeholder="Email / No. HP">
            </div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" name="password" autocomplete="current-password" class="compact-input-box" required placeholder="Password">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('password', this)"></i>
            </div>
            <div class="text-right mb-5 mt-1">
                <a href="/forgot.html" class="compact-link-small">Lupa password?</a>
            </div>
            <button type="submit" class="btn-yellow">Login Sekarang</button>
        </form>

        <div class="mt-6 text-center compact-text-small" id="registerLink">
            Belum punya akun? <a href="/register.html" class="compact-link-small">Daftar disini</a>
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
                el.classList.remove('fa-eye'); 
                el.classList.add('fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.remove('fa-eye-slash'); 
                el.classList.add('fa-eye'); 
            }
        }
        
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const identifier = document.getElementById('identifier').value; 
            const password = document.getElementById('password').value;
            
            localStorage.setItem('savedPhone', identifier);
            
            Swal.fire({
                title: 'Memeriksa Data...', 
                allowOutsideClick: false, 
                didOpen: () => { 
                    Swal.showLoading(); 
                }
            });
            
            try {
                const res = await fetch('/api/auth/login', { 
                    method: 'POST', 
                    headers: { 
                        'Content-Type': 'application/json' 
                    }, 
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
                        background: '#111c2e', 
                        color: '#fff' 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Kesalahan sistem.', 
                    background: '#111c2e', 
                    color: '#fff' 
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
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
    <div class="centered-modal-box" id="box-register">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2>
        <p class="compact-text-small mb-4">Silahkan lengkapi data untuk mendaftar!</p>
        
        <form id="registerForm">
            <div class="compact-input-wrapper">
                <input type="text" id="name" name="name" class="compact-input-box" required placeholder="Nama Lengkap">
            </div>
            <div class="compact-input-wrapper">
                <input type="number" id="phone" name="username" class="compact-input-box" required placeholder="Nomor WA (08123...)">
            </div>
            <div class="compact-input-wrapper">
                <input type="email" id="email" name="email" class="compact-input-box" required placeholder="Email">
            </div>
            <div class="compact-input-wrapper">
                <input type="password" id="password" name="password" class="compact-input-box" required placeholder="Password">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('password', this)"></i>
            </div>
            <button type="submit" class="btn-yellow mt-1">Daftar Sekarang</button>
        </form>

        <div class="mt-4 text-center compact-text-small">
            Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a>
        </div>
    </div>

    <div class="centered-modal-box hidden" id="box-otp">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2>
        <p class="compact-text-small mb-5 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
        
        <form id="otpForm">
            <div class="compact-input-wrapper">
                <input type="number" id="otpCode" class="compact-input-box text-center text-2xl tracking-[0.5em] font-bold" required placeholder="XXXX">
            </div>
            <button type="submit" class="btn-yellow mt-4">Verifikasi OTP</button>
        </form>
    </div>

    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.remove('fa-eye'); 
                el.classList.add('fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.remove('fa-eye-slash'); 
                el.classList.add('fa-eye'); 
            }
        }
        
        let registeredPhone = '';

        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const name = document.getElementById('name').value; 
            const phone = document.getElementById('phone').value; 
            const email = document.getElementById('email').value; 
            const password = document.getElementById('password').value;
            
            Swal.fire({
                title: 'Memproses...', 
                allowOutsideClick: false, 
                didOpen: () => { 
                    Swal.showLoading(); 
                }
            });
            
            try {
                const res = await fetch('/api/auth/register', { 
                    method: 'POST', 
                    headers: { 
                        'Content-Type': 'application/json' 
                    }, 
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
                        background: '#111c2e', 
                        color: '#fff' 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gagal memproses.', 
                    background: '#111c2e', 
                    color: '#fff' 
                }); 
            }
        });

        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            
            const otp = document.getElementById('otpCode').value;
            
            Swal.fire({
                title: 'Verifikasi...', 
                allowOutsideClick: false, 
                didOpen: () => { 
                    Swal.showLoading(); 
                }
            });
            
            try {
                const res = await fetch('/api/auth/verify', { 
                    method: 'POST', 
                    headers: { 
                        'Content-Type': 'application/json' 
                    }, 
                    body: JSON.stringify({ phone: registeredPhone, otp }) 
                });
                
                const data = await res.json();
                
                if (res.ok) { 
                    Swal.fire({ 
                        icon: 'success', 
                        title: 'Berhasil!', 
                        text: 'Akun aktif.', 
                        background: '#111c2e', 
                        color: '#fff' 
                    }).then(() => { 
                        window.location.href = '/?phone=' + registeredPhone; 
                    }); 
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'OTP Salah', 
                        text: data.error, 
                        background: '#111c2e', 
                        color: '#fff' 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    text: 'Gagal verifikasi.', 
                    background: '#111c2e', 
                    color: '#fff' 
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
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
    <div class="centered-modal-box">
        <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
        <h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2>
        
        <form id="requestOtpForm">
            <p class="compact-text-small mb-5 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div class="compact-input-wrapper">
                <input type="number" id="phone" class="compact-input-box text-center" required placeholder="08123...">
            </div>
            <button type="submit" class="btn-yellow mt-2">Kirim OTP Reset</button>
        </form>

        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-5 border-gray-600">
            <div class="compact-input-wrapper">
                <label class="compact-label text-center text-white">Kode OTP</label>
                <input type="number" id="otp" class="compact-input-box text-center text-xl tracking-[0.5em] font-bold" required placeholder="XXXX">
            </div>
            <div class="compact-input-wrapper">
                <label class="compact-label text-center text-white mt-2">Password Baru</label>
                <input type="password" id="newPassword" class="compact-input-box" required placeholder="Ketik disini">
                <i class="fas fa-eye password-toggle" onclick="togglePassword('newPassword', this)" style="top:70%;"></i>
            </div>
            <button type="submit" class="btn-yellow mt-3">Simpan Password</button>
        </form>

        <div class="mt-6 text-center compact-text-small">
            <a href="/" class="compact-link-small">Kembali ke Login</a>
        </div>
    </div>

    <script>
        function togglePassword(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.remove('fa-eye'); 
                el.classList.add('fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.remove('fa-eye-slash'); 
                el.classList.add('fa-eye'); 
            }
        }
        
        let resetPhone = '';
        
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            const phone = document.getElementById('phone').value;
            
            Swal.fire({
                title: 'Memproses...', 
                didOpen: () => { 
                    Swal.showLoading(); 
                }
            });
            
            try {
                const res = await fetch('/api/auth/forgot', { 
                    method: 'POST', 
                    headers: { 
                        'Content-Type': 'application/json' 
                    }, 
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
                        background: '#111c2e', 
                        color: '#fff' 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    background: '#111c2e', 
                    color: '#fff' 
                }); 
            }
        });

        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault(); 
            const otp = document.getElementById('otp').value; 
            const newPassword = document.getElementById('newPassword').value;
            
            Swal.fire({
                title: 'Memproses...', 
                didOpen: () => { 
                    Swal.showLoading(); 
                }
            });
            
            try {
                const res = await fetch('/api/auth/reset', { 
                    method: 'POST', 
                    headers: { 
                        'Content-Type': 'application/json' 
                    }, 
                    body: JSON.stringify({ phone: resetPhone, otp, newPassword }) 
                });
                
                if (res.ok) { 
                    Swal.fire({ 
                        icon: 'success', 
                        title: 'Berhasil!', 
                        text: 'Password diubah.', 
                        background: '#111c2e', 
                        color: '#fff' 
                    }).then(() => { 
                        window.location.href = '/'; 
                    }); 
                } else { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal', 
                        text: 'OTP Salah.', 
                        background: '#111c2e', 
                        color: '#fff' 
                    }); 
                }
            } catch (err) { 
                Swal.fire({ 
                    icon: 'error', 
                    title: 'Oops...', 
                    background: '#111c2e', 
                    color: '#fff' 
                }); 
            }
        });
    </script>
</body>
</html>
EOF

echo "[PART 1 SELESAI BOSKUUU!]"
echo "[5/8] Membangun Halaman Dashboard & Operator (FULL UNCOMPRESSED)..."

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
        tailwind.config = { 
            darkMode: 'class' 
        }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div id="maintenanceBanner" class="hidden bg-red-600 text-white text-center py-2 px-4 text-xs font-bold shadow-md z-50 sticky top-0">
            <i class="fas fa-tools mr-1 animate-pulse"></i> SISTEM SEDANG MAINTENANCE (23:00 - 00:30 WIB). TRANSAKSI DITUTUP.
        </div>

        <div class="flex justify-between items-center p-4 bg-[#0b1320] sticky z-40 top-0" id="headerMain">
            <i class="fas fa-bars text-xl cursor-pointer text-gray-300 hover:text-[#facc15] shrink-0" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></i>
            
            <div class="marquee-wrapper border-l border-r border-[#1e293b] mx-3 px-2 h-6">
                <span class="marquee-text text-[#facc15]">WELCOME TO THE DIGITAL FIKY STORE - PUSAT PPOB TERMURAH & TERPERCAYA - TRANSAKSI CEPAT AMAN</span>
            </div>

            <div class="text-[10px] font-extrabold text-[#facc15] bg-[#111c2e] border border-[#facc15]/30 px-3 py-1.5 rounded-full shrink-0 shadow-sm" id="headTrx">
                0 Trx
            </div>
        </div>

        <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
            <div class="w-full bg-black/60 backdrop-blur-sm" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></div>
            <div class="absolute top-0 left-0 w-[80%] max-w-[300px] h-full bg-[#0b1320] shadow-2xl flex flex-col border-r border-[#1e293b]">
                <div class="p-8 pb-4 flex flex-col items-center relative border-b border-[#1e293b]">
                    <button class="absolute top-5 right-5 text-gray-400 hover:text-red-500" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                    <div class="w-[4.5rem] h-[4.5rem] bg-[#111c2e] rounded-full flex justify-center items-center text-[#facc15] font-extrabold text-3xl mb-3 shadow-md overflow-hidden border border-[#1e293b]" id="sidebarInitial">U</div>
                    <h3 class="font-bold text-lg text-white" id="sidebarName">User</h3>
                    <p class="text-sm text-gray-400" id="sidebarPhone">08...</p>
                </div>
                <div class="flex-1 overflow-y-auto py-2">
                    <ul class="text-[14px]">
                        <li class="px-6 py-4 border-b border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-[#111c2e]" onclick="location.href='/profile.html'">
                            <i class="far fa-user w-6 text-center text-lg text-[#facc15]"></i>
                            <span class="font-semibold text-gray-100">Profil Akun</span>
                        </li>
                        <li class="px-6 py-4 border-b border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-[#111c2e]" onclick="location.href='/riwayat.html'">
                            <i class="far fa-clock w-6 text-center text-lg text-[#facc15]"></i>
                            <span class="font-semibold text-gray-100">Riwayat Transaksi</span>
                        </li>
                        <li class="px-6 py-4 border-b border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-[#111c2e]" onclick="location.href='/mutasi.html'">
                            <i class="fas fa-exchange-alt w-6 text-center text-lg text-[#facc15]"></i>
                            <span class="font-semibold text-gray-100">Mutasi Saldo</span>
                        </li>
                        <li class="px-6 py-4 border-b border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-[#111c2e]" onclick="location.href='/info.html'">
                            <i class="far fa-bell w-6 text-center text-lg text-[#facc15]"></i>
                            <span class="font-semibold text-gray-100">Pusat Informasi</span>
                        </li>
                        <li class="px-6 py-4 border-b border-[#1e293b] flex items-center gap-4 cursor-pointer hover:bg-[#111c2e]" onclick="bantuanAdmin()">
                            <i class="fas fa-headset w-6 text-center text-lg text-[#facc15]"></i>
                            <span class="font-semibold text-gray-100">Hubungi Admin</span>
                        </li>
                    </ul>
                </div>
                <div class="p-6">
                    <button onclick="logout()" class="w-full py-3 border border-red-500 text-red-500 font-bold rounded-xl hover:bg-red-900/20">
                        Keluar Akun
                    </button>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-4 bg-[#111c2e] rounded-[1.2rem] p-4 text-white relative overflow-hidden shadow-lg border border-[#1e293b]">
            <div class="tech-bg opacity-30"></div> 
            <div class="relative z-10 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 rounded-xl bg-[#0b1320] flex items-center justify-center text-[#facc15] border border-[#facc15]/20">
                        <i class="fas fa-wallet text-xl"></i>
                    </div>
                    <div class="flex flex-col">
                        <div class="flex items-center gap-2 mb-0.5">
                            <span class="text-xs text-gray-300 font-medium">
                                Saldo Aktif 
                                <i class="fas fa-eye cursor-pointer hover:text-[#facc15]" onclick="toggleSaldo()" id="eyeSaldo"></i>
                            </span>
                        </div>
                        <h2 class="text-[19px] font-extrabold mt-0.5" id="displaySaldo">Rp •••••••</h2>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <button class="w-10 h-10 rounded-full bg-[#0b1320] flex items-center justify-center text-[#facc15] border border-[#1e293b] hover:bg-[#1a2639] transition-colors z-10" onclick="bantuanAdmin()">
                        <i class="fas fa-headset text-lg"></i>
                    </button>
                    <button class="bg-[#facc15] text-[#0b1320] px-5 py-2.5 rounded-full text-[13px] font-extrabold shadow-md hover:opacity-90 z-10 relative" onclick="openTopUp()">
                        Topup
                    </button>
                </div>
            </div>
        </div>

        <div id="bannerContainer" class="mx-4 mt-6 relative rounded-[1.2rem] h-[170px] overflow-hidden border border-[#1e293b] hidden shadow-md">
            <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
            <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
        </div>

        <div class="mx-4 mt-4 bg-[#111c2e] border border-[#1e293b] rounded-[1rem] p-3.5 shadow-sm flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="w-9 h-9 rounded-full bg-[#0b1320] flex items-center justify-center text-[#facc15] shadow-sm border border-[#1e293b]">
                    <i class="far fa-calendar-alt text-[15px]"></i>
                </div>
                <div class="flex flex-col">
                    <span class="text-[9px] text-gray-400 font-bold uppercase mb-0.5">Tanggal</span>
                    <span class="text-xs font-extrabold text-gray-200" id="realtimeDate">YYYY/MM/DD</span>
                </div>
            </div>
            <div class="h-8 w-px bg-[#1e293b] mx-2"></div>
            <div class="flex items-center gap-3">
                <div class="flex flex-col text-right">
                    <span class="text-[9px] text-gray-400 font-bold uppercase mb-0.5">Waktu</span>
                    <span class="text-xs font-extrabold text-gray-200 tracking-widest" id="realtimeClock">00:00:00</span>
                </div>
                <div class="w-9 h-9 rounded-full bg-[#0b1320] flex items-center justify-center text-[#facc15] shadow-sm border border-[#1e293b]">
                    <i class="far fa-clock text-[15px]"></i>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-4">
            <h3 class="font-extrabold text-white mb-4 text-[16px] ml-1">Layanan Produk</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pulsa'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">PULSA</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=data'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-globe"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">DATA</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/game.html'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-gamepad"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">GAME</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=voucher'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-ticket-alt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">VOUCHER</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=smstelpon'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-phone-square-alt"></i>
                    </div>
                    <span class="text-[10px] font-bold text-gray-300 text-center">SMS & TELP</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pln'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">PLN</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=masaaktif'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <span class="text-[10px] font-bold text-gray-300 text-center">MASA AKTIF</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=perdana'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-sim-card"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300 text-center">PERDANA</span>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8">
            <h3 class="font-extrabold text-white mb-4 text-[16px] ml-1">Produk Digital</h3>
            <div class="grid grid-cols-4 gap-y-6 gap-x-3">
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=ewallet'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <span class="text-[11px] font-bold text-gray-300">E-WALLET</span>
                </div>
                <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=etoll'">
                    <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-[#111c2e] text-[#facc15] flex items-center justify-center text-3xl shadow-sm mb-2 border border-[#1e293b]">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <span class="text-[10px] font-bold text-gray-300 text-center">SALDO<br>E-TOLL</span>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8">
            <h3 class="font-extrabold text-white mb-2 text-[16px] ml-1">Komunitas & Update</h3>
            <p class="text-[11px] text-gray-400 mb-4 ml-1">Gabung ke saluran resmi kami untuk mendapatkan info promo, event, dan update terbaru langsung dari Digital Fiky Store!</p>
            <div class="grid grid-cols-2 gap-3">
                <div class="bg-gradient-to-br from-[#111c2e] to-[#0b1320] border border-[#1e293b] rounded-2xl p-4 flex items-center cursor-pointer hover:shadow-md transition-shadow" onclick="bukaLinkKomunitas('tele')">
                    <i class="fab fa-telegram text-4xl text-blue-500 mr-3 drop-shadow-sm"></i>
                    <div class="flex flex-col">
                        <h4 class="font-extrabold text-[13px] text-white">Telegram</h4>
                        <p class="text-[10px] font-bold text-gray-400 mt-0.5 uppercase tracking-wide">Join Channel</p>
                    </div>
                </div>
                <div class="bg-gradient-to-br from-[#111c2e] to-[#0b1320] border border-[#1e293b] rounded-2xl p-4 flex items-center cursor-pointer hover:shadow-md transition-shadow" onclick="bukaLinkKomunitas('wa')">
                    <i class="fab fa-whatsapp text-4xl text-green-500 mr-3 drop-shadow-sm"></i>
                    <div class="flex flex-col">
                        <h4 class="font-extrabold text-[13px] text-white">WhatsApp</h4>
                        <p class="text-[10px] font-bold text-gray-400 mt-0.5 uppercase tracking-wide">Join Saluran</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="mx-4 mt-8 mb-8 bg-[#111c2e] rounded-2xl border border-[#1e293b] shadow-sm p-4">
            <div class="flex justify-between items-center mb-4">
                <h3 class="font-extrabold text-white text-[14px]">Statistik Penjualan Toko</h3>
                <span class="text-[9px] bg-[#1e293b] text-[#facc15] px-2 py-0.5 rounded-full font-bold uppercase tracking-wide animate-pulse border border-[#facc15]/30">Realtime</span>
            </div>
            <div class="grid grid-cols-4 gap-2">
                <div class="bg-[#0b1320] p-2.5 rounded-xl border border-[#1e293b] text-center">
                    <p class="text-[9px] text-gray-400 font-extrabold mb-1 uppercase">Hari Ini</p>
                    <p class="text-[13px] font-black text-[#facc15]" id="statToday">0</p>
                </div>
                <div class="bg-[#0b1320] p-2.5 rounded-xl border border-[#1e293b] text-center">
                    <p class="text-[9px] text-gray-400 font-extrabold mb-1 uppercase">Minggu Ini</p>
                    <p class="text-[13px] font-black text-green-400" id="statWeek">0</p>
                </div>
                <div class="bg-[#0b1320] p-2.5 rounded-xl border border-[#1e293b] text-center">
                    <p class="text-[9px] text-gray-400 font-extrabold mb-1 uppercase">Bulan Ini</p>
                    <p class="text-[13px] font-black text-[#facc15]" id="statMonth">0</p>
                </div>
                <div class="bg-[#0b1320] p-2.5 rounded-xl border border-[#1e293b] text-center">
                    <p class="text-[9px] text-gray-400 font-extrabold mb-1 uppercase">Semua</p>
                    <p class="text-[13px] font-black text-purple-400" id="statAll">0</p>
                </div>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-2xl z-40">
            <div class="flex flex-col items-center cursor-pointer text-[#facc15]">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/riwayat.html'">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>

        <div id="topupOverlay" class="fixed inset-0 bg-black/60 z-[110] hidden opacity-0 transition-opacity" onclick="closeTopUp()"></div>
        <div id="topupSheet" class="fixed bottom-0 left-0 right-0 bg-[#111c2e] z-[120] rounded-t-[2rem] transform translate-y-full transition-transform max-w-md mx-auto pb-safe border-t border-[#1e293b]">
            <div class="w-12 h-1.5 bg-gray-700 rounded-full mx-auto my-3"></div>
            <div class="px-6 pb-6">
                <div class="flex justify-between mb-5">
                    <h3 class="font-extrabold text-white">Isi Saldo</h3>
                    <i class="fas fa-times text-gray-400 text-xl cursor-pointer hover:text-red-500" onclick="closeTopUp()"></i>
                </div>
                
                <div class="relative w-full mb-4">
                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 font-bold">Rp</span>
                    <input type="number" id="inputNominal" class="w-full bg-[#0b1320] border border-[#1e293b] rounded-xl py-3 pl-10 pr-4 text-white font-bold focus:outline-none focus:border-[#facc15]" placeholder="Ketik nominal...">
                </div>

                <div class="grid grid-cols-5 gap-2 mb-6">
                    <button onclick="document.getElementById('inputNominal').value=1000" class="w-full bg-[#0b1320] border border-[#1e293b] text-white font-extrabold py-2.5 rounded-xl hover:border-[#facc15] text-[11px]">1K</button>
                    <button onclick="document.getElementById('inputNominal').value=5000" class="w-full bg-[#0b1320] border border-[#1e293b] text-white font-extrabold py-2.5 rounded-xl hover:border-[#facc15] text-[11px]">5K</button>
                    <button onclick="document.getElementById('inputNominal').value=10000" class="w-full bg-[#0b1320] border border-[#1e293b] text-white font-extrabold py-2.5 rounded-xl hover:border-[#facc15] text-[11px]">10K</button>
                    <button onclick="document.getElementById('inputNominal').value=50000" class="w-full bg-[#0b1320] border border-[#1e293b] text-white font-extrabold py-2.5 rounded-xl hover:border-[#facc15] text-[11px]">50K</button>
                    <button onclick="document.getElementById('inputNominal').value=100000" class="w-full bg-[#0b1320] border border-[#1e293b] text-white font-extrabold py-2.5 rounded-xl hover:border-[#facc15] text-[11px]">100K</button>
                </div>

                <div class="flex flex-col gap-3 mb-6">
                    
                    <div onclick="selM('qris')" id="m-qris" class="flex items-center justify-between bg-[#0b1320] border border-[#1e293b] p-3 rounded-xl cursor-pointer">
                        <div class="flex items-center gap-3">
                            <i class="fas fa-qrcode text-2xl text-white"></i>
                            <div class="flex flex-col">
                                <span class="font-bold text-sm text-white">Otomatis QRIS Dinamis</span>
                                <span class="text-[10px] text-gray-500 leading-tight">Otomatis masuk (Nominal instan muncul)</span>
                            </div>
                        </div>
                        <div id="r-qris" class="w-5 h-5 rounded-full border-[3px] border-gray-600 bg-transparent shrink-0"></div>
                    </div>
                    
                    <div onclick="selM('wa')" id="m-wa" class="flex items-center justify-between bg-[#0b1320] border border-[#1e293b] p-3 rounded-xl cursor-pointer">
                        <div class="flex items-center gap-3">
                            <i class="fab fa-whatsapp text-2xl text-green-500"></i>
                            <div class="flex flex-col">
                                <span class="font-bold text-sm text-white">Manual WA</span>
                                <span class="text-[10px] text-gray-500 leading-tight">Transfer ke admin</span>
                            </div>
                        </div>
                        <div id="r-wa" class="w-5 h-5 rounded-full border-[3px] border-gray-600 bg-transparent shrink-0"></div>
                    </div>

                </div>

                <button onclick="prosesTopup()" class="w-full py-3.5 bg-[#facc15] text-[#0b1320] font-extrabold rounded-xl shadow-md hover:bg-yellow-500 mb-3">Lanjutkan Pembayaran</button>
            </div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) { 
            window.location.href = '/'; 
        }
        
        document.getElementById('html-root').classList.add('dark');

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
        let hideS = localStorage.getItem('hideSaldo') === 'true';

        function updateDateTime() {
            const tzStr = new Date().toLocaleString("en-US", {timeZone: "Asia/Jakarta"}); 
            const now = new Date(tzStr);
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            
            if(document.getElementById('realtimeDate')) document.getElementById('realtimeDate').innerText = `${year}/${month}/${date}`;
            if(document.getElementById('realtimeClock')) document.getElementById('realtimeClock').innerText = `${hours}:${minutes}:${seconds}`;
        }
        
        setInterval(updateDateTime, 1000);
        updateDateTime();

        function updSal() {
            const el = document.getElementById('displaySaldo'); 
            const e = document.getElementById('eyeSaldo');
            if(hideS) { 
                el.innerText = 'Rp •••••••'; 
                e.className = 'fas fa-eye-slash cursor-pointer text-gray-400 hover:text-[#facc15]'; 
            } else { 
                el.innerText = 'Rp ' + curSal.toLocaleString('id-ID'); 
                e.className = 'fas fa-eye cursor-pointer text-gray-400 hover:text-[#facc15]'; 
            }
        }
        
        function toggleSaldo() { 
            hideS = !hideS; 
            localStorage.setItem('hideSaldo', hideS); 
            updSal(); 
        }

        function logout() {
            Swal.fire({
                title: 'Keluar Akun?', 
                text: 'Apakah kamu yakin ingin keluar?', 
                icon: 'warning',
                showCancelButton: true, 
                background: '#0b1320', 
                color: '#fff'
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
            setTimeout(() => document.getElementById('topupOverlay').classList.add('hidden'), 300); 
        }
        
        function selM(m) {
            sel = m;
            ['wa','qris'].forEach(x => {
                document.getElementById('r-' + x).className = 'w-5 h-5 rounded-full border-[3px] border-gray-600 bg-transparent shrink-0';
                document.getElementById('m-' + x).classList.remove('border-[#facc15]');
            });
            document.getElementById('r-' + m).className = 'w-5 h-5 rounded-full border-[6px] border-[#facc15] bg-[#0b1320] shrink-0';
            document.getElementById('m-' + m).classList.add('border-[#facc15]');
        }

        async function prosesTopup() {
            const n = parseInt(document.getElementById('inputNominal').value);
            const bg = '#0b1320'; 
            const c = '#fff';
            
            if(isMaintenance()) {
                return Swal.fire({ 
                    icon: 'error', 
                    title: 'MAINTENANCE', 
                    text: 'Sistem sedang Maintenance Otomatis. Transaksi ditutup sementara.', 
                    background: bg, 
                    color: c 
                });
            }
            
            if(!n || n <= 0) {
                return Swal.fire({
                    icon: 'warning', 
                    title: 'Gagal', 
                    text: 'Isi nominal valid!', 
                    background: bg, 
                    color: c
                });
            }
            
            if(!sel) {
                return Swal.fire({
                    icon: 'warning', 
                    title: 'Gagal', 
                    text: 'Pilih metode pembayaran!', 
                    background: bg, 
                    color: c
                });
            }
            
            const fn = n + Math.floor(Math.random() * 90) + 10;
            
            if(sel === 'qris') {
                if(n < 1000) {
                    return Swal.fire({
                        icon: 'warning', 
                        title: 'Gagal', 
                        text: 'Minimal Top Up Rp 1.000', 
                        background: bg, 
                        color: c
                    });
                }
                
                closeTopUp();
                
                Swal.fire({ 
                    title: 'Membuat QRIS Dinamis...', 
                    allowOutsideClick: false, 
                    background: bg, 
                    color: c, 
                    didOpen: () => Swal.showLoading() 
                });

                try {
                    let res = await fetch('/api/topup/request', { 
                        method: 'POST', 
                        headers: {'Content-Type': 'application/json'}, 
                        body: JSON.stringify({phone: user.phone, method: 'QRIS Otomatis', nominal: fn}) 
                    });
                    
                    let data = await res.json();
                    
                    if(res.ok) {
                        Swal.close();
                        
                        let finalQrisImg = data.qris_string 
                            ? `https://api.qrserver.com/v1/create-qr-code/?size=500x500&margin=2&data=${encodeURIComponent(data.qris_string)}` 
                            : 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg';
                        
                        // TAMPILAN POP UP QRIS YANG MEWAH! ADA TOMBOL "CEK RIWAYAT TOPUP"
                        let htmlContent = `
                        <div class="flex flex-col items-center pb-2">
                            <div class="w-full text-center mb-4 mt-2">
                                <p class="text-gray-400 text-[11px] font-bold mb-1.5 uppercase">Sisa Waktu Pembayaran</p>
                                <div class="bg-[#1e293b] text-[#facc15] font-black text-3xl py-2 rounded-xl border border-[#facc15]/30 shadow-sm tracking-wider w-3/4 mx-auto" id="qrisTimerModal">10 : 00</div>
                            </div>
                            <div class="bg-white p-3 rounded-2xl inline-block mb-4 shadow-sm">
                                <img src="${finalQrisImg}" class="w-48 h-48 object-contain" style="image-rendering: crisp-edges;">
                            </div>
                            <div class="text-center w-full mb-6">
                                <p class="text-gray-400 text-[10px] font-bold uppercase tracking-wider mb-1">Transfer TEPAT SEBESAR:</p>
                                <p class="text-[#38bdf8] font-black text-3xl mb-1.5 drop-shadow-md">Rp ${fn.toLocaleString('id-ID')}</p>
                                <p class="text-[#ef4444] text-[11px] font-bold bg-red-500/10 border border-red-500/30 py-1.5 px-3 rounded-lg inline-block">Wajib persis agar otomatis masuk.</p>
                            </div>
                            <button onclick="window.location.href='/riwayat_topup.html'" class="w-full py-3.5 bg-[#facc15] text-[#0b1320] font-extrabold rounded-xl shadow-md hover:opacity-90 transition text-[14px]">Cek Riwayat Topup</button>
                        </div>`;

                        setTimeout(() => {
                            Swal.fire({
                                title: `<span class="text-white font-extrabold text-lg uppercase tracking-wide">Scan QRIS Dinamis</span>`,
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
                        Swal.fire({ 
                            icon: 'error', 
                            title: 'Gagal', 
                            text: data.error || 'Terjadi kesalahan sistem.', 
                            background: bg, 
                            color: c 
                        });
                    }
                } catch(e) {
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Gagal', 
                        text: 'Jaringan bermasalah.', 
                        background: bg, 
                        color: c 
                    });
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
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/operator.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pilih Layanan</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { 
            darkMode: 'class' 
        }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
        
        <div class="flex items-center p-5 bg-[#0b1320] sticky top-0 z-40 border-b border-[#1e293b] shrink-0">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-white" onclick="goBack()"></i>
            <h1 class="text-[18px] font-bold text-white uppercase" id="pageTitle">Layanan</h1>
        </div>

        <div class="flex-1 overflow-y-auto hide-scrollbar pb-10">
            <div id="operatorContainer" class="block">
                <div class="px-4 mt-6">
                    <div class="bg-[#111c2e] rounded-2xl overflow-hidden border border-[#1e293b] shadow-sm" id="opListRender"></div>
                </div>
            </div>

            <div id="categoryContainer" class="hidden">
                <div class="flex justify-between items-center px-5 py-4 bg-[#0b1320] text-white border-b border-[#1e293b]">
                    <span class="font-bold text-[15px]" id="catSubtitle">Pilih Kategori</span>
                    <i class="fas fa-home text-lg cursor-pointer hover:text-[#facc15]" onclick="location.href='/dashboard.html'"></i>
                </div>
                <div class="bg-[#111c2e] shadow-sm pb-4" id="categoryList"></div>
            </div>

            <div id="productContainer" class="hidden">
                <div class="flex justify-between items-center px-5 py-4 bg-[#0b1320] text-white border-b border-[#1e293b]">
                    <span class="font-bold text-[15px]" id="prodSubtitle">Pilih Produk</span>
                    <i class="fas fa-home text-lg cursor-pointer hover:text-[#facc15]" onclick="location.href='/dashboard.html'"></i>
                </div>
                <div class="px-4 py-4 bg-[#0b1320] border-b border-[#1e293b]">
                    <label class="text-[10px] text-gray-500 font-bold mb-2 block uppercase" id="targetLabel">Target / Tujuan</label>
                    <div class="relative flex items-center">
                        <input type="text" id="inputTarget" class="w-full bg-[#1a2639] border border-gray-700 text-white rounded-xl py-3 pl-4 pr-24 text-sm font-bold focus:outline-none focus:border-[#facc15]" placeholder="Ketik target...">
                        <div id="prefixIcon" class="absolute right-12 font-bold text-[10px] uppercase px-2 py-1 rounded bg-[#1e293b] text-[#facc15] hidden"></div>
                    </div>
                </div>
                <div class="bg-[#111c2e] shadow-sm pb-4" id="productList"></div>
            </div>
        </div>
    </div>

    <div id="detailOverlay" class="fixed inset-0 bg-black/60 z-[130] hidden opacity-0 transition-opacity" onclick="closeDetail()"></div>
    <div id="detailSheet" class="fixed bottom-0 left-0 right-0 bg-[#0b1320] z-[140] rounded-t-[2rem] transform translate-y-full transition-transform max-w-md mx-auto flex flex-col max-h-[85vh]">
        <div class="w-12 h-1.5 bg-gray-700 rounded-full mx-auto my-3 shrink-0"></div>
        <div class="px-5 pb-2 border-b border-[#1e293b] shrink-0 flex justify-between">
            <h3 class="font-extrabold text-white">Detail Produk</h3>
            <i class="fas fa-times text-gray-400 hover:text-red-500 text-xl cursor-pointer" onclick="closeDetail()"></i>
        </div>
        <div class="p-5 overflow-y-auto hide-scrollbar flex-1">
            <div class="flex items-start gap-3 mb-4">
                <div class="w-10 h-10 rounded-full bg-[#111c2e] border border-[#1e293b] flex items-center justify-center text-[#facc15] text-lg shrink-0 mt-1">
                    <i class="fas fa-box"></i>
                </div>
                <div>
                    <h4 class="font-extrabold text-[15px] text-white" id="dtName">-</h4>
                    <p class="font-black text-lg text-[#facc15] mt-1" id="dtPrice">Rp 0</p>
                </div>
            </div>
            <div class="bg-[#111c2e] rounded-xl p-3 mb-4 border border-[#1e293b] flex justify-between">
                <span class="text-xs font-bold text-gray-500">No Tujuan:</span>
                <span class="text-sm font-bold text-red-500" id="dtTarget">Kosong</span>
            </div>
            <div class="bg-[#111c2e] rounded-xl p-3 mb-4 border border-[#1e293b] flex justify-between items-center">
                <span class="text-xs font-bold text-gray-500">Status Server:</span>
                <div id="dtStatusServer"></div>
            </div>
            <div>
                <span class="text-xs font-bold text-gray-500 mb-2 block">Deskripsi:</span>
                <div class="bg-[#111c2e] rounded-xl p-3 text-[11px] text-gray-300 border border-[#1e293b] leading-relaxed" id="dtDesc">Desc...</div>
            </div>
        </div>
        <div class="p-5 border-t border-[#1e293b] bg-[#0b1320]">
            <div class="flex gap-3 mb-3">
                <button class="flex-1 py-2.5 rounded-xl border border-gray-700 font-bold text-sm text-gray-300 hover:bg-[#1a2639]" onclick="closeDetail()">Kembali</button>
                <button class="flex-1 py-2.5 rounded-xl bg-red-500 text-white font-bold text-sm shadow-sm hover:bg-red-600" onclick="bantuanAdmin()">
                    <i class="fab fa-whatsapp mr-1"></i> Komplain
                </button>
            </div>
            <button id="btnLanjutkan" class="w-full py-3.5 bg-[#facc15] text-[#001229] font-bold rounded-xl text-sm shadow-md transition-opacity" onclick="executeBuy()">
                Lanjutkan Pembayaran
            </button>
        </div>
    </div>

    <script>
        if(!localStorage.getItem('user')) {
            window.location.href = '/';
        }
        
        document.getElementById('html-root').classList.add('dark');
        
        const user = JSON.parse(localStorage.getItem('user'));
        
        const p = new URLSearchParams(window.location.search);
        const t = p.get('type');
        const pp = p.get('provider');
        
        let cS = 'operator'; 
        let oT = ''; 
        let cP = null;
        let sS = ''; 
        let sN = ''; 
        let sP = 0; 
        let sL = false;
        let isProductOpen = true;

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

        const o = {
            xl: { name: 'XL', logo: 'XL', digiBrand: 'XL' },
            axis: { name: 'AXIS', logo: 'AXIS', digiBrand: 'AXIS' },
            telkomsel: { name: 'TELKOMSEL', logo: 'TS', digiBrand: 'TELKOMSEL' },
            indosat: { name: 'INDOSAT', logo: 'IS', digiBrand: 'INDOSAT' },
            tri: { name: 'TRI', logo: '3', digiBrand: 'TRI' },
            smartfren: { name: 'SMARTFREN', logo: 'SF', digiBrand: 'SMARTFREN' },
            byu: { name: 'BY.U', logo: 'BY.U', digiBrand: 'BYU' }
        };

        const dC = JSON.parse(JSON.stringify(o));
        
        dC['telkomsel'].items = [
            'Umum', 'Bulk', 'Flash', 'Mini', 'Apps Kuota', 'Maxstream', 'Umroh', 'Malam',
            'Combo Sakti', 'GamesMAX Unlimited Play', 'Whatsapp', 'Youtube', 'Instagram', 'Facebook',
            'Ketengan TikTok', 'GamesMAX', 'MusicMAX', 'Disney+ Hotstar', 'OMG', 'GigaMAX', 'Orbit',
            'UKM', 'UKM COMBO', 'Bronze', 'Harian', 'Mingguan', 'Bulanan', 'Ketengan Utama',
            'Harian Sepuasnya', 'Roamax', 'GamesMAX Booster', 'Games', 'RoaMAX Haji', 'Combo',
            'Eksklusif', 'Super Seru', 'Flash Revamp', 'DPI', 'Enterprise+', 'Serba Lima Ribu',
            'UKM Plus', 'Non Puma', 'Videomax'
        ];
        
        dC['indosat'].items = [
            'Umum', 'Gift Data', 'Yellow', 'Freedom Combo', 'Freedom Harian', 'Freedom Internet', 
            'Ekstra', 'Freedom U', 'Freedom Apps', 'Freedom U Gift', 'Freedom Combo Gift', 
            'Freedom Internet Gift', 'Umroh Haji Combo', 'Freedom Max', 'UMKM', 'gaspol', 
            'Sachet', 'Pure Merdeka', 'Kita', 'SMB', 'Ramadan', 'Freedom Apps Gift', 'HiFi Air', 
            'Freedom Internet 5G', 'Freedom Spesial', 'Freedom Play', 'Freedom Sensasi'
        ];
        
        dC['axis'].items = [
            'Umum', 'Mini', 'Bronet', 'Owsem', 'Conference', 'Edukasi', 'Ekstra', 'Youtube', 
            'Sosmed', 'Harian', 'BOY', 'Paket Warnet', 'Sulutra', 'Aigo SS', 'Mabrur', 'Video', 
            'Games', 'Sunset', 'Pure', 'DRP Games', 'Obor', 'Edu Confrence', 'Apps Games', 
            'AIGO Unlimited', 'Bagi Kuota'
        ];
        
        dC['tri'].items = [
            'Umum', 'Mini', 'AlwaysOn', 'GetMore', 'Mix', 'Home', 'Roaming', 'Data Transfer', 
            'Happy', 'Lokal', 'H3RO', 'EJBN', 'Ibadah', 'Addon', 'KeepOn', 'Happy Play', 
            'Pure 7 Hari', 'Pure 14 Hari', 'Pure 30 Hari', 'Ramadan', 'HiFi Air', 'Happy 5G'
        ];
        
        dC['xl'].items = [
            'Umum', 'Mini', 'Umroh', 'Hotrod', 'Xtra Combo', 'Xtra Kuota', 'Conference', 'Edukasi', 
            'Xtra Combo Plus', 'Xtra Combo Gift', 'Hotrod Special', 'Xtra Combo Flex', 
            'Paket Akrab', 'Harian', 'Blue', 'Xtra Combo Mini', 'Xtra Combo VIP Gift', 'Games', 
            'Bebas Puas 2rb', 'Grab Gacor', 'Flex', 'FlexMax', 'Ultra 5G+', 'Flex Mini'
        ];
        
        dC['smartfren'].items = [
            'Umum', 'Unlimited', 'Volume', 'Roaming', 'Youtube', 'Connex Evo', 'Gokil Max', 
            'Nonstop', 'Unlimited Nonstop', 'Musik', 'Games', 'Kuota', 'Tiktok', 'Mandiri', 'Nonton', 
            'Unlimited Harian 5G', 'Unlimited Nonstop 5G', 'Kuota 5G'
        ];
        
        dC['byu'].items = [
            'Umum', 'Kaget', 'Mbps', 'Topping GGWP', 'Vidio', 'Jajan', 'Super Kaget'
        ];

        const g = {
            free_fire: { name: 'Free Fire', logo: 'fas fa-gamepad', isIcon: true, digiBrand: 'FREE FIRE' },
            mobile_legends: { name: 'Mobile Legends', logo: 'fas fa-gamepad', isIcon: true, digiBrand: 'MOBILE LEGENDS' },
            pubg_mobile: { name: 'PUBG Mobile', logo: 'fas fa-gamepad', isIcon: true, digiBrand: 'PUBG MOBILE' },
            valorant: { name: 'Valorant', logo: 'fas fa-gamepad', isIcon: true, digiBrand: 'VALORANT' }
        };

        const gC = JSON.parse(JSON.stringify(g));
        gC['mobile_legends'].items = ['Weekly Diamond Pass', 'Diamond'];
        gC['free_fire'].items = ['Membership', 'Diamond'];

        const e = {
            dana: { name: 'DANA', logo: 'DN', digiBrand: 'DANA' },
            gopay: { name: 'GOPAY', logo: 'GP', digiBrand: 'GO PAY' },
            shopeepay: { name: 'SHOPEEPAY', logo: 'SP', digiBrand: 'SHOPEE PAY' },
            ovo: { name: 'OVO', logo: 'OV', digiBrand: 'OVO' },
            linkaja: { name: 'LINKAJA', logo: 'LA', digiBrand: 'LINKAJA' }
        };

        const etoll = {
            bni: { name: 'BNI TapCash', logo: 'BNI', digiBrand: 'TAPCASH' },
            bri: { name: 'BRI Brizzi', logo: 'BRI', digiBrand: 'BRIZZI' },
            mandiri: { name: 'Mandiri Emoney', logo: 'MDR', digiBrand: 'E-MONEY' }
        };

        const v = {
            telkomsel: { name: 'TELKOMSEL', logo: 'TS', digiBrand: 'TELKOMSEL' },
            indosat: { name: 'INDOSAT', logo: 'IS', digiBrand: 'INDOSAT' },
            tri: { name: 'TRI', logo: '3', digiBrand: 'TRI' },
            axis: { name: 'AXIS', logo: 'AXIS', digiBrand: 'AXIS' },
            smartfren: { name: 'SMARTFREN', logo: 'SF', digiBrand: 'SMARTFREN' },
            google_play: { name: 'GOOGLE PLAY INDONESIA', logo: 'GP', digiBrand: 'GOOGLE PLAY INDONESIA' },
            spotify: { name: 'SPOTIFY', logo: 'SP', digiBrand: 'SPOTIFY' }
        };

        const prd = {
            telkomsel: { name: 'TELKOMSEL', logo: 'TS', digiBrand: 'TELKOMSEL' },
            indosat: { name: 'INDOSAT', logo: 'IS', digiBrand: 'INDOSAT' },
            tri: { name: 'TRI', logo: '3', digiBrand: 'TRI' },
            axis: { name: 'AXIS', logo: 'AXIS', digiBrand: 'AXIS' },
            smartfren: { name: 'SMARTFREN', logo: 'SF', digiBrand: 'SMARTFREN' },
            byu: { name: 'BY.U', logo: 'BY.U', digiBrand: 'BYU' }
        };

        const smstelponData = {
            telkomsel: { name: 'TELKOMSEL', logo: 'TS', digiBrand: 'TELKOMSEL' },
            indosat: { name: 'INDOSAT', logo: 'IS', digiBrand: 'INDOSAT' },
            tri: { name: 'TRI', logo: '3', digiBrand: 'TRI' },
            xl: { name: 'XL', logo: 'XL', digiBrand: 'XL' },
            axis: { name: 'AXIS', logo: 'AXIS', digiBrand: 'AXIS' },
            smartfren: { name: 'SMARTFREN', logo: 'SF', digiBrand: 'SMARTFREN' }
        };

        const pln = { 
            pln_token: { name: 'Token PLN', logo: 'fas fa-bolt', isIcon: true, digiBrand: 'PLN' } 
        };

        const a = { ...o, ...dC, ...gC, ...e, ...etoll, ...pln, ...v, ...prd, ...smstelponData };
        
        let cL = {};

        if (t === 'game') { oT = 'Top Up Game'; cL = gC; }
        else if (t === 'data') { oT = 'Paket Data'; cL = dC; }
        else if (t === 'ewallet') { oT = 'E-Wallet'; cL = e; }
        else if (t === 'etoll') { oT = 'Saldo E-Toll'; cL = etoll; }
        else if (t === 'pln') { oT = 'PLN'; cL = pln; }
        else if (t === 'masaaktif') { oT = 'Masa Aktif'; cL = o; }
        else if (t === 'voucher') { oT = 'Voucher'; cL = v; }
        else if (t === 'perdana') { oT = 'Perdana'; cL = prd; }
        else if (t === 'smstelpon') { oT = 'SMS & Telpon'; cL = smstelponData; }
        else { oT = 'Isi Pulsa'; cL = o; }
        
        document.getElementById('pageTitle').innerText = oT;

        let h = '';
        for (let k in cL) {
            let v = cL[k];
            h += `
            <div class="flex items-center p-4 border-b border-[#1e293b] cursor-pointer hover:bg-[#1a2639] transition" onclick="selectProvider('${k}')">
                <div class="w-10 h-10 rounded-full border border-gray-600 flex items-center justify-center text-[10px] bg-[#0b1320] text-gray-300 font-bold">
                    ${v.isIcon ? `<i class="${v.logo} text-lg"></i>` : v.logo}
                </div>
                <div class="flex-1 ml-4 font-bold text-gray-200">${v.name}</div>
            </div>`;
        }
        document.getElementById('opListRender').innerHTML = h;

        if (pp && a[pp]) { setTimeout(() => selectProvider(pp), 50); }

        const px = {
            'Telkomsel': ['0811', '0812', '0813', '0821', '0822', '0823', '0851', '0852', '0853'],
            'Indosat': ['0814', '0815', '0816', '0855', '0856', '0857', '0858'],
            'XL/Axis': ['0817', '0818', '0819', '0859', '0877', '0878', '0831', '0832', '0833', '0838'],
            'Tri': ['0895', '0896', '0897', '0898', '0899'],
            'Smartfren': ['0881', '0882', '0883', '0884', '0885', '0886', '0887', '0888', '0889']
        };

        document.getElementById('inputTarget').addEventListener('input', function() {
            let v = this.value.replace(/[^0-9]/g, '');
            let pi = document.getElementById('prefixIcon');
            let dt = document.getElementById('dtTarget');
            let btn = document.getElementById('btnLanjutkan');
            
            if(v) {
                dt.innerText = v; 
                dt.classList.remove('text-red-500'); 
                dt.classList.add('text-white');
                
                if(isProductOpen) {
                    btn.classList.remove('opacity-50', 'cursor-not-allowed');
                }
            } else {
                dt.innerText = 'Kosong'; 
                dt.classList.add('text-red-500'); 
                dt.classList.remove('text-white');
                btn.classList.add('opacity-50', 'cursor-not-allowed');
            }

            if(v.length >= 4) {
                let f = null;
                for (let b in px) { 
                    if(px[b].includes(v.substring(0, 4))) { f = b; break; } 
                }
                if(f) { 
                    pi.innerText = f; 
                    pi.classList.remove('hidden'); 
                } else { 
                    pi.classList.add('hidden'); 
                }
            } else { 
                pi.classList.add('hidden'); 
            }
        });

        async function fetchProducts(b, c) {
            const l = document.getElementById('productList');
            l.innerHTML = '<div class="py-12 flex justify-center text-[#facc15]"><i class="fas fa-spinner fa-spin text-3xl"></i></div>';
            
            try {
                let r = await fetch('/api/products', { 
                    method: 'POST', 
                    headers: {'Content-Type': 'application/json'}, 
                    body: JSON.stringify({ type: t, brand: b, category: c }) 
                });
                
                let d = await r.json();
                
                if (d.data && d.data.length > 0) {
                    l.innerHTML = d.data.map(p => {
                        let sN = p.name.replace(/'/g, "\\'").replace(/"/g, "&quot;");
                        let sS = p.sku.replace(/'/g, "\\'").replace(/"/g, "&quot;");
                        let sD = p.desc ? p.desc.replace(/'/g, "\\'").replace(/"/g, "&quot;").replace(/\n/g, "<br>") : 'Tidak ada deskripsi.';
                        
                        let bdg = p.is_open ? 
                            `<span class="text-[8px] bg-green-900/30 text-green-400 px-2 py-0.5 rounded-full font-bold uppercase tracking-wide border border-green-800">✅ AMAN</span>` : 
                            `<span class="text-[8px] bg-red-900/30 text-red-400 px-2 py-0.5 rounded-full font-bold uppercase tracking-wide border border-red-800 animate-pulse">❌ GANGGUAN</span>`;
                        
                        let clk = `showProductDetail('${sS}','${sN}',${p.price},${p.isLocal},'${sD}', ${p.is_open})`;
                        let opc = p.is_open ? '' : 'opacity-60 bg-[#1a2639]';

                        return `
                        <div class="flex justify-between px-5 py-4 border-b border-[#1e293b] cursor-pointer hover:bg-[#1a2639] transition ${opc}" onclick="${clk}">
                            <div class="w-2/3 text-[12px] font-bold text-gray-100 leading-tight">
                                ${p.name} ${p.isLocal ? '<i class="fas fa-check-circle text-green-500 ml-1"></i>' : ''}
                            </div>
                            <div class="text-right flex flex-col items-end justify-center">
                                <div class="mb-1">${bdg}</div>
                                <span class="text-[13px] font-extrabold text-[#facc15]">Rp ${p.price.toLocaleString('id-ID')}</span>
                            </div>
                        </div>`;
                    }).join('');
                } else {
                    l.innerHTML = '<div class="py-12 text-center text-gray-400 font-bold">Katalog Kosong</div>';
                }
            } catch(e) { 
                l.innerHTML = '<div class="py-12 text-center text-red-500 font-bold">Gagal memuat API</div>'; 
            }
        }

        function showProductDetail(sku, n, pr, il, ds, isOpen) {
            sS = sku; 
            sN = n; 
            sP = pr; 
            sL = il; 
            isProductOpen = isOpen;
            
            document.getElementById('dtName').innerText = n;
            document.getElementById('dtPrice').innerText = 'Rp ' + pr.toLocaleString('id-ID');
            document.getElementById('dtDesc').innerHTML = ds;
            
            let statBadge = isOpen 
                ? `<span class="bg-green-900/30 text-green-400 px-3 py-1 rounded-full text-xs font-bold border border-green-800"><i class="fas fa-check-circle mr-1"></i> NORMAL / AMAN</span>`
                : `<span class="bg-red-900/30 text-red-400 px-3 py-1 rounded-full text-xs font-bold border border-red-800 animate-pulse"><i class="fas fa-times-circle mr-1"></i> SEDANG GANGGUAN</span>`;
            
            document.getElementById('dtStatusServer').innerHTML = statBadge;

            const btn = document.getElementById('btnLanjutkan');
            if(!isOpen) {
                btn.innerText = "Produk Sedang Gangguan";
                btn.classList.add('opacity-50', 'cursor-not-allowed');
                btn.classList.replace('bg-[#facc15]', 'bg-gray-600');
                btn.classList.replace('text-[#001229]', 'text-gray-300');
            } else {
                btn.innerText = "Lanjutkan Pembayaran";
                btn.classList.replace('bg-gray-600', 'bg-[#facc15]');
                btn.classList.replace('text-gray-300', 'text-[#001229]');
                document.getElementById('inputTarget').dispatchEvent(new Event('input')); 
            }
            
            document.getElementById('detailOverlay').classList.remove('hidden');
            setTimeout(() => {
                document.getElementById('detailOverlay').classList.remove('opacity-0');
                document.getElementById('detailSheet').classList.remove('translate-y-full');
            }, 10);
        }

        function closeDetail() {
            document.getElementById('detailSheet').classList.add('translate-y-full');
            document.getElementById('detailOverlay').classList.add('opacity-0');
            setTimeout(() => document.getElementById('detailOverlay').classList.add('hidden'), 300);
        }

        function bantuanAdmin() {
            window.open(`https://wa.me/6282231154407?text=` + encodeURIComponent(`Halo Admin, saya ingin komplain mengenai produk *${sN}*.`), '_blank');
        }

        function executeBuy() {
            if(!isProductOpen) {
                return Swal.fire({
                    icon: 'error', 
                    title: 'Gangguan', 
                    text: 'Mohon maaf, produk ini sedang mengalami gangguan dari server pusat.',
                    background: '#0b1320', 
                    color: '#fff'
                });
            }

            const tr = document.getElementById('inputTarget').value;
            if (!tr) return;
            
            closeDetail();
            const bg = '#0b1320';
            const c = '#fff';
            
            if(isMaintenance()) {
                return Swal.fire({
                    icon: 'error', 
                    title: 'MAINTENANCE', 
                    text: 'Sistem sedang Maintenance Otomatis (23:00 - 00:30 WIB). Transaksi ditutup sementara.', 
                    background: bg, 
                    color: c
                });
            }
            
            setTimeout(() => {
                Swal.fire({ 
                    title: 'Memproses...', 
                    allowOutsideClick: false, 
                    background: bg, 
                    color: c, 
                    didOpen: () => Swal.showLoading() 
                });
                
                fetch('/api/transaction/create', {
                    method: 'POST', 
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ phone: user.phone, target: tr, sku: sS, name: sN, price: sP, isLocal: sL })
                })
                .then(async r => {
                    let d = await r.json();
                    if (r.ok) {
                        Swal.fire({ 
                            icon: 'success', 
                            title: 'Berhasil!', 
                            text: d.message, 
                            background: bg, 
                            color: c 
                        }).then(() => window.location.href = '/riwayat.html');
                    } else {
                        Swal.fire({ 
                            icon: 'error', 
                            title: 'Gagal', 
                            text: d.error, 
                            background: bg, 
                            color: c 
                        });
                    }
                })
                .catch(e => { 
                    Swal.fire({ 
                        icon: 'error', 
                        title: 'Oops!', 
                        text: 'Gangguan jaringan.', 
                        background: bg, 
                        color: c 
                    }); 
                });
            }, 300);
        }

        function selectProvider(o) {
            let pr = cL[o] || a[o];
            if (pr) {
                cP = pr;
                document.getElementById('operatorContainer').classList.replace('block', 'hidden');
                
                if (pr.items && pr.items.length > 0 && (t === 'data' || t === 'game')) {
                    cS = 'category';
                    document.getElementById('categoryContainer').classList.remove('hidden');
                    document.getElementById('pageTitle').innerText = pr.name;
                    let h = '';
                    pr.items.forEach(i => {
                        h += `
                        <div class="flex items-center px-5 py-4 border-b border-[#1e293b] cursor-pointer hover:bg-[#1a2639] transition" onclick="selectCategory('${i}')">
                            <div class="flex-1 text-[13px] font-bold text-gray-200 uppercase">${i}</div>
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                        </div>`;
                    });
                    document.getElementById('categoryList').innerHTML = h;
                } else {
                    cS = 'product';
                    document.getElementById('productContainer').classList.remove('hidden');
                    document.getElementById('pageTitle').innerText = pr.name;
                    document.getElementById('inputTarget').placeholder = pr.placeholder || "Ketik target disini...";
                    document.getElementById('inputTarget').value = '';
                    document.getElementById('inputTarget').dispatchEvent(new Event('input'));
                    fetchProducts(pr.digiBrand, null);
                }
            }
        }

        function selectCategory(c) {
            cS = 'product';
            document.getElementById('categoryContainer').classList.add('hidden');
            document.getElementById('productContainer').classList.remove('hidden');
            document.getElementById('pageTitle').innerText = c;
            document.getElementById('inputTarget').value = '';
            document.getElementById('inputTarget').dispatchEvent(new Event('input'));
            fetchProducts(cP.digiBrand, c);
        }

        function goBack() {
            if (cS === 'product') {
                if (cP && cP.items && cP.items.length > 0 && (t === 'data' || t === 'game')) {
                    cS = 'category';
                    document.getElementById('productContainer').classList.add('hidden');
                    document.getElementById('categoryContainer').classList.remove('hidden');
                    document.getElementById('pageTitle').innerText = cP.name;
                } else {
                    cS = 'operator';
                    document.getElementById('productContainer').classList.add('hidden');
                    document.getElementById('operatorContainer').classList.replace('hidden', 'block');
                    document.getElementById('pageTitle').innerText = oT;
                }
            } else if (cS === 'category') {
                cS = 'operator';
                document.getElementById('categoryContainer').classList.add('hidden');
                document.getElementById('operatorContainer').classList.replace('hidden', 'block');
                document.getElementById('pageTitle').innerText = oT;
            } else {
                history.back();
            }
        }
    </script>
</body>
</html>
EOF

echo "[PART 2 SELESAI BOSKUUU!]"
echo "[6/8] Membangun Halaman Game, Riwayat Topup, dan Info (FULL UNCOMPRESSED)..."

cat << 'EOF' > public/game.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Up Game - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center p-5 bg-[#0b1320] sticky top-0 z-40 border-b border-[#1e293b]">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-white" onclick="history.back()"></i>
            <h1 class="text-[18px] font-bold text-white">Top Up Game</h1>
        </div>

        <div class="px-4 mt-6">
            <div class="bg-[#111c2e] rounded-b-2xl rounded-t-xl overflow-hidden border border-[#1e293b] shadow-sm mt-4">
                <div class="bg-black p-4 flex items-center gap-2">
                    <i class="fas fa-gamepad text-[#facc15] text-lg"></i>
                    <span class="font-bold text-white text-sm">Pilih Game</span>
                </div>
                <div class="p-4 grid grid-cols-3 gap-3">
                    
                    <div class="bg-[#1a2639] border border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#facc15] transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=free_fire'">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-600 flex items-center justify-center text-[#facc15] font-extrabold text-sm mb-2 shadow-sm">FF</div>
                        <div class="text-[11px] font-bold text-gray-300 text-center">Free Fire</div>
                    </div>
                    
                    <div class="bg-[#1a2639] border border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#facc15] transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=mobile_legends'">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-600 flex items-center justify-center text-[#facc15] font-extrabold text-xs text-center shadow-sm">ML</div>
                        <div class="text-[11px] font-bold text-gray-300 text-center">Mobile<br>Legends</div>
                    </div>
                    
                    <div class="bg-[#1a2639] border border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#facc15] transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=pubg_mobile'">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-600 flex items-center justify-center text-[#facc15] font-extrabold text-[10px] text-center shadow-sm">PUBG</div>
                        <div class="text-[11px] font-bold text-gray-300 text-center">PUBG<br>Mobile</div>
                    </div>
                    
                    <div class="bg-[#1a2639] border border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#facc15] transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=valorant'">
                        <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-600 flex items-center justify-center text-[#facc15] font-extrabold text-[11px] text-center shadow-sm">VALO</div>
                        <div class="text-[11px] font-bold text-gray-300 text-center">Valorant</div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
    
    <script>
        if(!localStorage.getItem('user')) {
            window.location.href = '/';
        }
        document.getElementById('html-root').classList.add('dark');
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/riwayat_topup.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Topup - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
    <style>
        .swal2-popup.custom-swal-bg { background-color: #111c2e !important; border-radius: 1.5rem !important; width: 340px !important; padding: 1.5rem !important; border: 1px solid #1e293b; }
        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center pt-5 px-5 pb-0 bg-[#0b1320] sticky top-0 z-50">
            <i class="fas fa-chevron-left text-xl cursor-pointer mr-4 text-white" onclick="location.href='/dashboard.html'"></i>
            <h1 class="text-[18px] font-extrabold text-white tracking-wide">Riwayat Transaksi</h1>
        </div>

        <div class="flex bg-[#0b1320] sticky top-[60px] z-40 border-b border-[#1e293b] mt-4 shadow-sm">
            <div class="flex-1 text-center py-3.5 text-[13px] font-bold text-gray-500 cursor-pointer uppercase tracking-wide transition-colors" onclick="location.href='/riwayat.html'">
                Produk
            </div>
            <div class="flex-1 text-center py-3.5 text-[13px] font-bold text-[#facc15] border-b-[3px] border-[#facc15] cursor-pointer uppercase tracking-wide">
                Topup Saldo
            </div>
        </div>

        <div class="mx-4 mt-4 bg-[#111c2e] p-4 rounded-2xl border border-[#1e293b] shadow-sm">
            <div class="relative mb-4">
                <i class="fas fa-search absolute left-3.5 top-3 text-gray-400 text-sm"></i>
                <input type="text" id="searchInput" onkeyup="filterHistory()" class="w-full bg-[#0b1320] border border-gray-700 text-gray-200 rounded-xl py-2.5 pl-10 pr-4 text-sm font-bold focus:outline-none focus:border-[#facc15]" placeholder="Cari transaksi...">
            </div>
            <div class="flex justify-between mb-2 gap-2">
                <div id="btn-Semua" onclick="setStatusFilter('Semua')" class="flex-1 bg-[#facc15] text-[#0b1320] text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer shadow-sm transition-colors border border-[#facc15]">Semua</div>
                <div id="btn-Sukses" onclick="setStatusFilter('Sukses')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Sukses</div>
                <div id="btn-Proses" onclick="setStatusFilter('Proses')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Proses</div>
                <div id="btn-Gagal" onclick="setStatusFilter('Gagal')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Gagal</div>
            </div>
        </div>

        <div class="px-4 mt-4" id="historyContainer">
            <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
                <i class="fas fa-spinner fa-spin text-4xl mb-4 text-[#facc15]"></i>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-sm z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/dashboard.html'">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-[#facc15]">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>
    </div>
    
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) { 
            window.location.href = '/'; 
        }
        document.getElementById('html-root').classList.add('dark');
        
        let allTrx = [];
        let currentFilter = 'Semua';

        fetch('/api/topup/history', { 
            method: 'POST', 
            headers: { 'Content-Type': 'application/json' }, 
            body: JSON.stringify({ phone: user.phone }) 
        })
        .then(r => r.json())
        .then(d => { 
            allTrx = d.history ? d.history.reverse() : []; 
            window.topupData = allTrx; 
            renderHistory(); 
        })
        .catch(e => { 
            document.getElementById('historyContainer').innerHTML = `<div class="mt-10 text-center text-red-500 font-bold">Gagal memuat data.</div>`; 
        });

        function setStatusFilter(status) {
            currentFilter = status;
            ['Semua', 'Sukses', 'Proses', 'Gagal'].forEach(btn => { 
                document.getElementById('btn-' + btn).className = 'flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]'; 
            });
            document.getElementById('btn-' + status).className = `flex-1 bg-[#facc15] text-[#0b1320] text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer shadow-sm transition-colors border border-[#facc15]`;
            filterHistory();
        }

        function filterHistory() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            let filtered = allTrx;
            
            if(currentFilter !== 'Semua') { 
                filtered = currentFilter === 'Gagal' ? filtered.filter(i => i.status === 'Gagal' || i.status === 'Expired') : filtered.filter(i => i.status === currentFilter); 
            }
            
            if(query) { 
                filtered = filtered.filter(i => (i.method && i.method.toLowerCase().includes(query)) || (i.id && i.id.toLowerCase().includes(query))); 
            }
            
            const c = document.getElementById('historyContainer');
            
            if(!filtered || filtered.length === 0) {
                c.innerHTML = `
                <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
                    <div class="w-[5.5rem] h-[5.5rem] bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-[#1e293b]">
                        <i class="fas fa-wallet text-gray-400 text-4xl"></i>
                    </div>
                    <h2 class="text-white font-bold text-lg tracking-wide mb-2">Belum Ada Top Up</h2>
                    <button class="bg-[#facc15] text-[#0b1320] font-extrabold py-3 px-8 rounded-full shadow-lg hover:opacity-90 transition mt-4" onclick="location.href='/dashboard.html'">Top Up Sekarang</button>
                </div>`;
            } else {
                c.innerHTML = filtered.map((i) => {
                    let isExp = i.status === 'Expired';
                    let sc = isExp || i.status === 'Gagal' ? 'text-red-400 border border-red-500/50 bg-red-500/10' : (i.status === 'Sukses' ? 'text-green-400 border border-green-500/50 bg-green-500/10' : 'text-[#facc15] border border-[#facc15]/50 bg-[#facc15]/10');
                    let statusText = isExp ? 'KEDALUWARSA' : i.status.toUpperCase();
                    let methodClean = i.method.includes('QRIS') ? 'QRIS Dinamis' : (i.method.includes('Admin') ? 'Admin' : 'Manual WA');
                    let rawIdx = allTrx.indexOf(i);
                    
                    return `
                    <div onclick="showDetailTopup(${rawIdx})" class="bg-[#111c2e] p-4 rounded-[1.2rem] mb-3 border border-[#1e293b] shadow-sm cursor-pointer hover:bg-[#1a2639] transition-colors flex items-center justify-between">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-[#0b1320] flex items-center justify-center shrink-0 border border-gray-700"><i class="fas fa-wallet text-gray-400 text-xl"></i></div>
                            <div class="flex flex-col"><h4 class="font-extrabold text-[14px] text-gray-200 mb-1">Topup Saldo ${methodClean}</h4><span class="text-[11px] text-gray-400 font-medium">${i.date}</span></div>
                        </div>
                        <div class="flex flex-col items-end"><p class="text-[15px] font-black text-[#facc15] mb-1.5">Rp ${(i.nominal || 0).toLocaleString('id-ID')}</p><span class="text-[9px] font-bold px-2 py-0.5 rounded uppercase tracking-wider ${sc}">${statusText}</span></div>
                    </div>`;
                }).join('');
            }
        }

        function renderHistory() { 
            filterHistory(); 
        }

        window.komplainTopup = function(nominal, tanggal, statusLengkap) {
            let msg = `Halo, saya ingin komplain deposit dengan nominal ${nominal} pada tanggal ${tanggal}. Status: ${statusLengkap}.`;
            window.open(`https://wa.me/6282231154407?text=` + encodeURIComponent(msg), '_blank');
        }

        window.showDetailTopup = function(index) {
            const item = window.topupData[index];
            let statusText = item.status === 'Expired' ? 'Kedaluwarsa' : item.status;
            let rawStatus = item.status.toLowerCase();
            
            if(rawStatus === 'proses' && item.method.includes('QRIS')) rawStatus = 'pending_qris';
            if(rawStatus === 'expired') rawStatus = 'gagal_kedaluwarsa';
            
            let methodClean = item.method.includes('QRIS') ? 'QRIS Dinamis' : (item.method.includes('Admin') ? 'Admin' : 'Manual WA');
            
            // SENSOR DATA MEMBER SEPARO SESUAI REQUEST BOS
            let rawName = item.nama || user.name || 'Hamba Allah';
            let maskName = rawName.length > 3 ? rawName.substring(0, 3) + '*'.repeat(rawName.length - 3) : rawName + '***';

            let rawEmail = item.email || user.email || 'email@gmail.com';
            let emailParts = rawEmail.split('@');
            let maskEmail = emailParts[0].length > 3 ? emailParts[0].substring(0,3) + '***@' + (emailParts[1] || 'gmail.com') : '***@' + (emailParts[1] || 'gmail.com');

            let rawWa = item.wa || user.phone || '080000000000';
            let maskWa = rawWa.length > 8 ? rawWa.substring(0, 4) + '****' + rawWa.substring(rawWa.length - 4) : rawWa;

            // KALKULASI SALDO DAN UNIK
            let nominalLengkap = item.nominal || 0;
            let kodeUnik = item.kode_unik !== undefined ? item.kode_unik : (nominalLengkap % 1000);
            let jmlDeposit = nominalLengkap - kodeUnik;
            
            let salSebelum = item.saldo_sebelum !== undefined ? 'Rp ' + item.saldo_sebelum.toLocaleString('id-ID') : 'Rp -';
            let salSesudah = item.saldo_sesudah !== undefined ? 'Rp ' + item.saldo_sesudah.toLocaleString('id-ID') : '- (Belum Masuk)';

            let htmlContent = `
            <h3 class="text-white font-extrabold text-[18px] mb-5 text-center">Detail Transaksi Topup</h3>
            <div class="bg-[#0b1320] border border-[#1e293b] rounded-xl p-4 mb-5 text-left overflow-y-auto max-h-[60vh] hide-scrollbar">
                
                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Data Pelanggan</p>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Nama</span><span class="text-white font-bold text-[12px] text-right">${maskName}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Email</span><span class="text-white font-bold text-[12px] text-right">${maskEmail}</span></div>
                <div class="flex justify-between mb-4"><span class="text-gray-400 font-medium text-[12px]">No. WA</span><span class="text-white font-bold text-[12px] text-right">${maskWa}</span></div>
                
                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Rincian Topup</p>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Waktu</span><span class="text-white font-bold text-[11px] text-right">${item.date}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Status</span><span class="text-white font-bold text-[12px] text-right ${item.status === 'Sukses' ? 'text-green-400' : 'text-[#facc15]'}">${statusText}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Metode</span><span class="text-white font-bold text-[12px] text-right">${methodClean}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">SN/Ref</span><span class="text-white font-bold text-[10px] text-right break-all ml-4">${item.id}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Jml Deposit</span><span class="text-white font-bold text-[12px] text-right">Rp ${jmlDeposit.toLocaleString('id-ID')}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Kode Unik</span><span class="text-white font-bold text-[12px] text-right">+ ${kodeUnik}</span></div>
                <div class="flex justify-between mb-4"><span class="text-gray-400 font-extrabold text-[13px]">Total Diterima</span><span class="text-[#facc15] font-black text-[15px] text-right">Rp ${nominalLengkap.toLocaleString('id-ID')}</span></div>
                
                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Riwayat Saldo</p>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Saldo Sebelum</span><span class="text-white font-bold text-[12px] text-right">${salSebelum}</span></div>
                <div class="flex justify-between"><span class="text-gray-400 font-medium text-[12px]">Saldo Sesudah</span><span class="text-white font-bold text-[12px] text-right">${salSesudah}</span></div>

            </div>
            <button onclick="komplainTopup('${item.nominal}', '${item.date}', '${rawStatus}')" class="w-full py-3.5 bg-[#ef4444] hover:bg-[#dc2626] text-white font-extrabold rounded-[12px] mb-3 transition-colors text-[14px]">Hubungi Admin (Komplain)</button>
            <button onclick="Swal.close()" class="w-full py-3.5 bg-transparent border border-[#334155] text-white hover:bg-[#1a2639] font-extrabold rounded-[12px] transition-colors text-[14px]">Tutup</button>
            `;
            
            Swal.fire({ 
                html: htmlContent, 
                showConfirmButton: false, 
                background: '#111c2e', 
                customClass: { popup: 'custom-swal-bg' }, 
                padding: 0 
            });
        }
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/info.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pusat Informasi - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center p-5 bg-[#0b1320] sticky top-0 z-40 border-b border-[#1e293b]">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-white" onclick="location.href='/dashboard.html'"></i>
            <h1 class="text-[18px] font-bold text-white">Pusat Informasi</h1>
        </div>

        <div class="p-4" id="infoList">
            <div class="mt-20 flex flex-col items-center justify-center text-gray-400">
                <i class="fas fa-spinner fa-spin text-4xl mb-4 text-[#facc15]"></i>
                <p class="text-sm font-bold">Memuat informasi...</p>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-sm z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/dashboard.html'">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/riwayat.html'">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-[#facc15]">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>
    </div>
    
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) window.location.href = '/';
        
        document.getElementById('html-root').classList.add('dark');

        fetch('/api/info')
        .then(r => r.json())
        .then(d => {
            const l = document.getElementById('infoList');
            if(!d.info || d.info.length === 0) {
                l.innerHTML = `
                <div class="mt-20 flex flex-col items-center justify-center text-gray-500">
                    <i class="fas fa-bell-slash text-5xl mb-4 opacity-50"></i>
                    <p class="text-sm font-bold">Belum ada info terbaru.</p>
                </div>`;
            } else {
                l.innerHTML = d.info.reverse().map(i => `
                <div class="relative bg-[#111c2e] border border-[#1e293b] rounded-2xl p-5 mb-4 shadow-sm overflow-hidden">
                    <div class="absolute -right-2 top-4 text-7xl opacity-20 select-none">📢</div>
                    <div class="flex justify-between items-start mb-3 relative z-10">
                        <h3 class="font-extrabold text-[#facc15] text-[15px] pr-2">${i.judul}</h3>
                        <span class="text-[10px] text-gray-400 bg-[#0b1320] font-bold px-2 py-1 rounded-md border border-[#1e293b]">${i.date}</span>
                    </div>
                    <p class="text-[13px] text-gray-300 leading-relaxed relative z-10 font-medium">${i.isi}</p>
                </div>`).join('');
            }
        });
    </script>
</body>
</html>
EOF

echo "[PART 3 SELESAI BOSKUUU!]"
cat << 'EOF' > public/mutasi.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mutasi Saldo - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center p-5 bg-[#0b1320] sticky top-0 z-40 border-b border-[#1e293b]">
            <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-white" onclick="history.back()"></i>
            <h1 class="text-[18px] font-bold text-white">Mutasi Saldo</h1>
        </div>

        <div class="p-4" id="mutasiList">
            <div class="mt-20 flex flex-col items-center justify-center text-[#facc15]">
                <i class="fas fa-spinner fa-spin text-4xl mb-4"></i>
                <p class="text-sm font-bold text-gray-500">Memuat data mutasi...</p>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-sm z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/dashboard.html'">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/riwayat.html'">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>

    </div>
    
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        
        if(!user) {
            window.location.href = '/';
        }
        
        document.getElementById('html-root').classList.add('dark');
        
        fetch('/api/user/mutasi', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: user.phone })
        })
        .then(r => r.json())
        .then(d => {
            const l = document.getElementById('mutasiList');
            
            if(!d.mutasi || d.mutasi.length === 0) {
                l.innerHTML = `
                <div class="mt-20 flex flex-col items-center justify-center text-center px-6">
                    <div class="w-[5.5rem] h-[5.5rem] bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-[#1e293b]">
                        <i class="fas fa-exchange-alt text-gray-400 text-4xl"></i>
                    </div>
                    <h2 class="text-white font-bold text-lg mb-2">Belum Ada Mutasi</h2>
                </div>`;
            } else {
                l.innerHTML = d.mutasi.reverse().map(m => `
                <div class="bg-[#111c2e] border border-[#1e293b] rounded-2xl p-4 mb-3 flex justify-between shadow-sm">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full ${m.type === 'in' ? 'bg-green-900/30 text-green-400' : 'bg-red-900/30 text-red-400'} flex items-center justify-center text-lg shrink-0">
                            <i class="fas ${m.type === 'in' ? 'fa-arrow-down' : 'fa-arrow-up'}"></i>
                        </div>
                        <div>
                            <h4 class="font-bold text-[13px] text-gray-200">${m.desc}</h4>
                            <p class="text-[10px] font-bold text-gray-500">${m.date}</p>
                        </div>
                    </div>
                    <div class="font-extrabold text-[14px] flex items-center ${m.type === 'in' ? 'text-green-500' : 'text-red-500'}">
                        ${m.type === 'in' ? '+' : '-'} Rp ${m.amount.toLocaleString('id-ID')}
                    </div>
                </div>`).join('');
            }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/profile.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="bg-[#111c2e] p-8 pb-10 flex flex-col items-center relative rounded-b-[2rem] shadow-lg border-b border-[#1e293b]">
            <div class="w-24 h-24 bg-[#0b1320] rounded-full flex justify-center items-center text-[#facc15] font-extrabold text-4xl mt-2 mb-3 shadow-md overflow-hidden border-2 border-[#1e293b]" id="profileCircle">U</div>
            <div class="flex items-center gap-3">
                <h2 class="text-2xl font-bold tracking-wide text-gray-100" id="profileName">User Name</h2>
                <i class="fas fa-pencil-alt text-gray-400 hover:text-[#facc15] cursor-pointer text-lg" onclick="openEditModal()"></i>
            </div>
        </div>

        <div class="mt-4 px-2">
            <div class="flex items-center px-4 py-5 border-b border-[#1e293b]">
                <i class="fas fa-envelope text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Email</div>
                <div class="text-sm font-bold text-gray-400" id="profileEmail">-</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-[#1e293b]">
                <i class="fas fa-phone-alt text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">No. Telp</div>
                <div class="text-sm font-bold text-gray-400" id="profilePhoneData">08...</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-[#1e293b]">
                <i class="fas fa-wallet text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Saldo Akun</div>
                <div class="text-sm font-extrabold text-[#facc15]" id="profileSaldo">Rp 0</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-[#1e293b]">
                <i class="fas fa-shopping-cart text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Total Transaksi</div>
                <div class="text-sm font-extrabold text-[#facc15]" id="profileTrx">0 Trx</div>
            </div>
            <div class="flex items-center px-4 py-5 border-b border-[#1e293b] cursor-pointer hover:bg-[#1a2639] transition-colors" onclick="location.href='/mutasi.html'">
                <i class="fas fa-exchange-alt text-gray-400 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-gray-200 ml-2">Mutasi Saldo</div>
                <i class="fas fa-chevron-right text-gray-400 text-sm"></i>
            </div>
            <div class="flex items-center px-4 py-5 cursor-pointer hover:bg-gray-800/50 transition-colors" onclick="logout()">
                <i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i>
                <div class="flex-1 text-[15px] font-bold text-red-600 ml-2">Keluar Akun</div>
            </div>
        </div>

        <div id="editProfileModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center bg-black/70">
            <div class="bg-[#111c2e] w-[90%] max-w-[340px] rounded-[1.25rem] border border-[#1e293b] shadow-2xl relative p-6 animate-slide-up">
                <button onclick="closeEditModal()" class="absolute top-4 right-4 text-gray-400 hover:text-red-500">
                    <i class="fas fa-times text-xl"></i>
                </button>
                <h3 class="text-center text-white font-extrabold text-lg mb-6">Ubah Profil</h3>
                
                <div class="relative w-20 h-20 mx-auto mb-8">
                    <div class="w-full h-full rounded-full border-2 border-[#facc15] flex items-center justify-center text-3xl font-bold bg-[#0b1320] overflow-hidden text-white" id="editModalInitial">U</div>
                    <input type="file" id="avatarInput" accept="image/*" class="hidden" onchange="previewAvatar(event)">
                    <div class="absolute bottom-0 right-0 bg-[#facc15] rounded-full w-7 h-7 flex items-center justify-center text-[#0b1320] border-[3px] border-[#0b1320] cursor-pointer z-10" onclick="document.getElementById('avatarInput').click()">
                        <i class="fas fa-camera text-[10px]"></i>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="block text-[10px] font-bold text-gray-500 mb-1 uppercase">Email (Hanya Baca)</label>
                    <input type="email" id="editEmail" readonly class="w-full bg-[#0b1320]/50 border border-[#1e293b] rounded-lg px-3 py-3 text-gray-400 font-bold text-sm focus:outline-none cursor-not-allowed">
                </div>
                <div class="mb-4">
                    <label class="block text-[10px] font-bold text-gray-500 mb-1 uppercase">Nama Pengguna</label>
                    <input type="text" id="editName" class="w-full bg-[#0b1320] border border-[#1e293b] rounded-lg px-3 py-3 text-white font-bold text-sm focus:outline-none focus:border-[#facc15]">
                </div>
                <div class="mb-4">
                    <label class="block text-[10px] font-bold text-gray-500 mb-1 uppercase">Nomor Telepon</label>
                    <input type="number" id="editPhone" class="w-full bg-[#0b1320] border border-[#1e293b] rounded-lg px-3 py-3 text-white font-bold text-sm focus:outline-none focus:border-[#facc15]">
                </div>
                <div class="mb-4">
                    <label class="block text-[10px] font-bold text-gray-500 mb-1 uppercase">Password Baru (Opsional)</label>
                    <div class="relative w-full">
                        <input type="password" id="editPassword" class="w-full bg-[#0b1320] border border-[#1e293b] rounded-lg px-3 py-3 text-white font-bold text-sm focus:outline-none focus:border-[#facc15]" placeholder="Kosongkan jika tidak diganti">
                        <i class="fas fa-eye absolute right-4 top-1/2 transform -translate-y-1/2 cursor-pointer text-gray-400" onclick="togglePasswordProfile('editPassword', this)"></i>
                    </div>
                </div>

                <div class="mb-6 hidden slide-down" id="editOtpContainer">
                    <label class="block text-[10px] font-bold text-gray-500 mb-1 text-center">OTP telah dikirim ke WA</label>
                    <input type="number" id="editOtpInput" class="w-full bg-[#0b1320] border border-green-500 rounded-lg px-3 py-3 text-white text-lg tracking-[0.5em] text-center font-extrabold focus:outline-none" placeholder="XXXX">
                </div>

                <button id="btnSimpanProfil" onclick="saveProfile()" class="w-full py-3.5 bg-[#facc15] text-[#0b1320] font-extrabold rounded-xl mb-3 shadow-md hover:opacity-90">Simpan Profil</button>
                <button onclick="deleteAccount()" class="w-full py-3.5 bg-red-500/10 text-red-500 font-bold rounded-xl border border-red-500/20 hover:bg-red-500/20">Hapus Akun Permanen</button>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-sm z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/dashboard.html'">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/riwayat.html'">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-[#facc15]">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>

    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) window.location.href = '/';
        
        document.getElementById('html-root').classList.add('dark');

        function loadProfileData() {
            document.getElementById('profileName').innerText = user.name;
            document.getElementById('profilePhoneData').innerText = user.phone;
            document.getElementById('profileEmail').innerText = user.email || 'Tidak ada email';
            
            const pCircle = document.getElementById('profileCircle');
            if(user.avatar) {
                pCircle.innerHTML = `<img src="${user.avatar}" class="w-full h-full rounded-full object-cover">`;
            } else {
                pCircle.innerText = user.name.charAt(0).toUpperCase();
            }
        }
        
        loadProfileData();

        function togglePasswordProfile(id, el) {
            const input = document.getElementById(id);
            if (input.type === 'password') { 
                input.type = 'text'; 
                el.classList.replace('fa-eye', 'fa-eye-slash'); 
            } else { 
                input.type = 'password'; 
                el.classList.replace('fa-eye-slash', 'fa-eye'); 
            }
        }

        fetch('/api/user/balance', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: user.phone })
        })
        .then(r => r.json())
        .then(d => {
            document.getElementById('profileSaldo').innerText = 'Rp ' + d.saldo.toLocaleString('id-ID');
        });

        fetch('/api/user/transactions', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: user.phone })
        })
        .then(r => r.json())
        .then(d => {
            document.getElementById('profileTrx').innerText = (d.transactions ? d.transactions.length : 0) + ' Trx';
        });

        function logout() {
            Swal.fire({
                title: 'Keluar Akun?', 
                text: 'Apakah kamu yakin ingin keluar?', 
                icon: 'warning',
                showCancelButton: true,
                background: '#0b1320',
                color: '#fff',
                confirmButtonColor: '#d33'
            }).then(r => {
                if(r.isConfirmed) {
                    localStorage.removeItem('user');
                    window.location.href = '/';
                }
            });
        }

        let tempAvatarBase64 = null;
        let isRequestingOtp = false;

        function previewAvatar(event) {
            const file = event.target.files[0];
            if(file) {
                const reader = new FileReader();
                reader.onload = function(e) { 
                    tempAvatarBase64 = e.target.result; 
                    document.getElementById('editModalInitial').innerHTML = `<img src="${tempAvatarBase64}" class="w-full h-full object-cover">`; 
                };
                reader.readAsDataURL(file);
            }
        }

        function openEditModal() {
            tempAvatarBase64 = user.avatar || null;
            const eCircle = document.getElementById('editModalInitial');
            
            if(tempAvatarBase64) {
                eCircle.innerHTML = `<img src="${tempAvatarBase64}" class="w-full h-full object-cover">`;
            } else {
                eCircle.innerText = user.name.charAt(0).toUpperCase();
            }
            
            document.getElementById('editEmail').value = user.email || 'Tidak ada email';
            document.getElementById('editName').value = user.name;
            document.getElementById('editPhone').value = user.phone.replace('62', '0');
            document.getElementById('editPassword').value = '';
            document.getElementById('editProfileModal').classList.remove('hidden');
        }

        function closeEditModal() {
            document.getElementById('editProfileModal').classList.add('hidden');
            isRequestingOtp = false;
            document.getElementById('editOtpContainer').classList.add('hidden');
            document.getElementById('btnSimpanProfil').innerText = 'Simpan Profil';
            document.getElementById('editOtpInput').value = '';
            document.getElementById('editPassword').value = '';
        }

        async function saveProfile() {
            const oldPhone = user.phone; 
            const newName = document.getElementById('editName').value; 
            const rawPhone = document.getElementById('editPhone').value; 
            const newPhone = rawPhone.startsWith('0') ? '62' + rawPhone.slice(1) : rawPhone; 
            const otp = document.getElementById('editOtpInput').value;
            const newPassword = document.getElementById('editPassword').value;
            
            const bg = '#0b1320'; 
            const col = '#fff';
            
            if(!newName || !rawPhone) {
                return Swal.fire({
                    icon: 'warning', title: 'Gagal', text: 'Nama & No WA wajib diisi!', background: bg, color: col
                });
            }
            
            const isSecureChange = (newPhone !== oldPhone) || (newPassword.trim() !== '');
            
            if(isSecureChange && !isRequestingOtp) {
                Swal.fire({ title: 'Mengirim OTP...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }, background: bg, color: col });
                try {
                    const res = await fetch('/api/auth/request-update-otp', { 
                        method: 'POST', headers: { 'Content-Type': 'application/json' }, 
                        body: JSON.stringify({ oldPhone, newPhone, isPasswordChange: newPassword.trim() !== '' }) 
                    });
                    if(res.ok) {
                        isRequestingOtp = true; 
                        document.getElementById('editOtpContainer').classList.remove('hidden'); 
                        document.getElementById('btnSimpanProfil').innerText = 'Verifikasi & Simpan'; 
                        Swal.fire({ icon: 'success', title: 'Terkirim!', text: 'Cek WA untuk kode OTP.', background: bg, color: col });
                    } else { 
                        Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error, background: bg, color: col }); 
                    }
                } catch(e) { Swal.fire({ icon: 'error', title: 'Oops', text: 'Kesalahan jaringan.', background: bg, color: col }); }
                return;
            }
            
            if(isSecureChange && isRequestingOtp && !otp) {
                return Swal.fire({ icon: 'warning', title: 'Gagal', text: 'Masukkan kode OTP 4 digit!', background: bg, color: col });
            }
            
            Swal.fire({ title: 'Menyimpan...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }, background: bg, color: col });
            
            try {
                const res = await fetch('/api/auth/update', { 
                    method: 'POST', headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ oldPhone, newPhone, newName, otp, avatar: tempAvatarBase64, newPassword }) 
                });
                
                if(res.ok) {
                    user.name = newName; 
                    user.phone = (await res.json()).phone || newPhone; 
                    user.avatar = tempAvatarBase64;
                    localStorage.setItem('user', JSON.stringify(user));
                    
                    Swal.fire({ icon: 'success', title: 'Berhasil', text: 'Profil diperbarui!', background: bg, color: col }).then(() => location.reload());
                } else { Swal.fire({ icon: 'error', title: 'Gagal', text: (await res.json()).error, background: bg, color: col }); }
            } catch(e) { Swal.fire({ icon: 'error', title: 'Oops', text: 'Kesalahan jaringan.', background: bg, color: col }); }
        }

        function deleteAccount() {
            Swal.fire({ 
                title: 'Hapus Akun Permanen?', text: "Akun dan sisa saldo Anda akan hangus!", icon: 'error', 
                showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#1e293b', 
                confirmButtonText: 'Ya, Hapus!', background: '#0b1320', color: '#fff' 
            }).then(async (result) => {
                if (result.isConfirmed) {
                    Swal.fire({ title: 'Menghapus...', allowOutsideClick: false, didOpen: () => { Swal.showLoading() }, background: '#0b1320', color: '#fff' });
                    try {
                        const res = await fetch('/api/auth/delete', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ phone: user.phone }) });
                        if(res.ok) { localStorage.removeItem('user'); Swal.fire({ icon: 'success', title: 'Terhapus', text: 'Akun dihapus.', background: '#0b1320', color: '#fff' }).then(() => { location.href = '/'; }); }
                    } catch(e) { Swal.fire({ icon: 'error', title: 'Error', text: 'Gagal menghapus.', background: '#0b1320', color: '#fff' }); }
                }
            });
        }
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/riwayat.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Transaksi - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="style.css">
    <script>
        tailwind.config = { darkMode: 'class' }
    </script>
    <style>
        .swal2-popup.custom-swal-bg { background-color: #111c2e !important; border-radius: 1.5rem !important; width: 340px !important; padding: 1.5rem !important; border: 1px solid #1e293b; }
        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="bg-[#0b1320] font-sans transition-colors duration-300 text-white">
    <div class="max-w-md mx-auto bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
        
        <div class="flex items-center pt-5 px-5 pb-0 bg-[#0b1320] sticky top-0 z-50">
            <i class="fas fa-chevron-left text-xl cursor-pointer mr-4 text-white" onclick="location.href='/dashboard.html'"></i>
            <h1 class="text-[18px] font-extrabold text-white uppercase tracking-wide">Riwayat Transaksi</h1>
        </div>

        <div class="flex bg-[#0b1320] sticky top-[60px] z-40 border-b border-[#1e293b] mt-4 shadow-sm">
            <div class="flex-1 text-center py-3.5 text-[13px] font-bold text-[#facc15] border-b-[3px] border-[#facc15] cursor-pointer uppercase tracking-wide">
                Produk
            </div>
            <div class="flex-1 text-center py-3.5 text-[13px] font-bold text-gray-500 cursor-pointer uppercase tracking-wide transition-colors" onclick="location.href='/riwayat_topup.html'">
                Topup Saldo
            </div>
        </div>

        <div class="mx-4 mt-4 bg-[#111c2e] p-4 rounded-2xl border border-[#1e293b] shadow-sm">
            <div class="relative mb-4">
                <i class="fas fa-search absolute left-3.5 top-3 text-gray-400 text-sm"></i>
                <input type="text" id="searchInput" onkeyup="filterHistory()" class="w-full bg-[#0b1320] border border-gray-700 text-gray-200 rounded-xl py-2.5 pl-10 pr-4 text-sm font-bold focus:outline-none focus:border-[#facc15]" placeholder="Cari transaksi (Nomor/SN)...">
            </div>
            <div class="flex justify-between mb-2 gap-2">
                <div id="btn-Semua" onclick="setStatusFilter('Semua')" class="flex-1 bg-[#facc15] text-[#0b1320] text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer shadow-sm transition-colors border border-[#facc15]">Semua</div>
                <div id="btn-Sukses" onclick="setStatusFilter('Sukses')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Sukses</div>
                <div id="btn-Proses" onclick="setStatusFilter('Proses')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Proses</div>
                <div id="btn-Gagal" onclick="setStatusFilter('Gagal')" class="flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]">Gagal</div>
            </div>
        </div>

        <div class="px-4 mt-4" id="historyContainer">
            <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
                <i class="fas fa-spinner fa-spin text-4xl mb-4 text-[#facc15]"></i>
            </div>
        </div>

        <div class="fixed bottom-0 w-full max-w-md bg-[#0b1320] border-t border-[#1e293b] flex justify-around p-3 pb-4 shadow-sm z-40">
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/dashboard.html'">
                <i class="fas fa-home text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">HOME</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-[#facc15]">
                <i class="fas fa-file-alt text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/info.html'">
                <i class="fas fa-bell text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">INFO</span>
            </div>
            <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#facc15]" onclick="location.href='/profile.html'">
                <i class="fas fa-user text-xl"></i>
                <span class="text-[10px] mt-1 font-bold">PROFIL</span>
            </div>
        </div>

    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if(!user) window.location.href = '/';
        
        document.getElementById('html-root').classList.add('dark');

        let allTrx = [];
        let currentFilter = 'Semua';

        fetch('/api/user/transactions', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: user.phone })
        })
        .then(r => r.json())
        .then(d => {
            allTrx = d.transactions ? d.transactions.reverse() : [];
            renderHistory();
        })
        .catch(e => {
            document.getElementById('historyContainer').innerHTML = `<div class="mt-10 text-center text-red-500 font-bold">Gagal memuat data.</div>`;
        });

        function setStatusFilter(status) {
            currentFilter = status;
            
            ['Semua', 'Sukses', 'Proses', 'Gagal'].forEach(btn => {
                const el = document.getElementById('btn-' + btn);
                el.className = 'flex-1 bg-transparent text-gray-400 text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer border border-gray-600 transition-colors hover:bg-[#1a2639]';
            });
            
            const activeBtn = document.getElementById('btn-' + status);
            activeBtn.className = `flex-1 bg-[#facc15] text-[#0b1320] text-center py-2 rounded-xl text-[11px] font-bold cursor-pointer shadow-sm transition-colors border border-[#facc15]`;
            
            filterHistory();
        }

        function filterHistory() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            let filtered = allTrx;
            
            if(currentFilter !== 'Semua') {
                filtered = filtered.filter(i => i.status === currentFilter);
            }
            
            if(query) {
                filtered = filtered.filter(i => 
                    (i.produk && i.produk.toLowerCase().includes(query)) || 
                    (i.no_tujuan && i.no_tujuan.includes(query)) || 
                    (i.sn_ref && i.sn_ref.toLowerCase().includes(query))
                );
            }
            
            const c = document.getElementById('historyContainer');
            
            if(!filtered || filtered.length === 0) {
                c.innerHTML = `
                <div class="mt-10 flex flex-col items-center justify-center text-center px-6">
                    <div class="w-[5.5rem] h-[5.5rem] bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-[#1e293b]">
                        <i class="fas fa-receipt text-gray-400 text-4xl"></i>
                    </div>
                    <h2 class="text-white font-bold text-lg tracking-wide mb-2">Transaksi Tidak Ditemukan</h2>
                </div>`;
            } else {
                c.innerHTML = filtered.map((i) => {
                    let sc = '';
                    if(i.status === 'Gagal') {
                        sc = 'text-red-400 border border-red-500/50 bg-red-500/10';
                    } else if(i.status === 'Sukses') {
                        sc = 'text-green-400 border border-green-500/50 bg-green-500/10'; 
                    } else {
                        sc = 'text-[#facc15] border border-[#facc15]/50 bg-[#facc15]/10'; 
                    }
                            
                    let rawIdx = allTrx.indexOf(i);
                    
                    return `
                    <div onclick="showDetailTrx(${rawIdx})" class="bg-[#111c2e] p-4 rounded-[1.2rem] mb-3 border border-[#1e293b] shadow-sm cursor-pointer hover:bg-[#1a2639] transition-colors flex items-center justify-between">
                        <div class="flex items-center gap-3 overflow-hidden">
                            <div class="w-11 h-11 rounded-full bg-[#0b1320] border border-gray-700 flex items-center justify-center shrink-0">
                                <i class="fas fa-box text-gray-400 text-lg"></i>
                            </div>
                            <div class="flex flex-col truncate">
                                <h4 class="font-extrabold text-[13px] text-gray-200 truncate mb-0.5">${i.produk}</h4>
                                <span class="text-[10px] font-medium text-gray-500">${i.date}</span>
                            </div>
                        </div>
                        <div class="flex flex-col items-end shrink-0 pl-2">
                            <p class="text-[14px] font-black text-[#facc15] mb-1.5">Rp ${(i.harga||0).toLocaleString('id-ID')}</p>
                            <span class="text-[9px] font-bold px-2 py-0.5 rounded uppercase tracking-wider ${sc}">${i.status}</span>
                        </div>
                    </div>`;
                }).join('');
            }
        }

        function renderHistory() { filterHistory(); }

        window.komplainTrx = function(harga, tanggal, statusLengkap) {
            let msg = `Halo, saya ingin komplain transaksi dengan nominal Rp ${harga} pada tanggal ${tanggal}. Status: ${statusLengkap}.`;
            window.open(`https://wa.me/6282231154407?text=` + encodeURIComponent(msg), '_blank');
        }

        window.showDetailTrx = function(idx) {
            const i = allTrx[idx];
            let rawStatus = i.status.toLowerCase();
            
            // SENSOR DATA MEMBER SEPARO SESUAI REQUEST BOS
            let rawName = user.name || 'Hamba Allah';
            let maskName = rawName.length > 3 ? rawName.substring(0, 3) + '*'.repeat(rawName.length - 3) : rawName + '***';

            let rawEmail = user.email || 'email@gmail.com';
            let emailParts = rawEmail.split('@');
            let maskEmail = emailParts[0].length > 3 ? emailParts[0].substring(0,3) + '***@' + (emailParts[1] || 'gmail.com') : '***@' + (emailParts[1] || 'gmail.com');

            let rawWa = user.phone || '080000000000';
            let maskWa = rawWa.length > 8 ? rawWa.substring(0, 4) + '****' + rawWa.substring(rawWa.length - 4) : rawWa;
            
            let htmlContent = `
            <h3 class="text-white font-extrabold text-[18px] mb-5 text-center">Detail Transaksi Produk</h3>
            <div class="bg-[#0b1320] border border-[#1e293b] rounded-xl p-4 mb-5 text-left overflow-y-auto max-h-[60vh] hide-scrollbar">
                
                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Data Pelanggan</p>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Nama</span><span class="text-white font-bold text-[12px] text-right">${maskName}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Email</span><span class="text-white font-bold text-[12px] text-right">${maskEmail}</span></div>
                <div class="flex justify-between mb-4"><span class="text-gray-400 font-medium text-[12px]">No. WA</span><span class="text-white font-bold text-[12px] text-right">${maskWa}</span></div>
                
                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Rincian Pembelian</p>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Waktu</span><span class="text-white font-bold text-[11px] text-right">${i.date}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Status</span><span class="${i.status === 'Sukses' ? 'text-green-400' : (i.status === 'Proses' ? 'text-[#facc15]' : 'text-red-400')} font-extrabold text-[12px] text-right uppercase">${i.status}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Produk</span><span class="text-white font-bold text-[12px] text-right ml-4">${i.produk}</span></div>
                <div class="flex justify-between mb-3"><span class="text-gray-400 font-medium text-[12px]">Tujuan</span><span class="text-white font-bold text-[12px] text-right">${i.no_tujuan}</span></div>
                <div class="flex justify-between mb-4"><span class="text-gray-400 font-medium text-[12px]">SN/Ref</span><span class="text-white font-bold text-[10px] text-right break-all ml-4">${i.sn_ref || i.id}</span></div>

                <p class="text-[10px] text-gray-500 font-bold mb-2 uppercase tracking-widest border-b border-[#1e293b] pb-1">Pembayaran</p>
                <div class="flex justify-between"><span class="text-gray-400 font-extrabold text-[13px]">Total Harga</span><span class="text-[#facc15] font-black text-[15px] text-right">Rp ${(i.harga||0).toLocaleString('id-ID')}</span></div>

            </div>
            
            <button onclick="komplainTrx('${(i.harga||0).toLocaleString('id-ID')}', '${i.date}', '${rawStatus}')" class="w-full py-3.5 bg-[#ef4444] hover:bg-[#dc2626] text-white font-extrabold rounded-[12px] mb-3 transition-colors text-[14px]">
                Hubungi Admin (Komplain)
            </button>
            <button onclick="Swal.close()" class="w-full py-3.5 bg-transparent border border-[#334155] text-white hover:bg-[#1a2639] font-extrabold rounded-[12px] transition-colors text-[14px]">
                Tutup
            </button>
            `;
            
            Swal.fire({
                html: htmlContent,
                showConfirmButton: false,
                background: '#111c2e', 
                customClass: { popup: 'custom-swal-bg' },
                padding: 0
            });
        }
    </script>
</body>
</html>
EOF

echo "[PART 4 SELESAI DITULIS. TINGGAL PART 5, 6, 7 (BACKEND & VPS MENU)!]"
echo "[5/8] Menulis logika Backend Node.js (V166 FULL UNCOMPRESSED)..."

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
        if (file === localProductsFile || file === infoFile) return [];
        return {};
    }
};

const saveJSON = (file, data) => {
    fs.writeFileSync(file, JSON.stringify(data, null, 2));
};

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});
if (!fs.existsSync(localProductsFile)) saveJSON(localProductsFile, []);
if (!fs.existsSync(digiCacheFile)) saveJSON(digiCacheFile, { time: 0, data: [] }); 
if (!fs.existsSync(infoFile)) saveJSON(infoFile, []);


// ==========================================
// FUNGSI AUTO MAINTENANCE (23:00 - 00:30 WIB)
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
// 3 BOT TELEGRAM LOGIC
// ==========================================
const sendTeleNotif = async (message, type = 'trx') => {
    let cfg = loadJSON(configFile);
    let token = ''; 
    let chatId = '';

    if (type === 'trx') { 
        token = cfg.teleTokenTrx || cfg.teleToken; 
        chatId = cfg.teleChatIdTrx || cfg.teleChatId; 
    } else if (type === 'topup') { 
        token = cfg.teleTokenTopup || cfg.teleToken; 
        chatId = cfg.teleChatIdTopup || cfg.teleChatId; 
    } else if (type === 'backup') { 
        token = cfg.teleTokenBackup || cfg.teleToken; 
        chatId = cfg.teleChatIdBackup || cfg.teleChatId; 
    }

    if (!token || !chatId) return;

    try { 
        await axios.post(`https://api.telegram.org/bot${token}/sendMessage`, { 
            chat_id: chatId, 
            text: message, 
            parse_mode: 'Markdown' 
        }); 
    } catch(e) {
        console.error("Gagal kirim notif Telegram:", e.message);
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
    let now = new Date();
    let todayStr = now.toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }).split(' ')[0]; 
    let startOfWeek = new Date(now); 
    startOfWeek.setDate(now.getDate() - now.getDay()); 
    let tToday = 0, tWeek = 0, tMonth = 0, tAll = 0;
    
    for (let phone in db) {
        let userTrx = db[phone].transactions || [];
        userTrx.forEach(trx => {
            if(trx.status === 'Sukses' || trx.status === 'Proses') {
                tAll++; 
                let trxDateStr = trx.date.split(',')[0].split(' ')[0]; 
                let dParts = trxDateStr.split('/');
                let trxDateObj = new Date(dParts[2], parseInt(dParts[1])-1, dParts[0]);
                
                if(trxDateStr === todayStr) tToday++;
                if(trxDateObj >= startOfWeek && trxDateObj <= now) tWeek++;
                if(trxDateObj.getMonth() === now.getMonth() && trxDateObj.getFullYear() === now.getFullYear()) tMonth++;
            }
        });
    }
    res.json({ today: tToday, week: tWeek, month: tMonth, all: tAll });
});

// ==========================================
// API BROADCAST (APLIKASI & SOSMED)
// ==========================================
app.post('/api/admin/broadcast', (req, res) => {
    const { judul, message } = req.body; 
    let infoData = loadJSON(infoFile);
    
    infoData.push({ 
        judul: judul || "📢 PENGUMUMAN RESMI", 
        isi: message, 
        date: new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }) 
    });
    
    saveJSON(infoFile, infoData); 
    res.json({ success: true, message: "Broadcast ditambahkan ke Pusat Informasi." });
});

app.post('/api/admin/broadcast-sosmed', async (req, res) => {
    const { message, target } = req.body;
    let config = loadJSON(configFile);
    let successInfo = [];

    // BROADCAST KE TELEGRAM CHANNEL/GROUP
    if (target === 'all' || target === 'tele') {
        if (config.teleChannelId && (config.teleTokenTrx || config.teleToken)) {
            let tkn = config.teleTokenTrx || config.teleToken;
            try {
                await axios.post(`https://api.telegram.org/bot${tkn}/sendMessage`, {
                    chat_id: config.teleChannelId,
                    text: message,
                    parse_mode: 'Markdown'
                });
                successInfo.push('Telegram: Berhasil');
            } catch (e) {
                successInfo.push('Telegram: Gagal (Pastikan Bot jadi Admin Channel/Grup)');
            }
        } else {
            successInfo.push('Telegram: Belum diatur ID-nya');
        }
    }

    // BROADCAST KE WHATSAPP CHANNEL/GROUP
    if (target === 'all' || target === 'wa') {
        if (config.waChannelId && global.waSocket) {
            try {
                await global.waSocket.sendMessage(config.waChannelId, { text: message });
                successInfo.push('WhatsApp: Berhasil');
            } catch (e) {
                successInfo.push('WhatsApp: Gagal (ID Grup/Saluran salah atau Bot belum gabung)');
            }
        } else {
            successInfo.push('WhatsApp: Belum diatur ID-nya atau Bot Mati');
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
        } else if (type === 'data') { 
            filtered = products.filter(p => p.category === 'Data' && p.brand.toLowerCase() === safeBrand); 
            if (category) { 
                const kw = category.toLowerCase().split(' '); 
                filtered = filtered.filter(p => kw.every(k => p.product_name.toLowerCase().includes(k))); 
            } 
        } else if (type === 'ewallet' || type === 'etoll') { 
            filtered = products.filter(p => p.category === 'E-Money' && p.brand.toLowerCase().includes(safeBrand)); 
        } else if (type === 'game') { 
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
        } else if (type === 'pln') { 
            filtered = products.filter(p => p.category === 'PLN'); 
        } else if (type === 'masaaktif') { 
            filtered = products.filter(p => p.category === 'Masa Aktif' && p.brand.toLowerCase() === safeBrand); 
        } else if (type === 'voucher') { 
            filtered = products.filter(p => p.category === 'Voucher' && p.brand.toLowerCase() === safeBrand); 
        } else if (type === 'perdana') { 
            filtered = products.filter(p => p.category === 'Perdana' && p.brand.toLowerCase() === safeBrand); 
        } else if (type === 'smstelpon') { 
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
        
        if (!db[phone]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
        if (db[phone].saldo < price) return res.status(400).json({ error: 'Saldo tidak mencukupi.' });
        
        if (!db[phone].mutasi) db[phone].mutasi = []; 
        if (!db[phone].transactions) db[phone].transactions = [];
        
        db[phone].saldo -= price; 
        let ref_id = 'TRX' + Date.now(); 
        let dateStr = new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }); 
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
                
                if (isDev) digiPayload.testing = true;
                
                let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload, { timeout: 8000 }); 
                let digiData = digiRes.data.data;
                
                if (digiData.status === 'Gagal') { 
                    db[phone].saldo += price; 
                    saveJSON(dbFile, db); 
                    return res.status(400).json({ error: digiData.message || 'Gagal dari provider.' }); 
                } else if (digiData.status === 'Sukses') { 
                    trxStatus = 'Sukses'; 
                    sn_ref = digiData.sn || ''; 
                } else { 
                    trxStatus = 'Proses'; 
                    sn_ref = digiData.sn || ''; 
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
        
        let msgTeleTrx = `🛒 *TRANSAKSI BARU (ORDER MASUK)* 🛒\n\n👤 Nama: ${uData.name}\n✉️ Email: ${uData.email}\n📱 WA: ${phone}\n\n📦 Produk: ${name}\n📱 Tujuan: ${target}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n🔄 Status: ${trxStatus}\n🔖 Ref: ${ref_id}`;
        sendTeleNotif(msgTeleTrx, 'trx'); 
        
        res.json({ message: 'Transaksi berhasil diproses.' });
    } catch (e) { 
        res.status(500).json({ error: 'Terjadi kesalahan internal.' }); 
    }
});

// INTERVAL PENGECEKAN STATUS TRANSAKSI DIGIFLAZZ (TIAP 20 DETIK)
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
                    
                    if (digiData.status === 'Sukses') { 
                        trx.status = 'Sukses'; 
                        trx.sn_ref = digiData.sn || trx.sn_ref; 
                        changed = true; 
                        
                        sendTeleNotif(`✅ *UPDATE: TRANSAKSI SUKSES* ✅\n\n👤 Nama: ${uData.name}\n📱 WA: ${phone}\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}`, 'trx'); 
                    } else if (digiData.status === 'Gagal') { 
                        trx.status = 'Gagal'; 
                        trx.sn_ref = digiData.sn || digiData.message || 'Gagal Pusat'; 
                        user.saldo += trx.harga; 
                        
                        user.mutasi.push({ 
                            id: 'REF'+Date.now(), 
                            type: 'in', 
                            amount: trx.harga, 
                            desc: `Refund: ${trx.produk}`, 
                            date: new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }) 
                        }); 
                        
                        changed = true; 
                        sendTeleNotif(`❌ *UPDATE: TRANSAKSI GAGAL (REFUND)* ❌\n\n👤 Nama: ${uData.name}\n📱 WA: ${phone}\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n⚠️ Alasan: ${digiData.message || 'Gagal Pusat'}`, 'trx'); 
                    }
                } catch(e) {}
            }
        }
    }
    
    if (changed) saveJSON(dbFile, db);
}, 20000); 


// ==========================================
// 🛠️ GENERATOR QRIS DINAMIS (RUMUS CRC16 CCITT)
// ==========================================
function convertCRC16(str) {
    let crc = 0xFFFF;
    for (let c = 0; c < str.length; c++) {
        crc ^= str.charCodeAt(c) << 8;
        for (let i = 0; i < 8; i++) {
            if (crc & 0x8000) crc = (crc << 1) ^ 0x1021;
            else crc = crc << 1;
        }
    }
    let hex = (crc & 0xFFFF).toString(16).toUpperCase();
    return hex.padStart(4, '0');
}

function generateDynamicQris(staticQris, amount) {
    try {
        let qrisWithoutCRC = staticQris.substring(0, staticQris.indexOf("6304"));
        if(!qrisWithoutCRC) return staticQris; 
        
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
// 💰 FUNGSI AUTO-QRIS CHECKER (VIA MUTASI GOPAY BHM) 💰
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
            let res = await axios.get('http://gopay.bhm.biz.id/api/transactions', {
                headers: { 'Authorization': `Bearer ${config.bhmToken}` },
                timeout: 10000
            });
            
            let txs = res.data.data || res.data || [];
            
            for (let p of pendingQris) {
                let targetNominal = parseInt(p.topup.nominal);
                
                // Cari transaksi mutasi GoPay masuk (credit) yang nominalnya PAS
                let matchTx = txs.find(tx => {
                    let amount = parseInt(tx.amount);
                    let isCredit = (tx.type && tx.type.toLowerCase() === 'credit') || parseFloat(tx.amount) > 0;
                    return amount === targetNominal && isCredit;
                });

                if (matchTx) {
                    if (!config.processedGopay) config.processedGopay = [];
                    
                    if (!config.processedGopay.includes(matchTx.transaction_id)) {
                        config.processedGopay.push(matchTx.transaction_id);
                        if(config.processedGopay.length > 500) config.processedGopay.shift();
                        saveJSON(configFile, config);

                        // RECORD SALDO SEBELUM & SESUDAH SESUAI REQUEST BOS
                        let nominalLengkap = targetNominal;
                        let kodeUnik = nominalLengkap % 1000;
                        let salSebelum = db[p.phone].saldo;
                        let salSesudah = salSebelum + nominalLengkap;

                        p.topup.status = 'Sukses';
                        p.topup.saldo_sebelum = salSebelum;
                        p.topup.saldo_sesudah = salSesudah;
                        p.topup.kode_unik = kodeUnik;

                        db[p.phone].saldo = salSesudah;
                        db[p.phone].mutasi.push({ 
                            id: 'TU' + Date.now(), 
                            type: 'in', 
                            amount: nominalLengkap, 
                            desc: 'Topup QRIS Otomatis', 
                            date: new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }) 
                        });
                        
                        changed = true;

                        let uData = webUsers[p.phone] || {name: 'Unknown'};
                        sendTeleNotif(`✅ *TOP UP QRIS OTOMATIS BERHASIL*\n\n👤 Nama: ${uData.name}\n📱 WA: ${p.phone}\n💰 Masuk: Rp ${nominalLengkap.toLocaleString('id-ID')}\n🔖 Ref GoPay: ${matchTx.transaction_id}`, 'topup');
                    }
                }
            }
        } catch (e) {
            console.log("⚠️ Gagal cek mutasi QRIS (BHM GoPay API):", e.message);
        }
    }

    if (changed) saveJSON(dbFile, db);
}, 30000); 

// FUNGSI AUTO BACKUP TELEGRAM
function startAutoBackup() {
    let config = loadJSON(configFile); 
    let t = config.teleTokenBackup || config.teleToken; 
    let c = config.teleChatIdBackup || config.teleChatId;
    
    if (!t || !c || !config.autoBackupHours || config.autoBackupHours <= 0) return;
    
    setInterval(() => {
        let zipName = `AutoBackup_FikyStore_${Date.now()}.zip`;
        exec(`zip -r ${zipName} database.json web_users.json config.json local_products.json info.json`, async (err) => {
            if (!err) { 
                const form = new FormData(); 
                form.append('chat_id', c); 
                form.append('caption', `⏳ *AUTO BACKUP (${config.autoBackupHours} Jam)*\n\nTanggal: ${new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' })}`); 
                form.append('document', fs.createReadStream(zipName)); 
                try { 
                    await axios.post(`https://api.telegram.org/bot${t}/sendDocument`, form, { headers: form.getHeaders() }); 
                } catch(e){} 
                fs.unlinkSync(zipName); 
            }
        });
    }, config.autoBackupHours * 60 * 60 * 1000);
}
setTimeout(startAutoBackup, 15000); 

// ==========================================
// API TOPUP LOGIC (MENYERTAKAN GENERATE QRIS DINAMIS)
// ==========================================
app.post('/api/topup/request', (req, res) => {
    const { phone, method, nominal } = req.body; 
    let config = loadJSON(configFile);
    
    if (isMaintenance()) return res.status(400).json({ error: 'Sistem sedang Maintenance Otomatis.' });
    
    let db = loadJSON(dbFile); 
    let webUsers = loadJSON(webUsersFile); 
    let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
    
    if (!db[phone]) db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    if (!db[phone].topup) db[phone].topup = [];
    
    let expiry = null;
    let finalQrisString = null;

    if (method === 'QRIS Otomatis') {
        expiry = Date.now() + 5 * 60 * 1000; 
        if (config.qrisStringCode) {
            finalQrisString = generateDynamicQris(config.qrisStringCode, nominal);
        } else {
            return res.status(400).json({ error: 'Admin belum menyetting String QRIS di panel VPS.' });
        }
    }

    let dateStr = new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' });
    
    // RECORD AWAL UNTUK SALDO SEBELUM
    let salSebelum = db[phone].saldo;

    const newTopup = { 
        id: 'TU' + Date.now(), 
        method: method, 
        nominal: nominal, 
        status: 'Proses', 
        date: dateStr, 
        expiry: expiry,
        saldo_sebelum: salSebelum, // Disimpan saat request
        kode_unik: nominal % 1000,
        nama: uData.name,     // Disimpan untuk diakses di riwayat
        email: uData.email,   // Disimpan untuk diakses di riwayat
        wa: phone             // Disimpan untuk diakses di riwayat
    };
    
    db[phone].topup.push(newTopup); 
    saveJSON(dbFile, db); 
    
    let kodeUnik = nominal % 1000; 
    let depositAsli = nominal - kodeUnik;
    let msgTopup = `⏳ *TOP UP MENUNGGU PEMBAYARAN* ⏳\n\n👤 Nama: ${uData.name}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n🏦 Metode: ${method}\n💰 Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Unik: ${kodeUnik}\n💵 Diterima: Rp ${nominal.toLocaleString('id-ID')}`;
    
    sendTeleNotif(msgTopup, 'topup'); 
    res.json({ message: 'Top up direkam', qris_string: finalQrisString });
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
    let t = config.teleTokenBackup || config.teleToken; 
    let c = config.teleChatIdBackup || config.teleChatId;
    
    if(!t || !c) return res.status(400).json({ error: "Token/Chat ID Telegram Backup belum disetting." });
    
    let zipName = `Backup_DigitalFikyStore_${Date.now()}.zip`;
    exec(`zip -r ${zipName} database.json web_users.json config.json local_products.json info.json`, async (err) => {
        if(err) return res.status(500).json({ error: "Gagal membuat file ZIP." });
        const form = new FormData(); 
        form.append('chat_id', c); 
        form.append('caption', `📦 *BACKUP MANUAL BERHASIL*`); 
        form.append('document', fs.createReadStream(zipName));
        
        try { 
            await axios.post(`https://api.telegram.org/bot${t}/sendDocument`, form, { headers: form.getHeaders() }); 
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
    
    if(!targetPhone || !webUsers[targetPhone]) return res.json({ success: false, message: '\n❌ Member tidak ditemukan!' });
    if(!db[targetPhone]) db[targetPhone] = { saldo: 0, mutasi: [], topup: [], transactions: [] };
    if(!db[targetPhone].mutasi) db[targetPhone].mutasi = []; 
    if(!db[targetPhone].topup) db[targetPhone].topup = [];
    
    const dateStr = new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' });
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
        sendTeleNotif(`✅ *TOP UP BERHASIL (ADMIN)*\n\n👤 Nama: ${webUsers[targetPhone].name}\n💰 Masuk: Rp ${nominalLengkap.toLocaleString('id-ID')}`, 'topup'); 
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
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' }); 
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email, avatar: webUsers[foundPhone].avatar || null } }); 
    } else { 
        res.status(400).json({ error: 'Email/No HP atau Password salah.' }); 
    }
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) return res.status(400).json({ error: 'Nomor sudah terdaftar.' });
    
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); 
    webUsers[fPhone] = { name, email, password, isVerified: false, otp, otpExpiry: Date.now() + 300000, avatar: null }; 
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
        if (Date.now() > webUsers[phone].otpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        
        webUsers[phone].isVerified = true; 
        delete webUsers[phone].otp; 
        delete webUsers[phone].otpExpiry; 
        saveJSON(webUsersFile, webUsers);
        
        let db = loadJSON(dbFile); 
        if (!db[phone]) { 
            db[phone] = { saldo: 0, mutasi: [], topup: [], transactions: [] }; 
            saveJSON(dbFile, db); 
        }
        
        sendTeleNotif(`🎊 *MEMBER BARU BERGABUNG* 🎊\n\n👤 Nama: ${webUsers[phone].name}\n📱 WA: ${phone}`, 'trx'); 
        res.json({ message: 'Sukses!' });
    } else { 
        res.status(400).json({ error: 'OTP Salah / Sesi tidak valid.' }); 
    }
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body; 
    let webUsers = loadJSON(webUsersFile); 
    let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    
    if (!webUsers[fPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    
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
        if(Date.now() > webUsers[phone].otpExpiry) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
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
    
    if (webUsers[fNew] && fNew !== fOld) return res.status(400).json({ error: 'Nomor baru sudah terdaftar.' });
    if(!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    
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
    
    if (!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    
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
                    } catch (e) {} 
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
    } catch (e) {}
}

// ==========================================
// CATCH-ALL ROUTE ANTI-BUG & RAMAH USER
// ==========================================
app.get('*', (req, res) => {
    let reqPath = req.path;
    
    if (!reqPath.includes('.') && reqPath !== '/') {
        let altPath = path.join(__dirname, 'public', reqPath + '.html');
        if (fs.existsSync(altPath)) return res.sendFile(altPath);
    }

    if (reqPath.endsWith('.html')) {
        let pagePath = path.join(__dirname, 'public', reqPath);
        if (fs.existsSync(pagePath)) return res.sendFile(pagePath);
    }
    
    res.status(404).send(`
        <div style="background-color:#0b1320; color:white; font-family:sans-serif; text-align:center; padding-top:50px; height:100vh;">
            <h1 style="color:#facc15;">FILE TIDAK DITEMUKAN (404)</h1>
            <p>Halaman <b>${reqPath}</b> tidak ada di server.</p>
            <p>Sepertinya file HTML tersebut terpotong saat instalasi VPS (Copy-Paste).</p>
            <br>
            <button onclick="window.location.href='/dashboard.html'" style="background-color:#facc15; border:none; padding:10px 20px; font-weight:bold; border-radius:5px; cursor:pointer; color:#0b1320;">KEMBALI KE DASHBOARD</button>
        </div>
    `); 
});

if (require.main === module) { 
    app.listen(3000, () => { console.log('🌐 Web berjalan di port 3000'); }); 
    startBot(); 
}
EOF

echo "[PART 5 SELESAI DITULIS. TINGGAL 2 PART LAGI!]"
echo "[6/8] Memperbarui Panel Manajemen VPS (V166 FULL UNCOMPRESSED)..."

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
    
    # FETCH SALDO DIGIFLAZZ OTOMATIS
    cd "$HOME/$DIR_NAME"
    SALDO_DIGI=$(node -e "
        const fs = require('fs');
        let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {};
        if (!cfg.digiUser || !cfg.digiKey) {
            console.log('Belum Disetting');
        } else {
            const axios = require('axios');
            const crypto = require('crypto');
            let sign = crypto.createHash('md5').update(cfg.digiUser + cfg.digiKey + 'depo').digest('hex');
            
            axios.post('https://api.digiflazz.com/v1/cek-saldo', { cmd: 'deposit', username: cfg.digiUser, sign: sign }, {timeout: 5000})
            .then(r => {
                if (r.data && r.data.data && r.data.data.deposit !== undefined) {
                    console.log('Rp ' + r.data.data.deposit.toLocaleString('id-ID'));
                } else {
                    console.log('Error/Invalid Key');
                }
            })
            .catch(e => {
                console.log('Gangguan/Timeout');
            });
        }
    " 2>/dev/null)

    clear
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${YELLOW}         💎 PANEL DIGITAL FIKY STORE (V166) 💎        ${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo -e "   💰 SALDO DIGIFLAZZ: ${GREEN}$SALDO_DIGI${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo ""
    echo -e "${PURPLE}[ 🤖 MANAJEMEN BOT WHATSAPP (KHUSUS OTP) ]${NC}"
    echo -e "  ${GREEN}1.${NC} Setup No. Bot & Login Pairing"
    echo -e "  ${GREEN}2.${NC} Jalankan Bot (Latar Belakang/PM2)"
    echo -e "  ${YELLOW}3.${NC} 🛠️ Install & Perbarui Sistem Bot WA"
    echo -e "  ${GREEN}4.${NC} Lihat Log / Error Bot"
    echo -e "  ${GREEN}5.${NC} Reset Sesi & Ganti Nomor Bot"
    echo -e "  ${GREEN}6.${NC} 📢 Broadcast Pengumuman (App, WA Channel, Telegram)"
    echo ""
    echo -e "${PURPLE}[ 📱 MANAJEMEN APLIKASI & WEB ]${NC}"
    echo -e "  ${GREEN}7.${NC} 💰 Manajemen Saldo Member"
    echo -e "  ${GREEN}8.${NC} 🖼️ Sinkronisasi Gambar Banner Lokal"
    echo -e "  ${GREEN}9.${NC} 📈 Seting Keuntungan 14 Tier (Margin GOD MODE)"
    echo -e "  ${GREEN}10.${NC} 📦 Manajemen Produk (Katalog Manual Satu-Satu)"
    echo -e "  ${YELLOW}11.${NC} 🔗 Setup Link Komunitas & ID Saluran Sosmed"
    echo ""
    echo -e "${PURPLE}[ 🌐 MANAJEMEN SERVER & API ]${NC}"
    echo -e "  ${GREEN}12.${NC} Setup Domain (Nginx + Cloudflare + UFW Firewall)"
    echo -e "  ${GREEN}13.${NC} 🔌 Setup API Digiflazz (Untuk Produk)"
    echo -e "  ${YELLOW}14.${NC} 💸 Setup API BHM GoPay (Untuk AUTO QRIS DINAMIS)"
    echo -e "  ${GREEN}15.${NC} 🔄 Refresh Katalog Digiflazz (Hapus Cache API)"
    echo ""
    echo -e "${PURPLE}[ 🛡️ PUSAT KOMANDO TELEGRAM ]${NC}"
    echo -e "  ${GREEN}16.${NC} ⚙️ Setup Telegram Bot (Trx, Topup, Backup)"
    echo -e "  ${GREEN}17.${NC} ⏳ Setting Auto-Backup Telegram (Tiap X Jam)"
    echo -e "  ${GREEN}18.${NC} 💾 BACKUP DATA MANUAL KE TELEGRAM"
    echo -e "  ${GREEN}19.${NC} 📥 RESTORE DATA DARI DIRECT LINK"
    echo ""
    echo -e "${PURPLE}[ ⚙️ SISTEM ]${NC}"
    echo -e "  ${RED}0.${NC} Keluar"
    echo -e "${CYAN}======================================================${NC}"
    read -p "Pilih menu [0-19]: " choice

    case $choice in
        1) 
            clear
            echo -e "${YELLOW}--- SETUP PAIRING BOT WHATSAPP ---${NC}"
            read -p "Masukkan Nomor WA Bot (Awalan 62, cth: 62812...): " botnum
            
            if [ ! -z "$botnum" ]; then
                pm2 stop $BOT_NAME > /dev/null 2>&1
                cd "$HOME/$DIR_NAME"
                
                cat << 'JS' > temp_setup.js
const fs = require('fs');
const file = './config.json';
let config = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
config.botNumber = process.argv[2];
fs.writeFileSync(file, JSON.stringify(config, null, 2));
console.log('Nomor berhasil disimpan!');
JS
                node temp_setup.js "$botnum"
                rm temp_setup.js
                
                echo -e "${GREEN}Meminta kode pairing ke WhatsApp...${NC}"
                echo -e "${CYAN}(Tunggu sekitar 5-10 detik. Jika kode sudah muncul, catat kodenya.)${NC}"
                echo -e "${RED}(Setelah mencatat kode dan berhasil login, tekan CTRL+C lalu pilih menu 2 untuk jalankan bot di background)${NC}"
                
                node index.js
            fi
            ;;
            
        2) 
            cd "$HOME/$DIR_NAME"
            pm2 delete $BOT_NAME 2>/dev/null
            pm2 start index.js --name "$BOT_NAME"
            pm2 save 
            echo -e "${GREEN}Bot berhasil dijalankan di latar belakang!${NC}"
            read -p "Tekan Enter..."
            ;;
            
        3)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}     🛠️ INSTALL & PERBARUI SISTEM BOT WA      ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            cd "$HOME/$DIR_NAME"
            echo "Menghapus cache dan module lama..."
            rm -rf node_modules package-lock.json
            npm cache clean --force
            echo "Menginstal ulang dependensi (Harap tunggu beberapa menit)..."
            npm install
            pm2 restart $BOT_NAME > /dev/null 2>&1
            echo -e "${GREEN}✅ Pembaruan sistem Bot WA selesai!${NC}"
            read -p "Tekan Enter untuk kembali..."
            ;;
            
        4) 
            pm2 logs $BOT_NAME 
            ;;
            
        5) 
            pm2 stop $BOT_NAME 2>/dev/null
            rm -rf "$HOME/$DIR_NAME/sesi_bot"
            echo -e "${GREEN}Sesi WA dihapus. Silahkan atur nomor baru di Menu 1.${NC}"
            read -p "Tekan Enter..." 
            ;;
            
        6)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}     📢 BROADCAST PUSAT INFORMASI & SOSMED     ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "Pilih Target Broadcast:"
            echo "1. Aplikasi Web (Pusat Informasi)"
            echo "2. Telegram Channel / Group"
            echo "3. WhatsApp Channel / Group"
            echo "4. SEMUANYA (Aplikasi, Telegram, WhatsApp)"
            echo ""
            read -p "Pilih [1-4]: " bc_target
            
            read -p "Judul Pesan (Hanya untuk Aplikasi) : " b_judul
            read -p "Isi Pesan Pengumuman               : " b_isi
            
            if [ ! -z "$b_isi" ]; then
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_broadcast.js
const http = require('http');
const targetOpt = process.argv[2];
const judul = process.argv[3];
const message = process.argv[4];

const postData = (path, data) => {
    return new Promise((resolve) => {
        const req = http.request({
            hostname: 'localhost', port: 3000, path: path, method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) }
        }, res => {
            let body = '';
            res.on('data', chunk => body += chunk.toString());
            res.on('end', () => resolve(body));
        });
        req.write(data); req.end();
    });
};

(async () => {
    if (targetOpt === '1' || targetOpt === '4') {
        await postData('/api/admin/broadcast', JSON.stringify({ judul: judul, message: message }));
        console.log('✅ Terkirim ke Aplikasi Web (Pusat Informasi)');
    }
    
    if (targetOpt === '2' || targetOpt === '4') {
        let res = await postData('/api/admin/broadcast-sosmed', JSON.stringify({ message: message, target: 'tele' }));
        console.log(JSON.parse(res).message);
    }
    
    if (targetOpt === '3' || targetOpt === '4') {
        let res = await postData('/api/admin/broadcast-sosmed', JSON.stringify({ message: message, target: 'wa' }));
        console.log(JSON.parse(res).message);
    }
})();
JS
                node temp_broadcast.js "$bc_target" "$b_judul" "$b_isi"
                rm temp_broadcast.js
                echo -e "\n${GREEN}✅ Eksekusi Broadcast Selesai!${NC}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
            
        7)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}         💰 MANAJEMEN SALDO MEMBER             ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "1. Cek Semua Saldo Member"
            echo "2. Tambah Saldo Member"
            echo "3. Kurangi Saldo Member"
            echo "0. Kembali"
            read -p "Pilih [0-3]: " s_menu
            
            if [ "$s_menu" == "1" ]; then
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_cek_saldo.js
const fs = require('fs');
const db = fs.existsSync('./database.json') ? JSON.parse(fs.readFileSync('./database.json')) : {};
const users = fs.existsSync('./web_users.json') ? JSON.parse(fs.readFileSync('./web_users.json')) : {};
console.log('\n--- DAFTAR SALDO MEMBER ---');
for (let p in users) {
    if (users[p].isVerified) {
        console.log('- ' + users[p].name + ' (' + p + ') : Rp ' + (db[p] ? db[p].saldo : 0));
    }
}
console.log('---------------------------\n');
JS
                node temp_cek_saldo.js
                rm temp_cek_saldo.js
                read -p "Tekan Enter..."
                
            elif [ "$s_menu" == "2" ]; then
                read -p "No WA Member (Awalan 62...): " no_mem
                read -p "Jumlah Tambah Saldo: " jm_mem
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_tambah.js
const http = require('http');
const data = JSON.stringify({ identifier: process.argv[2], amount: parseInt(process.argv[3]), action: 'add' });
const req = http.request({ hostname: 'localhost', port: 3000, path: '/api/admin/balance', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } }, res => { res.on('data', c => console.log(c.toString())); });
req.write(data); req.end();
JS
                node temp_tambah.js "$no_mem" "$jm_mem"
                rm temp_tambah.js
                read -p "Tekan Enter..."
                
            elif [ "$s_menu" == "3" ]; then
                read -p "No WA Member (Awalan 62...): " no_mem
                read -p "Jumlah Kurangi Saldo: " jm_mem
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_kurang.js
const http = require('http');
const data = JSON.stringify({ identifier: process.argv[2], amount: parseInt(process.argv[3]), action: 'reduce' });
const req = http.request({ hostname: 'localhost', port: 3000, path: '/api/admin/balance', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } }, res => { res.on('data', c => console.log(c.toString())); });
req.write(data); req.end();
JS
                node temp_kurang.js "$no_mem" "$jm_mem"
                rm temp_kurang.js
                read -p "Tekan Enter..."
            fi
            ;;
            
        8)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}      🖼️ SINKRONISASI GAMBAR BANNER LOKAL     ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo -e "Upload gambar (.jpg, .png, dll) ke direktori berikut via Termius:"
            echo -e "${GREEN}/root/$DIR_NAME/public/banners/${NC}"
            echo ""
            echo "1. Sinkronisasi (Baca gambar dan atasi bug spasi otomatis)"
            echo "2. Hapus Semua Banner (Aplikasi)"
            echo "0. Kembali"
            read -p "Pilih [0-2]: " b_menu
            
            if [ "$b_menu" == "1" ]; then
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_banner.js
const fs = require('fs'); 
const path = './public/banners';
if (!fs.existsSync(path)) fs.mkdirSync(path, {recursive:true});

let rawFiles = fs.readdirSync(path).filter(f => f.match(/\.(jpg|jpeg|png|gif)$/i));
rawFiles.forEach(f => {
    if (f.includes(' ')) {
        let newName = f.replace(/ /g, '_');
        fs.renameSync(path + '/' + f, path + '/' + newName);
    }
});

let finalFiles = fs.readdirSync(path).filter(f => f.match(/\.(jpg|jpeg|png|gif)$/i));
let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {};
cfg.banners = finalFiles;
fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2));
console.log('✅ Berhasil menyinkronkan ' + finalFiles.length + ' banner! (Bug Spasi Fixed via Rename)');
JS
                node temp_banner.js
                rm temp_banner.js
                pm2 restart $BOT_NAME > /dev/null 2>&1
                read -p "Tekan Enter..."
                
            elif [ "$b_menu" == "2" ]; then
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_banner_del.js
const fs = require('fs'); 
let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {};
cfg.banners = [];
fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2));
console.log('✅ Semua banner telah disembunyikan dari aplikasi.');
JS
                node temp_banner_del.js
                rm temp_banner_del.js
                pm2 restart $BOT_NAME > /dev/null 2>&1
                read -p "Tekan Enter..."
            fi
            ;;
            
        9)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}  📈 SETING KEUNTUNGAN 14 TIER (GOD MODE)      ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "Atur keuntungan berdasarkan rentang harga modal asli Digiflazz."
            echo ""
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
            
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_markup.js
const fs = require('fs');
const file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.markupRules = {
    m1: parseInt(process.argv[2]) || 0,
    m2: parseInt(process.argv[3]) || 0,
    m3: parseInt(process.argv[4]) || 0,
    m4: parseInt(process.argv[5]) || 0,
    m5: parseInt(process.argv[6]) || 0,
    m6: parseInt(process.argv[7]) || 0,
    m7: parseInt(process.argv[8]) || 0,
    m8: parseInt(process.argv[9]) || 0,
    m9: parseInt(process.argv[10]) || 0,
    m10: parseInt(process.argv[11]) || 0,
    m11: parseInt(process.argv[12]) || 0,
    m12: parseInt(process.argv[13]) || 0,
    m13: parseInt(process.argv[14]) || 0,
    m14: parseInt(process.argv[15]) || 0
};
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
console.log('\n✅ 14 Tingkatan Keuntungan (God Mode) Berhasil Disimpan!');
JS
            node temp_markup.js "$m1" "$m2" "$m3" "$m4" "$m5" "$m6" "$m7" "$m8" "$m9" "$m10" "$m11" "$m12" "$m13" "$m14"
            rm temp_markup.js
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter untuk kembali..."
            ;;
            
        10)
            clear
            echo "1. Tambah Produk LOKAL"
            echo "2. Hapus Produk LOKAL"
            read -p "Pilih: " pr_menu
            
            if [ "$pr_menu" == "1" ]; then
                echo "1. Pulsa | 2. Data | 3. Game | 4. Voucher | 5. E-Wallet | 6. PLN | 7. E-Toll | 8. Masa Aktif | 9. Perdana | 10. SMS/Telpon"
                read -p "Pilih Tipe [1-10]: " typ
                case $typ in 
                    1) tp="pulsa";; 2) tp="data";; 3) tp="game";; 4) tp="voucher";; 5) tp="ewallet";; 
                    6) tp="pln";; 7) tp="etoll";; 8) tp="masaaktif";; 9) tp="perdana";; 10) tp="smstelpon";;
                esac
                read -p "Brand (XL/DANA dll): " p_brand
                read -p "Kategori Sub: " p_cat
                read -p "Nama Produk: " p_name
                read -p "Harga Modal: " p_price
                read -p "SKU Digiflazz: " p_sku
                
                cd "$HOME/$DIR_NAME" 
                cat << 'JS' > temp_add_prod.js
const fs = require('fs');
let f = './local_products.json';
let data = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f)) : [];
data.push({ id: 'LOC' + Date.now(), type: process.argv[2], brand: process.argv[3], category: process.argv[4], name: process.argv[5], price: parseInt(process.argv[6]) || 0, sku: process.argv[7], isDigi: true });
fs.writeFileSync(f, JSON.stringify(data, null, 2));
console.log('✅ Produk Berhasil Ditambahkan!');
JS
                node temp_add_prod.js "$tp" "$p_brand" "$p_cat" "$p_name" "$p_price" "$p_sku"
                rm temp_add_prod.js
                read -p "Tekan Enter..."
                
            elif [ "$pr_menu" == "2" ]; then
                cd "$HOME/$DIR_NAME" 
                cat << 'JS' > temp_list_prod.js
const fs = require('fs');
let f = './local_products.json';
let data = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f)) : [];
if (data.length === 0) {
    console.log('\nBelum ada produk lokal.');
} else {
    console.log('\n--- DAFTAR PRODUK LOKAL ---');
    data.forEach((p, i) => console.log('[' + i + '] ' + p.name + ' - Rp' + p.price));
}
JS
                node temp_list_prod.js
                rm temp_list_prod.js
                
                read -p "Masukkan Nomor Produk (Angka dalam kurung) yang mau dihapus: " del_id
                if [ ! -z "$del_id" ]; then
                    cat << 'JS' > temp_del_prod.js
const fs = require('fs');
let f = './local_products.json';
let data = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f)) : [];
let idx = parseInt(process.argv[2]);
if (data[idx]) {
    data.splice(idx, 1);
    fs.writeFileSync(f, JSON.stringify(data, null, 2));
    console.log('\n✅ Produk berhasil dihapus!');
} else {
    console.log('\n❌ Nomor ID tidak valid.');
}
JS
                    node temp_del_prod.js "$del_id"
                    rm temp_del_prod.js
                fi
                read -p "Tekan Enter..."
            fi
            ;;
            
        11)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}  🔗 UBAH LINK KOMUNITAS & SETUP ID SOSMED     ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "Kosongkan jika tidak ingin mengubah data saat ini."
            echo ""
            read -p "Link Telegram Channel : " new_tele
            read -p "Link WhatsApp Saluran : " new_wa
            echo ""
            echo "SETUP ID BROADCAST (Dibutuhkan untuk Fitur Broadcast di Menu 6)"
            read -p "ID Grup/Channel Telegram (cth: -1001234567) : " id_tele
            read -p "ID Grup/Saluran WhatsApp (cth: 12036...456@newsletter) : " id_wa
            
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_links.js
const fs = require('fs');
const file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};

if (process.argv[2] && process.argv[2].trim() !== '') cfg.linkTele = process.argv[2].trim();
if (process.argv[3] && process.argv[3].trim() !== '') cfg.linkWa = process.argv[3].trim();
if (process.argv[4] && process.argv[4].trim() !== '') cfg.teleChannelId = process.argv[4].trim();
if (process.argv[5] && process.argv[5].trim() !== '') cfg.waChannelId = process.argv[5].trim();

fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
console.log('\n✅ Data Sosial Media & Komunitas berhasil diperbarui!');
JS
            node temp_links.js "$new_tele" "$new_wa" "$id_tele" "$id_wa"
            rm temp_links.js
            read -p "Tekan Enter untuk kembali..."
            ;;
            
        12)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}        🌐 SETUP DOMAIN (NGINX + UFW)          ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            read -p "Masukkan Nama Domain LENGKAP (cth: digital.myfiky.store): " domain_name
            if [ ! -z "$domain_name" ]; then
                apt-get install nginx ufw -y > /dev/null 2>&1
                ufw allow 80/tcp > /dev/null 2>&1
                ufw allow 443/tcp > /dev/null 2>&1
                cat << EOFNGINX > /etc/nginx/sites-available/$domain_name
server { listen 80; server_name $domain_name; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host \$host; proxy_cache_bypass \$http_upgrade; proxy_set_header X-Real-IP \$remote_addr; proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; proxy_set_header X-Forwarded-Proto \$scheme; } }
EOFNGINX
                ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
                rm -f /etc/nginx/sites-enabled/default
                nginx -t && systemctl restart nginx
                echo -e "${GREEN}✅ Domain $domain_name berhasil dikonfigurasi!${NC}"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
            
        13)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}           🔌 SETUP API DIGIFLAZZ              ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            read -p "Username Digiflazz: " digi_user
            read -p "API Key Digiflazz (Prod/Dev Key): " digi_key
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_digi.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.digiUser = process.argv[2];
cfg.digiKey = process.argv[3];
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
console.log('✅ Konfigurasi API Digiflazz Disimpan!');
JS
            node temp_digi.js "$digi_user" "$digi_key"
            rm temp_digi.js
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
            
        14)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW} 💸 SETUP API GOPAY & QRIS OTOMATIS (BHM BIZ ID) ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "API ini akan menarik transaksi dari akun GoPay Anda,"
            echo "lalu mengkonfirmasi deposit QRIS secara otomatis!"
            echo ""
            read -p "Masukkan API Token BHM Biz Anda: " bhm_token
            read -p "Masukkan Merchant ID (Angka, contoh: 123): " bhm_merchant
            read -p "Masukkan Nomor HP GoPay (08...): " bhm_phone
            echo ""
            echo "Siapkan TEKS STRING dari QRIS Statis Anda."
            echo "Teks QRIS berawalan '000201010211...' dan diakhiri dengan kombinasi 4 huruf/angka (CRC)."
            read -p "Paste TEKS STRING QRIS Anda di sini: " qris_string
            
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_bhm.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};

if (process.argv[2] && process.argv[2] !== '') cfg.bhmToken = process.argv[2];
if (process.argv[3] && process.argv[3] !== '') cfg.bhmMerchantId = process.argv[3];
if (process.argv[4] && process.argv[4] !== '') cfg.bhmGopayNumber = process.argv[4];
if (process.argv[5] && process.argv[5] !== '') cfg.qrisStringCode = process.argv[5];

fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
console.log('\n✅ Data API BHM & String QRIS Statis Berhasil Disimpan!');
JS
            node temp_bhm.js "$bhm_token" "$bhm_merchant" "$bhm_phone" "$qris_string"
            rm temp_bhm.js
            pm2 restart $BOT_NAME > /dev/null 2>&1
            read -p "Tekan Enter untuk kembali..." 
            ;;

        15)
            clear
            cd "$HOME/$DIR_NAME" 
            cat << 'JS' > temp_clear_cache.js
const fs = require('fs'); 
let f = './digi_cache.json'; 
if (fs.existsSync(f)) { 
    fs.unlinkSync(f); 
    console.log('✅ Cache Katalog berhasil dihapus! Katalog akan di-download ulang saat ada yang buka menu.'); 
} else {
    console.log('✅ Cache sudah bersih.');
}
JS
            node temp_clear_cache.js
            rm temp_clear_cache.js
            pm2 restart all > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
            
        16)
            clear
            echo -e "${CYAN}===============================================${NC}"
            echo -e "${YELLOW}      ⚙️ SETUP 3 BOT TELEGRAM (PISAH)           ${NC}"
            echo -e "${CYAN}===============================================${NC}"
            echo "1. Bot Transaksi (Order Masuk, Sukses, Gagal, Member Baru)"
            echo "2. Bot Top Up (Request Top Up, Saldo Admin)"
            echo "3. Bot Backup (Auto Backup & Manual Backup)"
            echo "0. Kembali"
            read -p "Pilih Bot yang mau disetting [0-3]: " bot_sel
            
            if [ "$bot_sel" == "1" ]; then
                read -p "Token Bot Transaksi: " t_trx
                read -p "Chat ID Transaksi: " c_trx
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_tele1.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.teleTokenTrx = process.argv[2];
cfg.teleChatIdTrx = process.argv[3];
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
JS
                node temp_tele1.js "$t_trx" "$c_trx"
                rm temp_tele1.js
                echo -e "${GREEN}✅ Bot Transaksi Disimpan!${NC}"
                
            elif [ "$bot_sel" == "2" ]; then
                read -p "Token Bot Top Up: " t_topup
                read -p "Chat ID Top Up: " c_topup
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_tele2.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.teleTokenTopup = process.argv[2];
cfg.teleChatIdTopup = process.argv[3];
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
JS
                node temp_tele2.js "$t_topup" "$c_topup"
                rm temp_tele2.js
                echo -e "${GREEN}✅ Bot Top Up Disimpan!${NC}"
                
            elif [ "$bot_sel" == "3" ]; then
                read -p "Token Bot Backup: " t_backup
                read -p "Chat ID Backup: " c_backup
                cd "$HOME/$DIR_NAME"
                cat << 'JS' > temp_tele3.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.teleTokenBackup = process.argv[2];
cfg.teleChatIdBackup = process.argv[3];
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
JS
                node temp_tele3.js "$t_backup" "$c_backup"
                rm temp_tele3.js
                echo -e "${GREEN}✅ Bot Backup Disimpan!${NC}"
            fi
            
            pm2 restart all > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
            
        17)
            clear
            echo "Format: 1 untuk tiap 1 jam, 0.5 untuk 30 menit."
            read -p "Berapa Jam Sekali Sistem Melakukan Auto-Backup?: " tele_jam
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_auto.js
const fs = require('fs');
let file = './config.json';
let cfg = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
cfg.autoBackupHours = parseFloat(process.argv[2]);
fs.writeFileSync(file, JSON.stringify(cfg, null, 2));
console.log('✅ Disimpan: Auto Backup dijalankan setiap ' + process.argv[2] + ' Jam!');
JS
            node temp_auto.js "$tele_jam"
            rm temp_auto.js
            pm2 restart all > /dev/null 2>&1
            read -p "Tekan Enter..." 
            ;;
            
        18)
            clear
            echo "Memproses Backup Manual ke Telegram..."
            cd "$HOME/$DIR_NAME"
            cat << 'JS' > temp_backup_man.js
const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');
const {exec} = require('child_process');

let cfg = fs.existsSync('./config.json') ? JSON.parse(fs.readFileSync('./config.json')) : {};
let t = cfg.teleTokenBackup || cfg.teleToken;
let c = cfg.teleChatIdBackup || cfg.teleChatId;

if (!t || !c) {
    console.log('❌ Token/Chat ID Bot Backup belum disetting (Buka Menu 16)');
    process.exit();
}

let zipName = 'Backup_FikyStore_' + Date.now() + '.zip';
exec('zip -r ' + zipName + ' database.json web_users.json config.json local_products.json info.json', (err) => {
    const form = new FormData();
    form.append('chat_id', c);
    form.append('document', fs.createReadStream(zipName));
    form.append('caption', '📦 *BACKUP MANUAL BERHASIL*\n\nTanggal: ' + new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' }));
    form.append('parse_mode', 'Markdown');
    
    axios.post('https://api.telegram.org/bot' + t + '/sendDocument', form, { headers: form.getHeaders() })
    .then(() => {
        console.log('✅ File Backup Berhasil Terkirim ke Telegram Anda!');
        fs.unlinkSync(zipName);
    })
    .catch(e => {
        console.log('❌ Gagal Mengirim ke Telegram. Pastikan Token/Chat ID Benar!');
    });
});
JS
            node temp_backup_man.js
            rm temp_backup_man.js
            read -p "Tunggu sebentar lalu tekan Enter..." 
            ;;
            
        19)
            clear
            read -p "Masukkan Direct Link (URL) File ZIP Backup: " link_zip
            cd "$HOME/$DIR_NAME" 
            wget -qO restore.zip "$link_zip"
            if [ -f "restore.zip" ]; then
                unzip -o restore.zip && rm -f restore.zip
                pm2 restart all > /dev/null 2>&1
                echo -e "${GREEN}✅ Restore Data Selesai! Sistem sudah memuat data lama Anda.${NC}"
            fi
            read -p "Tekan Enter..." 
            ;;
            
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
pm2 restart all > /dev/null 2>&1
echo "=========================================================="
echo "  SISTEM WEB V166 BERHASIL DIPERBARUI SECARA PENUH!       "
echo "  Ketik 'menu' di terminal untuk membuka panel manajemen  "
echo "=========================================================="

EOF
echo "[8/8] Menyelesaikan instalasi dan menyalakan Mesin Autopilot V166..."

cd "$HOME/$DIR_NAME"

echo "Menginstal npm dan menjalankan node module kembali..."
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

# MEMASTIKAN MENU PANEL BISA DIAKSES
chmod +x /usr/bin/menu

clear
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[1;33m       🚀 INSTALASI DIGITAL FIKY STORE V166 SELESAI! 🚀      \033[0m"
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[0;36mFITUR BARU DI V166 (THE PERFECT MASTERPIECE FULL UNCOMPRESSED):\033[0m"
echo -e "  ✅ \033[1;33mPOP-UP QRIS MEWAH\033[0m Bayar QRIS nggak pindah halaman, plus ada Timer!"
echo -e "  ✅ \033[1;33mNOMINAL TOP UP BARU\033[0m Pilihan instan 1K, 5K, 10K, 50K, 100K!"
echo -e "  ✅ \033[1;33mSENSOR DATA MEMBER\033[0m Nama, Email, & WA di detail transaksi disensor (Fik***)!"
echo -e "  ✅ \033[1;33mBROADCAST SOSMED\033[0m Tembak pengumuman ke WA Channel & Telegram via VPS!"
echo -e "  ✅ \033[1;33mAUTO QRIS DINAMIS\033[0m Generate QR & Cek Mutasi GoPay BHM otomatis!"
echo -e "  ✅ \033[1;33mFULL UNCOMPRESSED\033[0m Kode rapi jali, no minify, gampang dibaca & diedit!"
echo -e "\033[0;32m======================================================================\033[0m"
echo -e "\033[1;37mCARA PENGGUNAAN SELANJUTNYA:\033[0m"
echo -e "Ketik perintah: \033[1;32mmenu\033[0m (Lalu tekan Enter untuk buka Panel)"
echo -e "\033[0;32m======================================================================\033[0m"
