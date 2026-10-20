# Dokumen Normalisasi dan Skema Relasional - Koperasi Mahasiswa Sejahtera

**Nama:** Nia Septiana **NIM:** 25430080 **Basis data:** kopma_080

Sumber: dokumen kebutuhan data (P2, termasuk poin loyalitas AB-07 s.d. AB-10) dan ERD fisik (P3, 9 tabel).

## 1. UNF

Satu nota memuat dua grup berulang: barang dan mutasi poin.

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, status_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          { jenis_mutasi_poin, jumlah_mutasi_poin, tgl_jam_mutasi_poin },
          potongan_poin_penjualan, bayar_penjualan,
          jumlah_penjualan, diskon_penjualan, total_penjualan, saldo_poin_anggota)
```

## 2. 1NF

- **Barang:** satu baris per barang per nota, kunci `(no_nota_penjualan, kode_barang)`.
- **Mutasi poin:** dibuat relasi sendiri karena bebas dari grup barang (jika digabung, baris berlipat). Kuncinya `id_mutasi_poin`, sebab koreksi (AB-09) dapat menambah mutasi sejenis pada nota yang sama.

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, status_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          potongan_poin_penjualan, bayar_penjualan)
MUTASI_1NF (id_mutasi_poin, no_nota_penjualan, no_anggota,
            jenis_mutasi_poin, jumlah_mutasi_poin, tgl_jam_mutasi_poin)
```

Nilai turunan tidak dibawa (lihat bagian 5).

## 3. Dependensi fungsional

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota, bayar_penjualan, potongan_poin_penjualan | AB-01, AB-02, AB-10 |
| FD2 | kode_petugas -> nama_petugas, peran_petugas | satu kode satu petugas |
| FD3 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota; nim_anggota -> no_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang | AB-03, AB-06 |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | turunan |
| FD7 | id_mutasi_poin -> no_nota_penjualan, no_anggota, jenis_mutasi_poin, jumlah_mutasi_poin, tgl_jam_mutasi_poin | AB-07, AB-08, AB-09 |
| FD8 | kode_pemasok -> nama_pemasok, telepon_pemasok, alamat_pemasok | faktur pemasok |
| FD9 | (kode_pemasok, no_faktur_pembelian) -> tgl_pembelian, status_pembelian | AB-06; nomor faktur bisa sama antarpemasok |
| FD10 | (kode_pemasok, no_faktur_pembelian, kode_barang) -> qty_detail_pembelian, harga_beli_detail_pembelian | faktur pemasok |

FD5: harga berada pada kunci nota + barang, bukan pada `kode_barang`, karena harga saat transaksi tidak boleh berubah mengikuti harga barang (AB-04).

## 4. 2NF dan 3NF

**2NF.** FD1 dan FD4 hanya bergantung pada sebagian kunci, jadi dipisah menjadi `penjualan`, `barang`, dan `detail_penjualan`. `mutasi_poin` berkunci tunggal, jadi sudah 2NF.

**3NF.** Ada dua rantai di penjualan, yaitu nota -> kode_petugas -> nama_petugas dan nota -> no_anggota -> data anggota. Keduanya dipisah menjadi `petugas` dan `anggota`. Faktur pemasok dinormalisasi dengan pola yang sama menjadi `pemasok`, `pembelian`, dan `detail_pembelian`.

**Temuan di `mutasi_poin`.**

- `id_anggota` bergantung transitif lewat nota (id_mutasi_poin -> nota -> anggota).
- Keputusan: **tetap disimpan** sebagai denormalisasi terkendali, karena KI-05 sampai KI-07 dihitung per anggota. Nilainya diisi dengan `INSERT ... SELECT` dari baris nota (Modul 14), bukan diketik manual.
- `tgl_jam_mutasi_poin` bukan dependensi transitif, karena mutasi koreksi dicatat pada waktu yang berbeda dari nota.

## 5. Nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Dihitung | qty x harga; menyimpan berisiko tidak konsisten |
| jumlah_penjualan, total_penjualan | Dihitung | Bisa dihitung ulang dari detail, diskon, dan potongan poin |
| diskon_penjualan (5%) | Dihitung | Turunan dari status anggota aktif (AB-02) |
| saldo_poin_anggota | Dihitung | Jumlah seluruh mutasi poin; riwayat tidak dihapus (AB-09) |
| potongan_poin_penjualan | **Disimpan** | Potret nilai saat transaksi (AB-10) |
| jumlah_mutasi_poin | **Disimpan** | Fakta historis yang bergantung pada status dan aturan saat transaksi (AB-07, AB-08) |

Risiko: jika status anggota kemudian menjadi tidak aktif, penghitungan ulang nota lama kehilangan diskon. Untuk Buku 1 ini mengikuti skema kanonik dan dicatat sebagai risiko.

## 6. Hasil 3NF

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*,
           bayar_penjualan, potongan_poin_penjualan)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan,
                  harga_satuan_detail_penjualan)
MUTASI_POIN (id_mutasi_poin, no_anggota*, no_nota_penjualan*, jenis_mutasi_poin,
             jumlah_mutasi_poin, tgl_jam_mutasi_poin)
BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang,
        stok_barang, stok_min_barang)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota,
         status_anggota, tgl_daftar_anggota)
PEMASOK (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok)
PEMBELIAN (kode_pemasok*, no_faktur_pembelian, tgl_pembelian, status_pembelian)
DETAIL_PEMBELIAN (kode_pemasok*, no_faktur_pembelian*, kode_barang*,
                  qty_detail_pembelian, harga_beli_detail_pembelian)
-- atribut pertama / komposit pertama = kunci primer, * = kunci tamu
```

## 7. Skema kanonik dan pemeriksaan BCNF

Kunci pengganti `id_*` menjadi kunci primer; kode alami menjadi kunci unik. `pembelian` memakai `id_pembelian` karena `no_faktur_pembelian` tidak unik antarpemasok, dan `kode_pemasok` digantikan `id_pemasok`.

| Tabel | Kunci primer | Kunci unik | Kunci tamu | BCNF |
|---|---|---|---|---|
| petugas | id_petugas | kode_petugas | - | ya |
| anggota | id_anggota | no_anggota, nim_anggota | - | ya |
| barang | id_barang | kode_barang | - | ya |
| pemasok | id_pemasok | - | - | ya |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) | ya |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang | ya |
| mutasi_poin | id_mutasi_poin | - | id_anggota, id_penjualan | ya, kecuali `id_anggota` (bagian 4) |
| pembelian | id_pembelian | - | id_pemasok | ya |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang | ya |

## 8. Perubahan pada ERD P3

Tidak ada perubahan pada sembilan tabel. Jika Latihan 1 diterapkan, ditambahkan satu tabel `telepon_pemasok`.

## 9. Latihan dan Modifikasi

### Latihan 1: Beberapa nomor telepon per pemasok

Beberapa nomor dalam satu kolom melanggar 1NF (nilai tidak atomik), dan `telepon1`, `telepon2`, ... adalah grup berulang. Maka nomor dipindah ke relasi sendiri.

```
PEMASOK_UNF (kode_pemasok, nama_pemasok, alamat_pemasok, { no_telepon_pemasok })
-- hasil:
PEMASOK (kode_pemasok, nama_pemasok, alamat_pemasok)
TELEPON_PEMASOK (kode_pemasok*, no_telepon_pemasok)
```

- `TELEPON_PEMASOK` hanya berisi kunci, sehingga memenuhi 2NF, 3NF, dan BCNF. `PEMASOK` berkunci tunggal tanpa rantai transitif.
- Di skema kanonik: `telepon_pemasok` berkunci primer `id_telepon_pemasok`, unik `(id_pemasok, no_telepon_pemasok)`, kunci tamu `id_pemasok`. Kolom lama `telepon_pemasok` di `pemasok` dihapus.

### Latihan 2: Pelanggaran 3NF jika `nama_anggota` disimpan di `penjualan`

Muncul rantai `id_penjualan -> id_anggota -> nama_anggota`, jadi melanggar 3NF. Contoh data (anggota yang sama, tiga nota):

| no_nota_penjualan | id_anggota | nama_anggota |
|---|---|---|
| PJ-2609-0001 | 4 | Nadia Putri |
| PJ-2609-0017 | 4 | Nadia Putri |
| PJ-2610-0033 | 4 | Nadia Putri |

Anomali ubah: nama dikoreksi, tetapi hanya satu nota yang terkena.

```sql
UPDATE penjualan SET nama_anggota = 'Nadia Putri Ayu'
WHERE no_nota_penjualan = 'PJ-2609-0001';

SELECT id_anggota, nama_anggota, COUNT(*) AS jumlah_nota
FROM penjualan WHERE id_anggota = 4
GROUP BY id_anggota, nama_anggota;
```

Hasil yang diharapkan (belum dijalankan): `(4, Nadia Putri, 2)` dan `(4, Nadia Putri Ayu, 1)`. Satu anggota memiliki dua nama dan server tidak memberi galat. Pada skema 3NF, nama hanya ada di `anggota`, jadi satu perintah sudah benar untuk semua nota:

```sql
UPDATE anggota SET nama_anggota = 'Nadia Putri Ayu' WHERE id_anggota = 4;
```