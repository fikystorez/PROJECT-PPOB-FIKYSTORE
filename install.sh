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
echo "      MENGINSTAL DIGITAL FIKY STORE - PREMIUM THEME       "
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
# MEMBUAT TAMPILAN WEB (FULL YELLOW & OXFORD BLUE)
# ==========================================
echo "[3/5] Membangun Antarmuka Website (Logo Custom F & Full Yellow)..."

cat << 'EOF' > public/style.css
body {
    background-color: #fde047; /* KUNING PENUH SAMPAI BAWAH */
    margin: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100vh;
    font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
}

/* Kotak Modal Oxford Blue */
.centered-modal-box {
    background-color: #002147; /* Oxford Blue */
    padding: 3rem 1.5rem 2rem 1.5rem; /* Padding atas dilebarkan untuk ruang logo */
    border-radius: 1.2rem; 
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2); 
    width: 90%;
    max-width: 360px; 
    text-align: center;
    position: relative;
    z-index: 10;
}

/* Logo "F" Premium Hitam & Perak (Sesuai Referensi Terbaru) */
.logo-f-metalik-box {
    width: 85px; 
    height: 85px;
    margin: 0 auto; 
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    background: radial-gradient(circle, #333333 0%, #000000 100%); /* Latar hitam elegan */
    box-shadow: inset 0 0 10px rgba(255,255,255,0.2), 0 10px 20px rgba(0,0,0,0.5); 
    position: relative;
    border: 3px solid #94a3b8; /* Border perak metalik */
}

.logo-f-metalik-box::before {
    content: "F";
    font-size: 55px;
    font-family: "Times New Roman", Times, serif;
    font-weight: bold;
    color: #e2e8f0; /* Huruf F Perak Terang */
    text-shadow: 2px 2px 4px rgba(0,0,0,0.9), -1px -1px 1px rgba(255,255,255,0.3); /* Efek 3D Metalik */
    position: absolute;
    top: 52%;
    left: 50%;
    transform: translate(-50%, -50%);
}

/* Input Fields */
.compact-input-box {
    width: 100%;
    padding: 0.6rem 0.75rem; 
    border: 1px solid #334155; 
    border-radius: 0.5rem; 
    margin-bottom: 0.85rem; 
    font-size: 0.875rem; 
    outline: none;
    background-color: #ffffff; 
    color: #0f172a;
}

.compact-input-box:focus {
    border-color: #fde047; 
    box-shadow: 0 0 0 3px rgba(253, 224, 71, 0.3); 
}

::placeholder { color: #94a3b8; font-size: 0.8rem; }

/* Teks Terang untuk background gelap */
.compact-text-small { font-size: 0.8rem; color: #cbd5e1; }
.compact-label { font-size: 0.8rem; font-weight: bold; color: #f8fafc; margin-bottom: 0.25rem; display: block; text-align: left; }
.compact-link-small { font-size: 0.8rem; color: #fde047; text-decoration: none; font-weight: bold; }
.compact-link-small:hover { text-decoration: underline; color: #fef08a; }

/* Tombol Kuning Penuh */
.btn-yellow {
    width: 100%; padding: 0.625rem 1rem;
    background-color: #fde047; color: #002147;
    font-weight: bold; font-size: 0.9rem;
    border-radius: 0.5rem; cursor: pointer; border: none;
    transition: all 0.2s;
}
.btn-yellow:hover { background-color: #facc15; }
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
<body class="flex flex-col items-center justify-center h-screen relative">
    
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
        
        <div class="mt-6 text-center compact-text-small">
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
<body class="flex flex-col items-center justify-center h-screen relative">
    
    <div class="z-20 mb-[-42px]" id="logo-header">
        <div class="logo-f-metalik-box"></div>
    </div>

    <div class="centered-modal-box pt-14" id="box-register">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-2">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        
        <h2 class="text-lg font-bold text-white mb-1">DAFTAR AKUN</h2>
        <p class="compact-text-small mb-4">Silahkan lengkapi data untuk mendaftar!</p>

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
            
            <button type="submit" class="btn-yellow mt-1">Daftar Sekarang</button>
        </form>
        
        <div class="mt-4 text-center compact-text-small">
            Sudah punya akun? <a href="/" class="compact-link-small">Login disini</a>
        </div>
    </div>

    <div class="centered-modal-box pt-14 hidden" id="box-otp">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">VERIFIKASI WA</h2>
        <p class="compact-text-small mb-5 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda.</p>
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
<body class="flex flex-col items-center justify-center h-screen relative">
    
    <div class="z-20 mb-[-42px]">
        <div class="logo-f-metalik-box"></div>
    </div>

    <div class="centered-modal-box pt-14">
        <div class="inline-block border-2 border-yellow-300 rounded-full px-5 py-1 mb-4">
            <h1 class="text-sm font-extrabold text-yellow-300 tracking-widest m-0">DIGITAL FIKY STORE</h1>
        </div>
        <h2 class="text-lg font-bold text-white mb-1">RESET PASSWORD</h2>
        
        <form id="requestOtpForm">
            <p class="compact-text-small mb-5 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div>
                <input type="number" id="phone" class="compact-input-box text-center" required placeholder="Ketik disini (08123...)">
            </div>
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
            
            <button type="submit" class="btn-yellow mt-3">Simpan Password Baru</button>
        </form>
        
        <div class="mt-6 text-center compact-text-small">
            Kembali ke <a href="/" class="compact-link-small">Login</a>
        </div>
    </div>

    <script>
        let resetPhone = '';
        document.getElementById('requestOtpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const phone = document.getElementById('phone').value;
            try {
                const res = await fetch('/api/auth/forgot', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phone })
                });
                const data = await res.json();
                if (res.ok) {
                    resetPhone = data.phone;
                    document.getElementById('requestOtpForm').classList.add('hidden');
                    document.getElementById('resetForm').classList.remove('hidden');
                    alert('OTP Reset Password telah dikirim ke WA Anda!');
                } else { alert(data.error); }
            } catch (err) { alert('Gagal mengirim permintaan.'); }
        });

        document.getElementById('resetForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const otp = document.getElementById('otp').value;
            const newPassword = document.getElementById('newPassword').value;
            try {
                const res = await fetch('/api/auth/reset', {
                    method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ phone: resetPhone, otp, newPassword })
                });
                const data = await res.json();
                if (res.ok) {
                    alert('Password berhasil diubah! Silakan Login kembali.');
                    window.location.href = '/';
                } else { alert(data.error); }
            } catch (err) { alert('Gagal mereset password.'); }
        });
    </script>
</body>
</html>
EOF

cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <nav class="bg-[#002147] p-4 text-white flex justify-between items-center shadow-md border-b-4 border-yellow-400">
        <h1 class="font-bold text-xl text-yellow-400">DIGITAL FIKY STORE</h1>
        <div class="flex items-center gap-4">
            <span id="userName" class="font-semibold text-sm"></span>
            <button onclick="logout()" class="bg-red-600 hover:bg-red-700 px-3 py-1 rounded text-xs font-bold transition">Logout</button>
        </div>
    </nav>
    <div class="container mx-auto mt-8 p-4">
        <div class="bg-white p-6 rounded-lg shadow-md text-center">
            <h2 class="text-2xl font-bold mb-2 text-[#002147]">Selamat Datang!</h2>
            <p class="text-gray-600 mb-4">WhatsApp: <span id="userPhone" class="font-bold text-blue-600"></span></p>
            <div class="p-4 bg-green-100 border-l-4 border-green-500 text-green-700 text-left rounded-md">
                <strong>Sistem Selesai!</strong> Halaman ini siap diisi dengan skrip pembelian PPOB.
            </div>
        </div>
    </div>
    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        document.getElementById('userName').innerText = "Halo, " + user.name;
        document.getElementById('userPhone').innerText = user.phone;
        function logout() { localStorage.removeItem('user'); window.location.href = '/'; }
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS (LOGIK BOT + API WEB AUTH SUNGGUHAN)
# ==========================================
echo "[4/5] Menulis ulang logika Backend Node.js..."
cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, Browsers, jidNormalizedUser, fetchLatestBaileysVersion } = require('@whiskeysockets/baileys');
const { Boom } = require('@hapi/boom');
const fs = require('fs');
const pino = require('pino');
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const { exec } = require('child_process');
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
    console.log("\n⏳ Sedang menyiapkan mesin bot (Baileys)...");
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    let config = loadJSON(configFile);
    
    const { version } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({
        version,
        auth: state,
        logger: pino({ level: 'silent' }),
        browser: Browsers.ubuntu('Chrome'),
        printQRInTerminal: false
    });

    if (!sock.authState.creds.registered && !pairingRequested) {
        pairingRequested = true;
        let phoneNumber = config.botNumber;
        if (!phoneNumber) {
            console.log('\n❌ NOMOR BOT BELUM DIATUR! Gunakan Menu 1 di terminal.');
            process.exit(0);
        }
        setTimeout(async () => {
            try {
                let formattedNumber = phoneNumber.replace(/[^0-9]/g, '');
                const code = await sock.requestPairingCode(formattedNumber);
                console.log(`\n=======================================================`);
                console.log(`🔑 KODE PAIRING ANDA :  ${code}  `);
                console.log(`=======================================================`);
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

    if (webUsers[formattedPhone] && webUsers[formattedPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor HP sudah terdaftar dan terverifikasi.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[formattedPhone] = { name, email, password, isVerified: false, otp };
    saveJSON(webUsersFile, webUsers);

    const message = `Halo *${name}*!\n\nKode OTP Pendaftaran Akun Anda adalah: *${otp}*\n\n_Jangan berikan kode ini kepada siapapun._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].isVerified = true;
        webUsers[phone].otp = null; 
        saveJSON(webUsersFile, webUsers);
        
        let db = loadJSON(dbFile);
        if (!db[phone]) {
            db[phone] = { saldo: 0, tanggal_daftar: new Date().toLocaleDateString('id-ID'), jid: phone + '@s.whatsapp.net' };
            saveJSON(dbFile, db);
        }
        res.json({ message: 'Verifikasi sukses!' });
    } else {
        res.status(400).json({ error: 'OTP Salah.' });
    }
});

app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    let formattedPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => 
        (p === formattedPhone || webUsers[p].email === identifier) && 
        webUsers[p].password === password
    );

    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP. Silakan Daftar Ulang.' });
        let userData = { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email };
        res.json({ message: 'Login sukses', user: userData });
    } else {
        res.status(400).json({ error: 'Email/No HP atau Password salah.' });
    }
});

app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;

    if (!webUsers[formattedPhone] || !webUsers[formattedPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor belum terdaftar / belum diverifikasi.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    webUsers[formattedPhone].otp = otp;
    saveJSON(webUsersFile, webUsers);

    const message = `Halo!\n\nKode OTP Reset Password Anda adalah: *${otp}*\n\n_Jika Anda tidak meminta ini, abaikan pesan ini._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Reset Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        webUsers[phone].password = newPassword;
        webUsers[phone].otp = null; 
        saveJSON(webUsersFile, webUsers);
        res.json({ message: 'Password berhasil diubah!' });
    } else {
        res.status(400).json({ error: 'OTP Salah.' });
    }
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
    echo "      🤖 PANEL DIGITAL FIKY STORE (V14) 🤖     "
    echo "==============================================="
    echo "--- MANAJEMEN BOT & WEB ---"
    echo "1. Setup No. Bot & Login Pairing"
    echo "2. Jalankan Bot (Latar Belakang/PM2)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo "5. Reset Sesi WhatsApp"
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
            echo "⚠️ Ini akan menghapus sesi login WA."
            read -p "Lanjutkan? (y/n): " konfirm
            if [ "$konfirm" == "y" ]; then
                pm2 stop $BOT_NAME 2>/dev/null
                rm -rf "$HOME/$DIR_NAME/sesi_bot"
                echo "✅ Sesi dihapus! Buka Menu 1 untuk Login ulang."
            fi
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
