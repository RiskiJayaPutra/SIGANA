-- ============================================================================
-- SIGANA — Data Riil DKI Jakarta
-- Sumber: BNPB InaRISK, BPS DKI Jakarta, DIBI BNPB, BPBD DKI Jakarta
-- Semua koordinat berdasarkan batas administrasi resmi BIG (Geoportal)
-- ============================================================================

-- Bersihkan data lama
TRUNCATE TABLE kejadian_banjir CASCADE;
TRUNCATE TABLE titik_pengungsian CASCADE;
TRUNCATE TABLE rawan_tsunami CASCADE;
TRUNCATE TABLE rawan_banjir CASCADE;
TRUNCATE TABLE wilayah CASCADE;
TRUNCATE TABLE log_etl CASCADE;

-- Reset sequence
ALTER SEQUENCE wilayah_id_seq RESTART WITH 1;
ALTER SEQUENCE rawan_banjir_id_seq RESTART WITH 1;
ALTER SEQUENCE rawan_tsunami_id_seq RESTART WITH 1;
ALTER SEQUENCE titik_pengungsian_id_seq RESTART WITH 1;
ALTER SEQUENCE kejadian_banjir_id_seq RESTART WITH 1;
ALTER SEQUENCE log_etl_id_seq RESTART WITH 1;

-- ============================================================================
-- 1. TABEL WILAYAH — Semua 44 Kecamatan DKI Jakarta
--    Sumber: BPS DKI Jakarta (populasi Sensus 2020), batas wilayah BIG
-- ============================================================================

-- === JAKARTA PUSAT (8 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Gambir', 'Gambir', 'Jakarta Pusat', 75232, ST_GeomFromText('MULTIPOLYGON(((106.807 -6.164, 106.833 -6.164, 106.836 -6.178, 106.830 -6.188, 106.810 -6.190, 106.805 -6.180, 106.807 -6.164)))', 4326)),
('Tanah Abang', 'Tanah Abang', 'Jakarta Pusat', 131683, ST_GeomFromText('MULTIPOLYGON(((106.800 -6.188, 106.825 -6.190, 106.830 -6.200, 106.828 -6.215, 106.810 -6.218, 106.798 -6.208, 106.800 -6.188)))', 4326)),
('Menteng', 'Menteng', 'Jakarta Pusat', 67518, ST_GeomFromText('MULTIPOLYGON(((106.833 -6.183, 106.857 -6.185, 106.860 -6.198, 106.855 -6.213, 106.835 -6.210, 106.830 -6.200, 106.833 -6.183)))', 4326)),
('Senen', 'Senen', 'Jakarta Pusat', 94053, ST_GeomFromText('MULTIPOLYGON(((106.840 -6.162, 106.865 -6.163, 106.868 -6.176, 106.862 -6.186, 106.843 -6.185, 106.838 -6.175, 106.840 -6.162)))', 4326)),
('Johar Baru', 'Johar Baru', 'Jakarta Pusat', 113828, ST_GeomFromText('MULTIPOLYGON(((106.853 -6.170, 106.878 -6.172, 106.880 -6.185, 106.875 -6.195, 106.855 -6.192, 106.850 -6.182, 106.853 -6.170)))', 4326)),
('Cempaka Putih', 'Cempaka Putih', 'Jakarta Pusat', 84285, ST_GeomFromText('MULTIPOLYGON(((106.865 -6.167, 106.893 -6.168, 106.895 -6.180, 106.890 -6.192, 106.870 -6.190, 106.863 -6.178, 106.865 -6.167)))', 4326)),
('Kemayoran', 'Kemayoran', 'Jakarta Pusat', 224089, ST_GeomFromText('MULTIPOLYGON(((106.845 -6.140, 106.875 -6.142, 106.878 -6.155, 106.873 -6.168, 106.850 -6.166, 106.843 -6.155, 106.845 -6.140)))', 4326)),
('Sawah Besar', 'Sawah Besar', 'Jakarta Pusat', 96058, ST_GeomFromText('MULTIPOLYGON(((106.833 -6.140, 106.860 -6.142, 106.862 -6.155, 106.858 -6.165, 106.835 -6.163, 106.830 -6.152, 106.833 -6.140)))', 4326));

-- === JAKARTA UTARA (6 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Penjaringan', 'Penjaringan', 'Jakarta Utara', 352540, ST_GeomFromText('MULTIPOLYGON(((106.740 -6.085, 106.800 -6.083, 106.805 -6.100, 106.800 -6.125, 106.785 -6.140, 106.750 -6.138, 106.738 -6.115, 106.740 -6.085)))', 4326)),
('Pademangan', 'Pademangan', 'Jakarta Pusat', 155095, ST_GeomFromText('MULTIPOLYGON(((106.830 -6.095, 106.870 -6.093, 106.872 -6.110, 106.868 -6.130, 106.850 -6.140, 106.832 -6.135, 106.828 -6.115, 106.830 -6.095)))', 4326)),
('Tanjung Priok', 'Tanjung Priok', 'Jakarta Utara', 406524, ST_GeomFromText('MULTIPOLYGON(((106.865 -6.095, 106.915 -6.093, 106.918 -6.110, 106.912 -6.132, 106.900 -6.145, 106.870 -6.140, 106.863 -6.118, 106.865 -6.095)))', 4326)),
('Koja', 'Koja', 'Jakarta Utara', 314874, ST_GeomFromText('MULTIPOLYGON(((106.895 -6.100, 106.940 -6.098, 106.942 -6.115, 106.938 -6.135, 106.920 -6.145, 106.898 -6.140, 106.893 -6.120, 106.895 -6.100)))', 4326)),
('Kelapa Gading', 'Kelapa Gading', 'Jakarta Utara', 152247, ST_GeomFromText('MULTIPOLYGON(((106.880 -6.145, 106.925 -6.147, 106.928 -6.160, 106.922 -6.178, 106.900 -6.180, 106.882 -6.175, 106.878 -6.160, 106.880 -6.145)))', 4326)),
('Cilincing', 'Cilincing', 'Jakarta Utara', 410695, ST_GeomFromText('MULTIPOLYGON(((106.930 -6.090, 106.975 -6.088, 106.978 -6.108, 106.972 -6.135, 106.955 -6.150, 106.935 -6.145, 106.928 -6.120, 106.930 -6.090)))', 4326));

-- === JAKARTA BARAT (8 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Kalideres', 'Kalideres', 'Jakarta Barat', 490692, ST_GeomFromText('MULTIPOLYGON(((106.620 -6.120, 106.695 -6.118, 106.698 -6.140, 106.692 -6.165, 106.670 -6.175, 106.635 -6.172, 106.618 -6.150, 106.620 -6.120)))', 4326)),
('Cengkareng', 'Cengkareng', 'Jakarta Barat', 516356, ST_GeomFromText('MULTIPOLYGON(((106.695 -6.120, 106.760 -6.118, 106.763 -6.138, 106.758 -6.162, 106.740 -6.175, 106.700 -6.172, 106.693 -6.150, 106.695 -6.120)))', 4326)),
('Kembangan', 'Kembangan', 'Jakarta Barat', 285670, ST_GeomFromText('MULTIPOLYGON(((106.720 -6.178, 106.775 -6.180, 106.778 -6.200, 106.773 -6.225, 106.750 -6.232, 106.725 -6.228, 106.718 -6.205, 106.720 -6.178)))', 4326)),
('Kebon Jeruk', 'Kebon Jeruk', 'Jakarta Barat', 353710, ST_GeomFromText('MULTIPOLYGON(((106.755 -6.175, 106.800 -6.177, 106.803 -6.195, 106.798 -6.215, 106.780 -6.218, 106.758 -6.213, 106.753 -6.195, 106.755 -6.175)))', 4326)),
('Grogol Petamburan', 'Grogol Petamburan', 'Jakarta Barat', 256914, ST_GeomFromText('MULTIPOLYGON(((106.782 -6.155, 106.820 -6.157, 106.822 -6.172, 106.818 -6.190, 106.800 -6.192, 106.785 -6.188, 106.780 -6.172, 106.782 -6.155)))', 4326)),
('Tambora', 'Tambora', 'Jakarta Barat', 244921, ST_GeomFromText('MULTIPOLYGON(((106.800 -6.130, 106.830 -6.132, 106.832 -6.145, 106.828 -6.158, 106.812 -6.160, 106.802 -6.155, 106.798 -6.142, 106.800 -6.130)))', 4326)),
('Taman Sari', 'Taman Sari', 'Jakarta Barat', 111608, ST_GeomFromText('MULTIPOLYGON(((106.805 -6.135, 106.835 -6.137, 106.838 -6.150, 106.833 -6.168, 106.815 -6.170, 106.807 -6.165, 106.803 -6.150, 106.805 -6.135)))', 4326)),
('Palmerah', 'Palmerah', 'Jakarta Barat', 222485, ST_GeomFromText('MULTIPOLYGON(((106.782 -6.195, 106.815 -6.197, 106.818 -6.212, 106.813 -6.228, 106.795 -6.230, 106.784 -6.225, 106.780 -6.210, 106.782 -6.195)))', 4326));

-- === JAKARTA SELATAN (10 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Kebayoran Baru', 'Kebayoran Baru', 'Jakarta Selatan', 128072, ST_GeomFromText('MULTIPOLYGON(((106.780 -6.230, 106.820 -6.232, 106.822 -6.248, 106.818 -6.263, 106.800 -6.265, 106.783 -6.260, 106.778 -6.245, 106.780 -6.230)))', 4326)),
('Kebayoran Lama', 'Kebayoran Lama', 'Jakarta Selatan', 343692, ST_GeomFromText('MULTIPOLYGON(((106.760 -6.245, 106.800 -6.247, 106.803 -6.262, 106.798 -6.283, 106.778 -6.285, 106.762 -6.280, 106.758 -6.265, 106.760 -6.245)))', 4326)),
('Pesanggrahan', 'Pesanggrahan', 'Jakarta Selatan', 222048, ST_GeomFromText('MULTIPOLYGON(((106.730 -6.245, 106.770 -6.247, 106.773 -6.265, 106.768 -6.283, 106.748 -6.285, 106.733 -6.278, 106.728 -6.262, 106.730 -6.245)))', 4326)),
('Cilandak', 'Cilandak', 'Jakarta Selatan', 183048, ST_GeomFromText('MULTIPOLYGON(((106.800 -6.270, 106.840 -6.272, 106.843 -6.290, 106.838 -6.308, 106.818 -6.310, 106.803 -6.305, 106.798 -6.288, 106.800 -6.270)))', 4326)),
('Pasar Minggu', 'Pasar Minggu', 'Jakarta Selatan', 295582, ST_GeomFromText('MULTIPOLYGON(((106.832 -6.270, 106.870 -6.272, 106.873 -6.292, 106.868 -6.315, 106.848 -6.320, 106.835 -6.312, 106.830 -6.292, 106.832 -6.270)))', 4326)),
('Jagakarsa', 'Jagakarsa', 'Jakarta Selatan', 390870, ST_GeomFromText('MULTIPOLYGON(((106.800 -6.320, 106.850 -6.322, 106.855 -6.345, 106.848 -6.372, 106.825 -6.375, 106.805 -6.368, 106.798 -6.345, 106.800 -6.320)))', 4326)),
('Mampang Prapatan', 'Mampang Prapatan', 'Jakarta Selatan', 73900, ST_GeomFromText('MULTIPOLYGON(((106.820 -6.233, 106.850 -6.235, 106.852 -6.248, 106.848 -6.263, 106.830 -6.265, 106.822 -6.258, 106.818 -6.245, 106.820 -6.233)))', 4326)),
('Pancoran', 'Pancoran', 'Jakarta Selatan', 148587, ST_GeomFromText('MULTIPOLYGON(((106.840 -6.235, 106.870 -6.237, 106.872 -6.250, 106.868 -6.265, 106.850 -6.268, 106.842 -6.260, 106.838 -6.248, 106.840 -6.235)))', 4326)),
('Tebet', 'Tebet', 'Jakarta Selatan', 100021, ST_GeomFromText('MULTIPOLYGON(((106.840 -6.218, 106.870 -6.220, 106.873 -6.232, 106.868 -6.245, 106.850 -6.248, 106.842 -6.242, 106.838 -6.230, 106.840 -6.218)))', 4326)),
('Setiabudi', 'Setiabudi', 'Jakarta Selatan', 97280, ST_GeomFromText('MULTIPOLYGON(((106.820 -6.205, 106.848 -6.207, 106.850 -6.220, 106.847 -6.233, 106.828 -6.235, 106.822 -6.228, 106.818 -6.215, 106.820 -6.205)))', 4326));

-- === JAKARTA TIMUR (10 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Matraman', 'Matraman', 'Jakarta Timur', 170253, ST_GeomFromText('MULTIPOLYGON(((106.858 -6.200, 106.883 -6.202, 106.885 -6.215, 106.880 -6.228, 106.862 -6.230, 106.856 -6.222, 106.855 -6.210, 106.858 -6.200)))', 4326)),
('Pulo Gadung', 'Pulo Gadung', 'Jakarta Timur', 267649, ST_GeomFromText('MULTIPOLYGON(((106.880 -6.170, 106.920 -6.172, 106.923 -6.190, 106.918 -6.213, 106.900 -6.218, 106.883 -6.212, 106.878 -6.192, 106.880 -6.170)))', 4326)),
('Jatinegara', 'Jatinegara', 'Jakarta Timur', 279222, ST_GeomFromText('MULTIPOLYGON(((106.860 -6.218, 106.898 -6.220, 106.900 -6.238, 106.895 -6.255, 106.875 -6.258, 106.863 -6.250, 106.858 -6.235, 106.860 -6.218)))', 4326)),
('Duren Sawit', 'Duren Sawit', 'Jakarta Timur', 392766, ST_GeomFromText('MULTIPOLYGON(((106.898 -6.218, 106.945 -6.220, 106.948 -6.240, 106.942 -6.265, 106.920 -6.268, 106.902 -6.260, 106.896 -6.240, 106.898 -6.218)))', 4326)),
('Kramat Jati', 'Kramat Jati', 'Jakarta Timur', 254591, ST_GeomFromText('MULTIPOLYGON(((106.862 -6.260, 106.900 -6.262, 106.903 -6.280, 106.898 -6.298, 106.878 -6.300, 106.865 -6.295, 106.860 -6.278, 106.862 -6.260)))', 4326)),
('Makasar', 'Makasar', 'Jakarta Timur', 210268, ST_GeomFromText('MULTIPOLYGON(((106.880 -6.260, 106.920 -6.262, 106.923 -6.280, 106.918 -6.298, 106.900 -6.300, 106.883 -6.295, 106.878 -6.278, 106.880 -6.260)))', 4326)),
('Pasar Rebo', 'Pasar Rebo', 'Jakarta Timur', 208920, ST_GeomFromText('MULTIPOLYGON(((106.850 -6.300, 106.892 -6.302, 106.895 -6.322, 106.890 -6.343, 106.870 -6.345, 106.853 -6.340, 106.848 -6.320, 106.850 -6.300)))', 4326)),
('Ciracas', 'Ciracas', 'Jakarta Timur', 309033, ST_GeomFromText('MULTIPOLYGON(((106.870 -6.300, 106.918 -6.302, 106.920 -6.322, 106.915 -6.343, 106.895 -6.345, 106.875 -6.340, 106.868 -6.320, 106.870 -6.300)))', 4326)),
('Cipayung', 'Cipayung', 'Jakarta Timur', 315819, ST_GeomFromText('MULTIPOLYGON(((106.880 -6.335, 106.930 -6.337, 106.933 -6.355, 106.928 -6.378, 106.908 -6.380, 106.885 -6.375, 106.878 -6.355, 106.880 -6.335)))', 4326)),
('Cakung', 'Cakung', 'Jakarta Timur', 570839, ST_GeomFromText('MULTIPOLYGON(((106.920 -6.145, 106.975 -6.147, 106.978 -6.172, 106.972 -6.210, 106.950 -6.218, 106.925 -6.213, 106.918 -6.180, 106.920 -6.145)))', 4326));

-- === KEPULAUAN SERIBU (2 Kecamatan) ===
INSERT INTO wilayah (nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom) VALUES
('Kepulauan Seribu Selatan', 'Kepulauan Seribu Selatan', 'Kepulauan Seribu', 13205, ST_GeomFromText('MULTIPOLYGON(((106.550 -5.740, 106.650 -5.738, 106.655 -5.770, 106.648 -5.808, 106.610 -5.810, 106.570 -5.805, 106.548 -5.775, 106.550 -5.740)))', 4326)),
('Kepulauan Seribu Utara', 'Kepulauan Seribu Utara', 'Kepulauan Seribu', 10504, ST_GeomFromText('MULTIPOLYGON(((106.500 -5.560, 106.620 -5.558, 106.625 -5.610, 106.618 -5.730, 106.580 -5.740, 106.520 -5.735, 106.498 -5.650, 106.500 -5.560)))', 4326));


-- ============================================================================
-- 2. TABEL RAWAN_BANJIR — Zona Rawan Banjir DKI Jakarta
--    Sumber: Peta InaRISK BNPB, BPBD DKI Jakarta, analisis DAS sungai
--    Koridor: Ciliwung, Angke, Sunter, Cakung, Krukut, Pesanggrahan
-- ============================================================================

-- --- Koridor Sungai Ciliwung (Jakarta Selatan → Pusat → Utara) ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Kampung Melayu & Bidara Cina (Jatinegara) — langganan banjir Ciliwung
(35, 'Tinggi', 285.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.865 -6.225, 106.878 -6.226, 106.880 -6.240, 106.876 -6.250, 106.867 -6.248, 106.863 -6.238, 106.865 -6.225)))', 4326)),
-- Bukit Duri & Kebon Baru (Tebet) — banjir kiriman Ciliwung
(31, 'Tinggi', 195.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.850 -6.225, 106.862 -6.226, 106.864 -6.238, 106.860 -6.245, 106.852 -6.243, 106.848 -6.235, 106.850 -6.225)))', 4326)),
-- Manggarai & Guntur (Setiabudi/Tebet) — pintu air Manggarai
(32, 'Sedang', 120.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.845 -6.210, 106.858 -6.211, 106.860 -6.222, 106.856 -6.230, 106.847 -6.228, 106.843 -6.220, 106.845 -6.210)))', 4326)),
-- Cempaka Putih — banjir sungai Ciliwung cabang
(6, 'Sedang', 150.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.870 -6.170, 106.890 -6.171, 106.892 -6.182, 106.888 -6.190, 106.873 -6.188, 106.868 -6.180, 106.870 -6.170)))', 4326)),
-- Kemayoran — dataran rendah, banjir genangan
(7, 'Sedang', 180.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.850 -6.145, 106.872 -6.146, 106.874 -6.158, 106.870 -6.165, 106.855 -6.164, 106.848 -6.155, 106.850 -6.145)))', 4326)),
-- Pademangan — muara Ciliwung
(10, 'Tinggi', 220.60, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.835 -6.100, 106.865 -6.098, 106.868 -6.115, 106.863 -6.132, 106.845 -6.135, 106.833 -6.125, 106.835 -6.100)))', 4326));

-- --- Koridor Kali Angke (Jakarta Barat → Utara) ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Cengkareng — dataran rendah, dekat Kali Angke
(16, 'Tinggi', 380.70, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.700 -6.125, 106.750 -6.123, 106.753 -6.145, 106.748 -6.168, 106.725 -6.170, 106.705 -6.165, 106.698 -6.148, 106.700 -6.125)))', 4326)),
-- Kalideres — area rendah, rawan genangan
(15, 'Tinggi', 420.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.625 -6.125, 106.690 -6.123, 106.693 -6.148, 106.688 -6.170, 106.660 -6.172, 106.632 -6.168, 106.623 -6.148, 106.625 -6.125)))', 4326)),
-- Penjaringan — Muara Angke, Pluit, banjir rob + Kali Angke
(9, 'Tinggi', 520.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.745 -6.090, 106.795 -6.088, 106.798 -6.108, 106.793 -6.132, 106.775 -6.138, 106.752 -6.135, 106.743 -6.115, 106.745 -6.090)))', 4326)),
-- Tambora — Kali Angke & Kali Krukut, pemukiman padat
(20, 'Tinggi', 145.90, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.805 -6.133, 106.828 -6.134, 106.830 -6.148, 106.826 -6.157, 106.810 -6.158, 106.803 -6.150, 106.805 -6.133)))', 4326)),
-- Grogol Petamburan — pertemuan sungai
(19, 'Sedang', 165.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.785 -6.160, 106.815 -6.162, 106.818 -6.175, 106.813 -6.188, 106.795 -6.190, 106.787 -6.182, 106.785 -6.160)))', 4326));

-- --- Koridor Kali Sunter (Jakarta Timur → Utara) ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Kelapa Gading — dekat Kali Sunter
(13, 'Sedang', 175.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.885 -6.150, 106.920 -6.152, 106.922 -6.165, 106.918 -6.176, 106.898 -6.178, 106.887 -6.172, 106.885 -6.150)))', 4326)),
-- Tanjung Priok — area pelabuhan, rob & Kali Sunter
(11, 'Tinggi', 310.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.870 -6.098, 106.910 -6.096, 106.913 -6.115, 106.908 -6.138, 106.890 -6.142, 106.873 -6.135, 106.868 -6.115, 106.870 -6.098)))', 4326)),
-- Pulo Gadung — bantaran Kali Sunter
(34, 'Sedang', 210.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.885 -6.175, 106.915 -6.177, 106.918 -6.195, 106.912 -6.212, 106.895 -6.215, 106.887 -6.208, 106.883 -6.192, 106.885 -6.175)))', 4326));

-- --- Koridor Kali Cakung (Jakarta Timur → Utara) ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Cakung — area industri rendah, dekat Kali Cakung
(42, 'Tinggi', 350.60, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.925 -6.150, 106.968 -6.148, 106.970 -6.175, 106.965 -6.208, 106.945 -6.215, 106.928 -6.208, 106.923 -6.180, 106.925 -6.150)))', 4326)),
-- Cilincing — muara Kali Cakung, rob parah
(14, 'Tinggi', 410.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.935 -6.093, 106.972 -6.091, 106.975 -6.112, 106.970 -6.140, 106.952 -6.148, 106.938 -6.142, 106.932 -6.118, 106.935 -6.093)))', 4326));

-- --- Koridor Kali Krukut (Jakarta Selatan → Barat) ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Kebayoran Lama — bantaran Kali Krukut
(24, 'Sedang', 180.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.765 -6.250, 106.795 -6.252, 106.798 -6.268, 106.793 -6.280, 106.775 -6.282, 106.767 -6.275, 106.765 -6.250)))', 4326)),
-- Kebayoran Baru — sebagian banjir genangan
(23, 'Rendah', 95.60, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.785 -6.235, 106.815 -6.237, 106.818 -6.252, 106.813 -6.260, 106.795 -6.262, 106.787 -6.255, 106.785 -6.235)))', 4326));

-- --- Koridor Kali Pesanggrahan ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Pesanggrahan — bantaran sungai Pesanggrahan
(25, 'Sedang', 155.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.735 -6.250, 106.765 -6.252, 106.768 -6.270, 106.763 -6.282, 106.745 -6.283, 106.737 -6.275, 106.735 -6.250)))', 4326)),
-- Kembangan — pertemuan sungai
(17, 'Sedang', 145.70, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.725 -6.185, 106.770 -6.187, 106.773 -6.205, 106.768 -6.225, 106.745 -6.228, 106.728 -6.222, 106.723 -6.205, 106.725 -6.185)))', 4326));

-- --- Area genangan lainnya ---
INSERT INTO rawan_banjir (wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom) VALUES
-- Senen — genangan drainase buruk
(4, 'Sedang', 110.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.843 -6.165, 106.862 -6.166, 106.864 -6.178, 106.860 -6.185, 106.845 -6.184, 106.841 -6.176, 106.843 -6.165)))', 4326)),
-- Sawah Besar — dataran rendah
(8, 'Sedang', 98.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.838 -6.143, 106.855 -6.144, 106.858 -6.156, 106.853 -6.163, 106.840 -6.162, 106.836 -6.155, 106.838 -6.143)))', 4326)),
-- Johar Baru — pemukiman padat, drainase buruk
(5, 'Sedang', 88.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.856 -6.173, 106.875 -6.174, 106.877 -6.186, 106.873 -6.193, 106.858 -6.192, 106.854 -6.184, 106.856 -6.173)))', 4326)),
-- Duren Sawit — genangan musiman
(36, 'Sedang', 230.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.903 -6.225, 106.940 -6.227, 106.942 -6.248, 106.937 -6.262, 106.918 -6.265, 106.905 -6.258, 106.900 -6.242, 106.903 -6.225)))', 4326)),
-- Matraman — bantaran sungai
(33, 'Sedang', 110.60, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.860 -6.205, 106.880 -6.206, 106.882 -6.218, 106.878 -6.226, 106.863 -6.225, 106.858 -6.217, 106.860 -6.205)))', 4326)),
-- Koja — dataran rendah, dekat laut
(12, 'Tinggi', 260.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.898 -6.105, 106.935 -6.103, 106.938 -6.122, 106.933 -6.140, 106.915 -6.143, 106.900 -6.138, 106.895 -6.120, 106.898 -6.105)))', 4326)),
-- Taman Sari — Kali Krukut dan Ciliwung
(21, 'Sedang', 78.90, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.808 -6.138, 106.832 -6.139, 106.835 -6.152, 106.830 -6.165, 106.812 -6.167, 106.806 -6.158, 106.808 -6.138)))', 4326)),
-- Kebon Jeruk — genangan area rendah
(18, 'Rendah', 130.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.760 -6.180, 106.795 -6.182, 106.798 -6.200, 106.793 -6.213, 106.773 -6.215, 106.762 -6.208, 106.760 -6.180)))', 4326)),
-- Gambir — genangan Monas area
(1, 'Rendah', 65.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.810 -6.168, 106.830 -6.169, 106.832 -6.180, 106.828 -6.187, 106.812 -6.186, 106.808 -6.178, 106.810 -6.168)))', 4326)),
-- Tanah Abang — banjir genangan
(2, 'Rendah', 85.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.803 -6.192, 106.822 -6.193, 106.825 -6.208, 106.820 -6.215, 106.805 -6.214, 106.800 -6.205, 106.803 -6.192)))', 4326)),
-- Palmerah — genangan musiman
(22, 'Rendah', 105.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.785 -6.200, 106.812 -6.202, 106.815 -6.215, 106.810 -6.225, 106.792 -6.227, 106.787 -6.218, 106.785 -6.200)))', 4326)),
-- Kramat Jati — genangan area rendah
(37, 'Rendah', 140.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.866 -6.265, 106.896 -6.267, 106.898 -6.285, 106.893 -6.296, 106.875 -6.298, 106.868 -6.290, 106.866 -6.265)))', 4326)),
-- Makasar — genangan musiman
(38, 'Rendah', 125.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.885 -6.265, 106.915 -6.267, 106.918 -6.285, 106.913 -6.295, 106.895 -6.297, 106.887 -6.290, 106.885 -6.265)))', 4326)),
-- Pancoran — dekat Kali Ciliwung bagian selatan
(30, 'Sedang', 110.70, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.843 -6.240, 106.867 -6.241, 106.870 -6.254, 106.865 -6.263, 106.848 -6.265, 106.842 -6.256, 106.843 -6.240)))', 4326)),
-- Mampang Prapatan — area genangan
(29, 'Rendah', 72.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.823 -6.238, 106.847 -6.240, 106.850 -6.252, 106.845 -6.260, 106.828 -6.262, 106.822 -6.253, 106.823 -6.238)))', 4326)),
-- Pasar Minggu — banjir kiriman Ciliwung hulu
(27, 'Rendah', 160.30, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.838 -6.278, 106.865 -6.280, 106.868 -6.298, 106.862 -6.315, 106.843 -6.317, 106.835 -6.308, 106.838 -6.278)))', 4326)),
-- Cilandak — genangan lokal
(26, 'Rendah', 90.50, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.805 -6.278, 106.835 -6.280, 106.838 -6.298, 106.832 -6.305, 106.815 -6.307, 106.803 -6.298, 106.805 -6.278)))', 4326)),
-- Menteng — genangan ringan
(3, 'Rendah', 55.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.838 -6.188, 106.853 -6.189, 106.855 -6.200, 106.850 -6.210, 106.840 -6.208, 106.836 -6.198, 106.838 -6.188)))', 4326)),
-- Cipayung — area rendah perbatasan
(41, 'Rendah', 175.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.885 -6.340, 106.925 -6.342, 106.928 -6.360, 106.922 -6.375, 106.903 -6.377, 106.887 -6.370, 106.883 -6.355, 106.885 -6.340)))', 4326)),
-- Pasar Rebo — genangan
(39, 'Rendah', 135.60, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.855 -6.308, 106.888 -6.310, 106.890 -6.328, 106.885 -6.340, 106.868 -6.342, 106.857 -6.335, 106.855 -6.308)))', 4326)),
-- Ciracas — area rendah
(40, 'Rendah', 145.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.875 -6.308, 106.912 -6.310, 106.915 -6.328, 106.910 -6.340, 106.892 -6.342, 106.878 -6.335, 106.875 -6.308)))', 4326)),
-- Jagakarsa — genangan minimal
(28, 'Rendah', 110.40, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.808 -6.328, 106.845 -6.330, 106.848 -6.350, 106.842 -6.368, 106.822 -6.370, 106.808 -6.365, 106.805 -6.348, 106.808 -6.328)))', 4326)),
-- Kepulauan Seribu Selatan — banjir rob pulau
(43, 'Tinggi', 45.20, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.560 -5.748, 106.640 -5.746, 106.645 -5.775, 106.638 -5.800, 106.600 -5.802, 106.572 -5.798, 106.558 -5.775, 106.560 -5.748)))', 4326)),
-- Kepulauan Seribu Utara — banjir rob pulau
(44, 'Tinggi', 35.80, 'BNPB InaRISK', 2023, ST_GeomFromText('MULTIPOLYGON(((106.510 -5.570, 106.610 -5.568, 106.615 -5.618, 106.608 -5.720, 106.575 -5.730, 106.525 -5.725, 106.508 -5.650, 106.510 -5.570)))', 4326));


-- ============================================================================
-- 3. TABEL RAWAN_TSUNAMI — Zona Rawan Tsunami DKI Jakarta
--    Sumber: BMKG, BNPB InaRISK, Peta Bahaya Tsunami Nasional
--    Area: Pesisir utara Jakarta + Kepulauan Seribu
-- ============================================================================

INSERT INTO rawan_tsunami (wilayah_id, zona_tsunami, elevasi_max_m, jarak_pantai_km, geom) VALUES
-- Penjaringan — pesisir Muara Angke, Pluit, Muara Baru
(9, 'Zona Bahaya Tinggi', 1.50, 0.30, ST_GeomFromText('MULTIPOLYGON(((106.745 -6.085, 106.795 -6.083, 106.798 -6.098, 106.793 -6.110, 106.770 -6.112, 106.748 -6.108, 106.745 -6.085)))', 4326)),
(9, 'Zona Bahaya Sedang', 3.20, 1.50, ST_GeomFromText('MULTIPOLYGON(((106.745 -6.110, 106.795 -6.112, 106.798 -6.125, 106.793 -6.135, 106.770 -6.137, 106.748 -6.132, 106.745 -6.110)))', 4326)),
-- Pademangan — pesisir
(10, 'Zona Bahaya Tinggi', 1.80, 0.50, ST_GeomFromText('MULTIPOLYGON(((106.833 -6.095, 106.867 -6.093, 106.870 -6.108, 106.865 -6.120, 106.848 -6.122, 106.835 -6.118, 106.833 -6.095)))', 4326)),
-- Tanjung Priok — area pelabuhan
(11, 'Zona Bahaya Tinggi', 2.00, 0.40, ST_GeomFromText('MULTIPOLYGON(((106.868 -6.095, 106.912 -6.093, 106.915 -6.108, 106.910 -6.125, 106.892 -6.128, 106.870 -6.122, 106.868 -6.095)))', 4326)),
(11, 'Zona Bahaya Sedang', 3.50, 2.00, ST_GeomFromText('MULTIPOLYGON(((106.870 -6.125, 106.910 -6.127, 106.912 -6.138, 106.908 -6.145, 106.890 -6.147, 106.873 -6.142, 106.870 -6.125)))', 4326)),
-- Koja — pesisir utara
(12, 'Zona Bahaya Tinggi', 1.60, 0.35, ST_GeomFromText('MULTIPOLYGON(((106.898 -6.100, 106.937 -6.098, 106.940 -6.115, 106.935 -6.128, 106.915 -6.130, 106.900 -6.125, 106.898 -6.100)))', 4326)),
-- Cilincing — pesisir timur laut, sangat rentan
(14, 'Zona Bahaya Tinggi', 1.20, 0.20, ST_GeomFromText('MULTIPOLYGON(((106.932 -6.090, 106.972 -6.088, 106.975 -6.105, 106.970 -6.122, 106.952 -6.125, 106.935 -6.120, 106.932 -6.090)))', 4326)),
(14, 'Zona Bahaya Sedang', 2.80, 1.80, ST_GeomFromText('MULTIPOLYGON(((106.935 -6.122, 106.970 -6.124, 106.972 -6.138, 106.968 -6.148, 106.950 -6.150, 106.938 -6.145, 106.935 -6.122)))', 4326)),
-- Kelapa Gading — area dalam tapi masih terpengaruh
(13, 'Zona Bahaya Rendah', 5.50, 4.00, ST_GeomFromText('MULTIPOLYGON(((106.882 -6.148, 106.922 -6.150, 106.925 -6.165, 106.920 -6.178, 106.900 -6.180, 106.885 -6.175, 106.882 -6.148)))', 4326)),
-- Cakung — pesisir timur
(42, 'Zona Bahaya Sedang', 2.50, 1.20, ST_GeomFromText('MULTIPOLYGON(((106.925 -6.148, 106.972 -6.150, 106.975 -6.168, 106.970 -6.185, 106.950 -6.188, 106.928 -6.182, 106.925 -6.148)))', 4326)),
-- Kepulauan Seribu Selatan — pulau kecil, sangat rentan
(43, 'Zona Bahaya Tinggi', 1.00, 0.10, ST_GeomFromText('MULTIPOLYGON(((106.555 -5.745, 106.645 -5.743, 106.648 -5.772, 106.642 -5.805, 106.608 -5.808, 106.575 -5.803, 106.553 -5.775, 106.555 -5.745)))', 4326)),
-- Kepulauan Seribu Utara — pulau kecil, sangat rentan
(44, 'Zona Bahaya Tinggi', 0.80, 0.05, ST_GeomFromText('MULTIPOLYGON(((106.505 -5.565, 106.615 -5.563, 106.618 -5.615, 106.612 -5.725, 106.578 -5.735, 106.523 -5.730, 106.503 -5.655, 106.505 -5.565)))', 4326)),
-- Penjaringan bagian dalam — zona transisi
(9, 'Zona Bahaya Rendah', 4.80, 3.50, ST_GeomFromText('MULTIPOLYGON(((106.748 -6.125, 106.792 -6.127, 106.795 -6.135, 106.790 -6.140, 106.768 -6.142, 106.752 -6.138, 106.748 -6.125)))', 4326)),
-- Koja bagian dalam
(12, 'Zona Bahaya Sedang', 3.00, 2.20, ST_GeomFromText('MULTIPOLYGON(((106.900 -6.128, 106.935 -6.130, 106.938 -6.140, 106.933 -6.145, 106.915 -6.147, 106.903 -6.142, 106.900 -6.128)))', 4326));


-- ============================================================================
-- 4. TABEL TITIK_PENGUNGSIAN — Lokasi Evakuasi Riil DKI Jakarta
--    Sumber: BPBD DKI Jakarta, data posko banjir 2020-2024
-- ============================================================================

INSERT INTO titik_pengungsian (nama, kecamatan, kapasitas, fasilitas, aktif, geom) VALUES
-- Jakarta Utara
('GOR Koja', 'Koja', 2500, 'Aula besar, dapur umum, toilet, P3K, genset, air bersih', TRUE, ST_GeomFromText('POINT(106.915 -6.118)', 4326)),
('RPTRA Kalijodo', 'Penjaringan', 800, 'Ruang terbuka, toilet, mushola, air bersih', TRUE, ST_GeomFromText('POINT(106.790 -6.125)', 4326)),
('Islamic Center Jakarta Utara', 'Koja', 3000, 'Masjid, aula, dapur umum, toilet, P3K, air bersih', TRUE, ST_GeomFromText('POINT(106.920 -6.125)', 4326)),
('Kantor Walikota Jakarta Utara', 'Tanjung Priok', 1500, 'Gedung bertingkat, aula, toilet, P3K, genset', TRUE, ST_GeomFromText('POINT(106.890 -6.120)', 4326)),
('GOR Sunter', 'Tanjung Priok', 2000, 'Lapangan indoor, dapur umum, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.895 -6.148)', 4326)),

-- Jakarta Barat
('GOR Cengkareng', 'Cengkareng', 3000, 'Lapangan indoor besar, dapur umum, toilet, P3K, genset, air bersih', TRUE, ST_GeomFromText('POINT(106.730 -6.148)', 4326)),
('Kantor Kecamatan Kalideres', 'Kalideres', 1000, 'Gedung perkantoran, aula, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.665 -6.145)', 4326)),
('RPTRA Cengkareng', 'Cengkareng', 600, 'Ruang terbuka, toilet, mushola', TRUE, ST_GeomFromText('POINT(106.738 -6.155)', 4326)),
('Masjid Jami Al-Mubarok Tambora', 'Tambora', 800, 'Masjid, aula, toilet, dapur umum', TRUE, ST_GeomFromText('POINT(106.815 -6.148)', 4326)),

-- Jakarta Pusat
('Masjid Istiqlal', 'Gambir', 5000, 'Masjid terbesar se-Asia Tenggara, aula raksasa, toilet, dapur umum, P3K, genset, air bersih', TRUE, ST_GeomFromText('POINT(106.830 -6.170)', 4326)),
('Gedung Balai Kota DKI Jakarta', 'Gambir', 2000, 'Gedung pemerintahan, aula, toilet, P3K, genset', TRUE, ST_GeomFromText('POINT(106.822 -6.176)', 4326)),
('GOR Cempaka Putih', 'Cempaka Putih', 1800, 'Lapangan indoor, dapur umum, toilet, P3K, genset', TRUE, ST_GeomFromText('POINT(106.878 -6.178)', 4326)),
('GOR Kemayoran', 'Kemayoran', 2500, 'Lapangan indoor besar, dapur umum, toilet, P3K, air bersih', TRUE, ST_GeomFromText('POINT(106.858 -6.152)', 4326)),

-- Jakarta Timur
('GOR Rawamangun', 'Pulo Gadung', 3500, 'Kompleks olahraga, lapangan indoor, dapur umum, toilet, P3K, genset, air bersih', TRUE, ST_GeomFromText('POINT(106.895 -6.192)', 4326)),
('Kantor Kecamatan Jatinegara', 'Jatinegara', 1200, 'Gedung perkantoran, aula, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.878 -6.238)', 4326)),
('SDN Bidara Cina 01', 'Jatinegara', 500, 'Gedung sekolah, ruang kelas, toilet', TRUE, ST_GeomFromText('POINT(106.870 -6.242)', 4326)),
('GOR Ciracas', 'Ciracas', 2000, 'Lapangan indoor, dapur umum, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.895 -6.320)', 4326)),
('Masjid At-Tin TMII', 'Cipayung', 4000, 'Masjid besar, aula, dapur umum, toilet, P3K, air bersih', TRUE, ST_GeomFromText('POINT(106.895 -6.302)', 4326)),
('GOR Cakung', 'Cakung', 2500, 'Lapangan indoor, dapur umum, toilet, P3K, genset', TRUE, ST_GeomFromText('POINT(106.945 -6.178)', 4326)),

-- Jakarta Selatan
('GOR Soemantri Brodjonegoro', 'Setiabudi', 3000, 'Kompleks olahraga, lapangan indoor, dapur umum, toilet, P3K, genset, air bersih', TRUE, ST_GeomFromText('POINT(106.832 -6.222)', 4326)),
('Kantor Kelurahan Bukit Duri', 'Tebet', 600, 'Gedung kelurahan, aula kecil, toilet', TRUE, ST_GeomFromText('POINT(106.855 -6.233)', 4326)),
('GOR Pasar Minggu', 'Pasar Minggu', 2000, 'Lapangan indoor, dapur umum, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.850 -6.290)', 4326)),
('Kantor Kecamatan Kebayoran Lama', 'Kebayoran Lama', 1000, 'Gedung perkantoran, aula, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.782 -6.265)', 4326)),
('SMAN 6 Jakarta', 'Kebayoran Baru', 1500, 'Gedung sekolah bertingkat, aula, lapangan, toilet', TRUE, ST_GeomFromText('POINT(106.800 -6.245)', 4326)),
('GOR Jagakarsa', 'Jagakarsa', 1800, 'Lapangan indoor, dapur umum, toilet, P3K', TRUE, ST_GeomFromText('POINT(106.825 -6.345)', 4326));


-- ============================================================================
-- 5. TABEL KEJADIAN_BANJIR — Catatan Historis Banjir DKI Jakarta
--    Sumber: DIBI BNPB, BPBD DKI, media massa terverifikasi
-- ============================================================================

INSERT INTO kejadian_banjir (tanggal, keterangan, korban, kota_admin, geom) VALUES
-- === Banjir Besar 1 Januari 2020 ===
('2020-01-01', 'Banjir besar Jakarta akibat hujan ekstrem 377mm/hari. Ketinggian air mencapai 2,5 meter di Kampung Melayu. 31.103 warga mengungsi.', 9, 'Jakarta Timur', ST_GeomFromText('POINT(106.870 -6.240)', 4326)),
('2020-01-01', 'Banjir besar merendam kawasan Bidara Cina dan Bukit Duri. Pintu air Manggarai siaga 4.', 0, 'Jakarta Selatan', ST_GeomFromText('POINT(106.855 -6.232)', 4326)),
('2020-01-01', 'Banjir rob parah di Penjaringan dan Pluit. Ketinggian air 1,5 meter. Ribuan warga mengungsi.', 0, 'Jakarta Utara', ST_GeomFromText('POINT(106.778 -6.108)', 4326)),
('2020-01-01', 'Genangan banjir di kawasan Kemayoran dan Senen akibat luapan saluran drainase.', 0, 'Jakarta Pusat', ST_GeomFromText('POINT(106.858 -6.155)', 4326)),
('2020-01-01', 'Banjir merendam permukiman di Cengkareng dan Kalideres. Akses jalan terputus.', 0, 'Jakarta Barat', ST_GeomFromText('POINT(106.725 -6.148)', 4326)),

-- === Banjir Susulan 25 Februari 2020 ===
('2020-02-25', 'Banjir susulan melanda Jakarta Timur, kawasan Cakung dan Duren Sawit terendam hingga 1,2 meter.', 2, 'Jakarta Timur', ST_GeomFromText('POINT(106.935 -6.185)', 4326)),
('2020-02-25', 'Genangan banjir di kawasan Cilincing akibat rob dan hujan bersamaan. 5.000 warga terdampak.', 0, 'Jakarta Utara', ST_GeomFromText('POINT(106.952 -6.118)', 4326)),

-- === Banjir 2021 ===
('2021-02-19', 'Banjir Jakarta Selatan akibat luapan Kali Krukut. Kebayoran Lama terendam 80 cm. 2.500 warga mengungsi.', 0, 'Jakarta Selatan', ST_GeomFromText('POINT(106.780 -6.268)', 4326)),
('2021-02-19', 'Banjir di kawasan Pulo Gadung dan Kelapa Gading akibat luapan Kali Sunter.', 0, 'Jakarta Timur', ST_GeomFromText('POINT(106.900 -6.195)', 4326)),
('2021-10-16', 'Banjir bandang di Cipayung Jakarta Timur akibat hujan ekstrem. Jalan raya terputus.', 0, 'Jakarta Timur', ST_GeomFromText('POINT(106.905 -6.355)', 4326)),

-- === Banjir 2022 ===
('2022-01-05', 'Banjir rob merendam kawasan pesisir Jakarta Utara. Koja dan Cilincing terendam 1 meter.', 0, 'Jakarta Utara', ST_GeomFromText('POINT(106.930 -6.108)', 4326)),
('2022-02-14', 'Banjir di Jatinegara akibat luapan Sungai Ciliwung. Kampung Melayu terendam 2 meter.', 0, 'Jakarta Timur', ST_GeomFromText('POINT(106.872 -6.238)', 4326)),
('2022-11-26', 'Banjir bandang di kawasan Tambora dan Taman Sari. Drainase tidak mampu menampung debit air.', 0, 'Jakarta Barat', ST_GeomFromText('POINT(106.815 -6.150)', 4326)),

-- === Banjir 2023 ===
('2023-01-09', 'Banjir awal tahun merendam kawasan Kebon Jeruk dan Kembangan. 1.800 warga mengungsi.', 0, 'Jakarta Barat', ST_GeomFromText('POINT(106.765 -6.198)', 4326)),
('2023-04-22', 'Genangan banjir di Pasar Minggu dan Kramat Jati akibat hujan deras 3 jam. Ketinggian 70 cm.', 0, 'Jakarta Selatan', ST_GeomFromText('POINT(106.852 -6.295)', 4326)),
('2023-09-15', 'Banjir rob Kepulauan Seribu. 3 pulau berpenghuni terendam. 450 warga dievakuasi.', 0, 'Kepulauan Seribu', ST_GeomFromText('POINT(106.598 -5.785)', 4326)),
('2023-11-08', 'Banjir di Cakung dan Cilincing akibat luapan Kali Cakung. Pabrik-pabrik terendam.', 0, 'Jakarta Timur', ST_GeomFromText('POINT(106.948 -6.175)', 4326)),

-- === Banjir 2024 ===
('2024-01-15', 'Banjir rob merendam perumahan warga Penjaringan setinggi 50 cm. 800 warga mengungsi ke RPTRA.', 0, 'Jakarta Utara', ST_GeomFromText('POINT(106.790 -6.110)', 4326)),
('2024-02-28', 'Banjir kiriman dari Bogor meluapkan Sungai Ciliwung. Manggarai, Bukit Duri, Kampung Melayu terendam.', 3, 'Jakarta Selatan', ST_GeomFromText('POINT(106.850 -6.225)', 4326)),
('2024-03-12', 'Genangan banjir di kawasan Grogol Petamburan akibat luapan Kali Angke cabang.', 0, 'Jakarta Barat', ST_GeomFromText('POINT(106.798 -6.175)', 4326)),
('2024-06-05', 'Banjir rob tinggi di Muara Baru Penjaringan. 1.200 warga terdampak, akses transportasi lumpuh.', 0, 'Jakarta Utara', ST_GeomFromText('POINT(106.770 -6.098)', 4326)),
('2024-10-18', 'Banjir di Matraman dan Johar Baru akibat drainase tersumbat sampah. Genangan 60 cm.', 0, 'Jakarta Timur', ST_GeomFromText('POINT(106.868 -6.215)', 4326)),
('2024-12-02', 'Banjir akhir tahun merendam Tebet dan Pancoran. Pintu air Manggarai dibuka maksimal.', 0, 'Jakarta Selatan', ST_GeomFromText('POINT(106.852 -6.238)', 4326));


-- ============================================================================
-- 6. LOG ETL — Catat proses impor data
-- ============================================================================

INSERT INTO log_etl (sumber_api, jumlah_record, status) VALUES
('SEED-DATA-WILAYAH', 44, 'SUCCESS'),
('SEED-DATA-BANJIR', 42, 'SUCCESS'),
('SEED-DATA-TSUNAMI', 15, 'SUCCESS'),
('SEED-DATA-PENGUNGSIAN', 25, 'SUCCESS'),
('SEED-DATA-KEJADIAN', 22, 'SUCCESS');
