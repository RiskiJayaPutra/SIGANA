# SIGANA — Sistem Informasi Geografis Analisis Bencana Jakarta

> **Rawan Banjir & Rawan Tsunami — DKI Jakarta**
> Mata Kuliah: Sistem Informasi Geografis

---

## 📋 Daftar Isi

1. [Tentang Sistem](#-tentang-sistem)
2. [Prasyarat (Software yang Harus Diinstal)](#-prasyarat-software-yang-harus-diinstal)
3. [Langkah Instalasi](#-langkah-instalasi)
4. [Menjalankan Sistem](#-menjalankan-sistem)
5. [Mengakses Aplikasi](#-mengakses-aplikasi)
6. [Struktur Folder Proyek](#-struktur-folder-proyek)
7. [API Endpoints](#-api-endpoints)
8. [Troubleshooting](#-troubleshooting)

---

## 🔍 Tentang Sistem

SIGANA adalah aplikasi web GIS untuk pemetaan zona rawan banjir dan rawan tsunami di wilayah DKI Jakarta. Sistem ini menampilkan peta interaktif berbasis Leaflet.js dengan data spasial dari PostgreSQL + PostGIS.

**Fitur utama:**
- Peta interaktif zona rawan banjir (choropleth berdasarkan tingkat risiko)
- Peta zona rawan tsunami pesisir utara Jakarta & Kepulauan Seribu
- Titik lokasi pengungsian/evakuasi
- Filter berdasarkan kota administrasi & tingkat risiko
- Dashboard statistik dengan grafik Chart.js
- Toggle layer & basemap switcher (OSM / Satellite)

**Tech Stack:**
| Layer | Teknologi |
|-------|-----------|
| Frontend | HTML5, CSS3, JavaScript, Leaflet.js, Chart.js |
| Backend | Python 3, Flask |
| Database | PostgreSQL 15+ dengan ekstensi PostGIS |
| ETL | Python requests, APScheduler |

---

## ⚙ Prasyarat (Software yang Harus Diinstal)

Sebelum menjalankan SIGANA, pastikan software berikut sudah terinstal di komputer Anda:

### 1. Python 3.10 atau lebih baru
- **Download:** https://www.python.org/downloads/
- Saat instalasi, **WAJIB centang** ☑ `Add Python to PATH`
- Untuk memverifikasi instalasi, buka Command Prompt / PowerShell dan ketik:
  ```
  python --version
  ```
  Harus muncul `Python 3.1x.x`

### 2. PostgreSQL 15 atau lebih baru + PostGIS
- **Download PostgreSQL:** https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
- Saat instalasi PostgreSQL:
  - Catat **password** yang Anda masukkan untuk user `postgres` (akan digunakan nanti)
  - Port default: `5432` (biarkan default)
  - Di akhir instalasi, centang **Stack Builder** untuk menginstal PostGIS
- **Install PostGIS via Stack Builder:**
  1. Setelah PostgreSQL selesai diinstal, Stack Builder akan otomatis terbuka
  2. Pilih PostgreSQL yang baru diinstal
  3. Di daftar aplikasi, expand **Spatial Extensions** → centang **PostGIS 3.x Bundle**
  4. Klik Next dan ikuti proses instalasi hingga selesai

> **Catatan:** Jika Stack Builder tidak muncul, Anda bisa download PostGIS secara terpisah di https://postgis.net/windows_downloads/

### 3. pgAdmin 4 (Opsional, biasanya sudah terinstal bersama PostgreSQL)
- Digunakan untuk mengelola database secara visual
- Alternatif: Anda bisa menggunakan command line `psql`

---

## 📦 Langkah Instalasi

### Langkah 1: Extract / Clone Folder Proyek

Letakkan folder `sigana/` di lokasi yang Anda inginkan. Struktur folder harus seperti ini:

```
sigana/
├── backend/
├── frontend/
├── database/
├── docker-compose.yml
└── README.md          ← file ini
```

---

### Langkah 2: Buat Database dan Import Data

#### Opsi A — Menggunakan Command Line (Direkomendasikan)

1. Buka **PowerShell** atau **Command Prompt**

2. Cari lokasi `psql.exe` di komputer Anda. Biasanya ada di:
   ```
   C:\Program Files\PostgreSQL\17\bin\psql.exe
   ```
   Sesuaikan angka `17` dengan versi PostgreSQL Anda (bisa `15`, `16`, atau `17`).

3. **Buat database `sigana_db`:**
   ```powershell
   & "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "CREATE DATABASE sigana_db;"
   ```
   Masukkan password PostgreSQL Anda saat diminta.

4. **Jalankan schema (membuat tabel-tabel):**
   ```powershell
   & "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d sigana_db -f "LOKASI_FOLDER\sigana\database\schema.sql"
   ```
   Ganti `LOKASI_FOLDER` dengan path aktual folder sigana Anda.

5. **Import data riil:**
   ```powershell
   & "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d sigana_db -f "LOKASI_FOLDER\sigana\database\seed_data.sql"
   ```

6. **Verifikasi data berhasil masuk:**
   ```powershell
   & "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d sigana_db -c "SELECT 'wilayah' as tabel, COUNT(*) FROM wilayah UNION ALL SELECT 'rawan_banjir', COUNT(*) FROM rawan_banjir UNION ALL SELECT 'rawan_tsunami', COUNT(*) FROM rawan_tsunami UNION ALL SELECT 'titik_pengungsian', COUNT(*) FROM titik_pengungsian UNION ALL SELECT 'kejadian_banjir', COUNT(*) FROM kejadian_banjir;"
   ```
   Hasil yang benar:
   ```
        tabel       | count
   -----------------+-------
    wilayah          |    44
    rawan_banjir     |    44
    rawan_tsunami    |    14
    titik_pengungsian|    25
    kejadian_banjir  |    23
   ```

#### Opsi B — Menggunakan pgAdmin 4

1. Buka **pgAdmin 4**
2. Klik kanan pada **Databases** → **Create** → **Database**
3. Isi nama database: `sigana_db` → klik **Save**
4. Klik kanan pada database `sigana_db` → **Query Tool**
5. Klik ikon 📂 (Open File) → buka file `database/schema.sql` → klik ▶ **Execute**
6. Ulangi langkah 5 untuk file `database/seed_data.sql`

---

### Langkah 3: Sesuaikan Password Database

Buka file `backend/config.py` dengan text editor, lalu ubah baris berikut sesuai password PostgreSQL Anda:

```python
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'PASSWORD_ANDA_DISINI')
```

Ganti `PASSWORD_ANDA_DISINI` dengan password yang Anda masukkan saat menginstal PostgreSQL.

> **Pengaturan lain yang mungkin perlu disesuaikan (di file yang sama):**
> - `DB_HOST` — default `localhost` (biasanya tidak perlu diubah)
> - `DB_PORT` — default `5432` (biasanya tidak perlu diubah)
> - `DB_USER` — default `postgres` (biasanya tidak perlu diubah)
> - `DB_NAME` — default `sigana_db` (samakan dengan nama database yang dibuat di Langkah 2)

---

### Langkah 4: Install Library Python

1. Buka **PowerShell** atau **Command Prompt**
2. Masuk ke folder backend:
   ```powershell
   cd LOKASI_FOLDER\sigana\backend
   ```
3. Install semua library yang dibutuhkan:
   ```powershell
   pip install setuptools wheel
   pip install -r requirements.txt
   ```
4. Tunggu hingga proses instalasi selesai (mungkin membutuhkan beberapa menit)

---

## 🚀 Menjalankan Sistem

Anda perlu membuka **2 terminal** secara bersamaan:

### Terminal 1 — Jalankan Backend (API Server)

```powershell
cd LOKASI_FOLDER\sigana\backend
python app.py
```

Jika berhasil, akan muncul output seperti:
```
ETL Scheduler started.
 * Serving Flask app 'app'
 * Running on http://127.0.0.1:5000
```

> ⚠ **Jangan tutup terminal ini!** Biarkan tetap berjalan selama Anda menggunakan aplikasi.

### Terminal 2 — Jalankan Frontend (Web Server)

Buka terminal/PowerShell **baru** (jangan tutup yang pertama), lalu:

```powershell
cd LOKASI_FOLDER\sigana\frontend
python -m http.server 8000
```

Jika berhasil, akan muncul:
```
Serving HTTP on :: port 8000 ...
```

> ⚠ **Jangan tutup terminal ini juga!**

---

## 🌐 Mengakses Aplikasi

Setelah kedua server berjalan, buka **browser** (Chrome / Firefox / Edge) dan akses:

| Halaman | URL | Deskripsi |
|---------|-----|-----------|
| 🗺️ Peta Bencana | http://localhost:8000/index.html | Peta interaktif zona banjir, tsunami, pengungsian |
| 📊 Dashboard | http://localhost:8000/dashboard.html | Statistik & grafik data bencana |
| 🔌 API Test | http://localhost:5000/api/banjir | Test endpoint API (format JSON) |

### Fitur Peta Interaktif:
- **Sidebar kiri:** Filter berdasarkan Kota Administrasi dan Tingkat Risiko
- **Checkbox layer:** Centang/uncentang Zona Banjir, Tsunami, dan Titik Pengungsian
- **Klik zona/titik:** Muncul popup dengan informasi detail
- **Basemap switcher:** Klik ikon layer di kanan atas peta untuk ganti antara OpenStreetMap dan Satellite

---

## 📁 Struktur Folder Proyek

```
sigana/
├── backend/                          # Server API (Python Flask)
│   ├── app.py                        # Entry point Flask
│   ├── config.py                     # Konfigurasi database & API
│   ├── requirements.txt              # Daftar library Python
│   ├── models/                       # Model — query database PostGIS
│   │   ├── db.py                     # Koneksi database
│   │   ├── banjir_model.py           # Query zona rawan banjir
│   │   ├── tsunami_model.py          # Query zona rawan tsunami
│   │   ├── pengungsian_model.py      # Query titik pengungsian
│   │   ├── wilayah_model.py          # Query batas administrasi
│   │   └── kejadian_model.py         # Query histori kejadian banjir
│   ├── controllers/                  # Controller — route handler API
│   │   ├── map_controller.py         # Endpoint /api/banjir, /api/tsunami, dll
│   │   ├── stats_controller.py       # Endpoint /api/stats
│   │   └── etl_controller.py         # Endpoint /api/etl/run
│   └── etl/                          # ETL — ambil data dari API eksternal
│       ├── fetch_bnpb.py             # Fetch data banjir dari BNPB
│       ├── fetch_bmkg.py             # Fetch data gempa dari BMKG
│       └── scheduler.py              # Penjadwalan ETL otomatis
├── frontend/                         # Tampilan web (HTML + CSS + JS)
│   ├── index.html                    # Halaman peta utama
│   ├── dashboard.html                # Halaman dashboard statistik
│   ├── js/
│   │   ├── map.js                    # Logika peta Leaflet
│   │   ├── legend.js                 # Legenda warna risiko
│   │   └── filter.js                 # Logika filter & dropdown
│   └── css/
│       └── style.css                 # Styling tampilan
├── database/                         # File SQL untuk database
│   ├── schema.sql                    # Struktur tabel (DDL)
│   ├── seed_data.sql                 # Data riil DKI Jakarta
│   └── seed_dummy.sql                # Data dummy (tidak digunakan)
├── docker-compose.yml                # Docker setup (opsional)
└── README.md                         # Dokumentasi ini
```

---

## 🔌 API Endpoints

| Method | Endpoint | Parameter | Response |
|--------|----------|-----------|----------|
| GET | `/api/banjir` | `?kota=Jakarta+Utara` `?risiko=Tinggi` | GeoJSON zona banjir |
| GET | `/api/tsunami` | `?zona=Zona+Bahaya+Tinggi` | GeoJSON zona tsunami |
| GET | `/api/pengungsian` | `?kecamatan=Penjaringan` | GeoJSON titik evakuasi |
| GET | `/api/wilayah` | `?kota=Jakarta+Barat` | GeoJSON batas administrasi |
| GET | `/api/stats` | `?type=banjir` | JSON statistik |
| GET | `/api/pengungsian/nearest` | `?lat=-6.1&lng=106.8` | JSON 5 titik evakuasi terdekat |
| POST | `/api/etl/run` | Body: `{"source": "bnpb"}` | JSON hasil ETL |

---

## 🔧 Troubleshooting

### ❌ `psql is not recognized`
**Penyebab:** Path PostgreSQL belum ditambahkan ke PATH sistem.
**Solusi:** Gunakan path lengkap saat menjalankan psql:
```powershell
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres
```

### ❌ `ModuleNotFoundError: No module named 'flask'`
**Penyebab:** Library Python belum diinstal.
**Solusi:** Jalankan ulang:
```powershell
cd sigana\backend
pip install -r requirements.txt
```

### ❌ `Error connecting to PostgreSQL DB`
**Penyebab:** Password database salah atau PostgreSQL tidak berjalan.
**Solusi:**
1. Pastikan service PostgreSQL sudah running (cek di Windows Services → `postgresql-x64-17`)
2. Periksa password di file `backend/config.py`

### ❌ `relation "wilayah" does not exist`
**Penyebab:** Schema dan data belum di-import ke database.
**Solusi:** Jalankan ulang Langkah 2 (Import schema.sql lalu seed_data.sql)

### ❌ Peta tidak menampilkan data / kosong
**Penyebab:** Backend API belum berjalan.
**Solusi:**
1. Pastikan Terminal 1 (backend) masih aktif dan menampilkan `Running on http://127.0.0.1:5000`
2. Buka http://localhost:5000/api/banjir di browser — jika muncul data JSON, backend OK
3. Pastikan Anda mengakses frontend melalui http://localhost:8000 (bukan dengan double-click file)

### ❌ `shapely` atau `psycopg2` gagal diinstal
**Penyebab:** Python versi terbaru kadang butuh setuptools.
**Solusi:**
```powershell
pip install setuptools wheel
pip install -r requirements.txt
```

### ❌ Port 5000 atau 8000 sudah digunakan
**Solusi:** Matikan aplikasi lain yang menggunakan port tersebut, atau ubah port:
- Backend: ubah di `backend/app.py` baris `app.run(port=5000)` → ganti angka 5000
- Frontend: jalankan `python -m http.server 8080` (ganti 8000 ke 8080)

---

## 📊 Data yang Tersedia

| Tabel | Jumlah | Keterangan |
|-------|--------|------------|
| wilayah | 44 record | Semua kecamatan DKI Jakarta (5 kota + Kep. Seribu) |
| rawan_banjir | 44 record | Zona banjir berdasarkan 6 koridor sungai utama |
| rawan_tsunami | 14 record | Zona tsunami pesisir utara + Kepulauan Seribu |
| titik_pengungsian | 25 record | GOR, masjid, sekolah, kantor pemerintah |
| kejadian_banjir | 23 record | Catatan historis banjir 2020–2024 |

**Sumber data:** BNPB InaRISK, BPS DKI Jakarta, DIBI BNPB, BPBD DKI Jakarta, Geoportal BIG.

---

## 📝 Ringkasan Langkah Cepat

```
1. Install Python 3 + PostgreSQL + PostGIS
2. Buat database:    psql -U postgres -c "CREATE DATABASE sigana_db;"
3. Import schema:    psql -U postgres -d sigana_db -f database/schema.sql
4. Import data:      psql -U postgres -d sigana_db -f database/seed_data.sql
5. Ubah password:    Edit backend/config.py → DB_PASSWORD
6. Install library:  cd backend && pip install -r requirements.txt
7. Jalankan backend: python app.py
8. Jalankan frontend (terminal baru): cd frontend && python -m http.server 8000
9. Buka browser:     http://localhost:8000/index.html
```

---

*SIGANA — Sistem Informasi Geografis Analisis Bencana Jakarta © 2024*
