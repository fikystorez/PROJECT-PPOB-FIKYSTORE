#!/bin/bash

# Pastikan script dijalankan dengan akses root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "Tolong jalankan script ini sebagai root (ketik: sudo su)"
  exit
fi

# ==========================================
# MEMBUAT SHORTCUT PERINTAH 'menu'
# ==========================================
SCRIPT_PATH=$(realpath "$0")
if [ "$SCRIPT_PATH" != "/usr/bin/menu" ]; then
    cp -f "$SCRIPT_PATH" /usr/bin/menu
    chmod +x /usr/bin/menu
    echo "=========================================================="
    echo "  [INFO] Shortcut berhasil dibuat!"
    echo "  Mulai sekarang, Anda cukup mengetik: menu"
    echo "  untuk membuka panel ini kapan saja."
    echo "=========================================================="
    sleep 2
fi

DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

while true; do
    clear
    echo "=========================================================="
    echo "      PANEL MANAJEMEN BOT - DIGITAL FIKY STORE            "
    echo "=========================================================="
    echo "1. Install & Buat File Bot Otomatis (Pertama Kali)"
    echo "2. Mulai Bot (Terminal - Untuk Login Pairing Code)"
    echo "3. Jalankan Bot di Latar Belakang (PM2 - 24 Jam)"
    echo "4. Hentikan Bot (PM2)"
    echo "5. Lihat Log / Error Bot (Tekan Ctrl+C untuk keluar log)"
    echo "6. Update Bot (Tarik Kode Terbaru Tanpa Rebuild VPS)"
    echo "7. Reset Sesi WhatsApp (Gunakan jika bot error saat login)"
    echo "0. Keluar dari Panel Menu"
    echo "=========================================================="
    read -p "Pilih menu (0-7): " PILIHAN_MENU

    case $PILIHAN_MENU in
        1)
            echo ""
            echo "=========================================================="
            echo "  Mulai Proses Instalasi...                               "
            echo "=========================================================="
            echo "Bagaimana Anda ingin mengakses aplikasi ini?"
            echo "A. Sementara menggunakan IP VPS (Port 3000)"
            echo "B. Menggunakan Domain (Akan menginstal & set Nginx otomatis)"
            read -p "Pilih (A atau B): " PILIHAN_DOMAIN

            if [[ "$PILIHAN_DOMAIN" == "B" || "$PILIHAN_DOMAIN" == "b" ]]; then
                read -p "Masukkan nama domain Anda (contoh: digitalfikystore.com): " DOMAIN
            fi

            PORT=3000

            echo "[1/8] Mempersiapkan sistem dan menginstal Node.js & Library Browser (Mohon tunggu)..."
            apt update
            apt install curl wget gnupg git -y
            
            # Install Node.js
            curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            apt install -y nodejs
            
            # Install Dependencies Puppeteer (Chrome) untuk VPS
            apt install -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

            echo "[2/8] Membuat direktori project: $DIR_NAME..."
            mkdir -p $DIR_NAME
            cd $DIR_NAME

            echo "[3/8] Membuat file package.json (Menggunakan library WA versi Github Main)..."
            cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.0.0",
  "description": "Aplikasi PPOB DIGITAL FIKY STORE dengan WhatsApp Bot dan Digiflazz",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "axios": "^1.6.8",
    "express": "^4.19.2",
    "md5": "^2.3.0",
    "sqlite3": "^5.1.7",
    "whatsapp-web.js": "github:pedroslopez/whatsapp-web.js#main"
  }
}
EOF

            echo "[4/8] Membuat file utama index.js (FULL SCRIPT)..."
            cat << 'EOF' > index.js
const express = require('express');
const { Client, LocalAuth } = require('whatsapp-web.js');
const sqlite3 = require('sqlite3').verbose();
const axios = require('axios');
const md5 = require('md5');
const readline = require('readline');

const app = express();
app.use(express.json());

// ==========================================
// 1. INISIALISASI DATABASE SQLITE
// ==========================================
const db = new sqlite3.Database('./ppob.db', (err) => {
    if (err) {
        console.error('Error membuka database:', err.message);
    } else {
        console.log('Berhasil terkoneksi ke database SQLite.');
        
        db.serialize(() => {
            db.run(`CREATE TABLE IF NOT EXISTS members (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                phone TEXT UNIQUE,
                balance INTEGER DEFAULT 0,
                otp TEXT
            )`);

            db.run(`CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                sku TEXT UNIQUE,
                name TEXT,
                digiflazz_price INTEGER,
                sell_price INTEGER
            )`);

            db.run(`CREATE TABLE IF NOT EXISTS settings (
                key TEXT PRIMARY KEY,
                value TEXT
            )`);

            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_username', 'isi_username_disini')`);
            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_api_key', 'isi_api_key_disini')`);
        });
    }
});

// ==========================================
// 2. INISIALISASI WHATSAPP BOT
// ==========================================
const waClient = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: {
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
});

waClient.on('qr', async (qr) => {
    if (!global.isPairingPromptShown && process.stdin.isTTY) {
        global.isPairingPromptShown = true;
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        console.log('\n========================================================');
        console.log(' LOGIN DENGAN KODE PAIRING (TANPA SCAN QR) ');
        console.log('========================================================');
        rl.question('Masukkan Nomor HP Bot (contoh: 628123456789): ', async (phone) => {
            if (phone && phone.trim() !== '') {
                console.log('\nMeminta Kode Pairing ke WhatsApp... (Mohon tunggu)');
                
                let code = null;
                let attempts = 0;
                
                // SISTEM AUTO-RETRY (Maksimal 5x percobaan)
                while (attempts < 5 && !code) {
                    try {
                        attempts++;
                        await new Promise(resolve => setTimeout(resolve, 4000)); // Jeda 4 detik agar browser WA siap
                        code = await waClient.requestPairingCode(phone.trim());
                    } catch (error) {
                        console.log(`[Percobaan ${attempts}/5] Sistem WA belum siap memproses kode, mencoba lagi...`);
                    }
                }

                if (code) {
                    console.log('\n========================================================');
                    console.log(` KODE PAIRING ANDA: ${code}`);
                    console.log('========================================================');
                    console.log('Langkah-langkah di HP Anda:');
                    console.log('1. Buka aplikasi WhatsApp');
                    console.log('2. Ketuk ikon titik tiga di kanan atas -> Perangkat Tautkan');
                    console.log('3. Ketuk "Tautkan Perangkat"');
                    console.log('4. Pilih "Tautkan dengan nomor telepon saja" (Tulisan kecil di bawah)');
                    console.log('5. Masukkan 8 huruf kode di atas!');
                    console.log('========================================================\n');
                } else {
                    console.log('\n[ERROR] Gagal mendapatkan kode setelah 5 percobaan.');
                    console.log('Solusi: Tekan Ctrl+C, lalu jalankan Menu 7 untuk Mereset Sesi, dan coba lagi.');
                }
            } else {
                console.log('Nomor tidak boleh kosong. Tekan Ctrl+C lalu ulangi Menu 2.');
            }
            rl.close();
        });
    }
});

waClient.on('ready', () => {
    console.log('\nWhatsApp Bot DIGITAL FIKY STORE sudah siap dan terhubung!');
});

waClient.initialize();

const sendWhatsAppMessage = async (phone, message) => {
    try {
        const formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
        const chatId = formattedPhone + '@c.us';
        await waClient.sendMessage(chatId, message);
        return true;
    } catch (error) {
        console.error('Gagal mengirim WA:', error);
        return false;
    }
};

// ==========================================
// 3. ENDPOINT API - MANAJEMEN PENGATURAN & DIGIFLAZZ
// ==========================================
const getSetting = (key) => {
    return new Promise((resolve, reject) => {
        db.get(`SELECT value FROM settings WHERE key = ?`, [key], (err, row) => {
            if (err) reject(err);
            resolve(row ? row.value : null);
        });
    });
};

app.post('/api/settings/digiflazz', (req, res) => {
    const { username, api_key } = req.body;
    if (!username || !api_key) return res.status(400).json({ error: 'Username dan API Key wajib diisi' });

    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_username'`, [username]);
    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_api_key'`, [api_key], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'API Digiflazz berhasil diperbarui' });
    });
});

app.get('/api/digiflazz/cek-saldo', async (req, res) => {
    try {
        const username = await getSetting('digiflazz_username');
        const apiKey = await getSetting('digiflazz_api_key');
        const sign = md5(username + apiKey + "depo");

        const response = await axios.post('https://api.digiflazz.com/v1/cek-saldo', {
            cmd: "deposit",
            username: username,
            sign: sign
        });

        res.json({ success: true, data: response.data.data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.response ? error.response.data : error.message });
    }
});

// ==========================================
// 4. ENDPOINT API - MANAJEMEN MEMBER & OTP
// ==========================================
app.post('/api/members', (req, res) => {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ error: 'Nomor HP wajib diisi' });

    db.run(`INSERT INTO members (phone, balance) VALUES (?, 0)`, [phone], function(err) {
        if (err) return res.status(500).json({ error: 'Nomor HP mungkin sudah terdaftar' });
        res.json({ message: 'Member berhasil didaftarkan', id: this.lastID, phone: phone, balance: 0 });
    });
});

app.post('/api/members/request-otp', (req, res) => {
    const { phone } = req.body;
    
    db.get(`SELECT * FROM members WHERE phone = ?`, [phone], async (err, row) => {
        if (err || !row) return res.status(404).json({ error: 'Member tidak ditemukan' });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        
        db.run(`UPDATE members SET otp = ? WHERE phone = ?`, [otp, phone], async (updateErr) => {
            if (updateErr) return res.status(500).json({ error: 'Gagal update OTP' });
            
            const message = `Halo dari *DIGITAL FIKY STORE*!\n\nKode OTP Anda adalah: *${otp}*.\n\nJangan berikan kode ini kepada siapapun demi keamanan akun Anda.`;
            const waSent = await sendWhatsAppMessage(phone, message);
            
            if (waSent) {
                res.json({ message: 'OTP berhasil dikirim ke WhatsApp' });
            } else {
                res.status(500).json({ error: 'Gagal mengirim pesan WhatsApp' });
            }
        });
    });
});

app.post('/api/members/saldo', (req, res) => {
    const { phone, amount, type } = req.body;
    
    db.get(`SELECT balance FROM members WHERE phone = ?`, [phone], (err, row) => {
        if (err || !row) return res.status(404).json({ error: 'Member tidak ditemukan' });

        let newBalance = type === 'add' ? row.balance + amount : row.balance - amount;
        if (newBalance < 0) return res.status(400).json({ error: 'Saldo tidak mencukupi' });

        db.run(`UPDATE members SET balance = ? WHERE phone = ?`, [newBalance, phone], function(err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Saldo berhasil diupdate', current_balance: newBalance });
        });
    });
});

// ==========================================
// 5. ENDPOINT API - MANAJEMEN PRODUK
// ==========================================
app.post('/api/products', (req, res) => {
    const { sku, name, digiflazz_price, sell_price } = req.body;
    
    db.run(`INSERT INTO products (sku, name, digiflazz_price, sell_price) VALUES (?, ?, ?, ?)`, 
    [sku, name, digiflazz_price, sell_price], function(err) {
        if (err) return res.status(500).json({ error: 'Gagal menambah produk. Pastikan SKU unik.' });
        res.json({ message: 'Produk berhasil ditambahkan', id: this.lastID });
    });
});

app.get('/api/products', (req, res) => {
    db.all(`SELECT * FROM products`, [], (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ data: rows });
    });
});

// ==========================================
// 6. JALANKAN SERVER
// ==========================================
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server DIGITAL FIKY STORE berjalan di port ${PORT}`);
});
EOF

            echo "[5/8] Menginstal library Node.js pendukung..."
            npm install

            echo "[6/8] Menginstal PM2 untuk manajemen proses background..."
            npm install -g pm2

            # Keluar dari direktori project
            cd ..

            # Setup Nginx jika memilih domain
            if [[ "$PILIHAN_DOMAIN" == "B" || "$PILIHAN_DOMAIN" == "b" ]]; then
                echo "[7/8] Menginstal Nginx Web Server..."
                apt update
                apt install nginx -y

                echo "[8/8] Mengonfigurasi Reverse Proxy Nginx untuk $DOMAIN..."
                cat << EOF > /etc/nginx/sites-available/$DOMAIN
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
                ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
                rm -f /etc/nginx/sites-enabled/default
                nginx -t
                systemctl restart nginx
            else
                echo "[7/8] Setup Nginx dilewati (Mode IP VPS)."
                echo "[8/8] Membuka port $PORT di firewall (UFW)..."
                ufw allow $PORT/tcp > /dev/null 2>&1 || true
            fi

            echo "=========================================================="
            echo "  INSTALASI SELESAI & SUKSES!                             "
            echo "=========================================================="
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;
            
        2)
            echo "=========================================================="
            echo "  Memulai Bot di Terminal..."
            echo "  (PENTING: Gunakan menu ini untuk pertama kali Login WA!)"
            echo "  (Tekan Ctrl+C untuk mematikan dan kembali ke menu)"
            echo "=========================================================="
            if [ -d "$DIR_NAME" ]; then
                cd $DIR_NAME
                if ! command -v node &> /dev/null; then
                    echo "[ERROR] Node.js belum terinstal!"
                    echo "Silakan jalankan Menu 1 (Install & Buat File) terlebih dahulu."
                else
                    node index.js
                fi
                cd ..
            else
                echo "Folder project belum ada. Silakan jalankan Instalasi (Menu 1) terlebih dahulu."
            fi
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;

        3)
            echo "=========================================================="
            echo "  Menjalankan Bot di Latar Belakang (PM2)..."
            echo "=========================================================="
            if [ -d "$DIR_NAME" ]; then
                cd $DIR_NAME
                if ! command -v pm2 &> /dev/null; then
                     echo "[ERROR] PM2 belum terinstal. Silakan jalankan Menu 1."
                else
                    pm2 start index.js --name $BOT_NAME
                    pm2 save
                    echo "Bot berhasil dijalankan 24 jam!"
                fi
                cd ..
            else
                echo "Folder project belum ada. Silakan jalankan Instalasi (Menu 1) terlebih dahulu."
            fi
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;

        4)
            echo "=========================================================="
            echo "  Menghentikan Bot..."
            echo "=========================================================="
            if ! command -v pm2 &> /dev/null; then
                 echo "[ERROR] PM2 belum terinstal."
            else
                pm2 stop $BOT_NAME
                echo "Bot berhasil dihentikan."
            fi
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;

        5)
            echo "=========================================================="
            echo "  Menampilkan Log Bot..."
            echo "  (Tekan Ctrl+C untuk keluar dari log dan kembali ke menu)"
            echo "=========================================================="
            if ! command -v pm2 &> /dev/null; then
                 echo "[ERROR] PM2 belum terinstal."
                 read -p "Tekan Enter untuk kembali ke Menu Utama..."
            else
                pm2 logs $BOT_NAME
            fi
            ;;

        6)
            echo "=========================================================="
            echo "  Mengupdate Bot Tanpa Rebuild VPS..."
            echo "=========================================================="
            if [ -d "$DIR_NAME" ]; then
                cd $DIR_NAME
                echo "[1/3] Menulis ulang file package.json dan index.js terbaru..."
                
                cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.0.0",
  "description": "Aplikasi PPOB DIGITAL FIKY STORE dengan WhatsApp Bot dan Digiflazz",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "axios": "^1.6.8",
    "express": "^4.19.2",
    "md5": "^2.3.0",
    "sqlite3": "^5.1.7",
    "whatsapp-web.js": "github:pedroslopez/whatsapp-web.js#main"
  }
}
EOF

                cat << 'EOF' > index.js
const express = require('express');
const { Client, LocalAuth } = require('whatsapp-web.js');
const sqlite3 = require('sqlite3').verbose();
const axios = require('axios');
const md5 = require('md5');
const readline = require('readline');

const app = express();
app.use(express.json());

// ==========================================
// 1. INISIALISASI DATABASE SQLITE
// ==========================================
const db = new sqlite3.Database('./ppob.db', (err) => {
    if (err) {
        console.error('Error membuka database:', err.message);
    } else {
        console.log('Berhasil terkoneksi ke database SQLite.');
        
        db.serialize(() => {
            db.run(`CREATE TABLE IF NOT EXISTS members (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                phone TEXT UNIQUE,
                balance INTEGER DEFAULT 0,
                otp TEXT
            )`);

            db.run(`CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                sku TEXT UNIQUE,
                name TEXT,
                digiflazz_price INTEGER,
                sell_price INTEGER
            )`);

            db.run(`CREATE TABLE IF NOT EXISTS settings (
                key TEXT PRIMARY KEY,
                value TEXT
            )`);

            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_username', 'isi_username_disini')`);
            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_api_key', 'isi_api_key_disini')`);
        });
    }
});

// ==========================================
// 2. INISIALISASI WHATSAPP BOT
// ==========================================
const waClient = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: {
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
});

waClient.on('qr', async (qr) => {
    if (!global.isPairingPromptShown && process.stdin.isTTY) {
        global.isPairingPromptShown = true;
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        console.log('\n========================================================');
        console.log(' LOGIN DENGAN KODE PAIRING (TANPA SCAN QR) ');
        console.log('========================================================');
        rl.question('Masukkan Nomor HP Bot (contoh: 628123456789): ', async (phone) => {
            if (phone && phone.trim() !== '') {
                console.log('\nMeminta Kode Pairing ke WhatsApp... (Mohon tunggu)');
                
                let code = null;
                let attempts = 0;
                
                // SISTEM AUTO-RETRY (Maksimal 5x percobaan)
                while (attempts < 5 && !code) {
                    try {
                        attempts++;
                        await new Promise(resolve => setTimeout(resolve, 4000)); // Jeda 4 detik agar browser WA siap
                        code = await waClient.requestPairingCode(phone.trim());
                    } catch (error) {
                        console.log(`[Percobaan ${attempts}/5] Sistem WA belum siap memproses kode, mencoba lagi...`);
                    }
                }

                if (code) {
                    console.log('\n========================================================');
                    console.log(` KODE PAIRING ANDA: ${code}`);
                    console.log('========================================================');
                    console.log('Langkah-langkah di HP Anda:');
                    console.log('1. Buka aplikasi WhatsApp');
                    console.log('2. Ketuk ikon titik tiga di kanan atas -> Perangkat Tautkan');
                    console.log('3. Ketuk "Tautkan Perangkat"');
                    console.log('4. Pilih "Tautkan dengan nomor telepon saja" (Tulisan kecil di bawah)');
                    console.log('5. Masukkan 8 huruf kode di atas!');
                    console.log('========================================================\n');
                } else {
                    console.log('\n[ERROR] Gagal mendapatkan kode setelah 5 percobaan.');
                    console.log('Solusi: Tekan Ctrl+C, lalu jalankan Menu 7 untuk Mereset Sesi, dan coba lagi.');
                }
            } else {
                console.log('Nomor tidak boleh kosong. Tekan Ctrl+C lalu ulangi Menu 2.');
            }
            rl.close();
        });
    }
});

waClient.on('ready', () => {
    console.log('\nWhatsApp Bot DIGITAL FIKY STORE sudah siap dan terhubung!');
});

waClient.initialize();

const sendWhatsAppMessage = async (phone, message) => {
    try {
        const formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
        const chatId = formattedPhone + '@c.us';
        await waClient.sendMessage(chatId, message);
        return true;
    } catch (error) {
        console.error('Gagal mengirim WA:', error);
        return false;
    }
};

// ==========================================
// 3. ENDPOINT API - MANAJEMEN PENGATURAN & DIGIFLAZZ
// ==========================================
const getSetting = (key) => {
    return new Promise((resolve, reject) => {
        db.get(`SELECT value FROM settings WHERE key = ?`, [key], (err, row) => {
            if (err) reject(err);
            resolve(row ? row.value : null);
        });
    });
};

app.post('/api/settings/digiflazz', (req, res) => {
    const { username, api_key } = req.body;
    if (!username || !api_key) return res.status(400).json({ error: 'Username dan API Key wajib diisi' });

    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_username'`, [username]);
    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_api_key'`, [api_key], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'API Digiflazz berhasil diperbarui' });
    });
});

app.get('/api/digiflazz/cek-saldo', async (req, res) => {
    try {
        const username = await getSetting('digiflazz_username');
        const apiKey = await getSetting('digiflazz_api_key');
        const sign = md5(username + apiKey + "depo");

        const response = await axios.post('https://api.digiflazz.com/v1/cek-saldo', {
            cmd: "deposit",
            username: username,
            sign: sign
        });

        res.json({ success: true, data: response.data.data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.response ? error.response.data : error.message });
    }
});

// ==========================================
// 4. ENDPOINT API - MANAJEMEN MEMBER & OTP
// ==========================================
app.post('/api/members', (req, res) => {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ error: 'Nomor HP wajib diisi' });

    db.run(`INSERT INTO members (phone, balance) VALUES (?, 0)`, [phone], function(err) {
        if (err) return res.status(500).json({ error: 'Nomor HP mungkin sudah terdaftar' });
        res.json({ message: 'Member berhasil didaftarkan', id: this.lastID, phone: phone, balance: 0 });
    });
});

app.post('/api/members/request-otp', (req, res) => {
    const { phone } = req.body;
    
    db.get(`SELECT * FROM members WHERE phone = ?`, [phone], async (err, row) => {
        if (err || !row) return res.status(404).json({ error: 'Member tidak ditemukan' });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        
        db.run(`UPDATE members SET otp = ? WHERE phone = ?`, [otp, phone], async (updateErr) => {
            if (updateErr) return res.status(500).json({ error: 'Gagal update OTP' });
            
            const message = `Halo dari *DIGITAL FIKY STORE*!\n\nKode OTP Anda adalah: *${otp}*.\n\nJangan berikan kode ini kepada siapapun demi keamanan akun Anda.`;
            const waSent = await sendWhatsAppMessage(phone, message);
            
            if (waSent) {
                res.json({ message: 'OTP berhasil dikirim ke WhatsApp' });
            } else {
                res.status(500).json({ error: 'Gagal mengirim pesan WhatsApp' });
            }
        });
    });
});

app.post('/api/members/saldo', (req, res) => {
    const { phone, amount, type } = req.body;
    
    db.get(`SELECT balance FROM members WHERE phone = ?`, [phone], (err, row) => {
        if (err || !row) return res.status(404).json({ error: 'Member tidak ditemukan' });

        let newBalance = type === 'add' ? row.balance + amount : row.balance - amount;
        if (newBalance < 0) return res.status(400).json({ error: 'Saldo tidak mencukupi' });

        db.run(`UPDATE members SET balance = ? WHERE phone = ?`, [newBalance, phone], function(err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Saldo berhasil diupdate', current_balance: newBalance });
        });
    });
});

// ==========================================
// 5. ENDPOINT API - MANAJEMEN PRODUK
// ==========================================
app.post('/api/products', (req, res) => {
    const { sku, name, digiflazz_price, sell_price } = req.body;
    
    db.run(`INSERT INTO products (sku, name, digiflazz_price, sell_price) VALUES (?, ?, ?, ?)`, 
    [sku, name, digiflazz_price, sell_price], function(err) {
        if (err) return res.status(500).json({ error: 'Gagal menambah produk. Pastikan SKU unik.' });
        res.json({ message: 'Produk berhasil ditambahkan', id: this.lastID });
    });
});

app.get('/api/products', (req, res) => {
    db.all(`SELECT * FROM products`, [], (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ data: rows });
    });
});

// ==========================================
// 6. JALANKAN SERVER
// ==========================================
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server DIGITAL FIKY STORE berjalan di port ${PORT}`);
});
EOF
                
                echo "[2/3] Memperbarui library Node.js (Mengunduh versi GitHub Main)..."
                npm install
                
                cd ..
                echo "[3/3] Merestart Bot di PM2..."
                if command -v pm2 &> /dev/null; then
                    pm2 restart $BOT_NAME || echo "Bot belum berjalan di PM2. Setelah ini gunakan Menu 3."
                else
                    echo "[ERROR] PM2 belum terinstal."
                fi
                echo "=========================================================="
                echo "  UPDATE SELESAI & SUKSES!                                "
                echo "=========================================================="
            else
                echo "Folder project belum ada. Silakan jalankan Instalasi (Menu 1) terlebih dahulu."
            fi
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;

        7)
            echo "=========================================================="
            echo "  Mereset Sesi WhatsApp...                                "
            echo "=========================================================="
            if [ -d "$DIR_NAME/.wwebjs_auth" ]; then
                rm -rf $DIR_NAME/.wwebjs_auth
                echo "[SUKSES] Folder sesi rusak berhasil dihapus!"
                echo "Silakan jalankan Menu 2 lagi untuk mendapatkan kode baru."
            else
                echo "[INFO] Folder sesi tidak ditemukan. Bot sudah dalam keadaan bersih."
            fi
            read -p "Tekan Enter untuk kembali ke Menu Utama..."
            ;;

        0)
            echo "Keluar dari Panel Manajemen. Sampai jumpa!"
            exit 0
            ;;

        *)
            echo "Pilihan tidak valid, silakan masukkan angka 0-7."
            read -p "Tekan Enter untuk mencoba lagi..."
            ;;
    esac
done
