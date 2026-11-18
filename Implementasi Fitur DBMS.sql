USE fasilitas_kampus;
-- ====================================================================
-- MODUL 11 - 11.3 NOMOR 2: IMPLEMENTASI FITUR DBMS (JSON PADA TABEL FASILITAS)
-- ====================================================================
-- Salin SATU blok, jalankan di tab SQL phpMyAdmin, screenshot, lalu lanjut.
-- Blok bertanda ERROR sengaja gagal. Blok bertanda SATU KALI GO dijalankan utuh.

-- ----- BLOK 1 | 2.1 Menambah kolom JSON pada tabel fasilitas (aman dijalankan ulang)
ALTER TABLE fasilitas
  ADD COLUMN IF NOT EXISTS spesifikasi JSON NULL;

-- ----- BLOK 2 | 2.1 Bukti struktur tabel
SHOW CREATE TABLE fasilitas;

-- ----- BLOK 3 | 2.3 AC (QR-001): isi spesifikasi JSON
UPDATE fasilitas
SET spesifikasi = '{
    "merek": "Daikin",
    "daya_pk": 1.5,
    "jenis_freon": "R32",
    "tegangan": "220V"
}'
WHERE kode_qr = 'QR-001';

-- ----- BLOK 4 | 2.3 Proyektor (QR-002): isi spesifikasi JSON
UPDATE fasilitas
SET spesifikasi = '{
    "merek": "Epson",
    "lumens": 3600,
    "resolusi": "1920x1080",
    "input": ["HDMI", "VGA"]
}'
WHERE kode_qr = 'QR-002';

-- ----- BLOK 5 | 2.3 Komputer (QR-003): fasilitas baru. Jalankan SEKALI (kode_qr unik).
INSERT INTO fasilitas (nama_fasilitas, kode_qr, id_ruangan, spesifikasi)
SELECT 'Komputer', 'QR-003', id_ruangan,
       '{
    "ram": "16GB",
    "storage": "512GB SSD",
    "prosesor": "Intel Core i5",
    "ukuran_layar": "24 inch"
}'
FROM ruangan
WHERE nama_ruangan = 'Lab Komputer 1';

-- ----- BLOK 6 | 2.3 Periksa data (harus 3 baris dengan JSON berbeda)
SELECT id_fasilitas, nama_fasilitas, kode_qr, spesifikasi
FROM fasilitas
WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 7 | 2.4 MEMBACA: daya AC
SELECT nama_fasilitas, JSON_EXTRACT(spesifikasi, '$.daya_pk') AS daya_pk
FROM fasilitas
WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 8 | 2.4 MEMBACA: lumens proyektor
SELECT nama_fasilitas, JSON_EXTRACT(spesifikasi, '$.lumens') AS lumens
FROM fasilitas
WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 9 | 2.4 MEMBACA: RAM komputer
SELECT nama_fasilitas, JSON_EXTRACT(spesifikasi, '$.ram') AS ram
FROM fasilitas
WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 10 | 2.5 MENGUBAH: RAM menjadi 32GB
UPDATE fasilitas
SET spesifikasi = JSON_SET(spesifikasi, '$.ram', '32GB')
WHERE kode_qr = 'QR-003';

-- ----- BLOK 11 | 2.5 Bukti perubahan
SELECT nama_fasilitas, JSON_EXTRACT(spesifikasi, '$.ram') AS ram
FROM fasilitas
WHERE kode_qr = 'QR-003';

-- ----- BLOK 12 | 2.6 MENAMBAH atribut: garansi AC
UPDATE fasilitas
SET spesifikasi = JSON_SET(spesifikasi, '$.garansi', '2 tahun')
WHERE kode_qr = 'QR-001';

-- ----- BLOK 13 | 2.6 Bukti penambahan
SELECT nama_fasilitas, spesifikasi FROM fasilitas WHERE kode_qr = 'QR-001';

-- ----- BLOK 14 | 2.7 MENGHAPUS atribut: garansi AC
UPDATE fasilitas
SET spesifikasi = JSON_REMOVE(spesifikasi, '$.garansi')
WHERE kode_qr = 'QR-001';

-- ----- BLOK 15 | 2.7 Bukti penghapusan
SELECT nama_fasilitas, spesifikasi FROM fasilitas WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 16 | 2.8 MENCARI: RAM 32GB
SELECT nama_fasilitas, kode_qr, spesifikasi
FROM fasilitas
WHERE JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.ram')) = '32GB';

-- ----- BLOK 17 | 2.8 MENCARI: merek Epson
SELECT nama_fasilitas, kode_qr
FROM fasilitas
WHERE JSON_UNQUOTE(JSON_EXTRACT(spesifikasi, '$.merek')) = 'Epson';

-- ----- BLOK 18 | 2.8 MENCARI di dalam array: input HDMI
SELECT nama_fasilitas, kode_qr
FROM fasilitas
WHERE JSON_CONTAINS(spesifikasi, '"HDMI"', '$.input');

-- ----- BLOK 19 | 2.9 JSON_OBJECT
SELECT JSON_OBJECT('nama', 'Budi', 'umur', 21, 'status', 'Mahasiswa') AS data_mahasiswa;

-- ----- BLOK 20 | 2.9 JSON_ARRAY
SELECT JSON_ARRAY('MySQL', 'MariaDB', 'PostgreSQL') AS daftar_dbms;

-- ----- BLOK 21 | 2.9 JSON_VALID
SELECT JSON_VALID('{"nama":"Budi","umur":21}') AS json_valid;

-- ----- BLOK 22 | 2.9 JSON_LENGTH
SELECT nama_fasilitas, JSON_LENGTH(spesifikasi) AS jumlah_atribut
FROM fasilitas
WHERE spesifikasi IS NOT NULL;

-- ----- BLOK 23 | 2.10 ERROR yang diharapkan (#4025): JSON tidak valid ditolak
INSERT INTO fasilitas (nama_fasilitas, kode_qr, id_ruangan, spesifikasi)
SELECT 'Uji JSON rusak', 'QR-ERR', id_ruangan, '{ini bukan json'
FROM ruangan
WHERE nama_ruangan = 'Lab Komputer 1';

-- ----- BLOK 24 | 2.11 Menggabungkan relasional (gedung, ruangan, fasilitas) dan JSON
SELECT g.nama_gedung,
       r.nama_ruangan,
       f.nama_fasilitas,
       JSON_UNQUOTE(JSON_EXTRACT(f.spesifikasi, '$.merek')) AS merek
FROM fasilitas f
JOIN ruangan r ON r.id_ruangan = f.id_ruangan
JOIN gedung  g ON g.id_gedung  = r.id_gedung
WHERE f.spesifikasi IS NOT NULL;
