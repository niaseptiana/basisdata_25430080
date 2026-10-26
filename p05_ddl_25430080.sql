-- =============================================================================
-- Skrip DDL Modul 5: Membangun Struktur dengan DDL dan Constraint
-- Berkas: p05_ddl_25430080.sql
-- Nama  : Nia Septiana
-- NIM   : 25430080
-- Basis Data: akad_080
-- Tema  : Akademik Cendekia NS (SIAKAD)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS akad_080
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE akad_080;

-- Hapus tabel dengan urutan terbalik dari dependensi kunci tamu (anak ke induk)
DROP TABLE IF EXISTS detail_krs;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS mahasiswa;
DROP TABLE IF EXISTS dosen;

-- =============================================================================
-- 1. TABEL MASTER
-- =============================================================================

-- Tabel 1: dosen
CREATE TABLE dosen (
    nidn_dosen CHAR(10) NOT NULL,
    nama_dosen VARCHAR(100) NOT NULL,
    PRIMARY KEY (nidn_dosen),
    CONSTRAINT uq_dosen_nidn UNIQUE (nidn_dosen)
) ENGINE=InnoDB;

-- Tabel 2: mahasiswa (Memuat rujukan ke dosen wali dan data pribadi no_hp_mahasiswa)
CREATE TABLE mahasiswa (
    nim_mahasiswa CHAR(8) NOT NULL,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    program_studi_mahasiswa VARCHAR(60) NOT NULL,
    angkatan_mahasiswa SMALLINT NOT NULL,
    status_mahasiswa ENUM('Aktif','Cuti','Lulus') NOT NULL DEFAULT 'Aktif', -- AB-03[cite: 157]
    no_hp_mahasiswa VARCHAR(15) NULL, -- Data Pribadi (PDP)[cite: 157]
    nidn_dosen_wali CHAR(10) NOT NULL,
    PRIMARY KEY (nim_mahasiswa),
    CONSTRAINT uq_mahasiswa_nim UNIQUE (nim_mahasiswa), -- AB-01[cite: 157]
    CONSTRAINT fk_mahasiswa_dosen_wali FOREIGN KEY (nidn_dosen_wali) 
        REFERENCES dosen (nidn_dosen)
) ENGINE=InnoDB;

-- Tabel 3: mata_kuliah (Katalog)
CREATE TABLE mata_kuliah (
    kode_mk CHAR(10) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks_mk TINYINT NOT NULL,
    PRIMARY KEY (kode_mk),
    CONSTRAINT uq_mata_kuliah_kode UNIQUE (kode_mk), -- AB-02[cite: 157]
    CONSTRAINT ck_mata_kuliah_sks CHECK (sks_mk >= 1 AND sks_mk <= 6)
) ENGINE=InnoDB;

-- =============================================================================
-- 2. TABEL TRANSAKSI & PENDUKUNG KELAS
-- =============================================================================

-- Tabel 4: kelas (Dibuka per semester dengan dosen pengampu)
CREATE TABLE kelas (
    kode_kelas VARCHAR(20) NOT NULL,
    kode_mk CHAR(10) NOT NULL,
    kode_semester CHAR(5) NOT NULL, -- AB-02[cite: 157]
    nidn_dosen_pengampu CHAR(10) NOT NULL,
    kuota_kelas SMALLINT NOT NULL, -- AB-04[cite: 157]
    hari_kelas ENUM('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu') NOT NULL,
    jam_mulai_kelas TIME NOT NULL,
    jam_selesai_kelas TIME NOT NULL,
    ruang_kelas VARCHAR(20) NOT NULL,
    PRIMARY KEY (kode_kelas),
    CONSTRAINT uq_kelas_kode UNIQUE (kode_kelas),
    CONSTRAINT fk_kelas_mata_kuliah FOREIGN KEY (kode_mk) 
        REFERENCES mata_kuliah (kode_mk),
    CONSTRAINT fk_kelas_dosen_pengampu FOREIGN KEY (nidn_dosen_pengampu) 
        REFERENCES dosen (nidn_dosen),
    CONSTRAINT ck_kelas_kuota CHECK (kuota_kelas > 0),
    CONSTRAINT ck_kelas_jam CHECK (jam_mulai_kelas < jam_selesai_kelas)
) ENGINE=InnoDB;

-- Tabel 5: krs (Kepala KRS mahasiswa per semester)
CREATE TABLE krs (
    no_krs VARCHAR(20) NOT NULL,
    nim_mahasiswa CHAR(8) NOT NULL,
    kode_semester CHAR(5) NOT NULL, -- AB-03[cite: 157]
    nidn_dosen_wali CHAR(10) NOT NULL,
    tanggal_krs DATE NOT NULL,
    tanggal_batas_krs DATE NOT NULL,
    status_krs ENUM('Diajukan','Disetujui','Ditolak') NOT NULL DEFAULT 'Diajukan', -- AB-05[cite: 157]
    PRIMARY KEY (no_krs),
    CONSTRAINT uq_krs_no UNIQUE (no_krs),
    CONSTRAINT uq_krs_mhs_semester UNIQUE (nim_mahasiswa, kode_semester), -- AB-03: Satu KRS per semester[cite: 157]
    CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (nim_mahasiswa) 
        REFERENCES mahasiswa (nim_mahasiswa),
    CONSTRAINT fk_krs_dosen_wali FOREIGN KEY (nidn_dosen_wali) 
        REFERENCES dosen (nidn_dosen)
) ENGINE=InnoDB;

-- Tabel 6: detail_krs (Detail baris kelas pada KRS dengan pembatasan parameter P+2 = 11)
CREATE TABLE detail_krs (
    no_krs VARCHAR(20) NOT NULL,
    kode_kelas VARCHAR(20) NOT NULL,
    sks_detail_krs TINYINT NOT NULL, -- AB-07[cite: 157]
    nilai_angka_detail_krs DECIMAL(5,2) NULL, -- AB-08[cite: 157]
    PRIMARY KEY (no_krs, kode_kelas),
    CONSTRAINT fk_detail_krs_krs FOREIGN KEY (no_krs) 
        REFERENCES krs (no_krs) ON DELETE CASCADE,
    CONSTRAINT fk_detail_krs_kelas FOREIGN KEY (kode_kelas) 
        REFERENCES kelas (kode_kelas),
    CONSTRAINT ck_detail_sks CHECK (sks_detail_krs >= 1 AND sks_detail_krs <= 6),
    CONSTRAINT ck_detail_nilai CHECK (nilai_angka_detail_krs IS NULL OR (nilai_angka_detail_krs >= 0.00 AND nilai_angka_detail_krs <= 100.00))
) ENGINE=InnoDB;