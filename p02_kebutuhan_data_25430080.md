# Dokumen Kebutuhan Data - Akademik Cendekia NS

## 1. Latar belakang dan aktivitas organisasi

Akademik Cendekia NS adalah unit layanan akademik yang mengelola ±600 mahasiswa aktif dan ±40 dosen. Setiap semester unit ini membuka kelas dari katalog mata kuliah. Mahasiswa mengisi Kartu Rencana Studi (KRS) pada masa registrasi, dosen wali menyetujuinya, dosen pengampu menginput nilai di akhir semester, lalu staf akademik menerbitkan Kartu Hasil Studi (KHS).

Masalah yang mendasari kebutuhan data:
- Kurikulum berubah, sehingga SKS suatu mata kuliah pada KRS lama tidak boleh ikut berubah.
- Satu mata kuliah dibuka dalam beberapa kelas di semester berbeda, jadi mata kuliah dan kelas harus dibedakan.
- Mahasiswa sering mengisi kelas yang bentrok atau yang kuotanya sudah penuh.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mengelola data master (mahasiswa, dosen, mata kuliah) dan status mahasiswa | Staf akademik | Mahasiswa baru diterima, pergantian dosen atau kurikulum, permohonan cuti atau kelulusan |
| PB-02 | Membuka kelas per semester | Staf akademik | Awal persiapan semester |
| PB-03 | Mengisi dan menyetujui KRS | Mahasiswa (mengisi), dosen wali (menyetujui) | Masa registrasi dibuka |
| PB-04 | Menginput nilai dan menyusun KHS | Dosen pengampu (menginput), staf akademik (menyusun KHS) | Akhir semester |

## 3. Dokumen sumber yang dianalisis

### 3.1 KRS (dirancang sendiri)

```
KARTU RENCANA STUDI - AKADEMIK CENDEKIA NS     No. KRS : KRS-20261-0087
Semester : 20261 (Ganjil 2026/2027)            Tgl     : 12-08-2026
NIM      : 25430045                            Nama    : Yasmin Fahila
Prodi    : Sistem Informasi                    Dosen Wali : 0412345678
Batas registrasi : 10-08-2026

No | Kode MK | Nama Mata Kuliah   | Kelas | SKS | Hari/Jam      | Ruang
1  | SI2301  | Basis Data         | A     | 3   | Senin 08.00   | R-201
2  | SI2302  | Pemrograman Web    | B     | 3   | Selasa 10.00  | Lab-1
...
Total SKS : 20 (dihitung)                      Status  : Disetujui
Terlambat : 2 hari  -> Denda Rp18.000
```

### 3.2 Pembedahan KRS

| Isian | Disimpan / Turunan | Entitas |
|---|---|---|
| No. KRS, tanggal, status | Disimpan | KRS |
| Semester | Disimpan sebagai kode semester | Kelas, KRS |
| Batas registrasi | Disimpan sebagai salinan kalender akademik saat KRS dibuat | KRS |
| NIM, nama, prodi | Disimpan di master, dirujuk lewat NIM | Mahasiswa |
| Dosen wali | Disimpan (rujukan NIDN) pada KRS sebagai dosen yang menyetujui | KRS, Dosen |
| Kode MK, nama MK | Disimpan di master, dirujuk lewat kode | Mata Kuliah |
| Kelas, hari/jam, ruang | Disimpan | Kelas |
| SKS per baris | Disimpan sebagai snapshot saat KRS dibuat | Detail KRS |
| Total SKS | Turunan (jumlah SKS tiap baris) | - |
| Terlambat (hari) | Turunan dari tanggal KRS dan batas registrasi | - |
| Denda | Turunan dari hari terlambat (alasan disimpan atau dihitung diputuskan di Modul 4) | KRS |

Dokumen lain yang dirujuk: jadwal kuliah semester, dan KHS (hasil nilai per semester).

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Mahasiswa | NIM, nama, program studi, angkatan, status mahasiswa, nomor HP, dosen wali | Formulir registrasi, KRS |
| Dosen | NIDN, nama dosen | SK dosen, KRS |
| Mata Kuliah | kode, nama, SKS | Kurikulum |
| Kelas | kode kelas, mata kuliah, semester, dosen pengampu, kuota, hari, jam mulai, jam selesai, ruang | Jadwal kuliah |
| KRS | nomor KRS, mahasiswa, semester, dosen wali, tanggal, batas registrasi, status, denda | KRS |
| Detail KRS | nomor KRS, kelas, SKS saat diambil, nilai angka, nilai huruf | KRS, KHS |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | NIM mahasiswa unik (8 digit) dan satu NIM hanya dimiliki satu mahasiswa. Setiap mahasiswa memiliki tepat satu dosen wali. |
| AB-02 | Mata kuliah (katalog) berbeda dari kelas. Satu mata kuliah dapat dibuka dalam banyak kelas dan semester, tetapi satu kelas hanya untuk satu mata kuliah dan satu semester, dengan tepat satu dosen pengampu utama. |
| AB-03 | Setiap mahasiswa memiliki paling banyak satu KRS per semester, dan hanya mahasiswa berstatus Aktif yang boleh membuatnya. Satu KRS memuat minimal 1 dan maksimal 11 baris kelas (P + 2, P = 9). |
| AB-04 | Pengambilan kelas ditolak bila kelas itu sudah ada di KRS yang sama, bila hari dan jamnya beririsan dengan kelas lain di KRS yang sama, atau bila jumlah peserta kelas sudah mencapai kuota. |
| AB-05 | KRS baru sah setelah disetujui dosen wali. Nilai hanya dapat diinput untuk baris KRS yang berstatus disetujui. |
| AB-06 | KRS yang diisi setelah batas akhir registrasi dikenai denda Rp9.000 per hari keterlambatan (P = 9 ribu rupiah). |
| AB-07 | SKS yang dipakai pada baris KRS disimpan per baris dan tidak berubah meski SKS mata kuliah kemudian diubah kurikulum. |
| AB-08 | Nilai angka berada pada rentang 0–100. Nilai huruf diturunkan dari skala: A (85–100, bobot 4), B (70–84, bobot 3), C (55–69, bobot 2), D (40–54, bobot 1), E (0–39, bobot 0). |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Indeks Prestasi Semester (IPS) dan Indeks Prestasi Kumulatif (IPK) per mahasiswa | Mahasiswa, KRS, Detail KRS |
| KI-02 | Daftar peserta per kelas beserta sisa kuota | Kelas, Detail KRS, Mahasiswa, KRS |
| KI-03 | Mahasiswa yang terlambat mengisi KRS dan total dendanya per semester | KRS, Mahasiswa |
| KI-04 | Jadwal kuliah per mahasiswa per semester | KRS, Detail KRS, Kelas, Mata Kuliah |
| KI-05 | Distribusi nilai per mata kuliah per semester | Detail KRS, Kelas, Mata Kuliah |

## 7. Matriks CRUD

| Proses | Mahasiswa | Dosen | Mata Kuliah | Kelas | KRS | Detail KRS |
|---|---|---|---|---|---|---|
| PB-01 Kelola data master dan status mahasiswa | C, U | C, R, U | C, U | | | |
| PB-02 Buka kelas | | R | R | C, U | | |
| PB-03 Isi dan setujui KRS | R | R | R | R | C, R, U | C, R |
| PB-04 Input nilai dan susun KHS | R | R | R | R | R | R, U |

Catatan: tidak ada operasi D karena data akademik dipertahankan sesuai retensi (bagian 9). Entitas yang dihentikan cukup ditandai statusnya. Setiap entitas memiliki minimal satu proses yang melakukan C, sehingga tidak ada entitas yatim.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| nim_mahasiswa | Nomor induk mahasiswa | 25430045 | Unik, 8 digit (AB-01) | Staf akademik |
| nama_mahasiswa | Nama lengkap mahasiswa | Contoh Mahasiswa | Wajib diisi | Staf akademik |
| program_studi_mahasiswa | Program studi mahasiswa | Sistem Informasi | Wajib diisi | Staf akademik |
| angkatan_mahasiswa | Tahun masuk mahasiswa | 2025 | Bilangan 4 digit | Staf akademik |
| status_mahasiswa | Status keaktifan | Aktif | Salah satu: Aktif, Cuti, Lulus (AB-03) | Staf akademik |
| no_hp_mahasiswa | Nomor HP mahasiswa | 0812xxxx | Data pribadi, akses terbatas | Staf akademik |
| nidn_dosen | Nomor induk dosen nasional | 0412345678 | Unik, 10 digit | Staf akademik |
| nama_dosen | Nama dosen | Dr. Contoh Dosen | Wajib diisi | Staf akademik |
| kode_mk | Kode mata kuliah | SI2301 | Unik | Staf akademik |
| nama_mk | Nama mata kuliah | Basis Data | Wajib diisi | Staf akademik |
| sks_mk | SKS resmi mata kuliah | 3 | Bilangan bulat 1–6 | Staf akademik |
| kode_kelas | Kode kelas yang dibuka | SI2301-A-20261 | Unik (AB-02) | Staf akademik |
| kode_semester | Kode semester, dipakai pada Kelas dan KRS | 20261 | Format tahun + 1 (ganjil) atau 2 (genap) (AB-02, AB-03) | Staf akademik |
| kuota_kelas | Kapasitas peserta | 40 | Bilangan bulat > 0 (AB-04) | Staf akademik |
| hari_kelas | Hari kuliah | Senin | Salah satu hari kuliah (AB-04) | Staf akademik |
| jam_mulai_kelas | Jam mulai kuliah | 08.00 | Format jam, lebih awal dari jam selesai (AB-04) | Staf akademik |
| jam_selesai_kelas | Jam selesai kuliah | 10.30 | Format jam (AB-04) | Staf akademik |
| ruang_kelas | Ruang atau lab tempat kelas berlangsung | R-201 | Wajib diisi | Staf akademik |
| no_krs | Nomor KRS | KRS-20261-0087 | Unik per KRS | Mahasiswa (pembuat), staf akademik (pemelihara) |
| tanggal_krs | Tanggal pengisian KRS | 12-08-2026 | Tanggal valid | Mahasiswa |
| tanggal_batas_krs | Batas akhir registrasi, disalin dari kalender akademik | 10-08-2026 | Tanggal valid (dasar AB-06) | Staf akademik |
| status_krs | Status persetujuan | Disetujui | Diajukan, Disetujui, atau Ditolak (AB-05) | Dosen wali |
| sks_detail_krs | SKS saat KRS dibuat | 3 | Bilangan bulat 1–6, tidak berubah (AB-07) | Mahasiswa (diisi dari master) |
| nilai_angka_detail_krs | Nilai angka akhir | 85 | 0–100 (AB-08) | Dosen pengampu |

Catatan kamus data awal:
- Elemen turunan (total SKS, hari terlambat, denda, nilai huruf) tidak dimasukkan karena dihitung dari elemen di atas (AB-06, AB-08). Keputusan menyimpan atau menghitungnya dibahas di Modul 4.
- Rujukan antarentitas (dosen wali mahasiswa dan KRS, dosen pengampu kelas, mata kuliah pada kelas, mahasiswa pada KRS) dimodelkan sebagai relasi pada Modul 3, bukan sebagai elemen deskriptif.

## 9. Kebutuhan non-fungsional data

**Parameter personal.** NIM 25430080, dua digit terakhir = 80. 80 mod 9 = 8 (karena 9 × 8 = 72 dan 80 − 72 = 8), jadi P = 8 + 1 = 9.
- Batas maksimal item per transaksi = P + 2 = 11 (baris kelas per KRS, AB-03)
- Denda harian = P ribu rupiah = Rp9.000 (AB-06)
- Perkiraan volume transaksi harian = 40 + 5 × 9 = 85 (pengisian KRS per hari pada masa registrasi)

**Volume.** ±85 transaksi KRS per hari pada masa registrasi.

**Retensi.** Data KRS dan nilai disimpan minimal 10 tahun. Transkrip nilai tidak dihapus.

**Privasi dan akses.**
- Data pribadi: nomor HP mahasiswa dan nilai.
- Nomor HP hanya dapat dilihat staf akademik.
- Nilai hanya dapat dilihat oleh mahasiswa yang bersangkutan, dosen pengampu kelas tersebut, dosen wali mahasiswa tersebut, dan staf akademik.
- Pembatasan ini sejalan dengan kewajiban pengendali data menurut UU Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

- NIM duplikat atau salah ketik saat registrasi (AB-01).
- KRS yang memuat kelas bentrok atau melebihi kuota karena pengisian bersamaan (AB-04).
- Mahasiswa cuti masih bisa mengisi KRS karena status tidak diperbarui (AB-03).
- SKS pada KRS lama berubah mengikuti kurikulum baru bila SKS hanya disimpan di mata kuliah (AB-07).
- Nilai huruf tidak sesuai dengan nilai angka karena diinput manual (AB-08).
- Satu kelas tercatat memiliki lebih dari satu dosen pengampu utama (AB-02).
- Dosen wali mahasiswa berganti, sehingga KRS lama kehilangan jejak siapa yang menyetujuinya bila hanya dirujuk dari data mahasiswa (AB-01, AB-05).