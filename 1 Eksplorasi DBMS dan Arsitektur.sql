USE fasilitas_kampus;
-- =====================================================================
-- TUGAS 1 (25) - EKSPLORASI DBMS DAN ARSITEKTUR  [Tahap A]
-- =====================================================================
-- CARA PAKAI
-- Berkas ini berisi beberapa BLOK. Salin SATU blok, tempel di tab SQL, klik Go,
-- screenshot, lalu lanjut ke blok berikutnya. Jangan klik Go untuk seluruh berkas
-- sekaligus: blok bertanda ERROR sengaja gagal, dan phpMyAdmin berhenti di
-- error pertama. Blok bertanda SATU KALI GO harus disalin utuh dalam satu kirim.

-- ----- BLOK 1 | A.1 Mengenal DBMS: versi, distribusi, OS, port
SELECT VERSION()            AS versi_dbms,
       @@version_comment    AS distribusi,
       @@version_compile_os AS sistem_operasi,
       @@port               AS port,
       @@datadir            AS lokasi_data,
       @@hostname           AS nama_host;

-- ----- BLOK 2 | A.1 Storage engine bawaan
SHOW VARIABLES LIKE 'default_storage_engine';

-- ----- BLOK 3 | A.1 Database yang tersedia di server
SHOW DATABASES;

-- ----- BLOK 4 | A.4 Komponen internal: storage engine yang tersedia
SHOW ENGINES;

-- ----- BLOK 5 | A.4 Komponen internal: autocommit, buffer pool, charset
SHOW VARIABLES WHERE Variable_name IN
  ('autocommit', 'innodb_buffer_pool_size', 'character_set_server');

-- ----- BLOK 6 | A.5 Lingkungan DBMS: engine yang dipakai tiap tabel proyek
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'fasilitas_kampus'
ORDER BY table_name;

-- ----- BLOK 7 | A.5 Status tabel proyek: engine, jumlah baris, ukuran
SHOW TABLE STATUS FROM fasilitas_kampus;
