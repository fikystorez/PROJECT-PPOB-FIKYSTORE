# 🛒 DIGITAL FIKY STORE - Aplikasi PPOB & WhatsApp Bot

Selamat datang di *repository* resmi **DIGITAL FIKY STORE**. Ini adalah aplikasi PPOB (Payment Point Online Bank) terintegrasi yang dibangun menggunakan Node.js, SQLite, dan terhubung langsung dengan API Digiflazz serta WhatsApp Bot (whatsapp-web.js) untuk manajemen OTP & Notifikasi.

## ✨ Fitur Utama
- **Auto-Install & Panel Manajemen VPS:** Instalasi otomatis dengan satu perintah.
- **WhatsApp Bot Terintegrasi:** Menerima login via Pairing Code (Tanpa Scan QR).
- **Manajemen OTP & Saldo:** Member dapat mendaftar dan menerima kode OTP via WhatsApp.
- **Koneksi API Digiflazz:** Terhubung ke server Digiflazz untuk cek saldo dan transaksi.
- **Database Ringan (SQLite):** Tidak memerlukan instalasi server database berat di VPS.
- **Opsi Domain/IP:** Mendukung reverse proxy Nginx untuk penggunaan nama domain.

## 🚀 Cara Instalasi di VPS (One-Click Install)

Pastikan Anda menggunakan VPS dengan OS Linux (Ubuntu/Debian) dan login sebagai `root`. Jalankan perintah sakti di bawah ini pada terminal VPS Anda:

```bash
apt update && apt install wget -y && wget -qO install.sh [https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh](https://raw.githubusercontent.com/fikystorez/PROJECT-PPOB-FIKYSTORE/main/install.sh) && chmod +x install.sh && ./install.sh
