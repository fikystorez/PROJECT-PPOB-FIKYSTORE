#!/bin/bash

# Pastikan script dijalankan dengan akses root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "Tolong jalankan script ini sebagai root (ketik: sudo su)"
  exit
fi

# Fungsi untuk membersihkan karakter Windows (CRLF) jika ada
if command -v dos2unix > /dev/null 2>&1; then
    dos2unix "$0" > /dev/null 2>&1
fi

# ==========================================
# 1. KONFIGURASI NAMA & DIREKTORI
# ==========================================
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"
PORT=3000

echo "=========================================================="
echo "      MENGINSTAL DIGITAL FIKY STORE - PLEASE WAIT         "
echo "=========================================================="

# ==========================================
# 2. INSTALASI DEPENDENSI SISTEM (SILENT)
# ==========================================
echo "[1/5] Memperbarui sistem dan menginstal Node.js..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc -y > /dev/null 2>&1

# Install Node.js v20
if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1
fi

# Install Dependencies Puppeteer (Chrome) untuk VPS
echo "[2/5] Menginstal Library Browser (Google Chrome)..."
apt install -y gconf-service libgbm-dev libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils > /dev/null 2>&1

# ==========================================
# 3. MEMBUAT PROJECT & FILE SOURCE CODE
# ==========================================
echo "[3/5] Membuat direktori dan file aplikasi..."
mkdir -p "$HOME/$DIR_NAME"
cd "$HOME/$DIR_NAME"

# File package.json
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

# File index.js (Full Application Logic)
cat << 'EOF' > index.js
const express = require('express');
const { Client, LocalAuth } = require('whatsapp-web.js');
const sqlite3 = require('sqlite3').verbose();
const axios = require('axios');
const md5 = require('md5');
const readline = require('readline');

const app = express();
app.use(express.json());

// DATABASE SETUP
const db = new sqlite3.Database('./ppob.db', (err) => {
    if (err) console.error(err.message);
    else {
        db.serialize(() => {
            db.run(`CREATE TABLE IF NOT EXISTS members (id INTEGER PRIMARY KEY AUTOINCREMENT, phone TEXT UNIQUE, balance INTEGER DEFAULT 0, otp TEXT)`);
            db.run(`CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY AUTOINCREMENT, sku TEXT UNIQUE, name TEXT, digiflazz_price INTEGER, sell_price INTEGER)`);
            db.run(`CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT)`);
            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_username', 'isi_username_disini')`);
            db.run(`INSERT OR IGNORE INTO settings (key, value) VALUES ('digiflazz_api_key', 'isi_api_key_disini')`);
        });
    }
});

// WHATSAPP SETUP
const waClient = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: { 
        executablePath: '/usr/bin/nodejs', // Menyesuaikan path vps
        args: ['--no-sandbox', '--disable-setuid-sandbox'] 
    }
});

waClient.on('qr', async (qr) => {
    if (!global.isPairingPromptShown && process.stdin.isTTY) {
        global.isPairingPromptShown = true;
        const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
        console.log('\n========================================================');
        console.log(' LOGIN DENGAN KODE PAIRING (TANPA SCAN QR) ');
        console.log('========================================================');
        rl.question('Masukkan Nomor HP Bot (contoh: 628123456789): ', async (phone) => {
            if (phone && phone.trim() !== '') {
                console.log('\nMeminta Kode Pairing ke WhatsApp... (Mohon tunggu)');
                let code = null; let attempts = 0;
                while (attempts < 5 && !code) {
                    try {
                        attempts++;
                        await new Promise(resolve => setTimeout(resolve, 4000));
                        code = await waClient.requestPairingCode(phone.trim());
                    } catch (error) { console.log(`[Percobaan ${attempts}/5] Mencoba lagi...`); }
                }
                if (code) {
                    console.log('\nKODE PAIRING ANDA: ' + code);
                    console.log('========================================================\n');
                }
            }
            rl.close();
        });
    }
});

waClient.on('ready', () => { console.log('\nWhatsApp Bot DIGITAL FIKY STORE Siap!'); });
waClient.initialize();

const sendWhatsAppMessage = async (phone, message) => {
    try {
        const formattedPhone = phone.startsWith('0') ? '62' + phone.slice(1) : phone;
        await waClient.sendMessage(formattedPhone + '@c.us', message);
        return true;
    } catch (error) { return false; }
};

// API ENDPOINTS
const getSetting = (key) => {
    return new Promise((resolve, reject) => {
        db.get(`SELECT value FROM settings WHERE key = ?`, [key], (err, row) => {
            if (err) reject(err); resolve(row ? row.value : null);
        });
    });
};

app.post('/api/settings/digiflazz', (req, res) => {
    const { username, api_key } = req.body;
    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_username'`, [username]);
    db.run(`UPDATE settings SET value = ? WHERE key = 'digiflazz_api_key'`, [api_key], (err) => {
        res.json({ message: 'API Digiflazz diperbarui' });
    });
});

app.get('/api/digiflazz/cek-saldo', async (req, res) => {
    try {
        const username = await getSetting('digiflazz_username');
        const apiKey = await getSetting('digiflazz_api_key');
        const sign = md5(username + apiKey + "depo");
        const response = await axios.post('https://api.digiflazz.com/v1/cek-saldo', { cmd: "deposit", username, sign });
        res.json({ success: true, data: response.data.data });
    } catch (error) { res.status(500).json({ success: false, error: error.message }); }
});

app.post('/api/members', (req, res) => {
    const { phone } = req.body;
    db.run(`INSERT INTO members (phone, balance) VALUES (?, 0)`, [phone], (err) => {
        if (err) res.status(500).json({ error: 'Gagal daftar' });
        else res.json({ message: 'Member terdaftar' });
    });
});

app.post('/api/members/request-otp', (req, res) => {
    const { phone } = req.body;
    db.get(`SELECT * FROM members WHERE phone = ?`, [phone], async (err, row) => {
        if (!row) return res.status(404).json({ error: 'Tidak ditemukan' });
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        db.run(`UPDATE members SET otp = ? WHERE phone = ?`, [otp, phone], async () => {
            const message = `Kode OTP: *${otp}*`;
            await sendWhatsAppMessage(phone, message);
            res.json({ message: 'OTP terkirim' });
        });
    });
});

app.post('/api/members/saldo', (req, res) => {
    const { phone, amount, type } = req.body;
    db.get(`SELECT balance FROM members WHERE phone = ?`, [phone], (err, row) => {
        let newBalance = type === 'add' ? row.balance + amount : row.balance - amount;
        db.run(`UPDATE members SET balance = ? WHERE phone = ?`, [newBalance, phone], () => {
            res.json({ current_balance: newBalance });
        });
    });
});

app.post('/api/products', (req, res) => {
    const { sku, name, digiflazz_price, sell_price } = req.body;
    db.run(`INSERT INTO products (sku, name, digiflazz_price, sell_price) VALUES (?, ?, ?, ?)`, [sku, name, digiflazz_price, sell_price], () => {
        res.json({ message: 'Produk ditambah' });
    });
});

app.get('/api/products', (req, res) => {
    db.all(`SELECT * FROM products`, [], (err, rows) => { res.json({ data: rows }); });
});

app.listen(3000, () => { console.log(`Server DIGITAL FIKY STORE ON di port 3000`); });
EOF

echo "[4/5] Menginstal modul Node.js (Library)..."
npm install --silent

# ==========================================
# 4. SETUP SHORTCUT MENU & PM2
# ==========================================
echo "[5/5] Membuat Panel Manajemen 'menu'..."
npm install -g pm2 > /dev/null 2>&1
ufw allow 3000/tcp > /dev/null 2>&1

cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

while true; do
    clear
    echo "=========================================================="
    echo "      PANEL MANAJEMEN - DIGITAL FIKY STORE                "
    echo "=========================================================="
    echo "1. Mulai Bot (Terminal - Untuk Login Pairing Code)"
    echo "2. Jalankan Bot di Latar Belakang (PM2 - 24 Jam)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo "5. Reset Sesi WhatsApp"
    echo "6. Update Bot (Tarik Kode Terbaru)"
    echo "0. Keluar"
    echo "=========================================================="
    read -p "Pilih menu: " PILIHAN

    case $PILIHAN in
        1)
            cd "$HOME/$DIR_NAME"
            pm2 stop all > /dev/null 2>&1
            fuser -k 3000/tcp > /dev/null 2>&1
            node index.js
            read -p "Tekan Enter..."
            ;;
        2)
            cd "$HOME/$DIR_NAME"
            pm2 start index.js --name $BOT_NAME && pm2 save
            echo "Bot Running di Background!"
            read -p "Tekan Enter..."
            ;;
        3)
            pm2 stop $BOT_NAME
            echo "Bot Stopped."
            read -p "Tekan Enter..."
            ;;
        4)
            pm2 logs $BOT_NAME
            ;;
        5)
            rm -rf "$HOME/$DIR_NAME/.wwebjs_auth"
            echo "Sesi Direset."
            read -p "Tekan Enter..."
            ;;
        6)
            echo "Mengambil update terbaru dari GitHub..."
            cd "$HOME"
            wget -qO- https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh | tr -d '\r' > install.sh
            chmod +x install.sh && ./install.sh
            exit 0
            ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu

echo "=========================================================="
echo "  INSTALASI DIGITAL FIKY STORE BERHASIL!                  "
echo "  ------------------------------------------------------  "
echo "  Web API Anda: http://$(wget -qO- eth0.me):3000          "
echo "  Panel Manajemen: Ketik 'menu' di terminal               "
echo "=========================================================="
