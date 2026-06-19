-- SIGANA Database Schema
-- Requires PostgreSQL 15+ and PostGIS 3.4+

CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Tabel wilayah (Administrasi)
-- Functional Dependency: id -> nama_kelurahan, nama_kecamatan, kota_admin, populasi, geom
CREATE TABLE wilayah (
    id SERIAL PRIMARY KEY,
    nama_kelurahan VARCHAR(100) NOT NULL,
    nama_kecamatan VARCHAR(100) NOT NULL,
    kota_admin VARCHAR(100) NOT NULL,
    populasi INTEGER NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

CREATE INDEX idx_wilayah_geom ON wilayah USING GIST (geom);

-- 2. Tabel rawan_banjir
-- Functional Dependency: id -> wilayah_id, tingkat_risiko, luas_ha, sumber, tahun, geom
-- Transitive Dependency: wilayah_id -> nama_kelurahan, kota_admin (resolved via JOIN to wilayah)
CREATE TABLE rawan_banjir (
    id SERIAL PRIMARY KEY,
    wilayah_id INTEGER NOT NULL REFERENCES wilayah(id) ON DELETE CASCADE,
    tingkat_risiko VARCHAR(50) NOT NULL, -- 'Rendah', 'Sedang', 'Tinggi'
    luas_ha NUMERIC(10, 2) NOT NULL,
    sumber VARCHAR(100) NOT NULL,
    tahun INTEGER NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

CREATE INDEX idx_rawan_banjir_geom ON rawan_banjir USING GIST (geom);
CREATE INDEX idx_rawan_banjir_wilayah ON rawan_banjir (wilayah_id);

-- 3. Tabel rawan_tsunami
-- Functional Dependency: id -> wilayah_id, zona_tsunami, elevasi_max_m, jarak_pantai_km, geom
CREATE TABLE rawan_tsunami (
    id SERIAL PRIMARY KEY,
    wilayah_id INTEGER NOT NULL REFERENCES wilayah(id) ON DELETE CASCADE,
    zona_tsunami VARCHAR(50) NOT NULL,
    elevasi_max_m NUMERIC(5, 2) NOT NULL,
    jarak_pantai_km NUMERIC(5, 2) NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

CREATE INDEX idx_rawan_tsunami_geom ON rawan_tsunami USING GIST (geom);
CREATE INDEX idx_rawan_tsunami_wilayah ON rawan_tsunami (wilayah_id);

-- 4. Tabel titik_pengungsian
-- Functional Dependency: id -> nama, kecamatan, kapasitas, fasilitas, aktif, geom
CREATE TABLE titik_pengungsian (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kecamatan VARCHAR(100) NOT NULL,
    kapasitas INTEGER NOT NULL,
    fasilitas TEXT NOT NULL, -- 1NF: comma separated or descriptive text, not array
    aktif BOOLEAN DEFAULT TRUE,
    geom geometry(POINT, 4326) NOT NULL
);

CREATE INDEX idx_titik_pengungsian_geom ON titik_pengungsian USING GIST (geom);

-- 5. Tabel kejadian_banjir
-- Functional Dependency: id -> tanggal, keterangan, korban, kota_admin, geom
CREATE TABLE kejadian_banjir (
    id SERIAL PRIMARY KEY,
    tanggal DATE NOT NULL,
    keterangan TEXT NOT NULL,
    korban INTEGER DEFAULT 0,
    kota_admin VARCHAR(100) NOT NULL,
    geom geometry(POINT, 4326) NOT NULL
);

CREATE INDEX idx_kejadian_banjir_geom ON kejadian_banjir USING GIST (geom);

-- 6. Tabel log_etl
-- Non-spatial table for auditing
CREATE TABLE log_etl (
    id SERIAL PRIMARY KEY,
    sumber_api VARCHAR(100) NOT NULL,
    waktu_fetch TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    jumlah_record INTEGER NOT NULL,
    status VARCHAR(50) NOT NULL -- 'SUCCESS', 'FAILED'
);

-- Comments describing Normalization & Functional Dependencies
COMMENT ON TABLE wilayah IS '3NF, BCNF. FD: id -> all attributes.';
COMMENT ON TABLE rawan_banjir IS '3NF, BCNF. FD: id -> all attributes. No transitive dependency to region names.';
COMMENT ON TABLE rawan_tsunami IS '3NF, BCNF. FD: id -> all attributes.';
COMMENT ON TABLE titik_pengungsian IS '3NF. 1NF satisfied by using TEXT for fasilitas instead of array.';
COMMENT ON TABLE kejadian_banjir IS '3NF.';
