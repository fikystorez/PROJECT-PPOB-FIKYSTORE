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
echo "      MENGINSTAL DIGITAL FIKY STORE (WEB UI CUSTOM)       "
echo "=========================================================="

echo "[1/5] Memperbarui sistem dan menginstal Dependensi..."
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
# MEMBUAT TAMPILAN WEB (UI CUSTOM MOBILE APP)
# ==========================================
echo "[3/5] Membangun Antarmuka Website (UI Oxford Blue & Maize)..."

# 1. Halaman Login
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { oxford: '#0A174E', maize: '#F5D042' } } }
        }
    </script>
</head>
<body class="bg-gray-100 flex justify-center min-h-screen">
    <div class="w-full max-w-md bg-white min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
        <div class="bg-maize h-48 w-[150%] absolute -top-10 -left-[25%] rounded-b-[50%] z-0"></div>
        
        <div class="relative z-10 px-8 pt-24 flex-grow flex flex-col">
            <h1 class="text-4xl font-extrabold text-oxford mb-2">Login</h1>
            <p class="text-gray-600 mb-8">Silahkan masukkan email/no HP dan password kamu!</p>

            <form id="loginForm" class="flex flex-col flex-grow">
                <div class="mb-5">
                    <label class="block text-oxford font-bold mb-2">Email / No. HP</label>
                    <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford transition-all">
                        <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                        <input type="text" id="identifier" class="w-full bg-transparent outline-none ml-3 text-oxford placeholder-gray-400" placeholder="Ketik disini" required>
                    </div>
                </div>

                <div class="mb-2">
                    <label class="block text-oxford font-bold mb-2">Password</label>
                    <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford transition-all">
                        <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path></svg>
                        <input type="password" id="password" class="w-full bg-transparent outline-none ml-3 text-oxford placeholder-gray-400" placeholder="Ketik disini" required>
                    </div>
                </div>

                <div class="flex justify-end mb-8">
                    <a href="/forgot.html" class="text-oxford font-semibold text-sm hover:text-maize transition-colors">Lupa password?</a>
                </div>

                <div class="flex-grow"></div>

                <div class="pb-8">
                    <p class="text-center text-sm text-gray-500 mb-4">Belum punya akun? <a href="/register.html" class="text-oxford font-bold hover:underline">Daftar disini</a></p>
                    <button type="submit" class="w-full bg-oxford text-maize text-lg font-bold py-4 rounded-full shadow-lg hover:bg-opacity-90 transition-all active:scale-95">Login</button>
                </div>
            </form>
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

# 2. Halaman Register
cat << 'EOF' > public/register.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { oxford: '#0A174E', maize: '#F5D042' } } }
        }
    </script>
</head>
<body class="bg-gray-100 flex justify-center min-h-screen">
    <div class="w-full max-w-md bg-white min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
        <div class="bg-maize h-40 w-[150%] absolute -top-10 -left-[25%] rounded-b-[50%] z-0"></div>
        
        <div class="relative z-10 px-8 pt-20 flex-grow flex flex-col pb-8">
            <div id="box-register" class="flex flex-col flex-grow">
                <h1 class="text-3xl font-extrabold text-oxford mb-2">Daftar</h1>
                <p class="text-gray-600 mb-6 text-sm">Silahkan lengkapi data dibawah ini untuk mulai menggunakan aplikasi.</p>

                <form id="registerForm" class="flex flex-col flex-grow">
                    <div class="mb-4">
                        <label class="block text-oxford font-bold mb-2">Nama Lengkap</label>
                        <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford">
                            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                            <input type="text" id="name" class="w-full bg-transparent outline-none ml-3 text-oxford" placeholder="Ketik disini" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="block text-oxford font-bold mb-2">Nomor HP / WhatsApp</label>
                        <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford">
                            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                            <input type="number" id="phone" class="w-full bg-transparent outline-none ml-3 text-oxford" placeholder="08123..." required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="block text-oxford font-bold mb-1">Email</label>
                        <p class="text-xs text-gray-400 mb-2">Pastikan alamat email masih aktif</p>
                        <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford">
                            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                            <input type="email" id="email" class="w-full bg-transparent outline-none ml-3 text-oxford" placeholder="Ketik disini" required>
                        </div>
                    </div>

                    <div class="mb-8">
                        <label class="block text-oxford font-bold mb-2">Password</label>
                        <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford">
                            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path></svg>
                            <input type="password" id="password" class="w-full bg-transparent outline-none ml-3 text-oxford" placeholder="Ketik disini" required>
                        </div>
                    </div>

                    <div class="flex-grow"></div>

                    <div class="mt-auto">
                        <p class="text-center text-sm text-gray-500 mb-4">Sudah punya akun? <a href="/" class="text-oxford font-bold hover:underline">Login disini</a></p>
                        <button type="submit" class="w-full bg-oxford text-maize text-lg font-bold py-4 rounded-full shadow-lg active:scale-95 transition-transform">Daftar</button>
                    </div>
                </form>
            </div>

            <div id="box-otp" class="hidden flex-col flex-grow">
                <h1 class="text-3xl font-extrabold text-oxford mb-2">Verifikasi WA</h1>
                <p class="text-gray-600 mb-2">Masukkan 4 digit kode OTP yang kami kirimkan ke WhatsApp Anda.</p>
                <p class="text-sm font-bold text-red-500 mb-8">Berlaku 5 Menit.</p>

                <form id="otpForm" class="flex flex-col flex-grow">
                    <div class="mb-4">
                        <label class="block text-oxford font-bold mb-2">Kode OTP</label>
                        <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white focus-within:border-oxford focus-within:ring-1 focus-within:ring-oxford">
                            <input type="number" id="otpCode" class="w-full bg-transparent outline-none text-oxford text-center text-2xl tracking-widest font-bold" placeholder="XXXX" required>
                        </div>
                    </div>
                    <div class="flex-grow"></div>
                    <button type="submit" class="w-full bg-maize text-oxford text-lg font-bold py-4 rounded-full shadow-lg active:scale-95 transition-transform">Verifikasi</button>
                </form>
            </div>
        </div>
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
                    document.getElementById('box-otp').classList.add('flex');
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

# 3. Halaman Forgot Password
cat << 'EOF' > public/forgot.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lupa Password - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { oxford: '#0A174E', maize: '#F5D042' } } }
        }
    </script>
</head>
<body class="bg-gray-100 flex justify-center min-h-screen">
    <div class="w-full max-w-md bg-white min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
        <div class="bg-oxford h-40 w-[150%] absolute -top-10 -left-[25%] rounded-b-[50%] z-0"></div>
        
        <div class="relative z-10 px-8 pt-20 flex-grow flex flex-col pb-8">
            <h1 class="text-3xl font-extrabold text-maize mb-2 text-center">Reset Password</h1>
            
            <form id="requestOtpForm" class="flex flex-col flex-grow mt-8">
                <p class="text-gray-600 mb-6 text-sm text-center">Masukkan Nomor WA terdaftar Anda untuk menerima OTP Reset.</p>
                <div class="mb-4">
                    <label class="block text-oxford font-bold mb-2">Nomor WA Aktif</label>
                    <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white">
                        <input type="number" id="phone" class="w-full bg-transparent outline-none text-oxford" placeholder="08123..." required>
                    </div>
                </div>
                <div class="flex-grow"></div>
                <button type="submit" class="w-full bg-maize text-oxford text-lg font-bold py-4 rounded-full shadow-lg active:scale-95 transition-transform">Kirim OTP</button>
            </form>

            <form id="resetForm" class="hidden flex-col flex-grow mt-4">
                <p class="text-sm font-bold text-red-500 mb-4 text-center">OTP berlaku selama 5 Menit.</p>
                <div class="mb-4">
                    <label class="block text-oxford font-bold mb-2">Kode OTP (4 Digit)</label>
                    <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white">
                        <input type="number" id="otp" class="w-full bg-transparent outline-none text-oxford text-center tracking-widest font-bold text-xl" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="block text-oxford font-bold mb-2">Password Baru</label>
                    <div class="flex items-center border border-gray-300 rounded-2xl px-4 py-3 bg-white">
                        <input type="password" id="newPassword" class="w-full bg-transparent outline-none text-oxford" required>
                    </div>
                </div>
                <div class="flex-grow"></div>
                <button type="submit" class="w-full bg-oxford text-maize text-lg font-bold py-4 rounded-full shadow-lg active:scale-95 transition-transform">Simpan Password</button>
            </form>
            
            <div class="mt-6 text-center">
                <a href="/" class="text-gray-500 text-sm hover:text-oxford underline">Kembali ke Login</a>
            </div>
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
                    document.getElementById('resetForm').classList.add('flex');
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
                    alert('Password berhasil diubah! Silakan Login.');
                    window.location.href = '/';
                } else { alert(data.error); }
            } catch (err) { alert('Gagal mereset password.'); }
        });
    </script>
</body>
</html>
EOF

# 4. Halaman Dashboard (Tempat Referensi PPOB Nanti)
cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { oxford: '#0A174E', maize: '#F5D042' } } }
        }
    </script>
</head>
<body class="bg-gray-100 flex justify-center min-h-screen">
    <div class="w-full max-w-md bg-white min-h-screen relative shadow-2xl overflow-x-hidden flex flex-col">
        <nav class="bg-oxford p-4 text-maize flex justify-between items-center rounded-b-2xl shadow-md">
            <h1 class="font-bold text-lg">FIKY STORE</h1>
            <button onclick="logout()" class="text-sm font-semibold hover:text-white">Logout</button>
        </nav>
        
        <div class="p-6">
            <div class="bg-maize p-4 rounded-2xl shadow-sm text-oxford">
                <p class="text-sm">Halo,</p>
                <h2 id="userName" class="text-2xl font-extrabold">Member</h2>
                <p id="userPhone" class="text-sm mt-1 font-semibold"></p>
            </div>
            
            <div class="mt-8 text-center p-6 border-2 border-dashed border-gray-300 rounded-2xl">
                <p class="text-gray-500">Area ini siap untuk fitur Pembelian PPOB.</p>
            </div>
        </div>
    </div>

    <script>
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        
        document.getElementById('userName').innerText = user.name;
        document.getElementById('userPhone').innerText = user.phone;

        function logout() {
            localStorage.removeItem('user');
            window.location.href = '/';
        }
    </script>
</body>
</html>
EOF

# ==========================================
# FILE NODE.JS (LOGIK BOT + API WEB AUTH)
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

// ==========================================
// BACKEND API - SISTEM AUTENTIKASI (LOGIN/REGISTER)
// ==========================================

app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;

    if (webUsers[formattedPhone] && webUsers[formattedPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor HP sudah terdaftar dan diverifikasi.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString(); // 4 Digit
    const otpExpires = Date.now() + (5 * 60 * 1000); // 5 Menit

    webUsers[formattedPhone] = { name, email, password, isVerified: false, otp, otpExpires };
    saveJSON(webUsersFile, webUsers);

    const message = `Halo *${name}*!\n\nKode OTP Registrasi Aplikasi Anda adalah: *${otp}*\n\n_Kode ini berlaku 5 Menit. Jangan berikan kode ini kepada siapapun._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        if (Date.now() > webUsers[phone].otpExpires) {
            return res.status(400).json({ error: 'Kode OTP sudah kedaluwarsa (lebih dari 5 menit).' });
        }

        webUsers[phone].isVerified = true;
        webUsers[phone].otp = null; 
        webUsers[phone].otpExpires = null; 
        saveJSON(webUsersFile, webUsers);
        
        let db = loadJSON(dbFile);
        let senderNum = phone.replace('62', '0'); 
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
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum verifikasi WA.' });
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
    const otpExpires = Date.now() + (5 * 60 * 1000); 

    webUsers[formattedPhone].otp = otp;
    webUsers[formattedPhone].otpExpires = otpExpires;
    saveJSON(webUsersFile, webUsers);

    const message = `Halo!\n\nKode OTP Reset Password Anda adalah: *${otp}*\n\n_Kode ini hanya berlaku 5 Menit._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Reset Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        if (Date.now() > webUsers[phone].otpExpires) {
            return res.status(400).json({ error: 'Kode OTP sudah kedaluwarsa.' });
        }
        webUsers[phone].password = newPassword;
        webUsers[phone].otp = null; 
        webUsers[phone].otpExpires = null; 
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
    echo "      🤖 PANEL DIGITAL FIKY STORE (V12) 🤖     "
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
