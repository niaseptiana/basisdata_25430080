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
| PB-01 | Meregistrasi mahasiswa baru | Staf akademik | Calon mahasiswa dinyatakan diterima |
| PB-02 | Mengelola data master (dosen, mata kuliah, semester) | Staf akademik | Pergantian dosen, kurikulum, atau semester |
| PB-03 | Membuka kelas per semester | Staf akademik | Awal persiapan semester |
| PB-04 | Mengisi KRS | Mahasiswa | Masa registrasi dibuka |
| PB-05 | Menyetujui KRS | Dosen wali | KRS diajukan mahasiswa |
| PB-06 | Menginput nilai | Dosen pengampu | Akhir semester |
| PB-07 | Menyusun KHS dan laporan akademik | Staf akademik | Nilai selesai diinput |
| PB-08 | Mengelola status mahasiswa (aktif, cuti, lulus) | Staf akademik | Permohonan cuti atau kelulusan |

## 3. Dokumen sumber yang dianalisis

### 3.1 KRS (dirancang sendiri)

```
KARTU RENCANA STUDI - AKADEMIK CENDEKIA NS     No. KRS : KRS-20261-0087
Semester : 20261 (Ganjil 2026/2027)            Tgl     : 12-08-2026
NIM      : 25430045                            Nama    : Contoh Mahasiswa
Prodi    : Sistem Informasi                    Dosen Wali : 0412345678

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
| Semester | Disimpan (rujukan) | Semester |
| NIM, nama, prodi | Disimpan di master, dirujuk lewat NIM | Mahasiswa |
| Dosen wali | Disimpan (rujukan NIDN) | Dosen |
| Kode MK, nama MK | Disimpan di master, dirujuk lewat kode | Mata Kuliah |
| Kelas, hari/jam, ruang | Disimpan | Kelas |
| SKS per baris | Disimpan sebagai snapshot saat KRS dibuat | Detail KRS |
| Total SKS | Turunan (jumlah SKS tiap baris) | - |
| Denda | Turunan dari tanggal KRS dan batas akhir registrasi (alasan disimpan atau dihitung diputuskan di Modul 4) | KRS |

Dokumen lain yang dirujuk: jadwal kuliah semester, dan KHS (hasil nilai per semester).

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Mahasiswa | NIM, nama, program studi, angkatan, status mahasiswa, nomor HP | Formulir registrasi, KRS |
| Dosen | NIDN, nama dosen | SK dosen, KRS |
| Mata Kuliah | kode, nama, SKS | Kurikulum |
| Semester | kode semester, batas akhir KRS | Kalender akademik |
| Kelas | kode kelas, mata kuliah, semester, dosen pengampu, kuota, hari, jam mulai, jam selesai, ruang | Jadwal kuliah |
| KRS | nomor KRS, mahasiswa, semester, dosen wali, tanggal, status | KRS |
| Detail KRS | nomor KRS, kelas, SKS saat diambil, nilai angka, nilai huruf | KRS, KHS |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | NIM mahasiswa unik (8 digit) dan satu NIM hanya dimiliki satu mahasiswa. |
| AB-02 | Mata kuliah (katalog) berbeda dari kelas. Satu mata kuliah dapat dibuka dalam banyak kelas dan semester, tetapi satu kelas hanya untuk satu mata kuliah dan satu semester. |
| AB-03 | Setiap mahasiswa memiliki paling banyak satu KRS per semester. Satu KRS memuat minimal 1 dan maksimal 11 baris kelas (P + 2, P = 9). |
| AB-04 | Satu kelas tidak boleh diambil dua kali dalam satu KRS, dan dua kelas dengan hari dan jam yang beririsan tidak boleh berada di KRS yang sama. |
| AB-05 | Pengambilan kelas ditolak bila jumlah peserta kelas sudah mencapai kuota. |
| AB-06 | KRS baru sah setelah disetujui dosen wali. Nilai hanya dapat diinput untuk baris KRS yang berstatus disetujui. |
| AB-07 | KRS yang diisi setelah batas akhir registrasi dikenai denda Rp9.000 per hari keterlambatan (P = 9 ribu rupiah). |
| AB-08 | SKS yang dipakai pada baris KRS disimpan per baris dan tidak berubah meski SKS mata kuliah kemudian diubah kurikulum. |
| AB-09 | Nilai angka berada pada rentang 0–100. Nilai huruf diturunkan dari skala yang berlaku. |
| AB-10 | Setiap kelas memiliki tepat satu dosen pengampu utama. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Indeks Prestasi Semester (IPS) per mahasiswa per semester | KRS, Detail KRS |
| KI-02 | Indeks Prestasi Kumulatif (IPK) per mahasiswa | KRS, Detail KRS |
| KI-03 | Daftar peserta per kelas beserta sisa kuota | Kelas, Detail KRS, Mahasiswa |
| KI-04 | Mahasiswa yang terlambat mengisi KRS dan total dendanya per semester | KRS, Semester, Mahasiswa |
| KI-05 | Jadwal kuliah per mahasiswa per semester | KRS, Detail KRS, Kelas, Mata Kuliah |
| KI-06 | Distribusi nilai per mata kuliah per semester | Detail KRS, Kelas, Mata Kuliah |

## 7. Matriks CRUD

| Proses | Mahasiswa | Dosen | Mata Kuliah | Semester | Kelas | KRS | Detail KRS |
|---|---|---|---|---|---|---|---|
| PB-01 Registrasi mahasiswa | C | | | R | | | |
| PB-02 Kelola data master | | C, U | C, U | C, U | | | |
| PB-03 Buka kelas | | R | R | R | C, U | | |
| PB-04 Isi KRS | R | | R | R | R | C | C |
| PB-05 Setujui KRS | | R | | | | R, U | R |
| PB-06 Input nilai | | R | | | R | | R, U |
| PB-07 Susun KHS dan laporan | R | R | R | R | R | R | R |
| PB-08 Kelola status mahasiswa | U | | | | | | |

Catatan: tidak ada operasi D karena data akademik dipertahankan sesuai retensi (bagian 9). Entitas yang dihentikan cukup ditandai statusnya.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| nim_mahasiswa | Nomor induk mahasiswa | 25430045 | Unik, 8 digit (AB-01) | Staf akademik |
| nama_mahasiswa | Nama lengkap mahasiswa | Contoh Mahasiswa | Wajib diisi | Staf akademik |
| program_studi_mahasiswa | Program studi mahasiswa | Sistem Informasi | Wajib diisi | Staf akademik |
| angkatan_mahasiswa | Tahun masuk | 2025 | Bilangan 4 digit | Staf akademik |
| status_mahasiswa | Status keaktifan | Aktif | Salah satu: Aktif, Cuti, Lulus | Staf akademik |
| no_hp_mahasiswa | Nomor HP mahasiswa | 0812xxxx | Data pribadi, akses terbatas | Staf akademik |
| nidn_dosen | Nomor induk dosen nasional | 0412345678 | Unik, 10 digit | Staf akademik |
| nama_dosen | Nama dosen | Dr. Contoh Dosen | Wajib diisi | Staf akademik |
| kode_mk | Kode mata kuliah | SI2301 | Unik | Ketua program studi |
| nama_mk | Nama mata kuliah | Basis Data | Wajib diisi | Ketua program studi |
| sks_mk | SKS resmi mata kuliah | 3 | Bilangan bulat 1–6 | Ketua program studi |
| kode_semester | Kode semester | 20261 | Format tahun + 1 (ganjil) atau 2 (genap) | Staf akademik |
| tanggal_batas_krs | Batas akhir registrasi KRS | 10-08-2026 | Tanggal valid (dasar AB-07) | Staf akademik |
| kode_kelas | Kode kelas yang dibuka | SI2301-A-20261 | Unik (AB-02) | Staf akademik |
| kuota_kelas | Kapasitas peserta | 40 | Bilangan bulat > 0 (AB-05) | Staf akademik |
| hari_kelas | Hari kuliah | Senin | Salah satu hari kuliah | Staf akademik |
| jam_mulai_kelas | Jam mulai kuliah | 08.00 | Format jam, lebih awal dari jam selesai | Staf akademik |
| jam_selesai_kelas | Jam selesai kuliah | 10.30 | Format jam | Staf akademik |
| ruang_kelas | Ruang atau lab | R-201 | Wajib diisi | Staf akademik |
| no_krs | Nomor KRS | KRS-20261-0087 | Unik per KRS | Mahasiswa (pembuat), Staf akademik (pemelihara) |
| tanggal_krs | Tanggal pengisian KRS | 12-08-2026 | Tanggal valid | Mahasiswa |
| status_krs | Status persetujuan | Disetujui | Diajukan, Disetujui, atau Ditolak (AB-06) | Dosen wali |
| denda_krs | Denda keterlambatan KRS (rupiah) | 18000 | Bilangan bulat ≥ 0, Rp9.000 per hari (AB-07) | Staf akademik |
| sks_detail_krs | SKS saat KRS dibuat | 3 | Bilangan bulat 1–6, tidak berubah (AB-08) | Mahasiswa (diisi dari master) |
| nilai_angka_detail_krs | Nilai angka akhir | 85 | 0–100 (AB-09) | Dosen pengampu |
| nilai_huruf_detail_krs | Nilai huruf | A | Diturunkan dari skala nilai | Dosen pengampu |

## 9. Kebutuhan non-fungsional data

**Parameter personal.** NIM 25430080, dua digit terakhir = 80. 80 mod 9 = 8 (karena 9 × 8 = 72 dan 80 − 72 = 8), jadi P = 8 + 1 = 9.
- Batas maksimal item per transaksi = P + 2 = 11 (baris kelas per KRS, AB-03)
- Denda harian = P ribu rupiah = Rp9.000 (AB-07)
- Perkiraan volume transaksi harian = 40 + 5 × 9 = 85 (pengisian KRS per hari pada masa registrasi)

**Volume.** ±85 transaksi KRS per hari pada masa registrasi.

**Retensi.** Data KRS dan nilai disimpan minimal 10 tahun. Transkrip nilai tidak dihapus (asumsi, sesuaikan dengan kebijakan fiktif Anda).

**Privasi dan akses.**
- Data pribadi: nomor HP mahasiswa dan nilai.
- Nomor HP hanya dapat dilihat staf akademik.
- Nilai hanya dapat dilihat oleh mahasiswa yang bersangkutan, dosen pengampu kelas tersebut, dosen wali mahasiswa tersebut, dan staf akademik.
- Pembatasan ini sejalan dengan kewajiban pengendali data menurut UU Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

- NIM duplikat atau salah ketik saat registrasi (AB-01).
- KRS yang memuat kelas bentrok atau melebihi kuota karena pengisian bersamaan (AB-04, AB-05).
- SKS pada KRS lama berubah mengikuti kurikulum baru bila SKS hanya disimpan di mata kuliah (AB-08).
- Nilai huruf tidak sesuai dengan nilai angka karena diinput manual.
- Status mahasiswa tidak diperbarui, sehingga mahasiswa cuti masih bisa mengisi KRS.
- Satu kelas tercatat memiliki lebih dari satu dosen pengampu utama (AB-10).
