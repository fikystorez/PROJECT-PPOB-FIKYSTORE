#!/bin/bash
# ==========================================================
# DIGITAL FIKY STORE - V146 (PART 1 - CORE SYSTEM)
# ==========================================================

if [ "$EUID" -ne 0 ]; then
  echo "Tolong jalankan script ini sebagai root (ketik: sudo su)"
  exit
fi

if command -v dos2unix > /dev/null 2>&1; then dos2unix "$0" > /dev/null 2>&1; fi

DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

echo "=========================================================="
echo "    MENGINSTAL DIGITAL FIKY STORE V146 (PART 1/4)         "
echo "=========================================================="

echo "[1/5] Memperbarui sistem dan direktori..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip nginx ufw -y > /dev/null 2>&1
mkdir -p "$HOME/$DIR_NAME/public/banners"
cd "$HOME/$DIR_NAME"

cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": { "start": "node index.js" },
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

cat << 'EOF' > public/style.css
body { background-color: #fde047; margin: 0; font-family: ui-sans-serif, system-ui, -apple-system, sans-serif; }
.centered-modal-box { background-color: #002147; padding: 2.5rem 1.5rem 2rem 1.5rem; border-radius: 1.2rem; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3); width: 90%; max-width: 360px; text-align: center; position: relative; z-index: 10; margin: auto; margin-top: 10vh; }
.brand-logo-text { font-size: 1.8rem; font-weight: 900; background: linear-gradient(135deg, #fde047 0%, #facc15 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 1.5rem; letter-spacing: 1px; text-transform: uppercase; }
.compact-input-wrapper { position: relative; margin-bottom: 0.85rem; width: 100%; }
.compact-input-box { width: 100%; padding: 0.6rem 0.75rem; border: 1px solid #334155; border-radius: 0.5rem; font-size: 0.875rem; outline: none; background-color: #ffffff; color: #0f172a; }
.compact-input-box:focus { border-color: #fde047; box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); }
.password-toggle { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #94a3b8; }
.btn-yellow { width: 100%; padding: 0.625rem 1rem; background-color: #fde047; color: #002147; font-weight: bold; border-radius: 0.5rem; cursor: pointer; border: none; margin-top: 0.5rem; transition: all 0.2s; }
.btn-yellow:hover { background-color: #facc15; }
.swal2-popup { background-color: #002147 !important; border-radius: 1.5rem !important; color: #ffffff !important; width: 320px !important; }
EOF

cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Login - DIGITAL FIKY STORE</title>
  <link rel="stylesheet" href="style.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
  <div class="centered-modal-box">
    <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
    <h2 class="text-lg font-bold text-white mb-1">LOGIN AKUN</h2>
    <form id="loginForm">
      <div class="compact-input-wrapper"><input type="text" id="identifier" class="compact-input-box" required placeholder="Email / No. HP"></div>
      <div class="compact-input-wrapper"><input type="password" id="password" class="compact-input-box" required placeholder="Password"><i class="fas fa-eye password-toggle" onclick="tglPw('password', this)"></i></div>
      <div class="text-right mb-5 mt-1"><a href="/forgot.html" class="text-[0.8rem] text-[#fde047] font-bold">Lupa password?</a></div>
      <button type="submit" class="btn-yellow">Login Sekarang</button>
    </form>
    <div class="mt-6 text-center text-[0.8rem] text-white">Belum punya akun? <a href="/register.html" class="text-[#fde047] font-bold">Daftar disini</a></div>
  </div>
  <script>
    function tglPw(id,el){const i=document.getElementById(id);if(i.type==='password'){i.type='text';el.classList.replace('fa-eye','fa-eye-slash');}else{i.type='password';el.classList.replace('fa-eye-slash','fa-eye');}}
    document.getElementById('loginForm').addEventListener('submit', async(e)=>{
      e.preventDefault(); const identifier=document.getElementById('identifier').value; const password=document.getElementById('password').value;
      Swal.fire({title:'Checking...',didOpen:()=>Swal.showLoading()});
      const res=await fetch('/api/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({identifier,password})});
      const data=await res.json();
      if(res.ok){ localStorage.setItem('user',JSON.stringify(data.user)); window.location.href='/dashboard.html'; }
      else{ Swal.fire({icon:'error',title:'Gagal',text:data.error,background:'#002147',color:'#fff'}); }
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
  <title>Daftar - DIGITAL FIKY STORE</title>
  <link rel="stylesheet" href="style.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
  <div class="centered-modal-box" id="box-reg">
    <h1 class="brand-logo-text">DIGITAL FIKY STORE</h1>
    <h2 class="text-lg font-bold text-white mb-4">DAFTAR AKUN</h2>
    <form id="regForm">
      <div class="compact-input-wrapper"><input type="text" id="name" class="compact-input-box" required placeholder="Nama Lengkap"></div>
      <div class="compact-input-wrapper"><input type="number" id="phone" class="compact-input-box" required placeholder="Nomor WA"></div>
      <div class="compact-input-wrapper"><input type="email" id="email" class="compact-input-box" required placeholder="Email"></div>
      <div class="compact-input-wrapper"><input type="password" id="password" class="compact-input-box" required placeholder="Password"></div>
      <button type="submit" class="btn-yellow">Daftar Sekarang</button>
    </form>
  </div>
  <div class="centered-modal-box hidden" id="box-otp">
    <h1 class="brand-logo-text">VERIFIKASI OTP</h1>
    <form id="otpForm">
      <div class="compact-input-wrapper"><input type="number" id="otp" class="compact-input-box text-center text-2xl font-bold" required placeholder="XXXX"></div>
      <button type="submit" class="btn-yellow">Verifikasi</button>
    </form>
  </div>
  <script>
    let regPh='';
    document.getElementById('regForm').addEventListener('submit',async(e)=>{
      e.preventDefault();
      const n=document.getElementById('name').value; const p=document.getElementById('phone').value; const em=document.getElementById('email').value; const pw=document.getElementById('password').value;
      Swal.fire({title:'Proses...',didOpen:()=>Swal.showLoading()});
      const res=await fetch('/api/auth/register',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name:n,phone:p,email:em,password:pw})});
      if(res.ok){ regPh=(await res.json()).phone; document.getElementById('box-reg').classList.add('hidden'); document.getElementById('box-otp').classList.remove('hidden'); Swal.close(); }
      else { Swal.fire({icon:'error',text:'Gagal Daftar'}); }
    });
    document.getElementById('otpForm').addEventListener('submit',async(e)=>{
      e.preventDefault(); const otp=document.getElementById('otp').value;
      const res=await fetch('/api/auth/verify',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:regPh,otp})});
      if(res.ok){ Swal.fire({icon:'success',title:'Berhasil'}).then(()=>window.location.href='/'); }
      else { Swal.fire({icon:'error',text:'OTP Salah'}); }
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
  <title>Reset - DIGITAL FIKY STORE</title>
  <link rel="stylesheet" href="style.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-[#fde047] flex flex-col min-h-screen">
  <div class="centered-modal-box">
    <h1 class="brand-logo-text">RESET PASSWORD</h1>
    <form id="fForm">
      <div class="compact-input-wrapper"><input type="number" id="phone" class="compact-input-box" required placeholder="Nomor WA"></div>
      <button type="submit" class="btn-yellow">Kirim OTP</button>
    </form>
    <form id="rForm" class="hidden mt-4">
      <div class="compact-input-wrapper"><input type="number" id="otp" class="compact-input-box text-center" required placeholder="OTP"></div>
      <div class="compact-input-wrapper"><input type="password" id="new" class="compact-input-box" required placeholder="Password Baru"></div>
      <button type="submit" class="btn-yellow">Simpan</button>
    </form>
  </div>
  <script>
    let fPh='';
    document.getElementById('fForm').addEventListener('submit',async(e)=>{
      e.preventDefault(); const p=document.getElementById('phone').value;
      const res=await fetch('/api/auth/forgot',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:p})});
      if(res.ok){ fPh=(await res.json()).phone; document.getElementById('fForm').classList.add('hidden'); document.getElementById('rForm').classList.remove('hidden'); }
    });
    document.getElementById('rForm').addEventListener('submit',async(e)=>{
      e.preventDefault(); const o=document.getElementById('otp').value; const n=document.getElementById('new').value;
      const res=await fetch('/api/auth/reset',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:fPh,otp:o,newPassword:n})});
      if(res.ok){ window.location.href='/'; }
    });
  </script>
</body>
</html>
EOF

echo "[PART 1 SELESAI BOSKUUU!]"
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
  <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="flex justify-between items-center p-4 bg-white dark:bg-[#0b1320] shadow-sm dark:shadow-md sticky top-0 z-40">
      <div class="flex items-center gap-4">
        <i class="fas fa-bars text-xl cursor-pointer text-gray-600 dark:text-gray-300 hover:text-yellow-400" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></i>
        <h1 class="font-medium text-[17px] tracking-wide text-gray-800 dark:text-white" id="headerGreeting">Hai, Member</h1>
      </div>
      <div class="text-[11px] font-bold text-gray-600 dark:text-gray-300 bg-gray-200 dark:bg-white/10 px-3 py-1.5 rounded-full" id="headTrx">0 Trx</div>
    </div>

    <div id="sidebar" class="fixed inset-0 z-[100] transform -translate-x-full transition-transform duration-300 flex">
      <div class="w-full bg-black/60 backdrop-blur-sm" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"></div>
      <div class="absolute top-0 left-0 w-[80%] max-w-[300px] h-full bg-white dark:bg-[#001730] shadow-2xl flex flex-col border-r border-gray-200 dark:border-[#0a2342]">
        <div class="p-8 pb-4 flex flex-col items-center relative border-b border-gray-200 dark:border-gray-800">
          <button class="absolute top-5 right-5 text-gray-400 hover:text-red-500" onclick="document.getElementById('sidebar').classList.toggle('-translate-x-full')"><i class="fas fa-times text-xl"></i></button>
          <div class="w-[4.5rem] h-[4.5rem] bg-gray-200 dark:bg-[#050b14] rounded-full flex justify-center items-center text-[#001730] dark:text-yellow-400 font-extrabold text-3xl mb-3 shadow-md overflow-hidden" id="sidebarInitial">U</div>
          <h3 class="font-bold text-lg text-gray-800 dark:text-white" id="sidebarName">User</h3>
          <p class="text-sm text-gray-500" id="sidebarPhone">08...</p>
        </div>
        <div class="flex-1 overflow-y-auto py-2">
          <ul class="text-[14px]">
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342]" onclick="location.href='/profile.html'"><i class="far fa-user w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Profil Akun</span></li>
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342]" onclick="location.href='/riwayat.html'"><i class="far fa-clock w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Riwayat Transaksi</span></li>
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342]" onclick="location.href='/mutasi.html'"><i class="fas fa-exchange-alt w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Mutasi Saldo</span></li>
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342]" onclick="location.href='/info.html'"><i class="far fa-bell w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Pusat Informasi</span></li>
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center gap-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#0a2342]" onclick="bantuanAdmin()"><i class="fas fa-headset w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Hubungi Admin</span></li>
            <li class="px-6 py-4 border-b border-gray-100 dark:border-[#0a2342] flex items-center justify-between cursor-pointer" onclick="toggleDarkMode()">
              <div class="flex items-center gap-4"><i class="far fa-moon w-6 text-center text-lg text-[#002147] dark:text-gray-300"></i><span class="font-semibold dark:text-gray-100">Mode Gelap</span></div>
              <div class="w-11 h-[22px] bg-gray-300 rounded-full relative" id="darkModeToggleBg"><div class="w-[18px] h-[18px] bg-white rounded-full absolute top-[2px] left-[2px] shadow-md transform transition-transform" id="darkModeToggleDot"></div></div>
            </li>
          </ul>
        </div>
        <div class="p-6">
          <button onclick="logout()" class="w-full py-3 border border-red-500 text-red-500 font-bold rounded-xl hover:bg-red-50 dark:hover:bg-red-900/20">Keluar Akun</button>
        </div>
      </div>
    </div>

    <div class="mx-4 mt-4 bg-[#002147] dark:bg-[#111c2e] rounded-[1.2rem] p-4 text-white relative overflow-hidden shadow-lg border border-[#1e3a8a] dark:border-gray-800">
      <div class="tech-bg opacity-30"></div> 
      <div class="relative z-10 flex justify-between items-center">
        <div class="flex items-center gap-3">
          <div class="w-12 h-12 rounded-xl bg-blue-500/20 flex items-center justify-center text-blue-400 border border-blue-400/20"><i class="fas fa-wallet text-xl"></i></div>
          <div class="flex flex-col">
            <div class="flex items-center gap-2 mb-0.5">
              <span class="text-xs text-gray-300 font-medium">Saldo Aktif <i class="fas fa-eye cursor-pointer hover:text-white" onclick="toggleSaldo()" id="eyeSaldo"></i></span>
            </div>
            <h2 class="text-[19px] font-extrabold mt-0.5" id="displaySaldo">Rp •••••••</h2>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <button class="w-10 h-10 rounded-full bg-blue-500/20 flex items-center justify-center text-blue-400 border border-blue-400/20 hover:bg-blue-500/30 transition-colors z-10" onclick="bantuanAdmin()">
            <i class="fas fa-headset text-lg"></i>
          </button>
          <button class="bg-yellow-400 text-[#001229] px-5 py-2.5 rounded-full text-[13px] font-extrabold shadow-md hover:bg-yellow-500 z-10 relative" onclick="openTopUp()">Topup</button>
        </div>
      </div>
    </div>

    <div id="bannerContainer" class="mx-4 mt-6 relative rounded-[1.2rem] h-[170px] overflow-hidden border border-gray-200 dark:border-gray-800 hidden">
      <div id="promoSlider" class="flex w-full h-full overflow-x-auto snap-x snap-mandatory hide-scrollbar scroll-smooth"></div>
      <div class="absolute bottom-3 left-0 right-0 flex justify-center gap-1.5 z-20" id="promoDots"></div>
    </div>

    <div class="mx-4 mt-4 bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-[1rem] p-3.5 shadow-sm flex justify-between items-center">
      <div class="flex items-center gap-3">
        <div class="w-9 h-9 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center text-[#002147] dark:text-yellow-400 shadow-sm border border-blue-100 dark:border-blue-800/30"><i class="far fa-calendar-alt text-[15px]"></i></div>
        <div class="flex flex-col"><span class="text-[9px] text-gray-400 font-bold uppercase mb-0.5">Tanggal</span><span class="text-xs font-extrabold text-gray-800 dark:text-gray-200" id="realtimeDate">YYYY/MM/DD</span></div>
      </div>
      <div class="h-8 w-px bg-gray-200 dark:bg-gray-700 mx-2"></div>
      <div class="flex items-center gap-3">
        <div class="flex flex-col text-right"><span class="text-[9px] text-gray-400 font-bold uppercase mb-0.5">Waktu</span><span class="text-xs font-extrabold text-gray-800 dark:text-gray-200 tracking-widest" id="realtimeClock">00:00:00</span></div>
        <div class="w-9 h-9 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center text-[#002147] dark:text-yellow-400 shadow-sm border border-blue-100 dark:border-blue-800/30"><i class="far fa-clock text-[15px]"></i></div>
      </div>
    </div>

    <div class="mx-4 mt-8 mb-4">
      <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] ml-1">Layanan Produk</h3>
      <div class="grid grid-cols-4 gap-y-6 gap-x-3">
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pulsa'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-mobile-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">PULSA</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=data'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-globe"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">DATA</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/game.html'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-gamepad"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">GAME</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=voucher'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-ticket-alt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">VOUCHER</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=ewallet'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-wallet"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">E-WALLET</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=pln'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-bolt"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">PLN</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=masaaktif'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-calendar-check"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 text-center">MASA AKTIF</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=perdana'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-sim-card"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 text-center">PERDANA</span>
        </div>
      </div>
    </div>

    <div class="mx-4 mt-8 mb-8">
      <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[16px] ml-1">Produk Digital</h3>
      <div class="grid grid-cols-4 gap-y-6 gap-x-3">
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=tagihan'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-file-invoice-dollar"></i></div><span class="text-[11px] font-bold text-gray-600 dark:text-gray-300">TAGIHAN</span>
        </div>
        <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="location.href='/operator.html?type=etoll'">
          <div class="w-[4.5rem] h-[4.5rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-3xl shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60"><i class="fas fa-id-card"></i></div><span class="text-[10px] font-bold text-gray-600 dark:text-gray-300 text-center">SALDO<br>E-TOLL</span>
        </div>
      </div>
    </div>

    <div class="mx-4 mt-4 mb-8 bg-white dark:bg-[#111c2e] rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm p-4">
      <h3 class="font-extrabold text-gray-800 dark:text-white mb-4 text-[14px]">Statistik Transaksi Saya</h3>
      <div class="grid grid-cols-3 gap-3">
        <div class="bg-blue-50 dark:bg-[#1a2639] p-3 rounded-xl border border-blue-100 dark:border-gray-700 text-center">
          <p class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-1">HARI INI</p>
          <p class="text-[14px] font-extrabold text-[#002147] dark:text-yellow-400" id="statToday">0</p>
        </div>
        <div class="bg-green-50 dark:bg-[#1a2639] p-3 rounded-xl border border-green-100 dark:border-gray-700 text-center">
          <p class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-1">MINGGU INI</p>
          <p class="text-[14px] font-extrabold text-green-600 dark:text-green-400" id="statWeek">0</p>
        </div>
        <div class="bg-purple-50 dark:bg-[#1a2639] p-3 rounded-xl border border-purple-100 dark:border-gray-700 text-center">
          <p class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-1">BULAN INI</p>
          <p class="text-[14px] font-extrabold text-purple-600 dark:text-purple-400" id="statMonth">0</p>
        </div>
      </div>
    </div>

    <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-2xl z-40">
      <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400">
        <i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/riwayat.html'">
        <i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/info.html'">
        <i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-yellow-400" onclick="location.href='/profile.html'">
        <i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span>
      </div>
    </div>

    <div id="topupOverlay" class="fixed inset-0 bg-black/60 z-[110] hidden opacity-0 transition-opacity" onclick="closeTopUp()"></div>
    <div id="topupSheet" class="fixed bottom-0 left-0 right-0 bg-white dark:bg-[#050b14] z-[120] rounded-t-[2rem] transform translate-y-full transition-transform max-w-md mx-auto pb-safe">
      <div class="w-12 h-1.5 bg-gray-300 dark:bg-gray-700 rounded-full mx-auto my-3"></div>
      <div class="px-6 pb-6">
        <div class="flex justify-between mb-5">
          <h3 class="font-extrabold text-gray-800 dark:text-white">Isi Saldo</h3>
          <i class="fas fa-times text-gray-400 text-xl cursor-pointer" onclick="closeTopUp()"></i>
        </div>
        
        <div class="relative w-full mb-4">
          <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 font-bold">Rp</span>
          <input type="number" id="inputNominal" class="w-full bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-700 rounded-xl py-3 pl-10 pr-4 text-gray-800 dark:text-white font-bold focus:outline-none" placeholder="Ketik nominal...">
        </div>

        <div class="flex justify-between gap-2 mb-6">
          <button onclick="document.getElementById('inputNominal').value=10000" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl">10K</button>
          <button onclick="document.getElementById('inputNominal').value=20000" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl">20K</button>
          <button onclick="document.getElementById('inputNominal').value=50000" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl">50K</button>
          <button onclick="document.getElementById('inputNominal').value=100000" class="flex-1 bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 dark:text-white font-extrabold py-2.5 rounded-xl">100K</button>
        </div>

        <div class="flex flex-col gap-3 mb-6">
          <div onclick="selM('wa')" id="m-wa" class="flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-xl cursor-pointer">
            <div class="flex items-center gap-3">
              <i class="fab fa-whatsapp text-2xl text-green-500"></i>
              <div class="flex flex-col">
                <span class="font-bold text-sm dark:text-white">Manual WA</span>
                <span class="text-[10px] text-gray-500 leading-tight">Transfer ke admin</span>
              </div>
            </div>
            <div id="r-wa" class="w-5 h-5 rounded-full border-[3px] border-gray-400"></div>
          </div>
          <div onclick="selM('qris')" id="m-qris" class="flex items-center justify-between bg-gray-50 dark:bg-[#0b1320] border border-gray-200 dark:border-gray-800 p-3 rounded-xl cursor-pointer">
            <div class="flex items-center gap-3">
              <i class="fas fa-qrcode text-2xl dark:text-white"></i>
              <div class="flex flex-col">
                <span class="font-bold text-sm dark:text-white">Otomatis QRIS</span>
                <span class="text-[10px] text-gray-500 leading-tight">Otomatis masuk (Wajib 2 digit)</span>
              </div>
            </div>
            <div id="r-qris" class="w-5 h-5 rounded-full border-[3px] border-gray-400"></div>
          </div>
        </div>

        <button onclick="prosesTopup()" class="w-full py-3.5 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-extrabold rounded-xl shadow-md hover:opacity-90 mb-3">Lanjutkan Pembayaran</button>
        <button onclick="location.href='/riwayat_topup.html'" class="w-full py-3.5 bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 font-extrabold rounded-xl hover:bg-gray-200 dark:hover:bg-gray-700">Riwayat Top Up</button>
      </div>
    </div>
  </div>

  <script>
    const user=JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    
    document.getElementById('headerGreeting').innerText="Hai, "+user.name;
    document.getElementById('sidebarName').innerText=user.name;
    document.getElementById('sidebarPhone').innerText=user.phone;
    if(user.avatar) document.getElementById('sidebarInitial').innerHTML=`<img src="${user.avatar}" class="w-full h-full rounded-full object-cover border-2 border-gray-200 dark:border-none">`;
    else document.getElementById('sidebarInitial').innerText=user.name.charAt(0).toUpperCase();

    let qrisImg='https://upload.wikimedia.org/wikipedia/commons/a/a2/Logo_QRIS.svg';
    let sel=''; let curSal=0; let hideS=localStorage.getItem('hideSaldo')==='true';

    function updateDateTime() {
      const now = new Date();
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

    function updSal(){
      const el=document.getElementById('displaySaldo'); const e=document.getElementById('eyeSaldo');
      if(hideS){ el.innerText='Rp •••••••'; e.className='fas fa-eye-slash cursor-pointer text-gray-400 hover:text-white'; }
      else{ el.innerText='Rp '+curSal.toLocaleString('id-ID'); e.className='fas fa-eye cursor-pointer text-gray-400 hover:text-white'; }
    }
    function toggleSaldo(){ hideS=!hideS; localStorage.setItem('hideSaldo',hideS); updSal(); }
    function toggleSidebar(){ document.getElementById('sidebar').classList.toggle('-translate-x-full'); }

    function applyDark(){
      const d = localStorage.getItem('darkMode')==='true';
      const r = document.getElementById('html-root');
      const dot = document.getElementById('darkModeToggleDot');
      const bg = document.getElementById('darkModeToggleBg');
      if(d){ r.classList.add('dark'); if(dot)dot.classList.add('translate-x-5'); if(bg)bg.classList.replace('bg-gray-300','bg-blue-500'); }
      else{ r.classList.remove('dark'); if(dot)dot.classList.remove('translate-x-5'); if(bg)bg.classList.replace('bg-blue-500','bg-gray-300'); }
    }
    function toggleDarkMode(){ localStorage.setItem('darkMode',!(localStorage.getItem('darkMode')==='true')); applyDark(); }
    if(localStorage.getItem('darkMode')===null) localStorage.setItem('darkMode','true'); 
    applyDark();

    function logout(){
      Swal.fire({title:'Keluar Akun?', text:'Apakah kamu yakin ingin keluar?', icon:'warning',showCancelButton:true,background:localStorage.getItem('darkMode')==='true'?'#0b1320':'#fff',color:localStorage.getItem('darkMode')==='true'?'#fff':'#000'}).then(r=>{
        if(r.isConfirmed){localStorage.removeItem('user');window.location.href='/';}
      });
    }
    function bantuanAdmin(){ window.open(`https://wa.me/6282231154407?text=`+encodeURIComponent(`Halo Admin DIGITAL FIKY STORE, saya butuh bantuan.`),'_blank'); }

    fetch('/api/user/balance',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:user.phone})}).then(r=>r.json()).then(d=>{curSal=d.saldo;updSal();});
    
    // STATISTIK TRANSAKSI LOGIC
    fetch('/api/user/transactions',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:user.phone})}).then(r=>r.json()).then(d=>{
      let trxs = d.transactions || [];
      document.getElementById('headTrx').innerText = trxs.length + ' Trx';
      
      let now = new Date();
      let todayStr = now.toLocaleString('id-ID').split(' ')[0]; // Ambil DD/MM/YYYY
      
      let startOfWeek = new Date(now);
      startOfWeek.setDate(now.getDate() - now.getDay()); // Mulai dari minggu berjalan
      
      let tToday = 0; let tWeek = 0; let tMonth = 0;
      
      trxs.forEach(trx => {
          if(trx.status === 'Sukses' || trx.status === 'Proses') {
              let trxDateStr = trx.date.split(' ')[0]; 
              
              // Parse DD/MM/YYYY ke Date Object
              let dParts = trxDateStr.split('/');
              let trxDateObj = new Date(dParts[2], dParts[1]-1, dParts[0]);

              if(trxDateStr === todayStr) tToday++;
              if(trxDateObj >= startOfWeek && trxDateObj <= now) tWeek++;
              if(trxDateObj.getMonth() === now.getMonth() && trxDateObj.getFullYear() === now.getFullYear()) tMonth++;
          }
      });

      document.getElementById('statToday').innerText = tToday;
      document.getElementById('statWeek').innerText = tWeek;
      document.getElementById('statMonth').innerText = tMonth;
    });

    fetch('/api/config').then(r=>r.json()).then(d=>{
      if(d.qrisUrl) qrisImg=d.qrisUrl;
      if(d.banners && d.banners.length>0){
        const bc = document.getElementById('bannerContainer');
        if(bc) {
          bc.classList.remove('hidden');
          const s=document.getElementById('promoSlider'); const dc=document.getElementById('promoDots');
          s.innerHTML = d.banners.map(fileName=>`<div class="w-full h-full shrink-0 snap-center relative"><img src="/banners/${fileName}" class="absolute inset-0 w-full h-full object-cover"></div>`).join('');
          let dH=''; for(let i=0;i<d.banners.length;i++) dH+=`<div class="w-2 h-2 rounded-full bg-white opacity-${i===0?'100':'40'} dot-indicator shadow-sm"></div>`;
          dc.innerHTML=dH;
          let dots=document.querySelectorAll('.dot-indicator'); let cS=0;
          s.addEventListener('scroll',()=>{
            let sI=Math.round(s.scrollLeft/s.clientWidth);
            dots.forEach((dt,i)=>{dt.classList.toggle('opacity-100',i===sI);dt.classList.toggle('opacity-40',i!==sI);});
            cS=sI;
          });
          setInterval(()=>{cS=(cS+1)%(dots.length||1);s.scrollTo({left:cS*s.clientWidth,behavior:'smooth'});},3500);
        }
      }
    });

    function openTopUp(){ document.getElementById('topupOverlay').classList.remove('hidden'); setTimeout(()=>{ document.getElementById('topupOverlay').classList.remove('opacity-0'); document.getElementById('topupSheet').classList.remove('translate-y-full'); },10); }
    function closeTopUp(){ document.getElementById('topupSheet').classList.add('translate-y-full'); document.getElementById('topupOverlay').classList.add('opacity-0'); setTimeout(()=>document.getElementById('topupOverlay').classList.add('hidden'),300); }
    
    function selM(m){
      sel=m; const isD=localStorage.getItem('darkMode')==='true';
      ['wa','qris'].forEach(x=>{
        document.getElementById('r-'+x).className='w-5 h-5 rounded-full border-[3px] border-gray-300 dark:border-gray-600 bg-transparent shrink-0';
        document.getElementById('m-'+x).classList.remove('border-yellow-400','border-[#002147]');
      });
      document.getElementById('r-'+m).className='w-5 h-5 rounded-full border-[6px] border-[#002147] dark:border-yellow-400 bg-white dark:bg-[#050b14] shrink-0';
      document.getElementById('m-'+m).classList.add(isD?'border-yellow-400':'border-[#002147]');
    }

    async function prosesTopup(){
      const n = parseInt(document.getElementById('inputNominal').value);
      const isD = localStorage.getItem('darkMode')==='true'; const bg=isD?'#0b1320':'#fff'; const c=isD?'#fff':'#000';
      
      if(!n||n<=0) return Swal.fire({icon:'warning',title:'Gagal',text:'Isi nominal valid!',background:bg,color:c});
      if(!sel) return Swal.fire({icon:'warning',title:'Gagal',text:'Pilih metode pembayaran!',background:bg,color:c});
      
      const fn = n + Math.floor(Math.random()*90)+10;
      if(sel === 'qris'){
        if(n<10000) return Swal.fire({icon:'warning',title:'Gagal',text:'Minimal Rp 10.000',background:bg,color:c});
        closeTopUp();
        await fetch('/api/topup/request',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:user.phone,method:'QRIS Otomatis',nominal:fn})});
        setTimeout(()=>{
          Swal.fire({
            title:`<span class="font-bold text-lg">Scan QRIS</span>`,
            html:`<p class="text-4xl text-yellow-500 font-extrabold mb-2">Rp ${fn.toLocaleString('id-ID')}</p><div class="bg-red-100 text-red-600 px-3 py-1 rounded-full text-xs font-bold mb-3 animate-pulse">Sisa Waktu: <span id="qrisTimer">05:00</span></div><div class="bg-white p-3 rounded-xl inline-block border border-gray-200 mb-2"><img src="${qrisImg}" class="w-48 h-48 object-cover"></div><p class="text-xs text-blue-500">Transfer TEPAT sesuai nominal (3 digit akhir) agar otomatis masuk.</p>`,
            showCancelButton:true,confirmButtonText:'Sudah Transfer',cancelButtonText:'Tutup',background:bg,color:c,
            didOpen:()=>{
              let t=300; let tmr=document.getElementById('qrisTimer');
              timerInterval=setInterval(()=>{ t--; let m=Math.floor(t/60).toString().padStart(2,'0'); let s=(t%60).toString().padStart(2,'0'); if(tmr) tmr.innerText=`${m}:${s}`; if(t<=0){ clearInterval(timerInterval); Swal.close(); location.href='/riwayat_topup.html'; } },1000);
            }, willClose:()=>clearInterval(timerInterval)
          }).then(r=>{
            if(r.isConfirmed){Swal.fire({icon:'success',title:'Diproses',text:'Sistem sedang memverifikasi...',timer:2000,background:bg,color:c}).then(()=>location.href='/riwayat_topup.html')}
            else location.href='/riwayat_topup.html'
          })
        },300);
      }else{
        closeTopUp();
        fetch('/api/topup/request',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:user.phone,method:'Manual WA',nominal:fn})}).then(()=>{
          window.open(`https://wa.me/6282231154407?text=`+encodeURIComponent(`Halo Admin DIGITAL FIKY STORE, saya mau Top Up Saldo Manual.\nNomor Akun: ${user.phone}\nNominal: *Rp ${fn.toLocaleString('id-ID')}*\n\nMohon instruksi selanjutnya.`),'_blank');
          setTimeout(()=>location.href='/riwayat_topup.html',1000);
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
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800 shrink-0">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="goBack()"></i>
      <h1 class="text-[18px] font-bold text-gray-800 dark:text-white uppercase" id="pageTitle">Layanan</h1>
    </div>

    <div class="flex-1 overflow-y-auto hide-scrollbar pb-10">
      <div id="operatorContainer" class="block">
        <div class="px-4 mt-6">
          <div class="bg-white dark:bg-[#111c2e] rounded-2xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-sm" id="opListRender"></div>
        </div>
      </div>

      <div id="categoryContainer" class="hidden">
        <div class="flex justify-between items-center px-5 py-4 bg-black dark:bg-[#001229] text-white">
          <span class="font-bold text-[15px]" id="catSubtitle">Pilih Kategori</span>
          <i class="fas fa-home text-lg cursor-pointer hover:text-yellow-400" onclick="location.href='/dashboard.html'"></i>
        </div>
        <div class="bg-white dark:bg-[#111c2e] shadow-sm pb-4" id="categoryList"></div>
      </div>

      <div id="productContainer" class="hidden">
        <div class="flex justify-between items-center px-5 py-4 bg-black dark:bg-[#001229] text-white">
          <span class="font-bold text-[15px]" id="prodSubtitle">Pilih Produk</span>
          <i class="fas fa-home text-lg cursor-pointer hover:text-yellow-400" onclick="location.href='/dashboard.html'"></i>
        </div>
        <div class="px-4 py-4 bg-white dark:bg-[#0b1320] border-b border-gray-200 dark:border-gray-800">
          <label class="text-[10px] text-gray-500 font-bold mb-2 block uppercase" id="targetLabel">Target / Tujuan</label>
          <div class="relative flex items-center">
            <input type="text" id="inputTarget" class="w-full bg-gray-50 dark:bg-[#1a2639] border border-gray-300 dark:border-gray-700 text-gray-800 dark:text-white rounded-xl py-3 pl-4 pr-24 text-sm font-bold focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400" placeholder="Ketik target...">
            <div id="prefixIcon" class="absolute right-12 font-bold text-[10px] uppercase px-2 py-1 rounded bg-blue-100 text-blue-700 dark:bg-[#002147] dark:text-yellow-400 hidden"></div>
          </div>
        </div>
        <div class="bg-white dark:bg-[#111c2e] shadow-sm pb-4" id="productList"></div>
      </div>
    </div>
  </div>

  <div id="detailOverlay" class="fixed inset-0 bg-black/60 z-[130] hidden opacity-0 transition-opacity" onclick="closeDetail()"></div>
  <div id="detailSheet" class="fixed bottom-0 left-0 right-0 bg-white dark:bg-[#050b14] z-[140] rounded-t-[2rem] transform translate-y-full transition-transform max-w-md mx-auto flex flex-col max-h-[85vh]">
    <div class="w-12 h-1.5 bg-gray-300 dark:bg-gray-700 rounded-full mx-auto my-3 shrink-0"></div>
    <div class="px-5 pb-2 border-b border-gray-200 dark:border-gray-800 shrink-0 flex justify-between">
      <h3 class="font-extrabold text-gray-800 dark:text-white">Detail Produk</h3>
      <i class="fas fa-times text-gray-400 hover:text-red-500 text-xl cursor-pointer" onclick="closeDetail()"></i>
    </div>
    <div class="p-5 overflow-y-auto hide-scrollbar flex-1">
      <div class="flex items-start gap-3 mb-4">
        <div class="w-10 h-10 rounded-full bg-blue-50 dark:bg-[#111c2e] border border-blue-100 dark:border-gray-700 flex items-center justify-center text-[#002147] dark:text-yellow-400 text-lg shrink-0 mt-1"><i class="fas fa-box"></i></div>
        <div>
          <h4 class="font-extrabold text-[15px] text-gray-800 dark:text-white" id="dtName">-</h4>
          <p class="font-black text-lg text-[#002147] dark:text-yellow-400 mt-1" id="dtPrice">Rp 0</p>
        </div>
      </div>
      <div class="bg-gray-50 dark:bg-[#111c2e] rounded-xl p-3 mb-4 border border-gray-200 dark:border-gray-800 flex justify-between">
        <span class="text-xs font-bold text-gray-500">No Tujuan:</span>
        <span class="text-sm font-bold text-red-500" id="dtTarget">Kosong</span>
      </div>
      <div>
        <span class="text-xs font-bold text-gray-500 mb-2 block">Deskripsi:</span>
        <div class="bg-gray-50 dark:bg-[#111c2e] rounded-xl p-3 text-[11px] text-gray-600 dark:text-gray-300 border border-gray-200 dark:border-gray-800 leading-relaxed" id="dtDesc">Desc...</div>
      </div>
    </div>
    <div class="p-5 border-t border-gray-200 dark:border-gray-800 bg-white dark:bg-[#050b14]">
      <div class="flex gap-3 mb-3">
        <button class="flex-1 py-2.5 rounded-xl border border-gray-300 dark:border-gray-700 font-bold text-sm text-gray-600 dark:text-gray-300" onclick="closeDetail()">Kembali</button>
        <button class="flex-1 py-2.5 rounded-xl bg-green-600 text-white font-bold text-sm shadow-sm" onclick="bantuanAdmin()"><i class="fab fa-whatsapp mr-1"></i> Tanya CS</button>
      </div>
      <button id="btnLanjutkan" class="w-full py-3.5 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-bold rounded-xl text-sm opacity-50 cursor-not-allowed shadow-md" onclick="executeBuy()">Lanjutkan Pembayaran</button>
    </div>
  </div>

  <script>
    if(!localStorage.getItem('user')) {
        window.location.href='/';
    }
    
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) {
        document.getElementById('html-root').classList.add('dark');
    }
    
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

    // OPERATOR DASAR
    const o = {
      xl: {name:'XL', logo:'XL', digiBrand:'XL'},
      axis: {name:'AXIS', logo:'AXIS', digiBrand:'AXIS'},
      telkomsel: {name:'TELKOMSEL', logo:'TS', digiBrand:'TELKOMSEL'},
      indosat: {name:'INDOSAT', logo:'IS', digiBrand:'INDOSAT'},
      tri: {name:'TRI', logo:'3', digiBrand:'TRI'},
      smartfren: {name:'SMARTFREN', logo:'SF', digiBrand:'SMARTFREN'},
      byu: {name:'BY.U', logo:'BY.U', digiBrand:'BYU'}
    };

    // KATEGORI DATA 
    const dC = JSON.parse(JSON.stringify(o));
    
    dC['xl'].items = [
        'AKRAB','CIRCLE','XL DATA','BEBAS PUAS','XL CUANKU','XL XTRA DIGITAL','HARIAN',
        'HOTROAD SPESIAL','COMBO FLEX','XL Data Flex Mini (Baru)','XL Data FLex (Baru)',
        'FLEX MAX','ULTRA 5G+','XTRA COMBO','XTRA COMBO GIFT','XTRA COMBO LITE',
        'XTRA COMBO MINI','DATA GIFT','BONUS HARIAN','XL DATA GAMES','XL KUOTA GAMES',
        'GAMES','ROAMING','GRAB GACOR','X-TRA ON','BLUE','XL PASS','XL UMROH','TEMBAK XL'
    ];
    
    dC['axis'].items = [
        'Umum', 'Mini', 'Kzl', 'Bronet', 'Owsem', 'Conference', 'Edukasi', 'Ekstra', 
        'Youtube', 'Sosmed', 'Harian', 'BOY', 'Paket Warnet', 'Sulutra', 'Aigo SS', 
        'Combo Mabrur', 'Mabrur', 'Video', 'Musik', 'Games', 'Sunset', 'Komik', 
        'Bronet Vidio', 'Mdra Sdrj Mlng Smbw', 'Viu', 'Pure', 'Cek Paket', 'DRP Games', 
        'Obor', 'Edu Confrence', 'Apps Games', 'AIGO Unlimited', 'Bagi Kuota'
    ];
    
    dC['indosat'].items = [
        'Umum', 'Gift Data', 'Yellow', 'Freedom Combo', 'Freedom Harian', 'Freedom Internet', 
        'Roaming', 'Freedom U', 'Freedom Apps', 'Freedom Longlife', 'Yellow Gift', 
        'Kalisumapa', 'Sumatera', 'EJBN', 'Freedom U Gift', 'Freedom Combo Gift', 
        'Freedom Internet Gift', 'Umroh Haji Combo', 'Umroh Haji Internet', 'Freedom Max', 
        'UMKM', 'Extra Booster Gift', 'gaspol', 'Sachet', 'Community', 'Pure Merdeka', 
        'Kita', 'SMB', 'Ramadan', 'Freedom Apps Gift', 'HiFi Air', 'Freedom Internet 5G', 
        'Freedom Spesial', 'Freedom Play'
    ];
    
    dC['tri'].items = [
        'Umum', 'Mini', 'AlwaysOn', 'GetMore', 'Mix', 'Home', 'Roaming', 'Data Transfer', 
        'Happy', 'Lokal', 'Chat', 'H3RO', 'EJBN', 'Ibadah', 'Addon', 'KeepOn', 'Happy Play', 
        'Pure 7 Hari', 'Pure 14 Hari', 'Pure 30 Hari', 'Ramadan', 'HiFi Air', 'Kikida', 'Happy 5G'
    ];
    
    dC['smartfren'].items = [
        'Umum', 'Unlimited', 'Volume', 'Roaming', 'Youtube', 'Connex Evo', 'Gokil Max', 
        'Nonstop', 'Chat', 'Sosmed', 'Unlimited Nonstop', 'Musik', 'Games', 'Kuota', 
        'Tiktok', 'Mandiri', 'Nonton', 'Unlimited Harian 5G', 'Unlimited Nonstop 5G', 'Kuota 5G'
    ];
    
    dC['byu'].items = [
        'Paket Data Umum','Paket Data Topping','BY.U CUANKU PROMO',
        'Paket Data Mbps','Paket Data Kaget','Paket Data Super Kaget','Paket Data Jajan'
    ];

    // GAME
    const g = {
      free_fire: {name:'Free Fire',logo:'fas fa-gamepad',isIcon:true,digiBrand:'FREE FIRE'},
      mobile_legends: {name:'Mobile Legends',logo:'fas fa-gamepad',isIcon:true,digiBrand:'MOBILE LEGENDS'},
      pubg_mobile: {name:'PUBG Mobile',logo:'fas fa-gamepad',isIcon:true,digiBrand:'PUBG MOBILE'},
      valorant: {name:'Valorant',logo:'fas fa-gamepad',isIcon:true,digiBrand:'VALORANT'}
    };

    // KATEGORI GAME
    const gC = JSON.parse(JSON.stringify(g));
    gC['mobile_legends'].items = ['Weekly Diamond Pass', 'Diamond'];
    gC['free_fire'].items = ['Membership', 'Diamond'];

    const e = {
      dana: {name:'DANA',logo:'DN',digiBrand:'DANA'},
      gopay: {name:'GOPAY',logo:'GP',digiBrand:'GO PAY'},
      shopeepay: {name:'SHOPEEPAY',logo:'SP',digiBrand:'SHOPEE PAY'},
      ovo: {name:'OVO',logo:'OV',digiBrand:'OVO'},
      linkaja: {name:'LINKAJA',logo:'LA',digiBrand:'LINKAJA'}
    };

    const etoll = {
      bni: {name:'BNI TapCash',logo:'BNI',digiBrand:'TAPCASH'},
      bri: {name:'BRI Brizzi',logo:'BRI',digiBrand:'BRIZZI'},
      mandiri: {name:'Mandiri Emoney',logo:'MDR',digiBrand:'E-MONEY'}
    };

    // OPERATOR VOUCHER
    const v = {
      telkomsel: {name:'TELKOMSEL', logo:'TS', digiBrand:'TELKOMSEL'},
      indosat: {name:'INDOSAT', logo:'IS', digiBrand:'INDOSAT'},
      tri: {name:'TRI', logo:'3', digiBrand:'TRI'},
      axis: {name:'AXIS', logo:'AXIS', digiBrand:'AXIS'},
      smartfren: {name:'SMARTFREN', logo:'SF', digiBrand:'SMARTFREN'},
      google_play: {name:'GOOGLE PLAY INDONESIA', logo:'GP', digiBrand:'GOOGLE PLAY INDONESIA'},
      spotify: {name:'SPOTIFY', logo:'SP', digiBrand:'SPOTIFY'}
    };

    // OPERATOR PERDANA
    const prd = {
      telkomsel: {name:'TELKOMSEL', logo:'TS', digiBrand:'TELKOMSEL'},
      indosat: {name:'INDOSAT', logo:'IS', digiBrand:'INDOSAT'},
      tri: {name:'TRI', logo:'3', digiBrand:'TRI'},
      axis: {name:'AXIS', logo:'AXIS', digiBrand:'AXIS'},
      smartfren: {name:'SMARTFREN', logo:'SF', digiBrand:'SMARTFREN'},
      byu: {name:'BY.U', logo:'BY.U', digiBrand:'BYU'}
    };

    const tagihanCategories = [
      { id: 'tagihan_pln_pasca', name: 'PLN Pasca', icon: 'fas fa-lightbulb', placeholder: 'Masukkan ID Pelanggan PLN...' },
      { id: 'tagihan_bpjs', name: 'BPJS', icon: 'fas fa-heartbeat', placeholder: 'Masukkan No BPJS (13 Digit)...' },
      { id: 'tagihan_pgn', name: 'Gas Negara', icon: 'fas fa-fire', placeholder: 'Masukkan ID Pelanggan...' },
      { id: 'tagihan_gas', name: 'Pertagas', icon: 'fas fa-fire-alt', placeholder: 'Masukkan ID Pelanggan...' },
      { id: 'tagihan_telkom', name: 'Telkom/Indihome', icon: 'fas fa-wifi', placeholder: 'Masukkan No Telepon...' },
      { id: 'tagihan_tv', name: 'TV Berbayar', icon: 'fas fa-tv', placeholder: 'Masukkan ID Pelanggan...' },
      { id: 'tagihan_pasca', name: 'Tagihan Seluler', icon: 'fas fa-mobile-alt', placeholder: 'Masukkan Nomor HP...' },
      { id: 'tagihan_finance', name: 'Finance', icon: 'fas fa-hand-holding-usd', placeholder: 'Masukkan Nomor Kontrak...' },
      { id: 'tagihan_internet', name: 'Internet', icon: 'fas fa-globe', placeholder: 'Masukkan ID Pelanggan...' },
      { id: 'tagihan_pdam', name: 'PDAM', icon: 'fas fa-tint', placeholder: 'Masukkan Nomor Pelanggan...' }
    ];

    const pln = { 
        pln_token: {name:'Token PLN', logo:'fas fa-bolt', isIcon:true, digiBrand:'PLN'} 
    };

    const a = {...o, ...dC, ...gC, ...e, ...etoll, ...pln, ...v, ...prd};
    
    tagihanCategories.forEach(t => { 
        a[t.id] = { name: t.name, logo: t.icon, isIcon: true, placeholder: t.placeholder }; 
    });
    
    let cL = {};

    if (t === 'game') { oT = 'Top Up Game'; cL = gC; }
    else if (t === 'data') { oT = 'Paket Data'; cL = dC; }
    else if (t === 'ewallet') { oT = 'E-Wallet'; cL = e; }
    else if (t === 'etoll') { oT = 'Saldo E-Toll'; cL = etoll; }
    else if (t === 'pln') { oT = 'PLN'; cL = pln; }
    else if (t === 'masaaktif') { oT = 'Masa Aktif'; cL = o; }
    else if (t === 'voucher') { oT = 'Voucher'; cL = v; }
    else if (t === 'perdana') { oT = 'Perdana'; cL = prd; }
    else if (t === 'tagihan') { 
        oT = 'Tagihan'; 
        document.getElementById('operatorContainer').classList.replace('block', 'hidden');
        let gridHtml = '<div class="grid grid-cols-4 gap-y-6 gap-x-3 mt-4 mx-4">';
        
        tagihanCategories.forEach(item => {
            gridHtml += `
            <div class="flex flex-col items-center cursor-pointer hover:-translate-y-1 transition-transform" onclick="selectProvider('${item.id}')">
                <div class="w-[4.2rem] h-[4.2rem] rounded-[1.2rem] bg-white dark:bg-[#111c2e] text-[#002147] dark:text-yellow-400 flex items-center justify-center text-[26px] shadow-sm mb-2 border border-gray-200 dark:border-gray-800/60">
                    <i class="${item.icon}"></i>
                </div>
                <span class="text-[9px] font-bold text-gray-600 dark:text-gray-300 text-center leading-tight">${item.name}</span>
            </div>`;
        });
        
        gridHtml += '</div>';
        const tempDiv = document.createElement('div'); 
        tempDiv.id = 'tagihanGridWrap';
        tempDiv.innerHTML = `<h3 class="text-[10px] text-gray-500 dark:text-gray-400 font-bold mb-4 mx-4 mt-6">PILIH JENIS TAGIHAN</h3>` + gridHtml;
        document.getElementById('operatorContainer').parentElement.insertBefore(tempDiv, document.getElementById('categoryContainer'));
    }
    else { 
        oT = 'Isi Pulsa'; 
        cL = o; 
    }
    
    document.getElementById('pageTitle').innerText = oT;

    if (t !== 'tagihan') {
        let h='';
        for(let k in cL){
          let v = cL[k];
          h += `
            <div class="flex items-center p-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#1a2639] transition" onclick="selectProvider('${k}')">
              <div class="w-10 h-10 rounded-full border border-gray-400 flex items-center justify-center text-[10px] bg-white dark:bg-[#0b1320] text-gray-800 dark:text-gray-300 font-bold">${v.isIcon ? `<i class="${v.logo} text-lg"></i>` : v.logo}</div>
              <div class="flex-1 ml-4 font-bold text-gray-800 dark:text-gray-200">${v.name}</div>
            </div>`;
        }
        document.getElementById('opListRender').innerHTML = h;
    }

    if (pp && a[pp]) { 
        setTimeout(()=>selectProvider(pp),50); 
    }

    const px = {
      'Telkomsel':['0811','0812','0813','0821','0822','0823','0851','0852','0853'],
      'Indosat':['0814','0815','0816','0855','0856','0857','0858'],
      'XL/Axis':['0817','0818','0819','0859','0877','0878','0831','0832','0833','0838'],
      'Tri':['0895','0896','0897','0898','0899'],
      'Smartfren':['0881','0882','0883','0884','0885','0886','0887','0888','0889']
    };

    document.getElementById('inputTarget').addEventListener('input', function() {
      let v = this.value.replace(/[^0-9]/g, '');
      let pi = document.getElementById('prefixIcon');
      let dt = document.getElementById('dtTarget');
      let btn = document.getElementById('btnLanjutkan');
      
      if(v) {
        dt.innerText = v; 
        dt.classList.remove('text-red-500'); 
        dt.classList.add('text-gray-800','dark:text-white');
        btn.classList.remove('opacity-50','cursor-not-allowed');
      } else {
        dt.innerText = 'Kosong'; 
        dt.classList.add('text-red-500'); 
        dt.classList.remove('text-gray-800','dark:text-white');
        btn.classList.add('opacity-50','cursor-not-allowed');
      }

      if(v.length >= 4) {
        let f = null;
        for(let b in px) { 
            if(px[b].includes(v.substring(0,4))) { f = b; break; } 
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
      l.innerHTML = '<div class="py-12 flex justify-center text-gray-500"><i class="fas fa-spinner fa-spin text-3xl"></i></div>';
      
      try {
        let r = await fetch('/api/products', { 
            method: 'POST', 
            headers: {'Content-Type': 'application/json'}, 
            body: JSON.stringify({type: t, brand: b, category: c}) 
        });
        let d = await r.json();
        
        if(d.data && d.data.length > 0) {
          l.innerHTML = d.data.map(p => {
            let sN = p.name.replace(/'/g, "\\'").replace(/"/g, "&quot;");
            let sS = p.sku.replace(/'/g, "\\'").replace(/"/g, "&quot;");
            let sD = p.desc ? p.desc.replace(/'/g, "\\'").replace(/"/g, "&quot;").replace(/\n/g, "<br>") : 'Tidak ada deskripsi.';
            
            let bdg = p.is_open ? 
              `<span class="text-[8px] bg-green-100 text-green-600 dark:bg-green-900/30 dark:text-green-400 px-1.5 py-0.5 rounded font-bold uppercase tracking-wide">Tersedia</span>` : 
              `<span class="text-[8px] bg-red-100 text-red-600 dark:bg-red-900/30 dark:text-red-400 px-1.5 py-0.5 rounded font-bold uppercase tracking-wide">Gangguan</span>`;
            
            let clk = p.is_open ? `showProductDetail('${sS}','${sN}',${p.price},${p.isLocal},'${sD}')` : `Swal.fire({icon:'error',title:'Gangguan',text:'Produk sedang gangguan dari server pusat.',background:localStorage.getItem('darkMode')==='true'?'#0b1320':'#fff',color:localStorage.getItem('darkMode')==='true'?'#fff':'#000'})`;
            let opc = p.is_open ? '' : 'opacity-50';

            return `
            <div class="flex justify-between px-5 py-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-[#1a2639] transition ${opc}" onclick="${clk}">
              <div class="w-2/3 text-[12px] font-bold text-gray-800 dark:text-gray-100 leading-tight">${p.name} ${p.isLocal?'<i class="fas fa-check-circle text-green-500"></i>':''}</div>
              <div class="text-right flex flex-col items-end">
                <div class="mb-1">${bdg}</div>
                <span class="text-[13px] font-extrabold text-[#002147] dark:text-yellow-400">Rp ${p.price.toLocaleString('id-ID')}</span>
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

    function showProductDetail(sku, n, pr, il, ds) {
      sS = sku; sN = n; sP = pr; sL = il;
      document.getElementById('dtName').innerText = n;
      document.getElementById('dtPrice').innerText = 'Rp ' + pr.toLocaleString('id-ID');
      document.getElementById('dtDesc').innerHTML = ds;
      document.getElementById('inputTarget').dispatchEvent(new Event('input'));
      
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
      window.open(`https://wa.me/6282231154407?text=`+encodeURIComponent(`Halo Admin, mau tanya produk *${sN}* aman?`),'_blank');
    }

    function executeBuy() {
      const tr = document.getElementById('inputTarget').value;
      if(!tr) return;
      closeDetail();
      const isD = localStorage.getItem('darkMode') === 'true';
      const bg = isD ? '#0b1320' : '#fff';
      const c = isD ? '#fff' : '#000';
      
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
          body: JSON.stringify({phone: user.phone, target: tr, sku: sS, name: sN, price: sP, isLocal: sL})
        }).then(async r => {
          let d = await r.json();
          if(r.ok) {
            Swal.fire({icon: 'success', title: 'Berhasil!', text: d.message, background: bg, color: c}).then(() => window.location.href = '/riwayat.html');
          } else {
            Swal.fire({icon: 'error', title: 'Gagal', text: d.error, background: bg, color: c});
          }
        }).catch(e => Swal.fire({icon: 'error', title: 'Oops!', text: 'Gangguan jaringan.', background: bg, color: c}));
      }, 300);
    }

    function selectProvider(o) {
      let pr = cL[o] || a[o];
      if(pr) {
        cP = pr;
        document.getElementById('operatorContainer').classList.replace('block', 'hidden');
        if(document.getElementById('tagihanGridWrap')) document.getElementById('tagihanGridWrap').classList.add('hidden');
        
        if(pr.items && pr.items.length > 0 && (t === 'data' || t === 'game')) {
          cS = 'category';
          document.getElementById('categoryContainer').classList.remove('hidden');
          document.getElementById('pageTitle').innerText = pr.name;
          let h = '';
          pr.items.forEach(i => {
            h += `
            <div class="flex items-center px-5 py-4 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#1a2639] transition" onclick="selectCategory('${i}')">
                <div class="flex-1 text-[13px] font-bold text-gray-800 dark:text-gray-200 uppercase">${i}</div>
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
      if(cS === 'product') {
        if(cP && cP.items && cP.items.length > 0 && (t === 'data' || t === 'game')) {
          cS = 'category';
          document.getElementById('productContainer').classList.add('hidden');
          document.getElementById('categoryContainer').classList.remove('hidden');
          document.getElementById('pageTitle').innerText = cP.name;
        } else {
          cS = 'operator';
          document.getElementById('productContainer').classList.add('hidden');
          if(t === 'tagihan') document.getElementById('tagihanGridWrap').classList.remove('hidden');
          else document.getElementById('operatorContainer').classList.replace('hidden', 'block');
          document.getElementById('pageTitle').innerText = oT;
        }
      } else if(cS === 'category') {
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
cat << 'EOF' > public/game.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Top Up Game</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative shadow-2xl overflow-x-hidden">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 dark:text-white" onclick="history.back()"></i>
      <h1 class="text-[18px] font-bold dark:text-white">Top Up Game</h1>
    </div>

    <div class="px-4 mt-6">
      <div class="bg-white dark:bg-[#111c2e] rounded-b-2xl rounded-t-xl overflow-hidden border border-gray-200 dark:border-gray-800 shadow-sm mt-4">
        <div class="bg-black p-4 flex items-center gap-2">
          <i class="fas fa-gamepad text-yellow-400 text-lg"></i>
          <span class="font-bold text-white text-sm">Pilih Game</span>
        </div>
        <div class="p-4 grid grid-cols-3 gap-3">
          
          <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=free_fire'">
            <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold text-sm mb-2">FF</div>
            <div class="text-[11px] font-medium dark:text-gray-300 text-center">Free Fire</div>
          </div>
          
          <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=mobile_legends'">
            <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold text-xs text-center">ML</div>
            <div class="text-[11px] font-medium dark:text-gray-300 text-center">Mobile<br>Legends</div>
          </div>
          
          <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=pubg_mobile'">
            <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold text-[10px] text-center">PUBG</div>
            <div class="text-[11px] font-medium dark:text-gray-300 text-center">PUBG<br>Mobile</div>
          </div>
          
          <div class="bg-gray-50 dark:bg-[#1a2639] border border-gray-200 dark:border-gray-700 rounded-[1rem] p-3 flex flex-col items-center justify-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors h-28" onclick="location.href='/operator.html?type=game&provider=valorant'">
            <div class="w-[3.2rem] h-[3.2rem] rounded-full border border-gray-400 flex items-center justify-center text-[#002147] dark:text-yellow-400 font-extrabold text-[11px] text-center">VALO</div>
            <div class="text-[11px] font-medium dark:text-gray-300 text-center">Valorant</div>
          </div>
          
        </div>
      </div>
    </div>
  </div>
  
  <script>
    if(!localStorage.getItem('user')) {
        window.location.href='/';
    }
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) {
        document.getElementById('html-root').classList.add('dark');
    }
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
  <title>Riwayat Topup</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i>
      <h1 class="text-[18px] font-bold text-gray-800 dark:text-white">Riwayat Top Up</h1>
    </div>

    <div class="px-4 mt-6" id="historyContainer">
      <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
        <i class="fas fa-spinner fa-spin text-4xl mb-4 text-gray-400"></i>
      </div>
    </div>
  </div>
  
  <script>
    const user = JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) document.getElementById('html-root').classList.add('dark');
    
    fetch('/api/topup/history',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({phone:user.phone})
    })
    .then(r=>r.json())
    .then(d=>{
      const c = document.getElementById('historyContainer');
      if(!d.history || d.history.length===0){
        c.innerHTML=`
            <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
                <div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800">
                    <i class="fas fa-wallet text-gray-400 text-4xl"></i>
                </div>
                <h2 class="text-gray-800 dark:text-white font-bold text-lg tracking-wide mb-2">Belum Ada Top Up</h2>
                <p class="text-gray-500 dark:text-gray-400 text-[13px] leading-relaxed mb-8 px-2">Anda belum melakukan pengisian saldo. Ayo isi saldo sekarang!</p>
                <button class="bg-[#002147] text-white dark:bg-[#0b1320] dark:text-yellow-400 border border-transparent dark:border-gray-700 font-bold py-3 px-8 rounded-full shadow-lg hover:opacity-90 transition" onclick="location.href='/dashboard.html'">Top Up Sekarang</button>
            </div>`;
      } else {
        window.topupData = d.history.reverse();
        c.innerHTML = window.topupData.map((i,idx)=>{
          let isExp = i.status==='Expired';
          let sc = i.status==='Proses' ? 'text-yellow-600 dark:text-yellow-400 bg-yellow-100 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-800' : (i.status==='Sukses' ? 'text-green-600 dark:text-green-400 bg-green-100 dark:bg-green-900/30 border-green-200 dark:border-green-800' : 'text-red-600 dark:text-red-400 bg-red-100 dark:bg-red-900/30 border-red-200 dark:border-red-800');
          let iconMethod = i.method.includes('QRIS') ? '<i class="fas fa-qrcode"></i>' : (i.method.includes('Admin') ? '<i class="fas fa-check-circle"></i>' : '<i class="fab fa-whatsapp"></i>');
          let titleText = i.method.includes('Admin') ? 'Saldo ditambah Admin' : `Top Up ${i.method}`;
          
          return `
            <div onclick="showDetailTopup(${idx})" class="bg-white dark:bg-[#111c2e] p-4 rounded-2xl mb-3 border border-gray-200 dark:border-gray-800 shadow-sm flex justify-between items-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors ${isExp?'opacity-70':''}">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-gray-100 dark:bg-[#0b1320] flex items-center justify-center text-gray-500 dark:text-gray-400 text-lg">${iconMethod}</div>
                    <div>
                        <h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${titleText}</h4>
                        <p class="text-[10px] text-gray-500">${i.date}</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="font-extrabold text-[14px] text-[#002147] dark:text-yellow-400 mb-1">Rp ${(i.nominal||0).toLocaleString('id-ID')}</p>
                    <span class="text-[9px] font-bold px-2 py-0.5 rounded border ${sc} uppercase tracking-wider">${i.status}</span>
                </div>
            </div>`;
        }).join('');
      }
    });

    window.showDetailTopup = function(index) {
        const item = window.topupData[index];
        const isDark = localStorage.getItem('darkMode') === 'true';
        const bgPopup = isDark ? '#0b1320' : '#ffffff';
        const textColor = isDark ? 'text-gray-200' : 'text-gray-800';
        const mutedColor = isDark ? 'text-gray-400' : 'text-gray-500';
        const borderColor = isDark ? 'border-gray-800' : 'border-gray-200';
        let statusColor = item.status === 'Proses' ? 'text-yellow-500' : (item.status === 'Sukses' ? 'text-green-500' : 'text-red-500');
        
        Swal.fire({
            title: `<span class="font-bold ${isDark ? 'text-white' : 'text-gray-800'} text-lg">Detail Top Up</span>`,
            html: `
            <div class="text-left mt-2 space-y-3 text-sm border-t ${borderColor} pt-4">
                <div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Waktu</span><span class="font-medium ${textColor} text-right">${item.date}</span></div>
                <div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Nominal</span><span class="font-medium ${textColor} text-right">Rp ${(item.nominal||0).toLocaleString('id-ID')}</span></div>
                <div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Metode</span><span class="font-medium ${textColor} text-right">${item.method}</span></div>
                <div class="flex justify-between border-b ${borderColor} pb-2"><span class="${mutedColor}">Status</span><span class="font-bold ${statusColor} text-right uppercase">${item.status}</span></div>
                <div class="mt-5 text-center">
                    <p class="${mutedColor} text-xs mb-1">Total Bayar</p>
                    <p class="text-3xl font-extrabold ${isDark ? 'text-yellow-400' : 'text-[#002147]'}">Rp ${(item.nominal||0).toLocaleString('id-ID')}</p>
                </div>
            </div>`,
            showConfirmButton: true, 
            confirmButtonText: 'Tutup', 
            confirmButtonColor: isDark ? '#facc15' : '#002147', 
            background: bgPopup,
            customClass: { confirmButton: isDark ? 'text-[#001229] font-bold px-8' : 'text-white font-bold px-8' }
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
  <title>Pusat Informasi</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="style.css">
  <script>tailwind.config = { darkMode: 'class' }</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i>
      <h1 class="text-[18px] font-bold text-gray-800 dark:text-white">Pusat Informasi</h1>
    </div>

    <div class="p-4" id="infoList">
      <div class="mt-20 flex flex-col items-center justify-center text-gray-400">
        <i class="fas fa-spinner fa-spin text-4xl mb-4"></i>
        <p>Memuat informasi...</p>
      </div>
    </div>

    <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-sm z-40">
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/dashboard.html'">
        <i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/riwayat.html'">
        <i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400">
        <i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/profile.html'">
        <i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span>
      </div>
    </div>
  </div>
  
  <script>
    const user = JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) document.getElementById('html-root').classList.add('dark');
    
    fetch('/api/info').then(r=>r.json()).then(d=>{
      const l = document.getElementById('infoList');
      if(!d.info || d.info.length===0) {
        l.innerHTML='<div class="mt-20 flex flex-col items-center justify-center text-gray-400 dark:text-gray-500"><i class="fas fa-bell-slash text-5xl mb-4 opacity-50"></i><p class="text-sm">Belum ada info terbaru.</p></div>';
      } else {
        l.innerHTML = d.info.reverse().map(i=>`
            <div class="relative bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-2xl p-5 mb-4 shadow-sm overflow-hidden">
                <div class="absolute -right-2 top-4 text-7xl opacity-10 dark:opacity-20 select-none">📢</div>
                <div class="flex justify-between items-start mb-3 relative z-10">
                    <h3 class="font-bold text-[#002147] dark:text-yellow-400 text-[15px] pr-2">${i.judul}</h3>
                    <span class="text-[10px] text-gray-500 bg-gray-100 dark:bg-black px-2 py-1 rounded-md border border-gray-200 dark:border-gray-800">${i.date}</span>
                </div>
                <p class="text-sm text-gray-600 dark:text-gray-300 leading-relaxed relative z-10">${i.isi}</p>
            </div>`).join('');
      }
    });
  </script>
</body>
</html>
EOF

cat << 'EOF' > public/mutasi.html
<!DOCTYPE html>
<html lang="id" id="html-root">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mutasi Saldo</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="history.back()"></i>
      <h1 class="text-[18px] font-bold text-gray-800 dark:text-white">Mutasi Saldo</h1>
    </div>

    <div class="p-4" id="mutasiList">
      <div class="mt-20 flex flex-col items-center justify-center text-gray-400">
        <i class="fas fa-spinner fa-spin text-4xl mb-4"></i>
        <p>Memuat data mutasi...</p>
      </div>
    </div>
  </div>
  
  <script>
    const user = JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) document.getElementById('html-root').classList.add('dark');
    
    fetch('/api/user/mutasi',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({phone:user.phone})
    })
    .then(r=>r.json())
    .then(d=>{
      const l = document.getElementById('mutasiList');
      if(!d.mutasi || d.mutasi.length===0) {
        l.innerHTML='<div class="mt-20 flex flex-col items-center justify-center text-center px-6"><div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800"><i class="fas fa-exchange-alt text-gray-400 text-4xl"></i></div><h2 class="text-gray-800 dark:text-white font-bold text-lg mb-2">Belum Ada Mutasi</h2></div>';
      } else {
        l.innerHTML = d.mutasi.reverse().map(m=>`
        <div class="bg-white dark:bg-[#111c2e] border border-gray-200 dark:border-gray-800 rounded-2xl p-4 mb-3 flex justify-between shadow-sm">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full ${m.type==='in'?'bg-green-100 text-green-600 dark:bg-green-900/30 dark:text-green-400':'bg-red-100 text-red-600 dark:bg-red-900/30 dark:text-red-400'} flex items-center justify-center text-lg shrink-0">
                    <i class="fas ${m.type==='in'?'fa-arrow-down':'fa-arrow-up'}"></i>
                </div>
                <div>
                    <h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${m.desc}</h4>
                    <p class="text-[10px] text-gray-500">${m.date}</p>
                </div>
            </div>
            <div class="font-bold text-[14px] flex items-center ${m.type==='in'?'text-green-600 dark:text-green-500':'text-red-600 dark:text-red-500'}">
                ${m.type==='in'?'+':'-'} Rp ${m.amount.toLocaleString('id-ID')}
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
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="bg-white dark:bg-[#050b14] p-8 pb-10 flex flex-col items-center relative rounded-b-[2rem] shadow-sm dark:shadow-lg">
      <div class="w-24 h-24 bg-gray-100 dark:bg-[#1e293b] rounded-full flex justify-center items-center text-[#002147] dark:text-white font-extrabold text-4xl mt-2 mb-3 shadow-md overflow-hidden border-2 border-transparent" id="profileCircle">U</div>
      <div class="flex items-center gap-3">
        <h2 class="text-2xl font-bold tracking-wide text-gray-800 dark:text-gray-100" id="profileName">User Name</h2>
        <i class="fas fa-pencil-alt text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400 cursor-pointer text-lg" onclick="openEditModal()"></i>
      </div>
    </div>

    <div class="mt-4 px-2">
      <div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800">
        <i class="fas fa-envelope text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Email</div>
        <div class="text-sm text-gray-500 dark:text-gray-400" id="profileEmail">-</div>
      </div>
      <div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800">
        <i class="fas fa-phone-alt text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">No. Telp</div>
        <div class="text-sm text-gray-500 dark:text-gray-400" id="profilePhoneData">08...</div>
      </div>
      <div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800">
        <i class="fas fa-wallet text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Saldo Akun</div>
        <div class="text-sm font-bold text-[#002147] dark:text-yellow-400" id="profileSaldo">Rp 0</div>
      </div>
      <div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800">
        <i class="fas fa-shopping-cart text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Total Transaksi</div>
        <div class="text-sm font-bold text-[#002147] dark:text-yellow-400" id="profileTrx">0 Trx</div>
      </div>
      <div class="flex items-center px-4 py-5 border-b border-gray-200 dark:border-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-[#1a2639]" onclick="location.href='/mutasi.html'">
        <i class="fas fa-exchange-alt text-[#002147] dark:text-gray-400 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-gray-800 dark:text-gray-200 ml-2">Mutasi Saldo</div>
        <i class="fas fa-chevron-right text-gray-400 text-sm"></i>
      </div>
      <div class="flex items-center px-4 py-5 cursor-pointer hover:bg-red-50 dark:hover:bg-gray-800/50" onclick="logout()">
        <i class="fas fa-sign-out-alt text-red-600 w-10 text-xl text-center"></i>
        <div class="flex-1 text-[15px] font-bold text-red-600 ml-2">Keluar Akun</div>
      </div>
    </div>

    <div id="editProfileModal" class="fixed inset-0 z-[110] hidden flex items-center justify-center bg-black/70">
        <div class="bg-white dark:bg-[#0b1320] w-[90%] max-w-[340px] rounded-[1.25rem] border border-gray-200 dark:border-gray-800 shadow-2xl relative p-6 animate-slide-up">
            <button onclick="closeEditModal()" class="absolute top-4 right-4 text-gray-400 hover:text-red-500"><i class="fas fa-times text-xl"></i></button>
            <h3 class="text-center text-gray-800 dark:text-white font-bold text-lg mb-6">Ubah Profil</h3>
            
            <div class="relative w-20 h-20 mx-auto mb-8">
                <div class="w-full h-full rounded-full border-2 border-[#002147] dark:border-yellow-400 flex items-center justify-center text-3xl font-bold bg-gray-100 dark:bg-[#1e293b] overflow-hidden text-[#002147] dark:text-white" id="editModalInitial">U</div>
                <input type="file" id="avatarInput" accept="image/*" class="hidden" onchange="previewAvatar(event)">
                <div class="absolute bottom-0 right-0 bg-[#002147] dark:bg-yellow-400 rounded-full w-7 h-7 flex items-center justify-center text-white dark:text-[#0b1320] border-[3px] border-white dark:border-[#0b1320] cursor-pointer z-10" onclick="document.getElementById('avatarInput').click()"><i class="fas fa-camera text-[10px]"></i></div>
            </div>

            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Email (Hanya Baca)</label>
                <input type="email" id="editEmail" readonly class="w-full bg-gray-100 dark:bg-[#1e293b]/50 border border-gray-300 dark:border-gray-800 rounded-lg px-3 py-3 text-gray-500 dark:text-gray-400 text-sm focus:outline-none cursor-not-allowed">
            </div>
            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Nama Pengguna</label>
                <input type="text" id="editName" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400">
            </div>
            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Nomor Telepon</label>
                <input type="number" id="editPhone" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400">
            </div>
            <div class="mb-4">
                <label class="block text-[10px] text-gray-500 mb-1">Password Baru (Opsional)</label>
                <div class="relative w-full">
                    <input type="password" id="editPassword" class="w-full bg-white dark:bg-[#0b1320] border border-gray-300 dark:border-gray-700 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400" placeholder="Kosongkan jika tidak diganti">
                    <i class="fas fa-eye absolute right-4 top-1/2 transform -translate-y-1/2 cursor-pointer text-gray-400" onclick="togglePasswordProfile('editPassword', this)"></i>
                </div>
            </div>

            <div class="mb-6 hidden slide-down" id="editOtpContainer">
                <label class="block text-[10px] text-gray-500 mb-1 text-center">OTP telah dikirim ke WA</label>
                <input type="number" id="editOtpInput" class="w-full bg-white dark:bg-[#0b1320] border border-green-500 rounded-lg px-3 py-3 text-gray-800 dark:text-white text-lg tracking-[0.5em] text-center font-bold focus:outline-none" placeholder="XXXX">
            </div>

            <button id="btnSimpanProfil" onclick="saveProfile()" class="w-full py-3.5 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#001229] font-bold rounded-xl mb-3 shadow-md">Simpan Profil</button>
            <button onclick="deleteAccount()" class="w-full py-3.5 bg-red-500/10 text-red-500 font-bold rounded-xl border border-red-500/20">Hapus Akun Permanen</button>
        </div>
    </div>

    <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-sm z-40">
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/dashboard.html'"><i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span></div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/riwayat.html'"><i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span></div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/info.html'"><i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span></div>
      <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400"><i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span></div>
    </div>
  </div>

  <script>
    const user = JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) {
        document.getElementById('html-root').classList.add('dark');
    }
    
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

    fetch('/api/user/balance',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({phone:user.phone})
    })
    .then(r=>r.json())
    .then(d=>{
      document.getElementById('profileSaldo').innerText = 'Rp ' + d.saldo.toLocaleString('id-ID');
    });

    fetch('/api/user/transactions',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({phone:user.phone})
    })
    .then(r=>r.json())
    .then(d=>{
      document.getElementById('profileTrx').innerText = (d.transactions ? d.transactions.length : 0) + ' Trx';
    });

    function logout(){
      Swal.fire({
          title:'Keluar Akun?', 
          text:'Apakah kamu yakin ingin keluar?', 
          icon:'warning',
          showCancelButton:true,
          background:localStorage.getItem('darkMode')==='true'?'#0b1320':'#fff',
          color:localStorage.getItem('darkMode')==='true'?'#fff':'#000'
      }).then(r=>{
        if(r.isConfirmed){
            localStorage.removeItem('user');
            window.location.href='/';
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
        
        const isDark = localStorage.getItem('darkMode')==='true';
        const bg = isDark?'#0b1320':'#fff'; 
        const col = isDark?'#fff':'#000';
        
        if(!newName || !rawPhone) {
            return Swal.fire({icon:'warning', title:'Gagal', text:'Nama & No WA wajib diisi!', background:bg, color:col});
        }
        
        const isSecureChange = (newPhone !== oldPhone) || (newPassword.trim() !== '');
        
        if(isSecureChange && !isRequestingOtp) {
            Swal.fire({
                title: 'Mengirim OTP...', 
                allowOutsideClick: false, 
                didOpen: () => { Swal.showLoading() }, 
                background:bg, 
                color:col
            });
            try {
                const res = await fetch('/api/auth/request-update-otp', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify({ oldPhone, newPhone, isPasswordChange: newPassword.trim() !== '' }) 
                });
                
                if(res.ok) {
                    isRequestingOtp = true; 
                    document.getElementById('editOtpContainer').classList.remove('hidden'); 
                    document.getElementById('btnSimpanProfil').innerText = 'Verifikasi & Simpan'; 
                    Swal.fire({icon:'success', title:'Terkirim!', text:'Cek WA untuk kode OTP.', background:bg, color:col});
                } else { 
                    Swal.fire({icon:'error', title:'Gagal', text: (await res.json()).error, background:bg, color:col}); 
                }
            } catch(e) { 
                Swal.fire({icon:'error', title:'Oops', text:'Kesalahan jaringan.', background:bg, color:col}); 
            }
            return;
        }
        
        if(isSecureChange && isRequestingOtp && !otp) {
            return Swal.fire({icon:'warning', title:'Gagal', text:'Masukkan kode OTP 4 digit!', background:bg, color:col});
        }
        
        Swal.fire({
            title: 'Menyimpan...', 
            allowOutsideClick: false, 
            didOpen: () => { Swal.showLoading() }, 
            background:bg, 
            color:col
        });
        
        try {
            const res = await fetch('/api/auth/update', { 
                method: 'POST', 
                headers: { 'Content-Type': 'application/json' }, 
                body: JSON.stringify({ oldPhone, newPhone, newName, otp, avatar: tempAvatarBase64, newPassword }) 
            });
            
            if(res.ok) {
                user.name = newName; 
                user.phone = (await res.json()).phone || newPhone; 
                user.avatar = tempAvatarBase64;
                localStorage.setItem('user', JSON.stringify(user));
                Swal.fire({icon:'success', title:'Berhasil', text:'Profil diperbarui!', background:bg, color:col}).then(() => { 
                    location.reload(); 
                });
            } else { 
                Swal.fire({icon:'error', title:'Gagal', text: (await res.json()).error, background:bg, color:col}); 
            }
        } catch(e) { 
            Swal.fire({icon:'error', title:'Oops', text:'Kesalahan jaringan.', background:bg, color:col}); 
        }
    }

    function deleteAccount() {
        const isDark = localStorage.getItem('darkMode')==='true';
        Swal.fire({ 
            title: 'Hapus Akun Permanen?', 
            text: "Akun dan sisa saldo Anda akan hangus!", 
            icon: 'error', 
            showCancelButton: true, 
            confirmButtonColor: '#d33', 
            cancelButtonColor: isDark?'#111c2e':'#gray-200', 
            confirmButtonText: 'Ya, Hapus!', 
            background: isDark?'#0b1320':'#fff', 
            color: isDark?'#fff':'#000' 
        }).then(async (result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Menghapus...', 
                    allowOutsideClick: false, 
                    didOpen: () => { Swal.showLoading() }, 
                    background: isDark?'#0b1320':'#fff', 
                    color: isDark?'#fff':'#000'
                });
                
                try {
                    const res = await fetch('/api/auth/delete', { 
                        method: 'POST', 
                        headers: { 'Content-Type': 'application/json' }, 
                        body: JSON.stringify({ phone: user.phone }) 
                    });
                    
                    if(res.ok) { 
                        localStorage.removeItem('user'); 
                        Swal.fire({icon:'success', title:'Terhapus', text:'Akun dihapus.', background: isDark?'#0b1320':'#fff', color: isDark?'#fff':'#000'}).then(() => { 
                            location.href = '/'; 
                        }); 
                    }
                } catch(e) { 
                    Swal.fire({icon:'error', title:'Error', text:'Gagal menghapus.', background: isDark?'#0b1320':'#fff', color: isDark?'#fff':'#000'}); 
                }
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
  <script>tailwind.config={darkMode:'class'}</script>
</head>
<body class="bg-gray-50 dark:bg-[#0b1320] font-sans transition-colors duration-300">
  <div class="max-w-md mx-auto bg-gray-50 dark:bg-[#0b1320] min-h-screen relative pb-24 shadow-2xl overflow-x-hidden">
    
    <div class="flex items-center p-5 bg-white dark:bg-[#0b1320] sticky top-0 z-40 border-b border-gray-200 dark:border-gray-800">
      <i class="fas fa-arrow-left text-xl cursor-pointer mr-4 text-gray-800 dark:text-white" onclick="location.href='/dashboard.html'"></i>
      <h1 class="text-[18px] font-bold text-gray-800 dark:text-white">Riwayat Transaksi</h1>
    </div>

    <div class="mx-4 mt-4 bg-white dark:bg-[#111c2e] p-4 rounded-2xl border border-gray-200 dark:border-gray-800 shadow-sm">
        <div class="relative mb-4">
            <i class="fas fa-search absolute left-3.5 top-3 text-gray-400 text-sm"></i>
            <input type="text" id="searchInput" onkeyup="filterHistory()" class="w-full bg-gray-50 dark:bg-[#1a2639] border border-gray-300 dark:border-gray-700 text-gray-800 dark:text-gray-200 rounded-xl py-2.5 pl-10 pr-4 text-sm focus:outline-none focus:border-[#002147] dark:focus:border-yellow-400" placeholder="Cari transaksi...">
        </div>
        <div class="flex justify-between mb-2 gap-2">
            <div id="btn-Semua" onclick="setStatusFilter('Semua')" class="flex-1 bg-[#002147] dark:bg-yellow-400 text-white dark:text-[#0b1320] text-center py-2 rounded-full text-[11px] font-bold cursor-pointer shadow-sm transition-colors">Semua</div>
            <div id="btn-Sukses" onclick="setStatusFilter('Sukses')" class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 text-center py-2 rounded-full text-[11px] font-bold cursor-pointer border border-gray-200 dark:border-gray-700 transition-colors">Sukses</div>
            <div id="btn-Proses" onclick="setStatusFilter('Proses')" class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 text-center py-2 rounded-full text-[11px] font-bold cursor-pointer border border-gray-200 dark:border-gray-700 transition-colors">Proses</div>
            <div id="btn-Gagal" onclick="setStatusFilter('Gagal')" class="flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 text-center py-2 rounded-full text-[11px] font-bold cursor-pointer border border-gray-200 dark:border-gray-700 transition-colors">Gagal</div>
        </div>
    </div>

    <div class="px-4 mt-4" id="historyContainer">
      <div class="mt-14 flex flex-col items-center justify-center text-center px-6">
        <i class="fas fa-spinner fa-spin text-4xl mb-4 text-gray-400"></i>
      </div>
    </div>

    <div class="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#001229] border-t border-gray-200 dark:border-gray-800 flex justify-around p-3 pb-4 shadow-sm z-40">
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/dashboard.html'">
          <i class="fas fa-home text-xl"></i><span class="text-[10px] mt-1 font-bold">HOME</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-[#002147] dark:text-yellow-400">
          <i class="fas fa-file-alt text-xl"></i><span class="text-[10px] mt-1 font-bold">RIWAYAT</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/info.html'">
          <i class="fas fa-bell text-xl"></i><span class="text-[10px] mt-1 font-bold">INFO</span>
      </div>
      <div class="flex flex-col items-center cursor-pointer text-gray-400 hover:text-[#002147] dark:hover:text-yellow-400" onclick="location.href='/profile.html'">
          <i class="fas fa-user text-xl"></i><span class="text-[10px] mt-1 font-bold">PROFIL</span>
      </div>
    </div>
  </div>

  <script>
    const user = JSON.parse(localStorage.getItem('user'));
    if(!user) window.location.href='/';
    
    if(localStorage.getItem('darkMode')==='true' || localStorage.getItem('darkMode')===null) {
        document.getElementById('html-root').classList.add('dark');
    }
    
    let allTrx = [];
    let currentFilter = 'Semua';

    fetch('/api/user/transactions',{
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({phone:user.phone})
    })
    .then(r=>r.json())
    .then(d=>{
      allTrx = d.transactions ? d.transactions.reverse() : [];
      renderHistory();
    })
    .catch(e => {
      document.getElementById('historyContainer').innerHTML = `<div class="mt-10 text-center text-red-500 font-bold">Gagal memuat data.</div>`;
    });

    function setStatusFilter(status) {
        currentFilter = status;
        const isD = localStorage.getItem('darkMode') === 'true';
        
        ['Semua', 'Sukses', 'Proses', 'Gagal'].forEach(btn => {
            const el = document.getElementById('btn-' + btn);
            el.className = 'flex-1 bg-gray-50 dark:bg-[#1a2639] text-gray-500 dark:text-gray-400 text-center py-2 rounded-full text-[11px] font-bold cursor-pointer border border-gray-200 dark:border-gray-700 transition-colors';
        });
        
        const activeBtn = document.getElementById('btn-' + status);
        activeBtn.className = `flex-1 ${isD ? 'bg-yellow-400 text-[#0b1320]' : 'bg-[#002147] text-white'} text-center py-2 rounded-full text-[11px] font-bold cursor-pointer shadow-sm transition-colors`;
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
        
        if(!filtered || filtered.length === 0){
            c.innerHTML=`
            <div class="mt-10 flex flex-col items-center justify-center text-center px-6">
                <div class="w-[5.5rem] h-[5.5rem] bg-gray-100 dark:bg-[#111c2e] rounded-full flex items-center justify-center mb-6 shadow-sm border border-gray-200 dark:border-gray-800">
                    <i class="fas fa-receipt text-gray-400 text-4xl"></i>
                </div>
                <h2 class="text-gray-800 dark:text-white font-bold text-lg tracking-wide mb-2">Transaksi Tidak Ditemukan</h2>
            </div>`;
        } else {
            c.innerHTML = filtered.map((i)=>{
                let sc = i.status==='Proses' ? 'text-yellow-600 dark:text-yellow-400 bg-yellow-100 dark:bg-yellow-900/30 border-yellow-200 dark:border-yellow-800' : (i.status==='Sukses' ? 'text-green-600 dark:text-green-400 bg-green-100 dark:bg-green-900/30 border-green-200 dark:border-green-800' : 'text-red-600 dark:text-red-400 bg-red-100 dark:bg-red-900/30 border-red-200 dark:border-red-800');
                let rawIdx = allTrx.indexOf(i);
                
                return `
                <div onclick="showDetailTrx(${rawIdx})" class="bg-white dark:bg-[#111c2e] p-4 rounded-2xl mb-3 border border-gray-200 dark:border-gray-800 shadow-sm flex justify-between items-center cursor-pointer hover:border-[#002147] dark:hover:border-yellow-400 transition-colors">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-gray-100 dark:bg-[#0b1320] flex items-center justify-center text-gray-500 dark:text-gray-400 text-lg">
                            <i class="fas fa-box"></i>
                        </div>
                        <div>
                            <h4 class="font-bold text-[13px] text-gray-800 dark:text-gray-200">${i.produk}</h4>
                            <p class="text-[10px] text-gray-500">${i.date}</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="font-extrabold text-[14px] text-[#002147] dark:text-yellow-400 mb-1">Rp ${(i.harga||0).toLocaleString('id-ID')}</p>
                        <span class="text-[9px] font-bold px-2 py-0.5 rounded border ${sc} uppercase tracking-wider">${i.status}</span>
                    </div>
                </div>`;
            }).join('');
        }
    }

    function renderHistory() { filterHistory(); }

    window.showDetailTrx = function(idx){
      const i = allTrx[idx];
      const isD = localStorage.getItem('darkMode')==='true';
      
      Swal.fire({
        title: `<span class="font-bold ${isD?'text-white':'text-gray-800'} text-lg">Detail Transaksi</span>`,
        html: `
        <div class="text-left mt-2 text-sm space-y-3 border-t ${isD?'border-gray-800':'border-gray-200'} pt-4">
            <div class="flex justify-between border-b ${isD?'border-gray-800':'border-gray-200'} pb-2">
                <span class="${isD?'text-gray-400':'text-gray-500'}">Produk</span>
                <span class="${isD?'text-white':'text-gray-800'} font-bold text-right">${i.produk}</span>
            </div>
            <div class="flex justify-between border-b ${isD?'border-gray-800':'border-gray-200'} pb-2">
                <span class="${isD?'text-gray-400':'text-gray-500'}">Tujuan</span>
                <span class="${isD?'text-white':'text-gray-800'} font-bold text-right">${i.no_tujuan}</span>
            </div>
            <div class="flex justify-between border-b ${isD?'border-gray-800':'border-gray-200'} pb-2">
                <span class="${isD?'text-gray-400':'text-gray-500'}">Status</span>
                <span class="${i.status==='Sukses'?'text-green-500':(i.status==='Proses'?'text-yellow-500':'text-red-500')} font-bold text-right uppercase">${i.status}</span>
            </div>
            <div class="flex justify-between border-b ${isD?'border-gray-800':'border-gray-200'} pb-2">
                <span class="${isD?'text-gray-400':'text-gray-500'}">SN/Ref</span>
                <span class="${isD?'text-white':'text-gray-800'} font-medium text-right">${i.sn_ref||'-'}</span>
            </div>
            <div class="mt-5 text-center">
                <p class="${isD?'text-gray-400':'text-gray-500'} text-xs mb-1">Total Harga</p>
                <p class="text-3xl font-extrabold ${isD?'text-yellow-400':'text-[#002147]'}">Rp ${(i.harga||0).toLocaleString('id-ID')}</p>
            </div>
        </div>`,
        background: isD?'#0b1320':'#fff', 
        confirmButtonColor: isD?'#facc15':'#002147', 
        confirmButtonText: 'Tutup',
        customClass: { confirmButton: isD ? 'text-[#001229] font-bold px-8' : 'text-white font-bold px-8' }
      });
    }
  </script>
</body>
</html>
EOF
# ==========================================
# DIGITAL FIKY STORE - V146 (PART 4 - BACKEND & MENU)
# ==========================================

echo "[4/5] Menulis ulang logika Backend Node.js (V146 Edition)..."

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
const multer = require('multer');
const { exec } = require('child_process');

const app = express();
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// SERVE PUBLIC & BANNERS FOLDER
app.use(express.static(path.join(__dirname, 'public')));

const configFile = './config.json';
const dbFile = './database.json';
const webUsersFile = './web_users.json'; 
const localProductsFile = './local_products.json';
const digiCacheFile = './digi_cache.json'; 
const infoFile = './info.json';

const loadJSON = (file) => {
    if(fs.existsSync(file)) return JSON.parse(fs.readFileSync(file));
    if(file === localProductsFile || file === infoFile) return [];
    return {};
};
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(webUsersFile)) saveJSON(webUsersFile, {});
if (!fs.existsSync(localProductsFile)) saveJSON(localProductsFile, []);
if (!fs.existsSync(digiCacheFile)) saveJSON(digiCacheFile, { time: 0, data: [] }); 
if (!fs.existsSync(infoFile)) saveJSON(infoFile, []);

// ==========================================
// 3 BOT TELEGRAM LOGIC
// ==========================================
const sendTeleNotif = async (message, type = 'trx') => {
    let cfg = loadJSON(configFile);
    let token = ''; let chatId = '';

    if (type === 'trx') { 
        token = cfg.teleTokenTrx || cfg.teleToken; chatId = cfg.teleChatIdTrx || cfg.teleChatId; 
    } else if (type === 'topup') { 
        token = cfg.teleTokenTopup || cfg.teleToken; chatId = cfg.teleChatIdTopup || cfg.teleChatId; 
    } else if (type === 'backup') { 
        token = cfg.teleTokenBackup || cfg.teleToken; chatId = cfg.teleChatIdBackup || cfg.teleChatId; 
    }

    if (!token || !chatId) return;

    try {
        await axios.post(`https://api.telegram.org/bot${token}/sendMessage`, { 
            chat_id: chatId, text: message, parse_mode: 'Markdown' 
        });
    } catch(e) { console.log("Gagal Notif Telegram", e.message); }
};

app.get('/api/config', (req, res) => { res.json({ banners: loadJSON(configFile).banners || [], qrisUrl: loadJSON(configFile).qrisUrl || '' }); });
app.get('/api/info', (req, res) => { res.json({ info: loadJSON(infoFile) }); });
app.post('/api/user/balance', (req, res) => { res.json({ saldo: loadJSON(dbFile)[req.body.phone]?.saldo || 0 }); });
app.post('/api/user/mutasi', (req, res) => { res.json({ mutasi: loadJSON(dbFile)[req.body.phone]?.mutasi || [] }); });
app.post('/api/user/transactions', (req, res) => { res.json({ transactions: loadJSON(dbFile)[req.body.phone]?.transactions || [] }); });

app.post('/api/admin/broadcast', (req, res) => {
    const { judul, message } = req.body;
    let infoData = loadJSON(infoFile);
    infoData.push({ judul: judul || "📢 PENGUMUMAN RESMI", isi: message, date: new Date().toLocaleString('id-ID') });
    saveJSON(infoFile, infoData);
    res.json({ success: true, message: "Broadcast ditambahkan ke Pusat Informasi." });
});

// ==========================================
// PULL CATALOG & CUSTOM MARKUP
// ==========================================
app.post('/api/products', async (req, res) => {
    const { type, brand, category } = req.body;
    let config = loadJSON(configFile);
    let digiCache = loadJSON(digiCacheFile); 
    let filtered = [];
    
    if(config.digiUser && config.digiKey) {
        if (Date.now() - digiCache.time > 300000 || !digiCache.data || digiCache.data.length === 0) { 
            try {
                let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + "pricelist").digest('hex');
                let digiRes = await axios.post('https://api.digiflazz.com/v1/price-list', { cmd: 'prepaid', username: config.digiUser, sign: sign }, { timeout: 5000 });
                if(digiRes.data && digiRes.data.data) {
                    digiCache.data = digiRes.data.data; digiCache.time = Date.now(); saveJSON(digiCacheFile, digiCache); 
                }
            } catch(e) {
                console.log("[DIGIFLAZZ API] Timeout/Gagal Fetch Katalog.");
                digiCache.time = Date.now(); saveJSON(digiCacheFile, digiCache);
            }
        }
        let products = digiCache.data || [];
        const safeBrand = brand ? brand.toLowerCase() : '';
        
        if (type === 'pulsa') { filtered = products.filter(p => p.category === 'Pulsa' && p.brand.toLowerCase() === safeBrand); } 
        else if (type === 'data') {
            filtered = products.filter(p => p.category === 'Data' && p.brand.toLowerCase() === safeBrand);
            if (category) {
                const keywords = category.toLowerCase().split(' ');
                filtered = filtered.filter(p => keywords.every(kw => p.product_name.toLowerCase().includes(kw)));
            }
        } 
        else if (type === 'ewallet' || type === 'etoll') { filtered = products.filter(p => p.category === 'E-Money' && p.brand.toLowerCase().includes(safeBrand)); } 
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
        else if (type === 'pln') { filtered = products.filter(p => p.category === 'PLN'); }
        else if (type === 'masaaktif') { filtered = products.filter(p => p.category === 'Masa Aktif' && p.brand.toLowerCase() === safeBrand); }
        else if (type === 'voucher') { filtered = products.filter(p => p.category === 'Voucher' && p.brand.toLowerCase() === safeBrand); }
        else if (type === 'perdana') { filtered = products.filter(p => p.category === 'Perdana' && p.brand.toLowerCase() === safeBrand); }
    }

    let markupRules = config.markupRules || { l1: 10000, m1: 0, l2: 50000, m2: 0, l3: 100000, m3: 0, m4: 0 };
    let getMarkup = (price) => {
        if (price <= markupRules.l1) return markupRules.m1;
        if (price <= markupRules.l2) return markupRules.m2;
        if (price <= markupRules.l3) return markupRules.m3;
        return markupRules.m4;
    };

    let localProducts = loadJSON(localProductsFile);
    let myLocals = localProducts.filter(p => {
        if(p.type !== type) return false;
        if(brand && p.brand) { if(p.brand.toLowerCase() !== brand.toLowerCase()) return false; } else if (brand && !p.brand) { return false; }
        if((type === 'data' || type === 'game') && category) {
            if (p.category && p.category.toLowerCase().trim() === category.toLowerCase().trim()) return true;
            let kw = category.toLowerCase().split(' ');
            return kw.every(k => p.name.toLowerCase().includes(k) || (p.category && p.category.toLowerCase().includes(k)));
        }
        return true;
    });

    let combined = [
        ...filtered.map(p => ({ sku: p.buyer_sku_code, name: p.product_name, desc: p.desc, price: p.price + getMarkup(p.price), isLocal: false, is_open: (p.buyer_product_status === true && p.seller_product_status === true) })),
        ...myLocals.map(p => ({ sku: p.sku, name: p.name, desc: p.desc, price: p.price + getMarkup(p.price), isLocal: (p.isDigi === true) ? false : true, is_open: true }))
    ];
    combined.sort((a, b) => a.price - b.price); 
    res.json({ data: combined });
});

// ==========================================
// TRANSAKSI LOGIC
// ==========================================
app.post('/api/transaction/create', async (req, res) => {
    try {
        const { phone, target, sku, name, price, isLocal } = req.body;
        let db = loadJSON(dbFile); let config = loadJSON(configFile); let webUsers = loadJSON(webUsersFile);
        let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };

        if (!db[phone]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
        if (db[phone].saldo < price) return res.status(400).json({ error: 'Saldo tidak mencukupi.' });

        if (!db[phone].mutasi) db[phone].mutasi = []; 
        if (!db[phone].transactions) db[phone].transactions = [];

        db[phone].saldo -= price;
        let ref_id = 'TRX' + Date.now(); 
        let dateStr = new Date().toLocaleString('id-ID');
        let trxStatus = 'Proses'; 
        let sn_ref = '';

        if (!isLocal && config.digiUser && config.digiKey) {
            try {
                let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + ref_id).digest('hex');
                let isDev = (config.digiKey || '').toLowerCase().startsWith('dev');
                let digiPayload = { username: config.digiUser, buyer_sku_code: sku, customer_no: target, ref_id: ref_id, sign: sign };
                if (isDev) digiPayload.testing = true;

                let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload, { timeout: 8000 });
                let digiData = digiRes.data.data;

                if (digiData.status === 'Gagal') {
                    db[phone].saldo += price; saveJSON(dbFile, db); 
                    return res.status(400).json({ error: digiData.message || 'Gagal dari provider.' });
                } else if (digiData.status === 'Sukses') { 
                    trxStatus = 'Sukses'; sn_ref = digiData.sn || ''; 
                } else { 
                    trxStatus = 'Proses'; sn_ref = digiData.sn || ''; 
                }
            } catch(e) {
                db[phone].saldo += price; saveJSON(dbFile, db);
                return res.status(400).json({ error: 'Koneksi ke Digiflazz Timeout. Saldo dikembalikan otomatis.' });
            }
        }
        
        db[phone].mutasi.push({ id: ref_id, type: 'out', amount: price, desc: `Beli ${name}`, date: dateStr });
        db[phone].transactions.push({ id: ref_id, sku: sku, isLocal: isLocal, produk: name, nominal: price, no_tujuan: target, status: trxStatus, sn_ref: sn_ref, harga: price, date: dateStr });
        saveJSON(dbFile, db);
        
        try { global.waSocket?.sendMessage(db[phone].jid || phone + '@s.whatsapp.net', { text: `Halo kak, *TRANSAKSI ${trxStatus.toUpperCase()}* 🚀\n\n📦 Produk: *${name}*\n📱 Tujuan: ${target}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n🔖 Ref: ${ref_id}\n\nTerima kasih telah bertransaksi di DIGITAL FIKY STORE!` }); } catch(err) {}
        
        sendTeleNotif(`🛒 *TRANSAKSI BARU (ORDER MASUK)* 🛒\n\n👤 Nama: ${uData.name}\n✉️ Email: ${uData.email}\n📱 WA: ${phone}\n\n📦 Produk: ${name}\n📱 Tujuan: ${target}\n💰 Harga: Rp ${price.toLocaleString('id-ID')}\n🔄 Status: ${trxStatus}\n🔖 Ref: ${ref_id}`, 'trx');
        res.json({ message: 'Transaksi berhasil diproses.' });
    } catch (fatalErr) { res.status(500).json({ error: 'Terjadi kesalahan internal.' }); }
});

setInterval(async () => {
    let db = loadJSON(dbFile); let config = loadJSON(configFile); let webUsers = loadJSON(webUsersFile); let changed = false;
    if(!config.digiUser || !config.digiKey) return;
    
    for (let phone in db) {
        let user = db[phone]; if (!user.transactions) continue;
        let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
        
        for (let i = 0; i < user.transactions.length; i++) {
            let trx = user.transactions[i];
            if (trx.status === 'Proses' && !trx.isLocal && trx.sku) {
                try {
                    let sign = crypto.createHash('md5').update(config.digiUser + config.digiKey + trx.id).digest('hex');
                    let isDev = (config.digiKey || '').toLowerCase().startsWith('dev');
                    let digiPayload = { username: config.digiUser, buyer_sku_code: trx.sku, customer_no: trx.no_tujuan, ref_id: trx.id, sign: sign };
                    if (isDev) digiPayload.testing = true;

                    let digiRes = await axios.post('https://api.digiflazz.com/v1/transaction', digiPayload, { timeout: 10000 });
                    let digiData = digiRes.data.data;
                    
                    if (digiData.status === 'Sukses') {
                        trx.status = 'Sukses'; trx.sn_ref = digiData.sn || trx.sn_ref; changed = true;
                        try { global.waSocket?.sendMessage(user.jid || phone+'@s.whatsapp.net', { text: `✅ *TRANSAKSI SUKSES*\n\n📦 Produk: *${trx.produk}*\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}\n\nPesanan kamu sudah masuk ya kak!` }); } catch(e){}
                        sendTeleNotif(`✅ *UPDATE: TRANSAKSI SUKSES* ✅\n\n👤 Nama: ${uData.name}\n📱 WA: ${phone}\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n🔖 SN: ${trx.sn_ref}`, 'trx');
                    } else if (digiData.status === 'Gagal') {
                        trx.status = 'Gagal'; trx.sn_ref = digiData.sn || digiData.message || 'Gagal Pusat';
                        user.saldo += trx.harga; 
                        user.mutasi.push({ id: 'REF'+Date.now(), type: 'in', amount: trx.harga, desc: `Refund: ${trx.produk}`, date: new Date().toLocaleString('id-ID') }); 
                        changed = true;
                        try { global.waSocket?.sendMessage(user.jid || phone+'@s.whatsapp.net', { text: `❌ *TRANSAKSI GAGAL*\n\n📦 Produk: *${trx.produk}*\n📱 Tujuan: ${trx.no_tujuan}\n⚠️ Alasan: ${digiData.message || 'Gangguan Server'}\n\n💰 Saldo Rp ${trx.harga.toLocaleString('id-ID')} telah dikembalikan otomatis ke akun kamu.` }); } catch(e){}
                        sendTeleNotif(`❌ *UPDATE: TRANSAKSI GAGAL (REFUND)* ❌\n\n👤 Nama: ${uData.name}\n📱 WA: ${phone}\n📦 Produk: ${trx.produk}\n📱 Tujuan: ${trx.no_tujuan}\n⚠️ Alasan: ${digiData.message || 'Gagal Pusat'}`, 'trx');
                    }
                } catch(e) {}
            }
        }
    }
    if (changed) saveJSON(dbFile, db);
}, 20000); 

function startAutoBackup() {
    let config = loadJSON(configFile); let t = config.teleTokenBackup || config.teleToken; let c = config.teleChatIdBackup || config.teleChatId;
    if(!t || !c || !config.autoBackupHours || config.autoBackupHours <= 0) return;
    setInterval(() => {
        let zipName = `AutoBackup_FikyStore_${Date.now()}.zip`;
        exec(`zip -r ${zipName} database.json web_users.json config.json local_products.json info.json`, async (error) => {
            if(!error) {
                const form = new FormData(); form.append('chat_id', c); form.append('caption', `⏳ *AUTO BACKUP (${config.autoBackupHours} Jam)*\n\nTanggal: ${new Date().toLocaleString('id-ID')}`); form.append('document', fs.createReadStream(zipName));
                try { await axios.post(`https://api.telegram.org/bot${t}/sendDocument`, form, { headers: form.getHeaders() }); } catch(e) {}
                fs.unlinkSync(zipName);
            }
        });
    }, config.autoBackupHours * 60 * 60 * 1000);
}
setTimeout(startAutoBackup, 15000); 

// ==========================================
// TOPUP & ADMIN & AUTH LOGIC
// ==========================================
app.post('/api/topup/request', (req, res) => {
    const { phone, method, nominal } = req.body; let db = loadJSON(dbFile); let webUsers = loadJSON(webUsersFile); let uData = webUsers[phone] || { name: 'Unknown', email: 'Unknown' };
    if (!db[phone]) db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    if (!db[phone].topup) db[phone].topup = [];
    const expiry = method === 'QRIS Otomatis' ? Date.now() + 5*60*1000 : null; let dateStr = new Date().toLocaleString('id-ID');
    const newTopup = { id: 'TU' + Date.now(), method, nominal, status: 'Proses', date: dateStr, expiry };
    db[phone].topup.push(newTopup); saveJSON(dbFile, db); 
    let kodeUnik = nominal % 1000; let depositAsli = nominal - kodeUnik; let saldoSebelum = db[phone].saldo;
    sendTeleNotif(`⏳ *TOP UP MENUNGGU PEMBAYARAN* ⏳\n\n👤 Nama: ${uData.name}\n✉️ Email: ${uData.email}\n📱 WA: ${phone}\n⌚ Waktu: ${dateStr}\n🏦 Metode: ${method}\n\n💰 Jumlah Deposit: Rp ${depositAsli.toLocaleString('id-ID')}\n🎫 Kode Unik: ${kodeUnik}\n💵 Total Saldo Diterima: Rp ${nominal.toLocaleString('id-ID')}\n\n💳 *Riwayat Saldo*\n📉 Saldo Sebelum: Rp ${saldoSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${saldoSebelum.toLocaleString('id-ID')} (Pending)`, 'topup');
    res.json({ message: 'Top up direkam' });
});

app.post('/api/topup/history', (req, res) => { 
    let db = loadJSON(dbFile); let history = db[req.body.phone]?.topup || []; let changed = false; let now = Date.now();
    history.forEach(t => { if (t.status === 'Proses' && t.method === 'QRIS Otomatis' && t.expiry && now > t.expiry) { t.status = 'Expired'; changed = true; }});
    if (changed) saveJSON(dbFile, db); res.json({ history: history }); 
});

app.get('/api/admin/backup', async (req, res) => {
    let config = loadJSON(configFile); let t = config.teleTokenBackup || config.teleToken; let c = config.teleChatIdBackup || config.teleChatId;
    if(!t || !c) return res.status(400).json({ error: "Token/Chat ID Telegram Backup belum disetting." });
    try {
        let zipName = `Backup_DigitalFikyStore_${Date.now()}.zip`;
        exec(`zip -r ${zipName} database.json web_users.json config.json local_products.json info.json`, async (error) => {
            if(error) return res.status(500).json({ error: "Gagal membuat file ZIP." });
            const form = new FormData(); form.append('chat_id', c); form.append('caption', `📦 *BACKUP MANUAL BERHASIL*\n\nTanggal: ${new Date().toLocaleString('id-ID')}`); form.append('parse_mode', 'Markdown'); form.append('document', fs.createReadStream(zipName));
            await axios.post(`https://api.telegram.org/bot${t}/sendDocument`, form, { headers: form.getHeaders() }); fs.unlinkSync(zipName); res.json({ message: "Backup sukses terkirim ke Telegram!" });
        });
    } catch (e) { res.status(500).json({ error: "Gagal mengirim ke Telegram." }); }
});

app.post('/api/admin/balance', async (req, res) => {
    const { identifier, amount, action } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile); let targetPhone = null;
    if(identifier.includes('@')){ for(let p in webUsers){ if(webUsers[p].email === identifier){ targetPhone = p; break; } } } else { targetPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier; }
    if(!targetPhone || !webUsers[targetPhone]) return res.json({ success: false, message: '\n❌ Member tidak ditemukan!' });
    if(!db[targetPhone]) db[targetPhone] = { saldo: 0, jid: targetPhone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] };
    if(!db[targetPhone].mutasi) db[targetPhone].mutasi = []; if(!db[targetPhone].topup) db[targetPhone].topup = [];
    let uData = webUsers[targetPhone]; let saldoSebelum = db[targetPhone].saldo; const dateStr = new Date().toLocaleString('id-ID');
    if (action === 'add') {
        db[targetPhone].saldo += parseInt(amount); let saldoSesudah = db[targetPhone].saldo;
        db[targetPhone].mutasi.push({ id: 'TRX'+Date.now(), type: 'in', amount: parseInt(amount), desc: 'Penambahan oleh Admin', date: dateStr }); db[targetPhone].topup.push({ id: 'TU'+Date.now(), method: 'Admin Fiky Store', nominal: parseInt(amount), status: 'Sukses', date: dateStr }); saveJSON(dbFile, db);
        try { await global.waSocket?.sendMessage(targetPhone + '@c.us', { text: `🎉 Saldo Anda berhasil ditambah Admin sebesar *Rp ${parseInt(amount).toLocaleString('id-ID')}*.\n💰 Sisa Saldo: *Rp ${db[targetPhone].saldo.toLocaleString('id-ID')}*` }); } catch(e) {}
        sendTeleNotif(`✅ *PEMBAYARAN DITERIMA (TOP UP BERHASIL)* ✅\n\n👤 Nama: ${uData.name}\n✉️ Email: ${uData.email}\n📱 WA: ${targetPhone}\n⌚ Waktu: ${dateStr}\n🏦 Metode: Admin Fiky Store\n\n💰 Total Saldo Masuk: Rp ${parseInt(amount).toLocaleString('id-ID')}\n\n💳 *Riwayat Saldo*\n📉 Saldo Sebelum: Rp ${saldoSebelum.toLocaleString('id-ID')}\n📈 Saldo Sesudah: Rp ${saldoSesudah.toLocaleString('id-ID')}`, 'topup');
        res.json({ success: true, message: `\n✅ Saldo ${webUsers[targetPhone].name} berhasil ditambah!` });
    } else if (action === 'reduce') {
        db[targetPhone].saldo -= parseInt(amount); db[targetPhone].mutasi.push({ id: 'TRX'+Date.now(), type: 'out', amount: parseInt(amount), desc: 'Penarikan oleh Admin', date: dateStr }); saveJSON(dbFile, db);
        try { await global.waSocket?.sendMessage(targetPhone + '@c.us', { text: `⚠️ Saldo Anda telah dikurangi Admin sebesar *Rp ${parseInt(amount).toLocaleString('id-ID')}*.\n💰 Sisa Saldo: *Rp ${db[targetPhone].saldo.toLocaleString('id-ID')}*` }); } catch(e) {}
        res.json({ success: true, message: `\n✅ Saldo ${webUsers[targetPhone].name} berhasil dikurangi!` });
    }
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => (p === fPhone || webUsers[p].email === identifier) && webUsers[p].password === password);
    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP.' });
        res.json({ message: 'Login sukses', user: { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email, avatar: webUsers[foundPhone].avatar || null } });
    } else { res.status(400).json({ error: 'Email/No HP atau Password salah.' }); }
});

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (webUsers[fPhone] && webUsers[fPhone].isVerified) return res.status(400).json({ error: 'Nomor sudah terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fPhone] = { name, email, password, isVerified: false, otp, otpExpiry: Date.now() + 300000, avatar: null }; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Halo kak *${name}* 👋\n\nTerima kasih telah mendaftar di *DIGITAL FIKY STORE* 👑\n\nBerikut adalah kode rahasia (OTP) untuk mengaktifkan akun kakak:\n\n*${otp}*\n\n⏳ _Kode ini hanya berlaku selama 5 menit._` }); res.json({ message: 'OTP Terkirim', phone: fPhone }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp) {
        if (String(webUsers[phone].otp).trim() === String(otp).trim()) {
            if (Date.now() > (webUsers[phone].otpExpiry || Infinity)) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
            webUsers[phone].isVerified = true; delete webUsers[phone].otp; delete webUsers[phone].otpExpiry; saveJSON(webUsersFile, webUsers);
            let db = loadJSON(dbFile); if (!db[phone]) { db[phone] = { saldo: 0, jid: phone + '@s.whatsapp.net', mutasi: [], topup: [], transactions: [] }; saveJSON(dbFile, db); } 
            sendTeleNotif(`🎊 *MEMBER BARU BERGABUNG* 🎊\n\n👤 Nama: ${webUsers[phone].name}\n📱 WA: ${phone}\n✉️ Email: ${webUsers[phone].email}`, 'trx'); res.json({ message: 'Sukses!' });
        } else { res.status(400).json({ error: 'OTP Salah.' }); }
    } else { res.status(400).json({ error: 'Sesi tidak valid.' }); }
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body; let webUsers = loadJSON(webUsersFile); let fPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
    if (!webUsers[fPhone]) return res.status(400).json({ error: 'Nomor tidak terdaftar.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fPhone].otp = otp; webUsers[fPhone].otpExpiry = Date.now() + 300000; saveJSON(webUsersFile, webUsers);
    try { await global.waSocket?.sendMessage(fPhone + '@c.us', { text: `Halo kak 👋\n\nBerikut OTP untuk mereset password:\n\n*${otp}*\n\n⏳ _Kode ini hanya berlaku selama 5 menit._` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); }
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body; let webUsers = loadJSON(webUsersFile);
    if (webUsers[phone] && webUsers[phone].otp) {
        if (String(webUsers[phone].otp).trim() === String(otp).trim()) {
            if(Date.now() > (webUsers[phone].otpExpiry || Infinity)) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
            webUsers[phone].password = newPassword; delete webUsers[phone].otp; delete webUsers[phone].otpExpiry; saveJSON(webUsersFile, webUsers); res.json({ message: 'Diubah!' }); 
        } else { res.status(400).json({ error: 'OTP Salah.' }); }
    } else { res.status(400).json({ error: 'Sesi tidak valid.' }); }
});

app.post('/api/auth/request-update-otp', async (req, res) => {
    const { oldPhone, newPhone } = req.body; let webUsers = loadJSON(webUsersFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (webUsers[fNew] && fNew !== fOld) return res.status(400).json({ error: 'Nomor baru sudah terdaftar.' });
    if(!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    const otp = Math.floor(1000 + Math.random() * 9000).toString(); webUsers[fOld].updateOtp = otp; webUsers[fOld].updateOtpExpiry = Date.now() + 300000; saveJSON(webUsersFile, webUsers); 
    let targetWA = fNew !== fOld ? fNew : fOld;
    try { await global.waSocket?.sendMessage(targetWA + '@c.us', { text: `Halo kak 👋\n\nBerikut kode OTP untuk memverifikasi perubahan keamanan akun (Nomor/Password) di *DIGITAL FIKY STORE*:\n\n*${otp}*\n\n⏳ _Berlaku 5 menit._` }); res.json({ message: 'OTP Terkirim' }); } catch(e) { res.status(500).json({ error: 'Gagal kirim WA.' }); } 
});

app.post('/api/auth/update', (req, res) => {
    const { oldPhone, newPhone, newName, otp, avatar, newPassword } = req.body; let webUsers = loadJSON(webUsersFile); let db = loadJSON(dbFile);
    let fOld = oldPhone.startsWith('0') ? '62' + oldPhone.slice(1) : oldPhone; let fNew = newPhone.startsWith('0') ? '62' + newPhone.slice(1) : newPhone;
    if (!webUsers[fOld]) return res.status(400).json({ error: 'Akun tidak ditemukan.' });
    let isSecureChange = (fOld !== fNew) || (newPassword && newPassword.trim() !== '');
    if (isSecureChange) {
        if (fOld !== fNew && webUsers[fNew]) return res.status(400).json({ error: 'Nomor sudah dipakai.' });
        if (String(webUsers[fOld].updateOtp).trim() !== String(otp).trim()) return res.status(400).json({ error: 'Kode OTP Salah.' });
        if (Date.now() > (webUsers[fOld].updateOtpExpiry||Infinity)) return res.status(400).json({ error: 'OTP kedaluwarsa.' });
        if (fOld !== fNew) {
            webUsers[fNew] = { ...webUsers[fOld], name: newName, avatar: avatar || webUsers[fOld].avatar }; 
            if (newPassword && newPassword.trim() !== '') webUsers[fNew].password = newPassword;
            delete webUsers[fNew].updateOtp; delete webUsers[fNew].updateOtpExpiry; delete webUsers[fOld];
            if (db[fOld]) { db[fNew] = { ...db[fOld], jid: fNew + '@s.whatsapp.net' }; delete db[fOld]; }
        } else {
            webUsers[fOld].name = newName; if(avatar !== undefined) webUsers[fOld].avatar = avatar; if (newPassword && newPassword.trim() !== '') webUsers[fOld].password = newPassword;
            delete webUsers[fOld].updateOtp; delete webUsers[fOld].updateOtpExpiry;
        }
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
    const sock = makeWASocket({ version, auth: state, logger: pino({ level: 'silent' }), browser: ['Ubuntu', 'Chrome', '20.0.0'], printQRInTerminal: false });
    if (!sock.authState.creds.registered) { 
        let config = loadJSON(configFile); 
        if (config.botNumber) { setTimeout(async () => { try { const code = await sock.requestPairingCode(config.botNumber.replace(/[^0-9]/g, '')); console.log(`\n🔑 KODE PAIRING: ${code}\n`); } catch (error) {} }, 5000); } 
    }
    sock.ev.on('connection.update', (update) => { const { connection } = update; if (connection === 'close') setTimeout(startBot, 3000); else if (connection === 'open') console.log('\n✅ BOT WHATSAPP BERHASIL TERHUBUNG!\n'); });
    sock.ev.on('creds.update', saveCreds); global.waSocket = sock; 
}

if (require.main === module) { app.listen(3000, () => { console.log('🌐 Web berjalan di port 3000'); }); startBot(); }
EOF

echo "Menginstal modul Node.js..."
npm install --silent
npm install -g pm2 > /dev/null 2>&1

echo "[5/5] Memperbarui Panel Manajemen VPS..."

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

while true; do clear
    echo -e "${CYAN}======================================================${NC}"
    echo -e "${YELLOW}          💎 PANEL DIGITAL FIKY STORE (V146) 💎       ${NC}"
    echo -e "${CYAN}======================================================${NC}"
    echo ""
    echo -e "${PURPLE}[ 🤖 MANAJEMEN BOT WHATSAPP ]${NC}"
    echo -e "  ${GREEN}1.${NC} Setup No. Bot & Login Pairing"
    echo -e "  ${GREEN}2.${NC} Jalankan Bot (Latar Belakang/PM2)"
    echo -e "  ${YELLOW}3.${NC} 🛠️ Install & Perbarui Sistem Bot WA"
    echo -e "  ${GREEN}4.${NC} Lihat Log / Error Bot"
    echo -e "  ${GREEN}5.${NC} Reset Sesi & Ganti Nomor Bot"
    echo -e "  ${GREEN}6.${NC} 📢 Broadcast Pengumuman ke Pusat Informasi App"
    echo ""
    echo -e "${PURPLE}[ 📱 MANAJEMEN APLIKASI & WEB ]${NC}"
    echo -e "  ${GREEN}7.${NC} 💰 Manajemen Saldo Member"
    echo -e "  ${GREEN}8.${NC} 🖼️ Sinkronisasi Gambar Banner Lokal"
    echo -e "  ${GREEN}9.${NC} 📈 Seting Pasang Harga (Keuntungan/Markup)"
    echo -e "  ${GREEN}10.${NC} 📦 Manajemen Produk (Katalog Manual Satu-Satu)"
    echo -e "  ${YELLOW}11.${NC} 🚀 IMPORT CSV MASSAL (Ratusan Produk 1 Detik)"
    echo ""
    echo -e "${PURPLE}[ 🌐 MANAJEMEN SERVER & API ]${NC}"
    echo -e "  ${GREEN}12.${NC} Setup Domain (Nginx + Cloudflare + UFW Firewall)"
    echo -e "  ${GREEN}13.${NC} 🔌 Setup API Digiflazz"
    echo -e "  ${GREEN}14.${NC} 🔍 Cek Saldo & Koneksi Digiflazz"
    echo -e "  ${GREEN}15.${NC} 🔄 Refresh Katalog Digiflazz (Hapus Cache API)"
    echo ""
    echo -e "${PURPLE}[ 🛡️ PUSAT KOMANDO TELEGRAM ]${NC}"
    echo -e "  ${GREEN}16.${NC} ⚙️ Setup Telegram Bot (Trx, Topup, Backup)"
    echo -e "  ${GREEN}17.${NC} ⏳ Setting Auto-Backup Telegram (Tiap X Jam)"
    echo -e "  ${GREEN}18.${NC} 💾 BACKUP DATA MANUAL KE TELEGRAM"
    echo -e "  ${GREEN}19.${NC} 📥 RESTORE DATA DARI DIRECT LINK"
    echo ""
    echo -e "${PURPLE}[ ⚙️ SISTEM ]${NC}"
    echo -e "  ${YELLOW}20.${NC} Update Sistem"
    echo -e "  ${RED}0.${NC} Keluar"
    echo -e "${CYAN}======================================================${NC}"
    read -p "Pilih menu [0-20]: " choice

    case $choice in
        1) clear; read -p "Masukkan Nomor WA Bot (Awalan 62): " botnum; if [ ! -z "$botnum" ]; then cd "$HOME/$DIR_NAME"; node -e "const fs=require('fs');let f='./config.json';let c=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):{};c.botNumber='$botnum';fs.writeFileSync(f,JSON.stringify(c,null,2));"; echo -e "${GREEN}Nomor disimpan! Tunggu 5-10 detik...${NC}"; node index.js; fi ;;
        2) cd "$HOME/$DIR_NAME" && pm2 delete $BOT_NAME 2>/dev/null; pm2 start index.js --name "$BOT_NAME" && pm2 save ;;
        3) clear; cd "$HOME/$DIR_NAME"; echo "Menghapus cache..."; rm -rf node_modules package-lock.json; npm cache clean --force; echo "Menginstal ulang..."; npm install; pm2 restart $BOT_NAME > /dev/null 2>&1; echo -e "${GREEN}✅ Selesai!${NC}"; read -p "Enter..." ;;
        4) pm2 logs $BOT_NAME ;;
        5) pm2 stop $BOT_NAME 2>/dev/null; rm -rf "$HOME/$DIR_NAME/sesi_bot"; echo -e "${GREEN}Sesi WA dihapus.${NC}"; read -p "Enter..." ;;
        6) clear; read -p "Judul: " b_judul; read -p "Isi: " b_isi; if [ ! -z "$b_isi" ]; then cd "$HOME/$DIR_NAME"; node -e "const http=require('http');const data=JSON.stringify({judul:'$b_judul', message:'$b_isi'});const req=http.request({hostname:'localhost',port:3000,path:'/api/admin/broadcast',method:'POST',headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(data)}},res=>{});req.write(data);req.end();"; echo -e "\n${GREEN}✅ Broadcast sukses!${NC}"; fi; read -p "Enter..." ;;
        7) clear; echo "1. Cek Semua 2. Tambah 3. Kurangi 0. Kembali"; read -p "Pilih: " s_menu; if [ "$s_menu" == "1" ]; then cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');const db=fs.existsSync('./database.json')?JSON.parse(fs.readFileSync('./database.json')):{};const users=fs.existsSync('./web_users.json')?JSON.parse(fs.readFileSync('./web_users.json')):{};for(let p in users){if(users[p].isVerified){console.log('- '+users[p].name+' ('+p+') : Rp '+(db[p]?db[p].saldo:0));}}"; read -p "Enter..."; elif [ "$s_menu" == "2" ]; then read -p "No WA: " no_mem; read -p "Jumlah: " jm_mem; cd "$HOME/$DIR_NAME" && node -e "const http=require('http');const data=JSON.stringify({identifier:'$no_mem',amount:parseInt('$jm_mem'),action:'add'});const req=http.request({hostname:'localhost',port:3000,path:'/api/admin/balance',method:'POST',headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(data)}},res=>{res.on('data',c=>console.log(c.toString()));});req.write(data);req.end();"; read -p "Enter..."; elif [ "$s_menu" == "3" ]; then read -p "No WA: " no_mem; read -p "Jumlah: " jm_mem; cd "$HOME/$DIR_NAME" && node -e "const http=require('http');const data=JSON.stringify({identifier:'$no_mem',amount:parseInt('$jm_mem'),action:'reduce'});const req=http.request({hostname:'localhost',port:3000,path:'/api/admin/balance',method:'POST',headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(data)}},res=>{res.on('data',c=>console.log(c.toString()));});req.write(data);req.end();"; read -p "Enter..."; fi ;;
        8) clear; echo "1. Sinkronisasi 2. Hapus Banner"; read -p "Pilih: " b_menu; if [ "$b_menu" == "1" ]; then cd "$HOME/$DIR_NAME"; node -e "const fs=require('fs'); const path='./public/banners'; if(!fs.existsSync(path)) fs.mkdirSync(path, {recursive:true}); let files = fs.readdirSync(path).filter(f => f.match(/\.(jpg|jpeg|png|gif)$/i)); let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{}; cfg.banners = files; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ Sinkronisasi sukses!');"; pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Enter..."; elif [ "$b_menu" == "2" ]; then cd "$HOME/$DIR_NAME"; node -e "const fs=require('fs'); let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{}; cfg.banners=[]; fs.writeFileSync('./config.json', JSON.stringify(cfg, null, 2)); console.log('✅ Banner dihapus!');"; pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Enter..."; fi ;;
        9) clear; read -p "1. Modal Tier 1: " l1; read -p "-> Untung T1: " m1; read -p "2. Modal Tier 2: " l2; read -p "-> Untung T2: " m2; read -p "3. Modal Tier 3: " l3; read -p "-> Untung T3: " m3; read -p "4. Untung T4 (>T3): " m4; cd "$HOME/$DIR_NAME"; node -e "const fs=require('fs'); let file='./config.json'; let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{}; cfg.markupRules = { l1: parseInt('$l1')||10000, m1: parseInt('$m1')||0, l2: parseInt('$l2')||50000, m2: parseInt('$m2')||0, l3: parseInt('$l3')||100000, m3: parseInt('$m3')||0, m4: parseInt('$m4')||0 }; fs.writeFileSync(file, JSON.stringify(cfg, null, 2)); console.log('\n✅ Disimpan!');"; pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Enter..." ;;
        10) read -p "1. Tambah 2. Hapus: " pr_menu; if [ "$pr_menu" == "1" ]; then read -p "Tipe (pulsa/data/dll): " tp; read -p "Brand: " p_brand; read -p "Kategori: " p_cat; read -p "Nama: " p_name; read -p "Harga Modal: " p_price; read -p "SKU: " p_sku; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let f='./local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];data.push({id:'LOC'+Date.now(),type:'$tp',brand:'$p_brand',category:'$p_cat',name:'$p_name',price:parseInt('$p_price')||0,sku:'$p_sku',isDigi:true});fs.writeFileSync(f,JSON.stringify(data,null,2));console.log('Berhasil!');"; read -p "Enter..."; elif [ "$pr_menu" == "2" ]; then cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let f='./local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];data.forEach((p,i)=>console.log('['+i+'] '+p.name));"; read -p "Nomor ID: " del_id; if [ ! -z "$del_id" ]; then cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let f='./local_products.json';let data=fs.existsSync(f)?JSON.parse(fs.readFileSync(f)):[];if(data['$del_id']){data.splice('$del_id',1);fs.writeFileSync(f,JSON.stringify(data,null,2));console.log('\n✅ Terhapus!');}"; fi; read -p "Enter..."; fi ;;
        11) clear; echo "Pastikan ada import.csv. Ketik Y jika sudah: "; read confirm_csv; if [[ "$confirm_csv" == "y" || "$confirm_csv" == "Y" ]]; then cd "$HOME/$DIR_NAME"; node -e "const fs=require('fs');const file='./import.csv';if(!fs.existsSync(file))process.exit();const lines=fs.readFileSync(file,'utf-8').split('\n');let data=fs.existsSync('./local_products.json')?JSON.parse(fs.readFileSync('./local_products.json')):[];lines.forEach(line=>{let p=line.split(';');if(p.length>=6){data.push({id:'LOC'+Date.now()+Math.random(),type:p[0].trim().toLowerCase(),brand:p[1].trim(),category:p[2].trim(),name:p[3].trim(),price:parseInt(p[4].trim())||0,sku:p[5].trim(),desc:p[6]?p[6].trim():'',isDigi:true});}});fs.writeFileSync('./local_products.json',JSON.stringify(data,null,2));fs.unlinkSync(file);console.log('✅ Import sukses!');"; fi; read -p "Enter..." ;;
        12) read -p "Domain (cth: a.com): " domain_name; if [ ! -z "$domain_name" ]; then apt-get install nginx ufw -y > /dev/null 2>&1; ufw allow 80/tcp > /dev/null 2>&1; ufw allow 443/tcp > /dev/null 2>&1; cat << EOFNGINX > /etc/nginx/sites-available/$domain_name
server { listen 80; server_name $domain_name; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host \$host; proxy_cache_bypass \$http_upgrade; proxy_set_header X-Real-IP \$remote_addr; proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; proxy_set_header X-Forwarded-Proto \$scheme; } }
EOFNGINX
ln -sf /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/; rm -f /etc/nginx/sites-enabled/default; nginx -t && systemctl restart nginx; echo -e "${GREEN}✅ Domain aktif!${NC}"; fi; read -p "Enter..." ;;
        13) read -p "User Digiflazz: " digi_user; read -p "Key: " digi_key; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let file='./config.json';let cfg=fs.existsSync(file)?JSON.parse(fs.readFileSync(file)):{};cfg.digiUser='$digi_user';cfg.digiKey='$digi_key';fs.writeFileSync(file,JSON.stringify(cfg,null,2));"; pm2 restart $BOT_NAME > /dev/null 2>&1; read -p "Enter..." ;;
        14) clear; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};if(!cfg.digiUser||!cfg.digiKey)process.exit();const axios=require('axios');const crypto=require('crypto');let sign=crypto.createHash('md5').update(cfg.digiUser+cfg.digiKey+'depo').digest('hex');axios.post('https://api.digiflazz.com/v1/cek-saldo',{cmd:'deposit',username:cfg.digiUser,sign:sign}).then(r=>{if(r.data&&r.data.data)console.log('\n✅ Saldo: Rp '+r.data.data.deposit);else console.log('\n❌ Gagal');}).catch(e=>console.log('\n❌ Error Koneksi'));"; read -p "Enter..." ;;
        15) cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs'); let f='./digi_cache.json'; if(fs.existsSync(f)){ fs.unlinkSync(f); console.log('Cache dihapus!'); }"; pm2 restart all > /dev/null 2>&1; read -p "Enter..." ;;
        16) echo "1.Trx 2.Topup 3.Backup"; read -p "Pilih: " bot_sel; if [ "$bot_sel" == "1" ]; then read -p "Token: " t_trx; read -p "Chat ID: " c_trx; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};cfg.teleTokenTrx='$t_trx';cfg.teleChatIdTrx='$c_trx';fs.writeFileSync('./config.json',JSON.stringify(cfg,null,2));"; elif [ "$bot_sel" == "2" ]; then read -p "Token: " t_topup; read -p "Chat ID: " c_topup; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};cfg.teleTokenTopup='$t_topup';cfg.teleChatIdTopup='$c_topup';fs.writeFileSync('./config.json',JSON.stringify(cfg,null,2));"; elif [ "$bot_sel" == "3" ]; then read -p "Token: " t_backup; read -p "Chat ID: " c_backup; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};cfg.teleTokenBackup='$t_backup';cfg.teleChatIdBackup='$c_backup';fs.writeFileSync('./config.json',JSON.stringify(cfg,null,2));"; fi; pm2 restart all > /dev/null 2>&1; read -p "Enter..." ;;
        17) read -p "Tiap berapa jam?: " tele_jam; cd "$HOME/$DIR_NAME" && node -e "const fs=require('fs');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};cfg.autoBackupHours=parseFloat('$tele_jam');fs.writeFileSync('./config.json',JSON.stringify(cfg,null,2));"; pm2 restart all > /dev/null 2>&1; read -p "Enter..." ;;
        18) cd "$HOME/$DIR_NAME"; node -e "const axios=require('axios');const fs=require('fs');const FormData=require('form-data');const {exec}=require('child_process');let cfg=fs.existsSync('./config.json')?JSON.parse(fs.readFileSync('./config.json')):{};let t=cfg.teleTokenBackup||cfg.teleToken;let c=cfg.teleChatIdBackup||cfg.teleChatId;if(!t||!c)process.exit();let zipName='Backup_'+Date.now()+'.zip';exec('zip -r '+zipName+' database.json web_users.json config.json local_products.json info.json',(err)=>{const form=new FormData();form.append('chat_id',c);form.append('document',fs.createReadStream(zipName));axios.post('https://api.telegram.org/bot'+t+'/sendDocument',form,{headers:form.getHeaders()}).then(()=>{fs.unlinkSync(zipName);});});"; echo "Proses..."; read -p "Enter..." ;;
        19) read -p "Link ZIP: " link_zip; cd "$HOME/$DIR_NAME" && wget -qO restore.zip "$link_zip"; if [ -f "restore.zip" ]; then unzip -o restore.zip && rm -f restore.zip; pm2 restart all > /dev/null 2>&1; echo "Sukses"; fi; read -p "Enter..." ;;
        20) echo -e "${YELLOW}Update via Git...${NC}"; cd "$HOME/$DIR_NAME"; git pull origin main; npm install; chmod +x menu; cp menu /usr/bin/menu; pm2 restart all > /dev/null 2>&1; echo "Selesai!"; read -p "Enter..." ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu
pm2 restart all > /dev/null 2>&1
echo "=========================================================="
echo "  SISTEM WEB V146 BERHASIL DIPERBARUI SECARA PENUH!       "
echo "  Ketik 'menu' di terminal untuk membuka panel manajemen  "
echo "=========================================================="
