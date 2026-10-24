# AI DECLARATION

## Deklarasi Transparansi Penggunaan Artificial Intelligence (AI)

**Nama:** Dona Damayanti  
**NPM:** 2413025026  
**Nama Proyek:** DAMPING (Digitalisasi Administrasi Monitoring dan Pendampingan)

### 1. Daftar Alat AI yang Digunakan

Dalam proses pengembangan aplikasi DAMPING, AI digunakan sebagai alat bantu untuk mendukung penulisan kode, pemecahan masalah teknis, dan penyempurnaan antarmuka aplikasi.

| No. | Alat AI | Penggunaan                                                                                                                                                        |
| --- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.  | ChatGPT | Membantu menyusun struktur kode Flutter, menjelaskan kesalahan program, memberikan alternatif perbaikan, serta membantu merancang logika fitur pelanggaran siswa. |

ChatGPT digunakan sebagai alat bantu, bukan sebagai pengganti proses pengembangan. Setiap saran yang diberikan tetap perlu diperiksa, disesuaikan dengan struktur proyek, dan diuji sebelum digunakan.

### 2. Pembagian Peran AI dan Pengembangan Manual

Penggunaan AI dalam proyek DAMPING dilakukan secara kolaboratif. AI membantu memberikan rancangan awal dan alternatif penyelesaian masalah, sedangkan pengembang bertanggung jawab dalam menentukan kebutuhan, menyesuaikan kode, mengintegrasikan fitur, serta melakukan pengujian.

| No. | Modul atau Bagian             | Peran AI                                                                                      | Peran Pengembang secara Manual                                                                       |
| --- | ----------------------------- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| 1.  | Struktur halaman Flutter      | Memberikan contoh struktur widget dan tata letak halaman.                                     | Menyesuaikan struktur halaman dengan kebutuhan aplikasi DAMPING.                                     |
| 2.  | Fitur pencatatan pelanggaran  | Membantu menyusun rancangan kode formulir dan proses penyimpanan data.                        | Menyesuaikan input pelanggaran, kategori, poin, serta data yang perlu disimpan.                      |
| 3.  | Integrasi database lokal      | Membantu menjelaskan penggunaan SQLite dan contoh operasi pengambilan serta penyimpanan data. | Menyesuaikan nama tabel, kolom, dan query dengan struktur database proyek.                           |
| 4.  | Daftar dan detail pelanggaran | Membantu menyusun kode untuk menampilkan data, pencarian, filter, dan detail pelanggaran.     | Menyesuaikan tampilan, kondisi filter, perhitungan poin, dan hubungan data siswa dengan pelanggaran. |
| 5.  | Perbaikan antarmuka           | Memberikan alternatif desain, warna, dan komponen antarmuka.                                  | Memilih warna dan tata letak yang sesuai dengan identitas visual DAMPING.                            |
| 6.  | Penanganan kesalahan program  | Membantu menganalisis pesan kesalahan dan memberikan alternatif perbaikan.                    | Memeriksa penyebab kesalahan, menerapkan perubahan yang diperlukan, dan menguji kembali aplikasi.    |

**Catatan:** Tabel tersebut menjelaskan pembagian bantuan secara umum. Tidak semua kode dihasilkan oleh AI, dan bagian yang dibantu AI tidak berarti dapat langsung digunakan tanpa penyesuaian. Pembagian ini perlu disesuaikan kembali dengan riwayat pengerjaan kode yang sebenarnya.

### 3. Studi Kasus Prompting

#### Studi Kasus 1: Integrasi Data Pelanggaran dengan Database Lokal

**Tujuan:** Menampilkan data pelanggaran siswa yang telah disimpan dalam database lokal ke halaman daftar pelanggaran.

**Contoh prompt:**

> Saya sedang mengembangkan aplikasi DAMPING menggunakan Flutter dan SQLite. Bantu saya membuat halaman daftar pelanggaran siswa yang mengambil data dari database lokal. Data yang ditampilkan meliputi nama siswa, kelas, jenis pelanggaran, poin, status SP, dan tanggal kejadian. Sesuaikan query dengan tabel yang digunakan serta sediakan fitur pencarian berdasarkan nama siswa atau jenis pelanggaran.

**Hasil awal dari AI:**

AI memberikan contoh kode untuk mengambil data menggunakan query SQL, menghubungkan data pelanggaran dengan data siswa dan kelas, serta menampilkan hasilnya dalam bentuk daftar pada aplikasi Flutter.

**Penyesuaian manual yang dilakukan:**

Kode perlu disesuaikan dengan struktur database yang digunakan dalam proyek, termasuk nama tabel, nama kolom, dan relasi antara tabel pelanggaran, siswa, serta kelas. Query juga perlu diperiksa agar data yang ditampilkan sesuai dengan data yang tersimpan. Selain itu, pengembang perlu menguji kondisi ketika database belum berisi data, pencarian tidak menemukan hasil, dan proses pengambilan data mengalami kesalahan.

**Hasil yang diharapkan:** Halaman daftar pelanggaran dapat menampilkan data sesuai dengan struktur database DAMPING dan mendukung pencarian data.

#### Studi Kasus 2: Perbaikan Filter dan Tampilan Status Pelanggaran

**Tujuan:** Menyesuaikan fitur filter pada halaman pelanggaran agar pengguna dapat melihat data berdasarkan status penanganan pelanggaran.

**Contoh prompt:**

> Bantu saya memperbaiki fitur filter pada halaman PelanggaranScreen Flutter. Halaman ini menampilkan data pelanggaran dari SQLite dan memiliki filter berdasarkan status SP. Periksa agar pilihan filter sesuai dengan status yang tersedia, termasuk Normal, SP 1, SP 2, dan SP 3. Pastikan filter bekerja bersama fitur pencarian tanpa menghilangkan data yang seharusnya ditampilkan.

**Hasil awal dari AI:**

AI memberikan alternatif kode untuk mengelola pilihan filter dan menyaring data pelanggaran berdasarkan status yang dipilih pengguna.

**Penyesuaian manual yang dilakukan:**

Pengembang perlu memeriksa nilai status SP yang tersimpan di database dan memastikan nilai tersebut sesuai dengan pilihan filter pada antarmuka. Jika status SP 3 belum tersedia pada pilihan filter, pilihan tersebut perlu ditambahkan. Kondisi penyaringan juga harus diperiksa agar pencarian dan filter dapat digunakan secara bersamaan. Selanjutnya, setiap pilihan perlu diuji menggunakan data dengan status yang berbeda.

**Hasil yang diharapkan:** Filter dapat menampilkan data pelanggaran sesuai dengan status yang dipilih, termasuk SP 3 apabila status tersebut telah diterapkan dalam logika dan data aplikasi.

**Catatan:** Contoh prompt dan penyesuaian di atas merupakan dokumentasi studi kasus yang perlu dicocokkan dengan riwayat interaksi AI dan perubahan kode yang benar-benar dilakukan. Hasil yang diharapkan tidak boleh dianggap sebagai bukti bahwa fitur telah berhasil sebelum pengujian dilakukan.

### 4. Pernyataan Tanggung Jawab

Saya menyatakan bahwa penggunaan AI dalam pengembangan aplikasi DAMPING dilakukan secara transparan sebagai alat bantu teknis. Saya bertanggung jawab untuk memahami, memeriksa, menyesuaikan, dan menguji kode yang digunakan dalam proyek. Keputusan mengenai kebutuhan sistem, penerapan fitur, integrasi kode, dan hasil akhir pengembangan tetap menjadi tanggung jawab saya sebagai pengembang.

Dokumen ini disusun sebagai bentuk transparansi penggunaan AI selama proses pengembangan aplikasi DAMPING dan dapat diperbarui sesuai dengan perkembangan proyek.
