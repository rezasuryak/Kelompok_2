USE fasilitas_kampus;
-- ====================================================================
-- MODUL 11 - 11.3 NOMOR 3: BASIS DATA BERORIENTASI OBJEK (PEMETAAN OBJEK KE RELASIONAL)
-- ====================================================================
-- Prasyarat: kolom spesifikasi dan data JSON dari 11.3 Nomor 2 sudah ada.
-- Salin SATU blok, jalankan di tab SQL phpMyAdmin, screenshot, lalu lanjut.
-- Blok bertanda ERROR sengaja gagal. Blok bertanda SATU KALI GO dijalankan utuh.

-- ----- BLOK 1 | 3.1 DDL tabel induk: pengguna
SHOW CREATE TABLE pengguna;

-- ----- BLOK 2 | 3.1 DDL tabel turunan: mahasiswa
SHOW CREATE TABLE mahasiswa;

-- ----- BLOK 3 | 3.1 DDL tabel turunan: dosen
SHOW CREATE TABLE dosen;

-- ----- BLOK 4 | 3.2 Objek Mahasiswa = Pengguna + atribut turunan
SELECT p.id_pengguna, p.nama_pengguna, p.nomor_pengenal, p.peran, m.prodi, m.angkatan
FROM pengguna p
JOIN mahasiswa m ON m.id_pengguna = p.id_pengguna;

-- ----- BLOK 5 | 3.2 Objek Dosen = Pengguna + atribut turunan
SELECT p.id_pengguna, p.nama_pengguna, p.nomor_pengenal, p.peran, d.jurusan
FROM pengguna p
JOIN dosen d ON d.id_pengguna = p.id_pengguna;

-- ----- BLOK 6 | 3.3 Objek Fasilitas berjenis AC (atribut khusus di JSON)
SELECT id_fasilitas, nama_fasilitas, kode_qr, spesifikasi
FROM fasilitas
WHERE nama_fasilitas = 'AC';

-- ----- BLOK 7 | 3.3 Objek Fasilitas berjenis Proyektor
SELECT id_fasilitas, nama_fasilitas, kode_qr, spesifikasi
FROM fasilitas
WHERE nama_fasilitas = 'Proyektor';

-- ----- BLOK 8 | 3.3 Objek Fasilitas berjenis Komputer
SELECT id_fasilitas, nama_fasilitas, kode_qr, spesifikasi
FROM fasilitas
WHERE nama_fasilitas = 'Komputer';
