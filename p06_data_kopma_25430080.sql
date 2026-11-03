-- =============================================================================
-- Skrip DML Modul 6: Mengisi, Mengubah, dan Menguji Data (Kopma)
-- Berkas: p06_data_kopma_25430080.sql
-- Nama  : Nia Septiana
-- NIM   : 25430080
-- Basis Data: kopma_080
-- =============================================================================

USE kopma_080;

-- Aktifkan mode aman UPDATE/DELETE
SET SESSION sql_safe_updates = 1;

-- 1. Mengisi Data Induk (Master)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
('K01', 'Rina Kasir', 'kasir'),
('K02', 'Sari Kasir', 'kasir'),
('G01', 'Joko Gudang', 'gudang'),
('C01', 'Ketua Kopma', 'ketua');

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
('A-0001', '2543000101', 'Budi Santoso', 'Ilmu Komputer', '081234567801', 'aktif', '2026-01-10'),
('A-0002', '2543000102', 'Ani Lestari', 'Sistem Informasi', '081234567802', 'aktif', '2026-01-15'),
('A-0003', '2543000103', 'Dedi Pratama', 'Teknik Informatika', NULL, 'nonaktif', '2026-02-01');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000.00, 120, 20),
('ATK-002', 'Buku Tulis 58', 'ATK', 6500.00, 80, 20),
('MNM-001', 'Air Mineral 600', 'minuman', 4000.00, 50, 10),
('MKN-001', 'Roti Cokelat', 'makanan', 5000.00, 15, 10);

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
('CV Sumber ATK', '0725111222', 'Jl. Jend. Sudirman No. 10'),
('UD Segar Makmur', '0725333444', 'Jl. Ahmad Yani No. 5');

-- 2. Mengisi Data Transaksi Penjualan (Contoh Nota)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan, potongan_poin_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00', 1, 1, 30000.00, 0.00);

-- Mengisi Detail Penjualan dengan INSERT SELECT
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-001';

-- Mengurangi Stok Barang Sesuai Penjualan
UPDATE barang SET stok_barang = stok_barang - 3 
WHERE kode_barang = 'ATK-001' AND id_barang > 0;