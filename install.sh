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
echo "      MENGINSTAL DIGITAL FIKY STORE (WEB + AUTH LOGIN)    "
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
# MEMBUAT TAMPILAN WEB (SISTEM AUTENTIKASI)
# ==========================================
echo "[3/5] Membangun Antarmuka Website (UI) dengan Sistem Login..."

# 1. Halaman Login
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">FIKY STORE</h2>
        <form id="loginForm">
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Email / No. HP</label>
                <input type="text" id="identifier" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Password</label>
                <input type="password" id="password" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-2 px-4 rounded hover:bg-blue-700">Masuk</button>
        </form>
        <div class="mt-4 text-center text-sm">
            <a href="/register.html" class="text-blue-500 hover:underline">Daftar Akun Baru</a> | 
            <a href="/forgot.html" class="text-blue-500 hover:underline">Lupa Password?</a>
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
                } else {
                    alert(data.error);
                }
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
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-96" id="box-register">
        <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Daftar Akun</h2>
        <form id="registerForm">
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Nama Lengkap</label>
                <input type="text" id="name" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Nomor WA Aktif</label>
                <input type="number" id="phone" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required placeholder="08123...">
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Email</label>
                <input type="email" id="email" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Password</label>
                <input type="password" id="password" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-green-600 text-white font-bold py-2 px-4 rounded hover:bg-green-700">Daftar Sekarang</button>
        </form>
        <div class="mt-4 text-center text-sm">
            <a href="/" class="text-blue-500 hover:underline">Sudah punya akun? Masuk</a>
        </div>
    </div>

    <div class="bg-white p-8 rounded-lg shadow-md w-96 hidden" id="box-otp">
        <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Verifikasi WA</h2>
        <p class="text-sm text-gray-600 mb-4 text-center">4 Digit kode OTP telah dikirim ke WhatsApp Anda. <br><span class="text-red-500 font-bold">Berlaku 5 Menit.</span></p>
        <form id="otpForm">
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Kode OTP</label>
                <input type="number" id="otpCode" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required placeholder="XXXX">
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-2 px-4 rounded hover:bg-blue-700">Verifikasi OTP</button>
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
                    alert('OTP Terkirim! Silakan cek WhatsApp Anda (Berlaku 5 menit).');
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
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold text-center text-blue-600 mb-6">Reset Password</h2>
        
        <form id="requestOtpForm">
            <p class="text-sm text-gray-600 mb-4 text-center">Masukkan Nomor WA Anda untuk reset password.</p>
            <div class="mb-4">
                <input type="number" id="phone" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required placeholder="08123...">
            </div>
            <button type="submit" class="w-full bg-yellow-500 text-white font-bold py-2 px-4 rounded hover:bg-yellow-600">Kirim OTP Reset</button>
        </form>

        <form id="resetForm" class="hidden mt-4">
            <hr class="mb-4">
            <p class="text-sm text-red-500 mb-4 text-center font-bold">OTP berlaku selama 5 menit.</p>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Kode OTP (4 Digit)</label>
                <input type="number" id="otp" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2">Password Baru</label>
                <input type="password" id="newPassword" class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500" required>
            </div>
            <button type="submit" class="w-full bg-blue-600 text-white font-bold py-2 px-4 rounded hover:bg-blue-700">Simpan Password Baru</button>
        </form>
        <div class="mt-4 text-center text-sm">
            <a href="/" class="text-blue-500 hover:underline">Kembali ke Login</a>
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
                    alert('OTP Reset Password telah dikirim ke WA Anda! (Berlaku 5 Menit)');
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

# 4. Halaman Dashboard (Tempat Referensi PPOB)
cat << 'EOF' > public/dashboard.html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - DIGITAL FIKY STORE</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <nav class="bg-blue-600 p-4 text-white flex justify-between items-center">
        <h1 class="font-bold text-xl">DIGITAL FIKY STORE</h1>
        <div class="flex items-center gap-4">
            <span id="userName" class="font-semibold"></span>
            <button onclick="logout()" class="bg-red-500 hover:bg-red-600 px-3 py-1 rounded text-sm font-bold">Logout</button>
        </div>
    </nav>
    <div class="container mx-auto mt-8 p-4">
        <div class="bg-white p-6 rounded-lg shadow-md text-center">
            <h2 class="text-2xl font-bold mb-2">Selamat Datang!</h2>
            <p class="text-gray-600 mb-4">Nomor WhatsApp Terhubung: <span id="userPhone" class="font-bold text-blue-600"></span></p>
            <div class="p-4 bg-green-100 border-l-4 border-green-500 text-green-700 text-left">
                <strong>Sistem Login Sukses!</strong> Halaman ini siap diintegrasikan dengan UI Pembelian PPOB Anda selanjutnya.
            </div>
        </div>
    </div>
    <script>
        // Cek Login
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) window.location.href = '/';
        
        document.getElementById('userName').innerText = "Halo, " + user.name;
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

// MENJADIKAN FOLDER 'public' SEBAGAI TAMPILAN WEB UTAMA
app.use(express.static(path.join(__dirname, 'public')));

const configFile = './config.json';
const dbFile = './database.json';
const produkFile = './produk.json';
const trxFile = './trx.json';
const webUsersFile = './web_users.json'; // Database pengguna Web Aplikasi

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

// 1. REGISTER
app.post('/api/auth/register', async (req, res) => {
    const { name, phone, email, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;

    if (webUsers[formattedPhone] && webUsers[formattedPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor HP sudah terdaftar dan terverifikasi.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString(); // 4 Digit
    const otpExpires = Date.now() + (5 * 60 * 1000); // 5 Menit kedaluwarsa

    webUsers[formattedPhone] = { name, email, password, isVerified: false, otp, otpExpires };
    saveJSON(webUsersFile, webUsers);

    const message = `Halo *${name}*!\n\nKode OTP Pendaftaran Akun Anda adalah: *${otp}*\n\n_Sistem akan menghanguskan kode ini dalam waktu 5 menit. Jangan berikan kode ini kepada siapapun._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

// 2. VERIFY OTP
app.post('/api/auth/verify', (req, res) => {
    const { phone, otp } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        // Cek Kedaluwarsa 5 menit
        if (Date.now() > webUsers[phone].otpExpires) {
            return res.status(400).json({ error: 'Kode OTP sudah kedaluwarsa (lebih dari 5 menit). Silakan daftar ulang atau minta OTP baru.' });
        }

        webUsers[phone].isVerified = true;
        webUsers[phone].otp = null; 
        webUsers[phone].otpExpires = null; 
        saveJSON(webUsersFile, webUsers);
        
        // Sinkronisasi ke Database Saldo Bot WA
        let db = loadJSON(dbFile);
        let senderNum = phone.replace('62', '0'); // Boleh format apa saja, kita pakai default jid
        if (!db[phone]) {
            db[phone] = { saldo: 0, tanggal_daftar: new Date().toLocaleDateString('id-ID'), jid: phone + '@s.whatsapp.net' };
            saveJSON(dbFile, db);
        }

        res.json({ message: 'Verifikasi sukses!' });
    } else {
        res.status(400).json({ error: 'OTP Salah.' });
    }
});

// 3. LOGIN
app.post('/api/auth/login', (req, res) => {
    const { identifier, password } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    let formattedPhone = identifier.startsWith('0') ? '62' + identifier.slice(1) : identifier;
    let foundPhone = Object.keys(webUsers).find(p => 
        (p === formattedPhone || webUsers[p].email === identifier) && 
        webUsers[p].password === password
    );

    if (foundPhone) {
        if (!webUsers[foundPhone].isVerified) return res.status(400).json({ error: 'Akun belum diverifikasi OTP. Silakan Daftar Ulang / Verifikasi WA Anda.' });
        // Sembunyikan password saat dikirim ke frontend
        let userData = { phone: foundPhone, name: webUsers[foundPhone].name, email: webUsers[foundPhone].email };
        res.json({ message: 'Login sukses', user: userData });
    } else {
        res.status(400).json({ error: 'Email/No HP atau Password salah.' });
    }
});

// 4. MINTA OTP LUPA PASSWORD
app.post('/api/auth/forgot', async (req, res) => {
    const { phone } = req.body;
    let webUsers = loadJSON(webUsersFile);
    let formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;

    if (!webUsers[formattedPhone] || !webUsers[formattedPhone].isVerified) {
        return res.status(400).json({ error: 'Nomor belum terdaftar / belum diverifikasi.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const otpExpires = Date.now() + (5 * 60 * 1000); // Kedaluwarsa 5 Menit

    webUsers[formattedPhone].otp = otp;
    webUsers[formattedPhone].otpExpires = otpExpires;
    saveJSON(webUsersFile, webUsers);

    const message = `Halo!\n\nKode OTP Reset Password Anda adalah: *${otp}*\n\n_Kode ini hanya berlaku 5 Menit. Jika Anda tidak meminta ini, abaikan pesan ini._`;
    const sent = await sendWhatsAppMessage(formattedPhone, message);

    if(sent) res.json({ message: 'OTP Reset Terkirim', phone: formattedPhone });
    else res.status(500).json({ error: 'Gagal mengirim WA. Pastikan Bot Aktif.' });
});

// 5. EKSEKUSI RESET PASSWORD
app.post('/api/auth/reset', (req, res) => {
    const { phone, otp, newPassword } = req.body;
    let webUsers = loadJSON(webUsersFile);
    
    if (webUsers[phone] && webUsers[phone].otp === otp) {
        // Cek Kedaluwarsa 5 menit
        if (Date.now() > webUsers[phone].otpExpires) {
            return res.status(400).json({ error: 'Kode OTP sudah kedaluwarsa (lebih dari 5 menit). Silakan ulangi proses Reset Password.' });
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
    echo "      🤖 PANEL DIGITAL FIKY STORE (V11) 🤖     "
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
