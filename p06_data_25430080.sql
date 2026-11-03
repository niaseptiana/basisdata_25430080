-- =============================================================================
-- Skrip DML Modul 6: Mengisi, Mengubah, dan Menguji Data (SIAKAD)
-- Berkas: p06_data_25430080.sql
-- Nama  : Nia Septiana
-- NIM   : 25430080
-- Basis Data: akad_080
-- =============================================================================

USE akad_080;

-- Aktifkan mode aman UPDATE/DELETE
SET SESSION sql_safe_updates = 1;

-- =============================================================================
-- 1. PENGISIAN DATA MASTER (Dosen, Mahasiswa, Mata Kuliah)
-- =============================================================================

INSERT INTO dosen (nidn_dosen, nama_dosen) VALUES
('0412345678', 'Dr. Contoh Dosen, M.Kom.'),
('0487654321', 'Prof. Budi Raharjo, Ph.D.'),
('0411223344', 'Siti Aminah, M.T.');

INSERT INTO mahasiswa (nim_mahasiswa, nama_mahasiswa, program_studi_mahasiswa, angkatan_mahasiswa, status_mahasiswa, no_hp_mahasiswa, nidn_dosen_wali) VALUES
('25430045', 'Yasmin Fahila', 'Sistem Informasi', 2025, 'Aktif', '081234567890', '0412345678'),
('25430046', 'Ahmad Fauzi', 'Sistem Informasi', 2025, 'Aktif', '081234567891', '0412345678'),
('25430047', 'Dewi Lestari', 'Teknik Informatika', 2025, 'Cuti', NULL, '0487654321');

INSERT INTO mata_kuliah (kode_mk, nama_mk, sks_mk) VALUES
('SI2301', 'Basis Data', 3),
('SI2302', 'Pemrograman Web', 3),
('SI2303', 'Struktur Data', 4);

-- =============================================================================
-- 2. PENGISIAN DATA KELAS & KRS (Transaksi)
-- =============================================================================

INSERT INTO kelas (kode_kelas, kode_mk, kode_semester, nidn_dosen_pengampu, kuota_kelas, hari_kelas, jam_mulai_kelas, jam_selesai_kelas, ruang_kelas) VALUES
('SI2301-A-20261', 'SI2301', '20261', '0411223344', 40, 'Senin', '08:00:00', '10:30:00', 'R-201'),
('SI2302-B-20261', 'SI2302', '20261', '0412345678', 35, 'Selasa', '10:00:00', '12:30:00', 'Lab-1');

-- Kepala KRS Mahasiswa
INSERT INTO krs (no_krs, nim_mahasiswa, kode_semester, nidn_dosen_wali, tanggal_krs, tanggal_batas_krs, status_krs)
VALUES ('KRS-20261-0087', '25430045', '20261', '0412345678', '2026-08-12', '2026-08-10', 'Disetujui');

-- Detail KRS menggunakan INSERT ... SELECT (Mengambil SKS dari katalog mata kuliah)
INSERT INTO detail_krs (no_krs, kode_kelas, sks_detail_krs, nilai_angka_detail_krs)
SELECT 'KRS-20261-0087', k.kode_kelas, mk.sks_mk, 85.00
FROM kelas k
JOIN mata_kuliah mk ON k.kode_mk = mk.kode_mk
WHERE k.kode_kelas = 'SI2301-A-20261';