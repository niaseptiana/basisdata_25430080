# Normalisasi Proyek SIAKAD - Pertemuan 4

**Nama:** Nia Septiana **NIM:** 25430080
**Organisasi fiktif:** Akademik Cendekia NS **Tema:** Akademik **Basis data:** akad_080

Sumber: dokumen kebutuhan data (P2, P = 9) dan ERD fisik SIAKAD (P3, 6 tabel).

## 1. Dokumen sumber awal

KRS dari P2 bagian 3.1 (contoh: No. KRS-20261-0087, semester 20261). Data kelas (kuota, dosen pengampu) dilengkapi dari jadwal kuliah semester, dokumen yang dirujuk di P2.

## 2. UNF

Satu KRS memuat satu grup berulang: baris kelas yang diambil.

```
KRS_UNF (no_krs, kode_semester, tanggal_krs, tanggal_batas_krs, status_krs,
         nim_mahasiswa, nama_mahasiswa, program_studi_mahasiswa,
         nidn_dosen_wali, nama_dosen_wali,
         { kode_kelas, kode_mk, nama_mk, sks_detail_krs, kuota_kelas, hari_kelas,
           jam_mulai_kelas, jam_selesai_kelas, ruang_kelas,
           nidn_dosen_pengampu, nama_dosen_pengampu,
           nilai_angka_detail_krs, nilai_huruf },
         total_sks, hari_terlambat, denda_krs)
```

## 3. 1NF

Satu baris per kelas per KRS, kunci `(no_krs, kode_kelas)`. Nilai turunan (`nilai_huruf`, `total_sks`, `hari_terlambat`, `denda_krs`) tidak dibawa (lihat bagian 8).

```
KRS_1NF (no_krs, kode_kelas, kode_semester, tanggal_krs, tanggal_batas_krs, status_krs,
         nim_mahasiswa, nama_mahasiswa, program_studi_mahasiswa,
         nidn_dosen_wali, nama_dosen_wali, kode_mk, nama_mk, sks_detail_krs,
         kuota_kelas, hari_kelas, jam_mulai_kelas, jam_selesai_kelas, ruang_kelas,
         nidn_dosen_pengampu, nama_dosen_pengampu, nilai_angka_detail_krs)
```

## 4. Dependensi fungsional

| Kode | Dependensi fungsional | AB |
|---|---|---|
| FD1 | nim_mahasiswa -> nama_mahasiswa, program_studi_mahasiswa, angkatan_mahasiswa, status_mahasiswa, no_hp_mahasiswa, nidn_dosen_wali | AB-01 |
| FD2 | nidn_dosen -> nama_dosen | AB-01 |
| FD3 | kode_mk -> nama_mk, sks_mk | AB-02, AB-07 |
| FD4 | kode_kelas -> kode_mk, kode_semester, nidn_dosen_pengampu, kuota_kelas, hari_kelas, jam_mulai_kelas, jam_selesai_kelas, ruang_kelas | AB-02, AB-04 |
| FD5 | no_krs -> nim_mahasiswa, kode_semester, nidn_dosen_wali, tanggal_krs, tanggal_batas_krs, status_krs | AB-03, AB-05, AB-06 |
| FD6 | (nim_mahasiswa, kode_semester) -> no_krs | AB-03 |
| FD7 | (no_krs, kode_kelas) -> sks_detail_krs, nilai_angka_detail_krs | AB-07, AB-08 |

FD7: `sks_detail_krs` bergantung pada baris KRS, bukan pada `kode_mk`, karena SKS KRS lama tidak boleh berubah mengikuti kurikulum (AB-07). `sks_mk` di FD3 adalah SKS resmi terkini dari katalog.

## 5. 2NF

Pada KRS_1NF, atribut KRS (FD5) hanya bergantung pada `no_krs`, dan atribut kelas (FD4) hanya pada `kode_kelas`. Keduanya bergantung pada sebagian kunci, sehingga dipisah menjadi `krs`, `kelas`, dan `detail_krs` (kunci komposit).

## 6. 3NF

Rantai yang ditemukan dan dipisah:

- no_krs -> nim_mahasiswa -> data mahasiswa menjadi `mahasiswa`.
- no_krs -> nidn_dosen_wali -> nama_dosen_wali, dan kode_kelas -> nidn_dosen_pengampu -> nama_dosen_pengampu menjadi `dosen` (satu relasi untuk kedua peran).
- kode_kelas -> kode_mk -> nama_mk, sks_mk menjadi `mata_kuliah`.

Hasil: `mahasiswa`, `dosen`, `mata_kuliah`, `kelas`, `krs`, `detail_krs`.

Catatan keputusan:

- `nidn_dosen_wali` ada di `mahasiswa` (wali saat ini) dan di `krs` (wali yang menyetujui KRS). Ini bukan redundansi, karena wali bisa berganti dan KRS lama harus tetap menunjuk dosen yang menyetujuinya (P2 bagian 10).
- `tanggal_batas_krs` disimpan per KRS sebagai salinan kalender akademik saat KRS dibuat (P2 bagian 3.2).

## 7. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| mahasiswa | nim_mahasiswa | ya | BCNF |
| dosen | nidn_dosen | ya | BCNF |
| mata_kuliah | kode_mk | ya | BCNF |
| kelas | kode_kelas | ya | BCNF |
| krs | no_krs; (nim_mahasiswa, kode_semester) | ya, keduanya | BCNF |
| detail_krs | (no_krs, kode_kelas) | ya | BCNF |

## 8. Keputusan nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| total_sks | Dihitung | Jumlah `sks_detail_krs` per KRS |
| hari_terlambat | Dihitung | `tanggal_krs` dikurangi `tanggal_batas_krs`, minimal 0 |
| denda_krs | Dihitung | Hari terlambat x Rp9.000 (AB-06); bukan elemen yang berdiri sendiri |
| nilai_huruf, bobot | Dihitung | Diturunkan dari `nilai_angka_detail_krs` menurut skala AB-08; mencegah huruf tidak cocok dengan angka |
| IPS, IPK | Dihitung | Dari `sks_detail_krs` dan bobot nilai (KI-01) |
| sisa kuota kelas | Dihitung | `kuota_kelas` dikurangi jumlah baris `detail_krs` kelas itu (KI-02) |
| sks_detail_krs | **Disimpan** | Potret SKS saat KRS dibuat (AB-07) |
| tanggal_batas_krs | **Disimpan** | Potret kalender akademik saat KRS dibuat |

Risiko: tarif denda (Rp9.000) dan skala nilai tidak disimpan per KRS. Dalam lingkup proyek keduanya tetap, tetapi jika kelak berubah, nilai lama ikut terhitung ulang. Perbaikannya adalah menyimpan potret denda atau nilai huruf.

## 9. Perubahan pada ERD P3

Tidak ada perubahan struktur; ERD fisik sudah sesuai hasil 3NF. Catatan untuk tahap berikutnya:

- AB-04 (kelas bentrok, kuota penuh), batas 11 baris per KRS (AB-03), dan kesamaan semester antara `kelas` dan `krs` tidak dapat dijaga oleh constraint struktur; ditandai untuk diselesaikan di transaksi (Modul 14).
- `kode_kelas` (misalnya SI2301-A-20261) memuat kode mata kuliah dan semester sebagai format penamaan. Konsistensinya dengan kolom `kode_mk` dan `kode_semester` di `kelas` harus dijaga saat pengisian data.

## 10. Skema relasional akhir

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| mahasiswa | nim_mahasiswa | - | nidn_dosen_wali -> dosen |
| dosen | nidn_dosen | - | - |
| mata_kuliah | kode_mk | - | - |
| kelas | kode_kelas | - | kode_mk -> mata_kuliah; nidn_dosen_pengampu -> dosen |
| krs | no_krs | (nim_mahasiswa, kode_semester) | nim_mahasiswa -> mahasiswa; nidn_dosen_wali -> dosen |
| detail_krs | (no_krs, kode_kelas) | - | no_krs -> krs; kode_kelas -> kelas |
