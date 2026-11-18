USE fasilitas_kampus;
-- ====================================================================
-- MODUL 11 - 11.3 NOMOR 1: EKSPLORASI DAN PERBANDINGAN DBMS
-- ====================================================================
-- Salin SATU blok, jalankan di tab SQL phpMyAdmin, screenshot, lalu lanjut.
-- Blok bertanda ERROR sengaja gagal. Blok bertanda SATU KALI GO dijalankan utuh.

-- ----- BLOK 1 | Versi DBMS
SELECT VERSION();

-- ----- BLOK 2 | Informasi vendor
SELECT @@version_comment;

-- ----- BLOK 3 | Database yang tersedia
SHOW DATABASES;

-- ----- BLOK 4 | Storage engine yang tersedia
SHOW ENGINES;

-- ----- BLOK 5 | Karakter set server
SHOW VARIABLES LIKE 'character_set_server';

-- ----- BLOK 6 | Collation server
SHOW VARIABLES LIKE 'collation_server';

-- ----- BLOK 7 | Dukungan fungsi JSON
SELECT JSON_VALID('{"nama":"Budi"}') AS json_valid,
       JSON_EXTRACT('{"nama":"Budi"}', '$.nama') AS nama;

-- ----- BLOK 8 | Database aktif (harus fasilitas_kampus)
SELECT DATABASE();
