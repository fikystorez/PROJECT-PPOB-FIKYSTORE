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

DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

echo "=========================================================="
echo "      MENGINSTAL DIGITAL FIKY STORE (BAILEYS EDITION)     "
echo "=========================================================="

echo "[1/4] Memperbarui sistem dan menginstal Dependensi Ringan..."
apt update -y && apt install curl wget gnupg git dos2unix psmisc zip unzip -y > /dev/null 2>&1

if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1
fi

echo "[2/4] Membuat direktori dan file aplikasi..."
mkdir -p "$HOME/$DIR_NAME"
cd "$HOME/$DIR_NAME"

cat << 'EOF' > package.json
{
  "name": "digital-fiky-store",
  "version": "1.0.0",
  "description": "Aplikasi PPOB DIGITAL FIKY STORE (Baileys WebSocket)",
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

cat << 'EOF' > index.js
const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, Browsers, jidNormalizedUser, fetchLatestBaileysVersion } = require('@whiskeysockets/baileys');
const { Boom } = require('@hapi/boom');
const fs = require('fs');
const pino = require('pino');
const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const axios = require('axios'); 
const crypto = require('crypto'); 

const app = express();
app.use(bodyParser.json());

const configFile = './config.json';
const dbFile = './database.json';
const produkFile = './produk.json';
const trxFile = './trx.json';

const loadJSON = (file) => fs.existsSync(file) ? JSON.parse(fs.readFileSync(file)) : {};
const saveJSON = (file, data) => fs.writeFileSync(file, JSON.stringify(data, null, 2));

let configAwal = loadJSON(configFile);
configAwal.botName = configAwal.botName || "DIGITAL FIKY STORE";
configAwal.botNumber = configAwal.botNumber || "";
configAwal.teleToken = configAwal.teleToken || "";
configAwal.teleChatId = configAwal.teleChatId || "";
configAwal.autoBackup = configAwal.autoBackup || false;
saveJSON(configFile, configAwal);

if (!fs.existsSync(dbFile)) saveJSON(dbFile, {});
if (!fs.existsSync(produkFile)) saveJSON(produkFile, {});
if (!fs.existsSync(trxFile)) saveJSON(trxFile, {});

let pairingRequested = false; 

function doBackupAndSend() {
    let cfg = loadJSON(configFile);
    if (!cfg.teleToken || !cfg.teleChatId) return;
    console.log("⏳ Memulai proses Auto-Backup ke Telegram...");
    exec(`rm -f backup.zip && zip backup.zip config.json database.json trx.json index.js package.json produk.json 2>/dev/null`, (err) => {
        if (!err) {
            let caption = `📦 *Auto-Backup DIGITAL FIKY STORE*\n⏰ Waktu: ${new Date().toLocaleString('id-ID')}`;
            exec(`curl -s -F chat_id="${cfg.teleChatId}" -F document=@"backup.zip" -F caption="${caption}" https://api.telegram.org/bot${cfg.teleToken}/sendDocument`, () => {
                console.log("✅ Auto-Backup dikirim ke Telegram!");
                exec(`rm -f backup.zip`); 
            });
        }
    });
}

if (configAwal.autoBackup) setInterval(doBackupAndSend, 12 * 60 * 60 * 1000); 

async function startBot() {
    console.log("\n⏳ Sedang menyiapkan mesin bot (Baileys)...");
    const { state, saveCreds } = await useMultiFileAuthState('sesi_bot');
    let config = loadJSON(configFile);
    
    const { version, isLatest } = await fetchLatestBaileysVersion();
    const sock = makeWASocket({
        version,
        auth: state,
        logger: pino({ level: 'silent' }),
        browser: Browsers.ubuntu('Chrome'),
        printQRInTerminal: false,
        syncFullHistory: false
    });

    if (!sock.authState.creds.registered && !pairingRequested) {
        pairingRequested = true;
        let phoneNumber = config.botNumber;
        if (!phoneNumber) {
            console.log('\n❌ NOMOR BOT BELUM DIATUR! Gunakan Menu 2.');
            process.exit(0);
        }
        setTimeout(async () => {
            try {
                let formattedNumber = phoneNumber.replace(/[^0-9]/g, '');
                const code = await sock.requestPairingCode(formattedNumber);
                console.log(`\n=======================================================`);
                console.log(`🔑 KODE PAIRING ANDA :  ${code}  `);
                console.log(`=======================================================`);
                console.log('👉 Masukkan kode ini ke WA (Perangkat Tertaut -> Tautkan dgn nomor)\n');
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

    // AUTO-POLLING DIGIFLAZZ
    setInterval(async () => {
        let trxs = loadJSON(trxFile);
        let keys = Object.keys(trxs);
        if (keys.length === 0) return;
        let cfg = loadJSON(configFile);
        let userAPI = (cfg.digiflazzUsername || '').trim();
        let keyAPI = (cfg.digiflazzApiKey || '').trim();
        if (!userAPI || !keyAPI) return;

        for (let ref of keys) {
            let trx = trxs[ref];
            let signCheck = crypto.createHash('md5').update(userAPI + keyAPI + ref).digest('hex');
            try {
                const cekRes = await axios.post('https://api.digiflazz.com/v1/transaction', {
                    username: userAPI, buyer_sku_code: trx.sku, customer_no: trx.tujuan, ref_id: ref, sign: signCheck
                });
                const resData = cekRes.data.data;
                if (resData.status === 'Sukses') {
                    await sock.sendMessage(trx.jid, { text: `✅ *SUKSES*\n📦 ${trx.nama}\n📱 ${trx.tujuan}\n🔖 Ref: ${ref}\n🔑 SN: ${resData.sn || '-'}` });
                    delete trxs[ref]; saveJSON(trxFile, trxs);
                } else if (resData.status === 'Gagal') {
                    let db = loadJSON(dbFile);
                    let senderNum = trx.jid.split('@')[0];
                    if (db[senderNum]) { db[senderNum].saldo += trx.harga; saveJSON(dbFile, db); }
                    await sock.sendMessage(trx.jid, { text: `❌ *GAGAL*\n📦 ${trx.nama}\n📱 ${trx.tujuan}\n🔖 Ref: ${ref}\nAlasan: ${resData.message}\n_💰 Saldo Rp ${trx.harga} dikembalikan._` });
                    delete trxs[ref]; saveJSON(trxFile, trxs);
                } else {
                    if (Date.now() - trx.tanggal > 24 * 60 * 60 * 1000) { delete trxs[ref]; saveJSON(trxFile, trxs); }
                }
            } catch (err) {}
            await new Promise(r => setTimeout(r, 2000)); 
        }
    }, 15000); 

    sock.ev.on('messages.upsert', async m => {
        try {
            const msg = m.messages[0];
            if (!msg.message || msg.key.fromMe) return;
            const from = msg.key.remoteJid;
            const senderJid = jidNormalizedUser(msg.key.participant || msg.key.remoteJid);
            const sender = senderJid.split('@')[0]; 
            const body = msg.message.conversation || msg.message.extendedTextMessage?.text || "";
            if (!body) return;
            const command = body.split(' ')[0].toLowerCase();
            
            let config = loadJSON(configFile);
            let namaBot = config.botName || "DIGITAL FIKY STORE";
            let db = loadJSON(dbFile);
            let produkDB = loadJSON(produkFile);

            if (!db[sender]) {
                db[sender] = { saldo: 0, tanggal_daftar: new Date().toLocaleDateString('id-ID'), jid: senderJid };
                saveJSON(dbFile, db);
            }

            if (command === '.menu') {
                await sock.sendMessage(from, { text: `👋 Selamat Datang di *${namaBot}*\n📌 *ID Member:* ${sender}\n\n1. *.saldo* (Cek saldo)\n2. *.order* [kode] [tujuan]\n3. *.harga* (Cek harga)\n\n_Ketik perintah di atas untuk menggunakan bot._` });
                return;
            }
            if (command === '.saldo') {
                await sock.sendMessage(from, { text: `💰 Saldo Anda saat ini: *Rp ${db[sender].saldo.toLocaleString('id-ID')}*` });
                return;
            }
            if (command === '.harga') {
                let keys = Object.keys(produkDB);
                if (keys.length === 0) return await sock.sendMessage(from, { text: `🛒 Daftar Produk belum tersedia.`});
                let textHarga = `🛒 *DAFTAR PRODUK ${namaBot}*\n\n`;
                keys.forEach((k, i) => {
                    textHarga += `*${i+1}. ${produkDB[k].nama}*\n   Ketik: *.order ${k} tujuan*\n   Harga: *Rp ${produkDB[k].harga.toLocaleString('id-ID')}*\n\n`;
                });
                await sock.sendMessage(from, { text: textHarga.trim() });
                return;
            }
            if (command === '.order') {
                const args = body.split(' ').slice(1);
                if (args.length < 2) return await sock.sendMessage(from, { text: `❌ *Format salah!*\nContoh: .order TSEL10 08123456789` });
                const kodeProduk = args[0].toUpperCase();
                const tujuan = args[1];

                if (!produkDB[kodeProduk]) return await sock.sendMessage(from, { text: `❌ Kode produk *${kodeProduk}* tidak ditemukan.` });
                const hargaProduk = produkDB[kodeProduk].harga;

                if (db[sender].saldo < hargaProduk) return await sock.sendMessage(from, { text: `❌ *Saldo tidak mencukupi!*\n💰 Saldo: Rp ${db[sender].saldo}\n🏷️ Harga: Rp ${hargaProduk}` });

                let username = (config.digiflazzUsername || '').trim();
                let apiKey = (config.digiflazzApiKey || '').trim();
                if (!username || !apiKey) return await sock.sendMessage(from, { text: `❌ Sistem bermasalah: API Digiflazz belum diatur Admin.` });

                let refId = 'DFS-' + Date.now();
                let sign = crypto.createHash('md5').update(username + apiKey + refId).digest('hex');

                await sock.sendMessage(from, { text: `⏳ *Memproses pesanan...*\n📦 ${produkDB[kodeProduk].nama}\n📱 ${tujuan}` });

                try {
                    const response = await axios.post('https://api.digiflazz.com/v1/transaction', {
                        username: username, buyer_sku_code: kodeProduk, customer_no: tujuan, ref_id: refId, sign: sign
                    });
                    const resData = response.data.data;
                    if (resData.status === 'Gagal') {
                        await sock.sendMessage(from, { text: `❌ *Transaksi Gagal!*\nAlasan: ${resData.message}\n_Saldo Anda tidak dipotong._` });
                    } else if (resData.status === 'Pending') {
                        db[sender].saldo -= hargaProduk; saveJSON(dbFile, db);
                        let trxs = loadJSON(trxFile);
                        trxs[refId] = { jid: from, sku: kodeProduk, tujuan: tujuan, harga: hargaProduk, nama: produkDB[kodeProduk].nama, tanggal: Date.now() };
                        saveJSON(trxFile, trxs);
                        await sock.sendMessage(from, { text: `⏳ *PENDING*\nRef ID: ${refId}\n_Saldo dipotong Rp ${hargaProduk}. Akan diinfokan otomatis saat sukses._` });
                    } else {
                        db[sender].saldo -= hargaProduk; saveJSON(dbFile, db);
                        await sock.sendMessage(from, { text: `✅ *SUKSES*\nRef ID: ${refId}\nSN: ${resData.sn || '-'}\n💰 Sisa Saldo: Rp ${db[sender].saldo}` });
                    }
                } catch (error) {
                    await sock.sendMessage(from, { text: `❌ *Transaksi Gagal!*\nServer API error. Saldo aman.` });
                }
            }
        } catch (err) {}
    });

    global.waSocket = sock; // Expose socket for Express API
}

// ==========================================
// INTEGRASI WEB API EXPRESS KITA SEBELUMNYA
// ==========================================
app.get('/api/products', (req, res) => {
    let p = loadJSON(produkFile);
    res.json({ data: Object.keys(p).map(k => ({ sku: k, name: p[k].nama, sell_price: p[k].harga })) });
});

app.post('/api/products', (req, res) => {
    const { sku, name, sell_price } = req.body;
    let p = loadJSON(produkFile);
    p[sku.toUpperCase()] = { nama: name, harga: parseInt(sell_price) };
    saveJSON(produkFile, p);
    res.json({ message: 'Produk berhasil ditambahkan melalui API Web' });
});

app.get('/api/digiflazz/cek-saldo', async (req, res) => {
    try {
        let config = loadJSON(configFile);
        const username = config.digiflazzUsername;
        const apiKey = config.digiflazzApiKey;
        const sign = crypto.createHash('md5').update(username + apiKey + "depo").digest('hex');
        const response = await axios.post('https://api.digiflazz.com/v1/cek-saldo', { cmd: "deposit", username, sign });
        res.json({ success: true, data: response.data.data });
    } catch (error) { res.status(500).json({ success: false, error: error.message }); }
});

if (require.main === module) {
    app.listen(3000, () => { console.log('🌐 Web API Server berjalan di port 3000.'); });
    startBot().catch(err => console.error(err));
}
EOF

echo "[4/4] Menginstal Library Node.js (Termasuk Baileys)..."
npm install --silent
npm install -g pm2 > /dev/null 2>&1

cat << 'EOF' > /usr/bin/menu
#!/bin/bash
DIR_NAME="digital-fiky-store"
BOT_NAME="digital-fiky-bot"

menu_telegram() {
    while true; do clear
        echo "==============================================="
        echo "           ⚙️ BOT TELEGRAM SETUP ⚙️            "
        echo "==============================================="
        echo "1. Change BOT API & CHATID"
        echo "2. Set Notifikasi Backup Otomatis (12 Jam)"
        echo "0. Kembali ke Menu Utama"
        echo "==============================================="
        read -p "Pilih menu [0-2]: " telechoice
        case $telechoice in
            1)
                read -p "Token Bot Telegram: " token
                read -p "Chat ID Anda: " chatid
                node -e "const fs = require('fs'); let cfg = fs.existsSync('$HOME/$DIR_NAME/config.json') ? JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/config.json')) : {}; cfg.teleToken = '$token'; cfg.teleChatId = '$chatid'; fs.writeFileSync('$HOME/$DIR_NAME/config.json', JSON.stringify(cfg, null, 2)); console.log('\n✅ Data Telegram disimpan!');"
                read -p "Tekan Enter..." ;;
            2)
                read -p "Aktifkan Auto-Backup ke Telegram setiap 12 Jam? (y/n): " set_auto
                status="false"; if [ "$set_auto" == "y" ]; then status="true"; echo "✅ Auto-Backup DIAKTIFKAN!"; else echo "❌ Auto-Backup DIMATIKAN!"; fi
                node -e "const fs = require('fs'); let cfg = fs.existsSync('$HOME/$DIR_NAME/config.json') ? JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/config.json')) : {}; cfg.autoBackup = $status; fs.writeFileSync('$HOME/$DIR_NAME/config.json', JSON.stringify(cfg, null, 2));"
                read -p "Tekan Enter..." ;;
            0) break ;;
        esac
    done
}

menu_backup() {
    while true; do clear
        echo "==============================================="
        echo "             💾 BACKUP & RESTORE 💾             "
        echo "==============================================="
        echo "1. Backup Sekarang (Kirim file ZIP ke Telegram)"
        echo "2. Restore Database & Bot dari Direct Link"
        echo "0. Kembali ke Menu Utama"
        echo "==============================================="
        read -p "Pilih menu [0-2]: " backchoice
        case $backchoice in
            1)
                cd "$HOME/$DIR_NAME"
                zip backup.zip config.json database.json trx.json index.js package.json produk.json 2>/dev/null
                echo "✅ File backup.zip berhasil dikompresi!"
                node -e "const fs=require('fs');const {exec}=require('child_process');let cfg=fs.existsSync('config.json')?JSON.parse(fs.readFileSync('config.json')):{};if(cfg.teleToken&&cfg.teleChatId){exec(\`curl -s -F chat_id=\"\${cfg.teleChatId}\" -F document=@\"backup.zip\" -F caption=\"📦 Manual Backup\" https://api.telegram.org/bot\${cfg.teleToken}/sendDocument\`,()=>console.log('✅ Terkirim ke Telegram!'));}else{console.log('⚠️ Setup Telegram di Menu 8 dulu.');}"
                read -p "Tekan Enter..." ;;
            2)
                echo -e "\n⚠️ PERHATIAN: Restore MENIMPA file saat ini!"
                read -p "Yakin? (y/n): " yakin
                if [ "$yakin" == "y" ]; then
                    read -p "🔗 Link ZIP Backup: " linkzip
                    cd "$HOME/$DIR_NAME"
                    wget -O restore.zip "$linkzip"
                    unzip -o restore.zip && rm restore.zip && npm install
                    echo "✅ RESTORE BERHASIL! Silakan restart bot."
                fi
                read -p "Tekan Enter..." ;;
            0) break ;;
        esac
    done
}

menu_member() {
    while true; do clear
        echo "==============================================="
        echo "          👥 MANAJEMEN MEMBER BOT 👥           "
        echo "==============================================="
        echo "1. Tambah Saldo Member"
        echo "2. Kurangi Saldo Member"
        echo "3. Lihat Daftar Semua Member"
        echo "0. Kembali ke Menu Utama"
        echo "==============================================="
        read -p "Pilih menu [0-3]: " subchoice
        case $subchoice in
            1)
                read -p "ID Member (Nomor WA): " nomor
                read -p "Jumlah Tambah Saldo: " jumlah
                node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(!db['$nomor']) db['$nomor']={saldo:0,tanggal_daftar:new Date().toLocaleDateString(),jid:'$nomor@s.whatsapp.net'};db['$nomor'].saldo+=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));console.log('✅ Saldo ditambah!');"
                read -p "Tekan Enter..." ;;
            2)
                read -p "ID Member (Nomor WA): " nomor
                read -p "Jumlah Kurang Saldo: " jumlah
                node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};if(db['$nomor']){db['$nomor'].saldo-=parseInt('$jumlah');fs.writeFileSync('$HOME/$DIR_NAME/database.json',JSON.stringify(db,null,2));console.log('✅ Saldo dikurangi!');}else{console.log('❌ Member tidak ditemukan.');}"
                read -p "Tekan Enter..." ;;
            3)
                node -e "const fs=require('fs');let db=fs.existsSync('$HOME/$DIR_NAME/database.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/database.json')):{};Object.keys(db).forEach(k=>console.log(k+' | Rp '+db[k].saldo));"
                read -p "Tekan Enter..." ;;
            0) break ;;
        esac
    done
}

menu_produk() {
    while true; do clear
        echo "==============================================="
        echo "          🛒 MANAJEMEN PRODUK BOT 🛒           "
        echo "==============================================="
        echo "1. Tambah / Edit Produk"
        echo "2. Hapus Produk"
        echo "3. Lihat Daftar Produk"
        echo "0. Kembali ke Menu Utama"
        echo "==============================================="
        read -p "Pilih menu [0-3]: " prodchoice
        case $prodchoice in
            1)
                read -p "Kode Produk (Contoh: TSEL10): " kode
                read -p "Nama Produk: " nama
                read -p "Harga Jual: " harga
                node -e "const fs=require('fs');let p=fs.existsSync('$HOME/$DIR_NAME/produk.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/produk.json')):{};p['$kode'.toUpperCase()]={nama:'$nama',harga:parseInt('$harga')};fs.writeFileSync('$HOME/$DIR_NAME/produk.json',JSON.stringify(p,null,2));console.log('✅ Produk disimpan!');"
                read -p "Tekan Enter..." ;;
            2)
                read -p "Kode Produk dihapus: " kode
                node -e "const fs=require('fs');let p=fs.existsSync('$HOME/$DIR_NAME/produk.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/produk.json')):{};delete p['$kode'.toUpperCase()];fs.writeFileSync('$HOME/$DIR_NAME/produk.json',JSON.stringify(p,null,2));console.log('✅ Dihapus!');"
                read -p "Tekan Enter..." ;;
            3)
                node -e "const fs=require('fs');let p=fs.existsSync('$HOME/$DIR_NAME/produk.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/produk.json')):{};Object.keys(p).forEach(k=>console.log('['+k+'] '+p[k].nama+' - Rp '+p[k].harga));"
                read -p "Tekan Enter..." ;;
            0) break ;;
        esac
    done
}

while true; do clear
    echo "==============================================="
    echo "      🤖 PANEL DIGITAL FIKY STORE (V8) 🤖      "
    echo "==============================================="
    echo "--- MANAJEMEN BOT ---"
    echo "1. Setup No. Bot & Login Pairing"
    echo "2. Jalankan Bot (Latar Belakang/PM2)"
    echo "3. Hentikan Bot (PM2)"
    echo "4. Lihat Log / Error Bot"
    echo ""
    echo "--- MANAJEMEN TOKO & SISTEM ---"
    echo "5. 👥 Manajemen Member (Saldo)"
    echo "6. 🛒 Manajemen Produk (Harga)"
    echo "7. ⚙️ Bot Telegram Setup (Auto-Backup)"
    echo "8. 💾 Backup & Restore Data"
    echo "9. 🔌 Ganti API Digiflazz"
    echo "10. 🔄 Ganti Akun WA (Reset Sesi)"
    echo "0. Keluar"
    echo "==============================================="
    read -p "Pilih menu [0-10]: " choice

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
            echo "✅ Bot berjalan 24 jam!"
            read -p "Tekan Enter..." ;;
        3) pm2 stop $BOT_NAME; read -p "Tekan Enter..." ;;
        4) pm2 logs $BOT_NAME ;;
        5) menu_member ;;
        6) menu_produk ;;
        7) menu_telegram ;;
        8) menu_backup ;;
        9)
            read -p "Username Digiflazz: " user_api
            read -p "API Key Digiflazz: " key_api
            node -e "const fs=require('fs');let cfg=fs.existsSync('$HOME/$DIR_NAME/config.json')?JSON.parse(fs.readFileSync('$HOME/$DIR_NAME/config.json')):{};cfg.digiflazzUsername='$user_api'.trim();cfg.digiflazzApiKey='$key_api'.trim();fs.writeFileSync('$HOME/$DIR_NAME/config.json',JSON.stringify(cfg,null,2));console.log('✅ API Disimpan!');"
            read -p "Tekan Enter..." ;;
        10)
            echo "⚠️ Ini akan menghapus sesi login WA."
            read -p "Lanjutkan? (y/n): " konfirm
            if [ "$konfirmasi" == "y" ] || [ "$konfirmasi" == "Y" ]; then
                pm2 stop $BOT_NAME 2>/dev/null
                rm -rf "$HOME/$DIR_NAME/sesi_bot"
                echo "✅ Sesi dihapus! Buka Menu 1 untuk Login ulang."
            fi
            read -p "Tekan Enter..." ;;
        0) exit 0 ;;
    esac
done
EOF

chmod +x /usr/bin/menu

echo "=========================================================="
echo "  INSTALASI DIGITAL FIKY STORE BERHASIL!                  "
echo "  ------------------------------------------------------  "
echo "  Akses Panel Manajemen: Ketik 'menu' di terminal         "
echo "  Akses API Web        : http://$(wget -qO- eth0.me):3000 "
echo "=========================================================="
