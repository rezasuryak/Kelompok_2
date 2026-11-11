USE fasilitas_kampus;
-- =====================================================================
-- TUGAS 2 (30) - IMPLEMENTASI DAN INTEGRITAS BASIS DATA  [Tahap B dan C]
-- =====================================================================
-- CARA PAKAI
-- Berkas ini berisi beberapa BLOK. Salin SATU blok, tempel di tab SQL, klik Go,
-- screenshot, lalu lanjut ke blok berikutnya. Jangan klik Go untuk seluruh berkas
-- sekaligus: blok bertanda ERROR sengaja gagal, dan phpMyAdmin berhenti di
-- error pertama. Blok bertanda SATU KALI GO harus disalin utuh dalam satu kirim.

-- ----- BLOK 1 | B.1 Membuat database (sudah dibuat, tunjukkan DDL-nya)
SHOW CREATE DATABASE fasilitas_kampus;

-- ----- BLOK 2 | B.1 Daftar tabel di database proyek (15 tabel)
SHOW TABLES;

-- ----- BLOK 3 | B.2 Tabel pertama (padanan Pelanggan): gedung
SHOW CREATE TABLE gedung;

-- ----- BLOK 4 | B.3 Tabel kedua (padanan Produk): ruangan
SHOW CREATE TABLE ruangan;

-- ----- BLOK 5 | B.4 Tabel ketiga (padanan Pesanan): fasilitas
SHOW CREATE TABLE fasilitas;

-- ----- BLOK 6 | B.5 Tabel keempat (padanan Detail Pesanan): laporan
SHOW CREATE TABLE laporan;

-- ----- BLOK 7 | B.6 Memeriksa relasi tabel (FK) dan aturan referensialnya. Screenshot juga tab Desainer.
SELECT k.table_name, k.column_name,
       k.referenced_table_name, k.referenced_column_name,
       r.update_rule, r.delete_rule
FROM information_schema.key_column_usage k
JOIN information_schema.referential_constraints r
  ON r.constraint_schema = k.constraint_schema
 AND r.constraint_name   = k.constraint_name
 AND r.table_name        = k.table_name
WHERE k.table_schema = 'fasilitas_kampus'
  AND k.referenced_table_name IS NOT NULL
ORDER BY k.table_name, k.column_name;

-- ----- BLOK 8 | B.7 Mengisi data awal (dari 3_data_contoh.sql): cek jumlah baris
SELECT 'gedung' AS tabel, COUNT(*) AS jumlah FROM gedung
UNION ALL SELECT 'ruangan',   COUNT(*) FROM ruangan
UNION ALL SELECT 'fasilitas', COUNT(*) FROM fasilitas
UNION ALL SELECT 'laporan',   COUNT(*) FROM laporan
UNION ALL SELECT 'perbaikan', COUNT(*) FROM perbaikan;

-- ----- BLOK 9 | C.1 CREATE: tambah data uji Gedung C, ruangan, dan dua fasilitas (jalankan sekali)
INSERT INTO gedung (nama_gedung, lokasi) VALUES ('Gedung C', 'Kampus Barat');

INSERT INTO ruangan (nama_ruangan, lantai, id_gedung)
  SELECT 'Aula C', 1, id_gedung FROM gedung WHERE nama_gedung = 'Gedung C';

INSERT INTO fasilitas (nama_fasilitas, kode_qr, id_ruangan)
  SELECT 'Sound System', 'QR-C01', id_ruangan FROM ruangan WHERE nama_ruangan = 'Aula C';

INSERT INTO fasilitas (nama_fasilitas, kode_qr, id_ruangan)
  SELECT 'Kipas Angin', 'QR-C02', id_ruangan FROM ruangan WHERE nama_ruangan = 'Aula C';

-- ----- BLOK 10 | C.2 READ: baca satu tabel
SELECT * FROM gedung;

-- ----- BLOK 11 | C.2 READ: baca dengan JOIN
SELECT g.nama_gedung, r.nama_ruangan, f.nama_fasilitas, f.kode_qr
FROM gedung g
JOIN ruangan   r ON r.id_gedung  = g.id_gedung
JOIN fasilitas f ON f.id_ruangan = r.id_ruangan
WHERE g.nama_gedung = 'Gedung C';

-- ----- BLOK 12 | C.2 READ dengan filter: suku cadang berharga di atas 100000
SELECT * FROM suku_cadang WHERE harga_satuan > 100000;

-- ----- BLOK 13 | C.3 UPDATE: ubah lokasi Gedung C
UPDATE gedung SET lokasi = 'Kampus Timur' WHERE nama_gedung = 'Gedung C';

-- ----- BLOK 14 | C.3 Bukti UPDATE
SELECT * FROM gedung WHERE nama_gedung = 'Gedung C';

-- ----- BLOK 15 | C.4 DELETE: hapus satu fasilitas (tabel anak, tidak punya turunan)
DELETE FROM fasilitas WHERE kode_qr = 'QR-C02';

-- ----- BLOK 16 | C.4 Bukti DELETE: hanya QR-C01 yang tersisa
SELECT * FROM fasilitas WHERE kode_qr LIKE 'QR-C%';

-- ----- BLOK 17 | C.5a Uji FK: ruangan dengan gedung yang tidak ada. ERROR #1452 itu yang diharapkan.
INSERT INTO ruangan (nama_ruangan, lantai, id_gedung) VALUES ('Ruang Hantu', 1, 999);

-- ----- BLOK 18 | C.5b Uji RESTRICT: hapus gedung yang masih punya ruangan. ERROR #1451 itu yang diharapkan (MariaDB tidak menulis kata RESTRICT di pesannya, itu normal).
DELETE FROM gedung WHERE nama_gedung = 'Gedung C';

-- ----- BLOK 19 | C.5c Uji UNIQUE: nama gedung kembar. ERROR #1062 itu yang diharapkan.
INSERT INTO gedung (nama_gedung, lokasi) VALUES ('Gedung A', 'Kampus Mana Saja');

-- ----- BLOK 20 | C.5d Uji CHECK: rating di luar 1-5. Di MariaDB 10.4 error yang diharapkan: #4025 CONSTRAINT ... failed.
INSERT INTO penilaian (rating, komentar, id_laporan)
  SELECT 9, 'Uji CHECK', id_laporan FROM laporan WHERE deskripsi_kerusakan = 'AC tidak dingin';

-- ----- BLOK 21 | C.5e Uji ON UPDATE CASCADE: ubah id gedung
UPDATE gedung SET id_gedung = 30 WHERE nama_gedung = 'Gedung C';

-- ----- BLOK 22 | C.5e Bukti CASCADE: id_gedung di ruangan ikut berubah menjadi 30
SELECT nama_ruangan, id_gedung FROM ruangan WHERE nama_ruangan = 'Aula C';

-- ----- BLOK 23 | C.5f Bersihkan data uji (anak dulu, baru induk). Jalankan sekali.
DELETE FROM fasilitas WHERE kode_qr = 'QR-C01';
DELETE FROM ruangan   WHERE nama_ruangan = 'Aula C';
DELETE FROM gedung    WHERE nama_gedung = 'Gedung C';
