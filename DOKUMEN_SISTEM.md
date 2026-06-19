# 📄 DOKUMEN SISTEM SIGANA

## Sistem Informasi Geografis Analisis Bencana Jakarta

**Mata Kuliah:** Sistem Informasi Geografis
**Status:** ✅ Selesai & Running

---

## 1. Identitas Sistem

| Item | Keterangan |
|------|------------|
| **Nama Sistem** | SIGANA |
| **Kepanjangan** | **S**istem **I**nformasi **G**eografis **Ana**lisis Bencana Jakarta |
| **Versi** | 1.0 |
| **Wilayah Cakupan** | DKI Jakarta (5 Kota Administrasi + Kabupaten Kepulauan Seribu) |
| **Fokus Bencana** | Rawan Banjir & Rawan Tsunami |

---

## 2. Deskripsi Sistem

SIGANA adalah aplikasi web berbasis Sistem Informasi Geografis (SIG/GIS) yang dirancang untuk memvisualisasikan, menganalisis, dan menyajikan informasi spasial terkait zona rawan bencana banjir dan tsunami di wilayah DKI Jakarta. Sistem ini mengintegrasikan data geospasial dari berbagai sumber resmi (BNPB InaRISK, BPS, BMKG, BPBD DKI Jakarta) ke dalam sebuah peta interaktif berbasis web yang dapat diakses oleh publik, pemerintah daerah, dan akademisi.

Sistem ini menerapkan arsitektur **MVC (Model–View–Controller)** dengan backend RESTful API yang menyajikan data dalam format **GeoJSON** standar OGC, serta frontend peta interaktif menggunakan library **Leaflet.js**. Data spasial disimpan dalam database **PostgreSQL** dengan ekstensi **PostGIS** untuk mendukung operasi query geospasial seperti `ST_AsGeoJSON`, `ST_DistanceSphere`, dan spatial indexing menggunakan **GIST**.

---

## 3. Tujuan Sistem

1. **Memetakan zona rawan banjir** di seluruh 44 kecamatan DKI Jakarta berdasarkan tingkat risiko (Tinggi, Sedang, Rendah) dengan visualisasi choropleth pada peta interaktif.
2. **Memetakan zona rawan tsunami** di kawasan pesisir utara Jakarta dan Kepulauan Seribu berdasarkan elevasi, jarak pantai, dan klasifikasi zona bahaya.
3. **Menyediakan informasi titik pengungsian/evakuasi** beserta kapasitas dan fasilitas yang tersedia, dilengkapi fitur pencarian lokasi terdekat menggunakan query spasial `ST_DistanceSphere`.
4. **Mendokumentasikan kejadian banjir historis** (2020–2024) sebagai referensi analisis pola dan frekuensi bencana banjir di DKI Jakarta.
5. **Menyajikan dashboard statistik** berupa grafik distribusi zona rawan banjir per kota administrasi dan per tingkat risiko.
6. **Mengimplementasikan ETL pipeline** untuk pengambilan data otomatis dari API eksternal BNPB InaRISK dengan mekanisme fallback bertingkat.

---

## 4. Manfaat Sistem

### Bagi Pemerintah Daerah (BPBD DKI Jakarta)
- Peta rawan bencana digital yang mudah diakses untuk perencanaan mitigasi
- Data titik pengungsian dan kapasitasnya untuk koordinasi evakuasi
- Dashboard statistik sebagai dasar pengambilan keputusan alokasi anggaran penanggulangan bencana

### Bagi Masyarakat Umum
- Informasi zona rawan banjir dan tsunami di lingkungan tempat tinggal
- Lokasi pengungsian terdekat beserta fasilitas yang tersedia
- Riwayat kejadian banjir historis sebagai awareness bencana

### Bagi Akademisi / Peneliti
- Data geospasial terstruktur dalam format GeoJSON standar OGC untuk analisis lanjutan
- Skema database ternormalisasi (BCNF) yang dapat diadaptasi untuk wilayah lain
- Referensi implementasi WebGIS berbasis open-source technology stack

---

## 5. Kebutuhan Fungsional (KF)

| No | Kode | Kebutuhan Fungsional | Status |
|----|------|---------------------|--------|
| 1 | KF-01 | Sistem menampilkan peta interaktif zona rawan banjir DKI Jakarta dengan warna berdasarkan tingkat risiko (merah=Tinggi, kuning=Sedang, hijau=Rendah) | ✅ |
| 2 | KF-02 | Sistem menampilkan peta zona rawan tsunami di pesisir utara Jakarta dan Kepulauan Seribu | ✅ |
| 3 | KF-03 | Sistem menampilkan titik lokasi pengungsian/evakuasi beserta informasi kapasitas dan fasilitas | ✅ |
| 4 | KF-04 | Pengguna dapat memfilter data peta berdasarkan Kota Administrasi (Jakarta Pusat, Utara, Barat, Selatan, Timur, Kepulauan Seribu) | ✅ |
| 5 | KF-05 | Pengguna dapat memfilter data peta berdasarkan Tingkat Risiko Banjir (Tinggi, Sedang, Rendah) | ✅ |
| 6 | KF-06 | Pengguna dapat mengaktifkan/menonaktifkan layer peta (Zona Banjir, Zona Tsunami, Titik Pengungsian) melalui checkbox | ✅ |
| 7 | KF-07 | Pengguna dapat mengklik zona/titik pada peta untuk melihat popup informasi detail | ✅ |
| 8 | KF-08 | Sistem menyediakan dashboard statistik dengan grafik pie chart (distribusi risiko) dan bar chart (distribusi per kota) | ✅ |
| 9 | KF-09 | Pengguna dapat mengganti basemap antara OpenStreetMap dan Satellite | ✅ |
| 10 | KF-10 | Sistem menyediakan API endpoint untuk mengambil data GeoJSON zona banjir (`/api/banjir`) | ✅ |
| 11 | KF-11 | Sistem menyediakan API endpoint untuk mengambil data GeoJSON zona tsunami (`/api/tsunami`) | ✅ |
| 12 | KF-12 | Sistem menyediakan API endpoint untuk mencari titik pengungsian terdekat berdasarkan koordinat (`/api/pengungsian/nearest`) | ✅ |
| 13 | KF-13 | Sistem menyediakan ETL pipeline otomatis untuk mengambil data banjir dari API BNPB InaRISK dengan mekanisme retry dan fallback bertingkat | ✅ |
| 14 | KF-14 | Sistem mencatat log setiap proses ETL (sumber, jumlah record, status, waktu) ke dalam tabel `log_etl` | ✅ |

---

## 6. Kebutuhan Non-Fungsional (KNF)

| No | Kode | Kebutuhan Non-Fungsional | Kategori | Status |
|----|------|--------------------------|----------|--------|
| 1 | KNF-01 | Sistem dapat diakses melalui browser modern (Chrome, Firefox, Edge) tanpa instalasi plugin tambahan | Kompatibilitas | ✅ |
| 2 | KNF-02 | Peta interaktif dimuat dalam waktu kurang dari 5 detik pada koneksi internet standar | Performa | ✅ |
| 3 | KNF-03 | API merespons request GeoJSON dalam waktu kurang dari 2 detik | Performa | ✅ |
| 4 | KNF-04 | Database menggunakan spatial indexing (GIST) untuk optimasi query geospasial | Performa | ✅ |
| 5 | KNF-05 | Skema database memenuhi normalisasi hingga Boyce-Codd Normal Form (BCNF) | Integritas Data | ✅ |
| 6 | KNF-06 | Antarmuka pengguna bersifat responsive dan user-friendly | Usability | ✅ |
| 7 | KNF-07 | Sistem menerapkan CORS (Cross-Origin Resource Sharing) untuk keamanan API | Keamanan | ✅ |
| 8 | KNF-08 | ETL memiliki mekanisme retry (3x percobaan, delay 2 detik) dan fallback bertingkat | Reliabilitas | ✅ |
| 9 | KNF-09 | Semua data spasial menggunakan sistem referensi koordinat EPSG:4326 (WGS 84) | Standar | ✅ |
| 10 | KNF-10 | API mengembalikan data dalam format GeoJSON sesuai standar OGC | Standar | ✅ |

---

## 7. Arsitektur Sistem

### Pola Arsitektur: MVC (Model–View–Controller)

```
┌─────────────────────────────────────────────────────────────────────┐
│                        FRONTEND (View)                              │
│  ┌──────────────┐  ┌──────────────────┐  ┌───────────────────────┐  │
│  │  index.html   │  │  dashboard.html  │  │  CSS + JavaScript    │  │
│  │  (Peta)       │  │  (Statistik)     │  │  (Leaflet, Chart.js) │  │
│  └──────┬────────┘  └────────┬─────────┘  └───────────────────────┘  │
│         │ HTTP/AJAX (fetch)  │                                       │
└─────────┼────────────────────┼───────────────────────────────────────┘
          │                    │
          ▼                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     BACKEND — Flask API (Controller)                │
│  ┌──────────────────┐ ┌──────────────────┐ ┌─────────────────────┐  │
│  │ map_controller   │ │ stats_controller │ │  etl_controller     │  │
│  │ /api/banjir      │ │ /api/stats       │ │  /api/etl/run       │  │
│  │ /api/tsunami     │ │                  │ │                     │  │
│  │ /api/pengungsian │ │                  │ │                     │  │
│  │ /api/wilayah     │ │                  │ │                     │  │
│  └──────┬───────────┘ └────────┬─────────┘ └──────────┬──────────┘  │
│         │                      │                      │             │
│  ┌──────▼───────────────────────▼──────────────────────▼──────────┐  │
│  │                       Models (Model)                           │  │
│  │  banjir_model │ tsunami_model │ pengungsian_model │ wilayah    │  │
│  │               │               │                   │  _model    │  │
│  └──────────────────────────┬────────────────────────────────────┘  │
└─────────────────────────────┼────────────────────────────────────────┘
                              │ psycopg2 + SQL (ST_AsGeoJSON)
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  DATABASE — PostgreSQL + PostGIS                    │
│  ┌──────────┐ ┌────────────┐ ┌───────────────┐ ┌───────────────┐   │
│  │ wilayah  │ │rawan_banjir│ │rawan_tsunami  │ │titik_         │   │
│  │ (44 rec) │ │ (44 rec)   │ │ (14 rec)      │ │pengungsian    │   │
│  │          │ │            │ │               │ │ (25 rec)      │   │
│  └──────────┘ └────────────┘ └───────────────┘ └───────────────┘   │
│  ┌────────────────┐  ┌──────────┐                                  │
│  │kejadian_banjir │  │ log_etl  │                                  │
│  │ (23 rec)       │  │ (audit)  │                                  │
│  └────────────────┘  └──────────┘                                  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Teknologi yang Digunakan

### 8.1. Bahasa Pemrograman

| Bahasa | Versi | Penggunaan |
|--------|-------|------------|
| **Python** | 3.10+ | Backend API, ETL pipeline, koneksi database |
| **JavaScript (ES6+)** | — | Frontend: logika peta, filter, grafik |
| **HTML5** | — | Struktur halaman web |
| **CSS3** | — | Styling dan layout responsif |
| **SQL** | — | Schema DDL, query spasial PostGIS |

### 8.2. Framework & Library

| Teknologi | Versi | Layer | Fungsi |
|-----------|-------|-------|--------|
| **Flask** | ≥ 3.0.0 | Backend | Web framework Python untuk RESTful API |
| **Flask-CORS** | ≥ 4.0.0 | Backend | Cross-Origin Resource Sharing middleware |
| **psycopg2-binary** | ≥ 2.9.9 | Backend | Driver PostgreSQL untuk Python |
| **requests** | ≥ 2.31.0 | Backend | HTTP client untuk ETL (fetch API BNPB/BMKG) |
| **geopandas** | ≥ 0.14.1 | Backend | Pengolahan data geospasial |
| **shapely** | ≥ 2.0.6 | Backend | Operasi geometri spasial |
| **APScheduler** | ≥ 3.10.4 | Backend | Penjadwalan ETL otomatis (background job) |
| **Leaflet.js** | 1.9.4 | Frontend | Library peta interaktif (via CDN) |
| **Chart.js** | latest | Frontend | Library grafik untuk dashboard (via CDN) |

### 8.3. Database & Ekstensi

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| **PostgreSQL** | 15+ | RDBMS utama untuk penyimpanan data |
| **PostGIS** | 3.4+ | Ekstensi spasial: tipe data geometry, fungsi ST_*, spatial indexing GIST |

### 8.4. Sumber Data Eksternal

| Sumber | Jenis Data | Format |
|--------|------------|--------|
| **BNPB InaRISK** | Indeks bahaya banjir, data DIBI Hidromet | ArcGIS REST API (GeoJSON) |
| **BMKG** | Data gempa bumi terkini | REST API (JSON) |
| **BPS DKI Jakarta** | Data populasi per kecamatan (Sensus 2020) | Statistik |
| **BPBD DKI Jakarta** | Lokasi posko pengungsian, catatan kejadian | Data tabuler |
| **BIG (Geoportal)** | Batas administrasi kecamatan DKI Jakarta | Shapefile / koordinat |

---

## 9. Desain Database

### 9.1. Entity Relationship Diagram (ERD)

```
┌─────────────────────┐        ┌─────────────────────────┐
│      wilayah         │        │     rawan_banjir         │
├─────────────────────┤        ├─────────────────────────┤
│ PK  id              │◄──────┤ FK  wilayah_id           │
│     nama_kelurahan   │   1:N │ PK  id                  │
│     nama_kecamatan   │       │     tingkat_risiko       │
│     kota_admin       │       │     luas_ha              │
│     populasi         │       │     sumber               │
│     geom (MULTIPOLY) │       │     tahun                │
└─────────┬───────────┘       │     geom (MULTIPOLY)     │
          │                    └─────────────────────────┘
          │
          │ 1:N         ┌─────────────────────────┐
          ├────────────►│     rawan_tsunami        │
          │             ├─────────────────────────┤
          │             │ PK  id                  │
          │             │ FK  wilayah_id           │
          │             │     zona_tsunami         │
          │             │     elevasi_max_m        │
          │             │     jarak_pantai_km      │
          │             │     geom (MULTIPOLY)     │
          │             └─────────────────────────┘
          │
          │
┌─────────┴───────────┐       ┌─────────────────────────┐
│  titik_pengungsian   │       │    kejadian_banjir       │
├─────────────────────┤       ├─────────────────────────┤
│ PK  id              │       │ PK  id                  │
│     nama             │       │     tanggal              │
│     kecamatan        │       │     keterangan           │
│     kapasitas        │       │     korban               │
│     fasilitas        │       │     kota_admin           │
│     aktif            │       │     geom (POINT)         │
│     geom (POINT)     │       └─────────────────────────┘
└─────────────────────┘
                               ┌─────────────────────────┐
                               │       log_etl            │
                               ├─────────────────────────┤
                               │ PK  id                  │
                               │     sumber_api           │
                               │     waktu_fetch          │
                               │     jumlah_record        │
                               │     status               │
                               └─────────────────────────┘
```

### 9.2. Ketergantungan Fungsional (Functional Dependencies)

| Tabel | Functional Dependency |
|-------|----------------------|
| **wilayah** | `id → nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom` |
| **rawan_banjir** | `id → wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom` |
| **rawan_tsunami** | `id → wilayah_id, zona_tsunami, elevasi_max_m, jarak_pantai_km, geom` |
| **titik_pengungsian** | `id → nama, kecamatan, kapasitas, fasilitas, aktif, geom` |
| **kejadian_banjir** | `id → tanggal, keterangan, korban, kota_admin, geom` |
| **log_etl** | `id → sumber_api, waktu_fetch, jumlah_record, status` |

**Keterangan:**
- Setiap tabel memiliki **satu candidate key** yaitu kolom `id` (surrogate key, SERIAL PRIMARY KEY)
- Tidak ada **partial dependency** karena semua atribut non-key bergantung penuh pada `id`
- Tidak ada **transitive dependency** karena data wilayah (nama kecamatan, kota) diakses melalui JOIN ke tabel `wilayah` via foreign key `wilayah_id`, bukan disimpan redundan

### 9.3. Normalisasi Database

| Bentuk Normal | Status | Penjelasan |
|---------------|--------|------------|
| **1NF** (First Normal Form) | ✅ | Semua atribut bernilai atomik. Kolom `fasilitas` bertipe TEXT (deskriptif), bukan array. Tidak ada repeating group. |
| **2NF** (Second Normal Form) | ✅ | Semua atribut non-key bergantung penuh pada primary key `id`. Tidak ada partial dependency karena PK bersifat single-column. |
| **3NF** (Third Normal Form) | ✅ | Tidak ada transitive dependency. Data wilayah administrasi disimpan terpisah di tabel `wilayah` dan diakses via foreign key `wilayah_id`. |
| **BCNF** (Boyce-Codd Normal Form) | ✅ | Setiap determinan pada setiap tabel adalah candidate key (`id`). Tidak ada non-trivial FD dimana sisi kiri bukan superkey. |

### 9.4. Spatial Indexing

| Tabel | Index | Tipe | Kolom |
|-------|-------|------|-------|
| wilayah | `idx_wilayah_geom` | GIST | `geom` |
| rawan_banjir | `idx_rawan_banjir_geom` | GIST | `geom` |
| rawan_banjir | `idx_rawan_banjir_wilayah` | B-tree | `wilayah_id` |
| rawan_tsunami | `idx_rawan_tsunami_geom` | GIST | `geom` |
| rawan_tsunami | `idx_rawan_tsunami_wilayah` | B-tree | `wilayah_id` |
| titik_pengungsian | `idx_titik_pengungsian_geom` | GIST | `geom` |
| kejadian_banjir | `idx_kejadian_banjir_geom` | GIST | `geom` |

---

## 10. Data yang Tersedia

| Tabel | Jumlah Record | Sumber Data | Keterangan |
|-------|---------------|-------------|------------|
| **wilayah** | 44 | BPS DKI Jakarta, BIG | Seluruh kecamatan: Jakarta Pusat (8), Jakarta Utara (6), Jakarta Barat (8), Jakarta Selatan (10), Jakarta Timur (10), Kepulauan Seribu (2) |
| **rawan_banjir** | 44 | BNPB InaRISK | Zona banjir di 6 koridor sungai utama: Ciliwung, Angke, Sunter, Cakung, Krukut, Pesanggrahan. Tinggi: 13, Sedang: 16, Rendah: 15 |
| **rawan_tsunami** | 14 | BMKG, BNPB InaRISK | Zona bahaya tinggi (pesisir), sedang, dan rendah di 8 kecamatan pesisir + Kepulauan Seribu |
| **titik_pengungsian** | 25 | BPBD DKI Jakarta | GOR, masjid, sekolah, kantor pemerintah di seluruh Jakarta |
| **kejadian_banjir** | 23 | DIBI BNPB, BPBD DKI | Catatan historis banjir tahun 2020–2024 di seluruh kota administrasi |
| **log_etl** | 5 | Sistem | Audit trail proses impor data |

**Total Luas Area Rawan Banjir:** 7.587,2 Hektar

---

## 11. API Endpoints

| Method | Endpoint | Parameter Query | Response Format |
|--------|----------|-----------------|-----------------|
| GET | `/api/banjir` | `?kota=Jakarta Utara` `?risiko=Tinggi` | GeoJSON FeatureCollection |
| GET | `/api/tsunami` | `?zona=Zona Bahaya Tinggi` | GeoJSON FeatureCollection |
| GET | `/api/pengungsian` | `?kecamatan=Penjaringan` | GeoJSON FeatureCollection |
| GET | `/api/pengungsian/nearest` | `?lat=-6.1&lng=106.8` | JSON Array (5 terdekat) |
| GET | `/api/wilayah` | `?kota=Jakarta Barat` | GeoJSON FeatureCollection |
| GET | `/api/stats` | `?type=banjir` | JSON (luas_total, per_risiko, per_kota) |
| POST | `/api/etl/run` | Body: `{"source":"bnpb"}` | JSON (hasil ETL) |

---

## 12. Fitur Antarmuka Pengguna

### Halaman Peta Bencana (`index.html`)
- **Peta interaktif** Leaflet.js dengan center di Jakarta (-6.20, 106.82)
- **Sidebar filter:** dropdown Kota Administrasi & Tingkat Risiko
- **Layer toggle:** checkbox untuk Zona Banjir, Zona Tsunami, Titik Pengungsian
- **Choropleth banjir:** Merah (Tinggi), Kuning (Sedang), Hijau (Rendah)
- **Popup informasi:** klik zona/titik untuk detail (nama, risiko, luas, kapasitas)
- **Basemap switcher:** OpenStreetMap ↔ Esri Satellite
- **Legenda warna:** keterangan kode warna risiko

### Halaman Dashboard (`dashboard.html`)
- **Total luas area rawan banjir** (angka besar, formatted Indonesia)
- **Pie chart:** distribusi zona berdasarkan tingkat risiko
- **Bar chart:** distribusi zona per kota administrasi

---

## 13. Alur ETL (Extract–Transform–Load)

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   ATTEMPT 1       │────►│   ATTEMPT 2       │────►│   ATTEMPT 3       │
│ BNPB DIBI Hidromet│     │ BNPB Batas Admin  │     │ Local Fallback    │
│ (Feature Layer)   │     │ (Kecamatan Layer)  │     │ (12 zona banjir)  │
│                   │     │ + Risk klasifikasi │     │                   │
│ Retry: 3x, 2s    │     │ Pagination 100/page│     │ Immediate insert  │
│ Timeout: 120s     │     │ Retry: 3x, 2s     │     │                   │
└──────────────────┘     └──────────────────┘     └──────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
    ┌────────────────────────────────────────────────────────────┐
    │            PostgreSQL — INSERT rawan_banjir                │
    │            ST_GeomFromGeoJSON + ON CONFLICT DO NOTHING     │
    │            + log_etl (sumber, jumlah, status)              │
    └────────────────────────────────────────────────────────────┘
```

---

## 14. Struktur Folder Proyek

```
sigana/
├── backend/                          # Server API (Python Flask)
│   ├── app.py                        # Entry point, Blueprint registration
│   ├── config.py                     # Konfigurasi DB & API endpoints
│   ├── requirements.txt              # Dependencies Python
│   ├── models/                       # Layer Model — query PostGIS
│   │   ├── db.py                     # Koneksi PostgreSQL (psycopg2)
│   │   ├── banjir_model.py           # ST_AsGeoJSON query zona banjir
│   │   ├── tsunami_model.py          # ST_AsGeoJSON query zona tsunami
│   │   ├── pengungsian_model.py      # ST_DistanceSphere untuk nearest
│   │   ├── wilayah_model.py          # Query batas administrasi
│   │   └── kejadian_model.py         # Query histori kejadian
│   ├── controllers/                  # Layer Controller — REST endpoints
│   │   ├── map_controller.py         # /api/banjir, /api/tsunami, etc.
│   │   ├── stats_controller.py       # /api/stats
│   │   └── etl_controller.py         # /api/etl/run
│   └── etl/                          # Layer ETL — data pipeline
│       ├── fetch_bnpb.py             # 3-tier fallback BNPB fetch
│       ├── fetch_bmkg.py             # BMKG gempa bumi fetch
│       └── scheduler.py             # APScheduler background jobs
├── frontend/                         # Tampilan Web (View)
│   ├── index.html                    # Halaman peta utama
│   ├── dashboard.html                # Halaman dashboard statistik
│   ├── js/
│   │   ├── map.js                    # Inisialisasi Leaflet, layer, popup
│   │   ├── legend.js                 # Kontrol legenda warna risiko
│   │   └── filter.js                 # Logika filter dropdown
│   └── css/
│       └── style.css                 # CSS variables, layout, responsive
├── database/                         # File SQL
│   ├── schema.sql                    # DDL: 6 tabel + index GIST
│   └── seed_data.sql                 # Data riil 44 kecamatan DKI Jakarta
└── README.md                         # Dokumentasi instalasi & penggunaan
```

**Total file:** 25 file
**Total baris kode:** ±1.500 baris

---

## 15. Cara Menjalankan

```
1. Install Python 3.10+ dan PostgreSQL 15+ (dengan PostGIS)
2. Buat database:     psql -U postgres -c "CREATE DATABASE sigana_db;"
3. Import schema:     psql -U postgres -d sigana_db -f database/schema.sql
4. Import data:       psql -U postgres -d sigana_db -f database/seed_data.sql
5. Sesuaikan password: Edit backend/config.py → DB_PASSWORD
6. Install library:   cd backend && pip install -r requirements.txt
7. Jalankan backend:  python app.py         (Terminal 1)
8. Jalankan frontend: cd frontend && python -m http.server 8000  (Terminal 2)
9. Buka browser:      http://localhost:8000/index.html
```

---

*Dokumen ini dibuat sebagai bagian dari tugas mata kuliah Sistem Informasi Geografis.*
*SIGANA — Sistem Informasi Geografis Analisis Bencana Jakarta © 2024*
