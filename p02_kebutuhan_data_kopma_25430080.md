# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat A-xxxx. Anggota aktif memperoleh diskon 5% untuk setiap nota. Anggota aktif juga mengumpulkan poin loyalitas: setiap kelipatan Rp10.000 belanja bernilai 1 poin, dan 50 poin dapat ditukar dengan potongan Rp5.000 pada nota berikutnya.

Tiga kasir bekerja bergantian per sif untuk mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok dan membuat pesanan pembelian ke pemasok bila stok di bawah batas minimum. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, anggota paling aktif, dan ringkasan poin loyalitas.

Keluhan pengguna yang melatarbelakangi kebutuhan data:
- Ketua: harga barang sering naik sehingga nota lama membingungkan.
- Petugas gudang: stok di buku catatan kadang minus.
- Kasir: anggota sering lupa membawa kartu, sehingga dicari lewat NIM.
- Ketua (kebutuhan baru): program poin loyalitas harus bisa diaudit, yaitu setiap poin yang diberikan dan ditukar dapat ditelusuri ke nota.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan (termasuk poin loyalitas) | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola data barang | Petugas gudang | Barang baru, harga baru dari Ketua, atau batas minimum berubah |
| PB-08 | Mengelola status keanggotaan | Ketua koperasi | Anggota diaktifkan atau dinonaktifkan |
| PB-09 | Mengelola data petugas | Ketua koperasi | Petugas baru atau berganti peran |

PB-06 sampai PB-09 ditambahkan setelah pemeriksaan matriks CRUD (bagian 7).

Alur per aktor:
- **Kasir:** mendaftarkan anggota (PB-01), mencatat penjualan, memeriksa saldo poin, menerapkan penukaran poin, mencatat poin yang diperoleh, dan mencetak nota (PB-02).
- **Petugas gudang:** memeriksa stok, memesan ke pemasok (PB-03), menerima barang dan menambah stok (PB-04), mengelola data pemasok dan barang (PB-06, PB-07).
- **Ketua koperasi:** menerima laporan bulanan (PB-05), mengelola status anggota dan data petugas (PB-08, PB-09), serta menetapkan harga jual barang yang kemudian dimasukkan petugas gudang (PB-07).

## 3. Dokumen sumber yang dianalisis

| Dokumen | Isi utama | Dipakai untuk |
|---|---|---|
| Formulir pendaftaran anggota | NIM, nama, program studi, nomor HP | Entitas Anggota |
| Daftar barang | kode, nama, kategori, harga jual, stok, batas minimum | Entitas Barang |
| Nota penjualan | nomor nota, tanggal-jam, kasir, anggota, barang, qty, harga saat transaksi, bayar | Penjualan dan Detail penjualan |
| Faktur pemasok | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Pemasok, Pembelian |
| Wawancara | peran petugas, keluhan pengguna | Petugas, aturan bisnis |

Pembedahan nota penjualan (nota anggota juga mencetak potongan poin dan poin yang diperoleh):

| Isian nota | Disimpan / Turunan |
|---|---|
| Nomor nota, tanggal-jam, kasir, anggota, bayar | Disimpan |
| Potongan poin (rupiah), bila anggota menukar poin | Disimpan (nilai saat transaksi) |
| Poin ditukar dan poin diperoleh | Disimpan sebagai mutasi poin yang terkait nota |
| Barang, qty, harga saat transaksi (per baris) | Disimpan |
| Subtotal per baris (qty × harga) | Turunan |
| Diskon 5% anggota aktif | Turunan |
| Total | Turunan (bisa dihitung ulang dari qty, harga, diskon, dan potongan poin) |
| Saldo poin anggota setelah nota | Turunan (jumlah seluruh mutasi poin anggota) |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif (saldo poin: turunan dari Mutasi poin) | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar, potongan poin | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |
| Mutasi poin | id mutasi, anggota, nota, jenis (perolehan/penukaran), jumlah poin, tanggal-jam | Nota penjualan, wawancara |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Poin hanya diperoleh anggota berstatus aktif pada saat transaksi; pembeli umum dan anggota tidak aktif tidak memperoleh poin. Poin diperoleh per nota sebesar 1 poin untuk setiap kelipatan Rp10.000 dari total akhir yang dibayar (setelah diskon 5% dan potongan poin), dibulatkan ke bawah. |
| AB-08 | Anggota aktif dapat menukar poin dengan potongan: setiap 50 poin bernilai Rp5.000. Penukaran dalam kelipatan 50 poin, tidak melebihi saldo poin sebelum nota, dan potongan tidak melebihi total nota setelah diskon 5%. |
| AB-09 | Setiap perolehan dan penukaran poin dicatat sebagai mutasi poin yang terkait satu nota. Saldo poin adalah jumlah seluruh mutasi anggota, tidak boleh negatif, dan riwayat mutasi tidak dihapus. |
| AB-10 | Potongan poin (rupiah) disimpan pada nota saat transaksi dan tidak berubah meski aturan nilai poin kemudian berubah (selaras AB-04). |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Saldo poin seorang anggota (dicari lewat nomor anggota atau NIM) saat transaksi | Anggota, mutasi poin |
| KI-06 | Riwayat perolehan dan penukaran poin seorang anggota | Mutasi poin, penjualan |
| KI-07 | Total poin diberikan dan ditukar per bulan beserta total potongan rupiahnya | Mutasi poin, penjualan |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian | Petugas | Mutasi poin |
|---|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | | R | R, C |
| PB-03 Pesan ke pemasok | | R | | | R | C | R | |
| PB-04 Terima barang | | U | | | R | R, U | R | |
| PB-05 Laporan bulanan | R | R | R | R | | | | R |
| PB-06 Kelola data pemasok | | | | | C, U | | | |
| PB-07 Kelola data barang | | C, U | | | | | | |
| PB-08 Kelola status anggota | U | | | | | | | |
| PB-09 Kelola data petugas | | | | | | | C, U | |

Catatan pemeriksaan:
- Kolom **Pemasok**, **Barang**, dan **Petugas** semula tidak punya huruf C. Ditambahkan PB-06, PB-07, dan PB-09.
- **Status aktif anggota** semula tidak diubah proses mana pun. Ditambahkan PB-08 (aktor: Ketua, sesuai penanggung jawab data anggota).
- Kolom **Mutasi poin** dipenuhi PB-02: R untuk membaca saldo sebelum penukaran, C untuk mencatat penukaran dan perolehan. PB-05 membaca mutasi untuk KI-07. Tidak ada U karena mutasi tidak diubah; koreksi dicatat sebagai mutasi baru.
- Poin dikelola otomatis dari penjualan sehingga tidak perlu proses baru; aturan nilai poin (Rp10.000 per poin, 50 poin = Rp5.000) menjadi aturan bisnis, bukan data yang dikelola proses.
- Tidak ada operasi D karena data transaksi, termasuk mutasi poin, harus disimpan minimal lima tahun (bagian 9).

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit (AB-05) | Ketua |
| nama_anggota | Nama lengkap anggota | Contoh Anggota | Wajib diisi | Ketua |
| program_studi_anggota | Program studi anggota | Sistem Informasi | Wajib diisi | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas pada Ketua | Ketua |
| status_aktif_anggota | Status keaktifan anggota | Aktif | Aktif atau Tidak aktif; hanya anggota aktif memperoleh diskon (AB-02) | Ketua |
| kode_barang | Kode barang | BRG-014 | Unik | Petugas gudang |
| nama_barang | Nama barang | Pulpen biru | Wajib diisi | Petugas gudang |
| kategori_barang | Kategori barang | Alat tulis | Alat tulis, makanan ringan, atau minuman | Petugas gudang |
| harga_jual_barang | Harga jual terkini | 4000 | Bilangan bulat ≥ 0 (rupiah) | Ketua (menetapkan), Petugas gudang (memelihara) |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |
| batas_minimum_stok_barang | Batas stok untuk memicu pesanan | 10 | Bilangan bulat ≥ 0 (AB-06) | Petugas gudang |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota (AB-01) | Kasir |
| tanggal_jam_penjualan | Waktu transaksi | 2026-09-14 10:32 | Tanggal-jam valid | Kasir |
| bayar_penjualan | Jumlah uang dibayar | 20000 | Bilangan bulat ≥ 0 (rupiah) | Kasir |
| qty_detail_penjualan | Jumlah barang pada satu baris nota | 3 | Bilangan bulat ≥ 1 dan tidak melebihi stok (AB-03) | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah), tidak berubah (AB-04) | Kasir |
| potongan_poin_penjualan | Potongan rupiah dari penukaran poin pada nota | 5000 | Bilangan bulat ≥ 0, kelipatan 5000, tidak melebihi total setelah diskon (AB-08, AB-10) | Kasir |
| id_mutasi_poin | Pengenal satu mutasi poin | MP-000231 | Unik | Kasir |
| jenis_mutasi_poin | Jenis mutasi poin | Perolehan | Perolehan atau Penukaran (AB-09) | Kasir |
| jumlah_mutasi_poin | Jumlah poin pada mutasi | 12 | Bilangan bulat; positif untuk perolehan, negatif untuk penukaran, penukaran kelipatan 50 (AB-07, AB-08) | Kasir |
| tanggal_jam_mutasi_poin | Waktu mutasi poin | 2026-09-14 10:32 | Sama dengan tanggal-jam nota terkait | Kasir |
| saldo_poin_anggota | Saldo poin anggota (turunan) | 62 | Jumlah seluruh mutasi anggota, tidak boleh negatif (AB-09) | Ketua |
| kode_pemasok | Kode pemasok | SUP-03 | Unik | Petugas gudang |
| nama_pemasok | Nama pemasok | CV Contoh Grosir | Wajib diisi | Petugas gudang |
| telepon_pemasok | Telepon pemasok | 0271xxxx | Wajib diisi | Petugas gudang |
| no_faktur_pembelian | Nomor faktur pemasok | FK-2609-017 | Unik | Petugas gudang |
| harga_beli_pembelian | Harga beli per barang pada faktur | 3000 | Bilangan bulat ≥ 0 (rupiah) | Petugas gudang |
| kode_petugas | Kode petugas | PT-02 | Unik | Ketua |
| peran_petugas | Peran petugas | Kasir | Kasir, gudang, atau ketua | Ketua |

## 9. Kebutuhan non-fungsional data

- **Volume:** ±150 nota per hari; mutasi poin paling banyak dua baris per nota (perolehan dan penukaran).
- **Retensi:** data transaksi, termasuk mutasi poin, disimpan minimal lima tahun.
- **Privasi dan akses:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua. Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

- Harga lama hilang bila harga hanya disimpan di data barang, sehingga nota lama tidak dapat diverifikasi (AB-04).
- Stok minus akibat pencatatan manual atau penjualan melebihi stok (AB-03).
- NIM anggota duplikat atau salah ketik, padahal NIM dipakai sebagai kunci pencarian (AB-05).
- Anggota yang sudah tidak aktif masih mendapat diskon karena status tidak diperbarui (AB-02).
- Faktur pemasok tercatat dua kali sehingga stok bertambah ganda.
- Nomor HP anggota terlihat oleh petugas selain ketua.
- Poin ganda karena nota dicetak ulang atau diproses dua kali (AB-09).
- Saldo poin negatif karena penukaran melebihi saldo, atau potongan poin melebihi total nota (AB-08).
- Poin diberikan atau ditukar atas nama anggota yang sudah tidak aktif (AB-07).
- Mutasi poin tanpa nota terkait sehingga saldo tidak dapat ditelusuri (AB-09).
- Perubahan aturan nilai poin mengubah hasil nota lama bila potongan tidak disimpan per nota (AB-10).