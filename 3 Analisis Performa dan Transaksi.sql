USE fasilitas_kampus;
-- =====================================================================
-- TUGAS 3 (25) - ANALISIS PERFORMA DAN TRANSAKSI  [Tahap D dan E]
-- =====================================================================
-- CARA PAKAI
-- Berkas ini berisi beberapa BLOK. Salin SATU blok, tempel di tab SQL, klik Go,
-- screenshot, lalu lanjut ke blok berikutnya. Jangan klik Go untuk seluruh berkas
-- sekaligus: blok bertanda ERROR sengaja gagal, dan phpMyAdmin berhenti di
-- error pertama. Blok bertanda SATU KALI GO harus disalin utuh dalam satu kirim.

-- ----- BLOK 1 | D.0 Persiapan: suku cadang uji dengan stok 50
INSERT INTO suku_cadang (nama_suku_cadang, satuan, stok, stok_minimum, harga_satuan, id_pemasok)
  SELECT 'Kabel NYM 2x1.5', 'meter', 50, 10, 8000, id_pemasok
  FROM pemasok WHERE nama_pemasok = 'CV Sumber Teknik';

-- ----- BLOK 2 | D.0 Cek stok awal (harus 50)
SELECT nama_suku_cadang, stok FROM suku_cadang WHERE nama_suku_cadang = 'Kabel NYM 2x1.5';

-- ----- BLOK 3 | D.1 COMMIT. Seluruh blok ini dijalankan dalam SATU KALI klik Go.
START TRANSACTION;

INSERT INTO pemakaian_suku_cadang (id_laporan, id_perbaikan, id_suku_cadang, jumlah, harga_saat_pakai)
  SELECT p.id_laporan, p.id_perbaikan, s.id_suku_cadang, 5, s.harga_satuan
  FROM perbaikan p
  JOIN laporan l ON l.id_laporan = p.id_laporan, suku_cadang s
  WHERE l.deskripsi_kerusakan = 'AC tidak dingin'
    AND p.id_perbaikan = 1
    AND s.nama_suku_cadang = 'Kabel NYM 2x1.5';

UPDATE suku_cadang SET stok = stok - 5 WHERE nama_suku_cadang = 'Kabel NYM 2x1.5';

COMMIT;

-- ----- BLOK 4 | D.1 Bukti COMMIT: stok menjadi 45
SELECT nama_suku_cadang, stok FROM suku_cadang WHERE nama_suku_cadang = 'Kabel NYM 2x1.5';

-- ----- BLOK 5 | D.1 Bukti COMMIT: pemakaian tersimpan permanen
SELECT * FROM pemakaian_suku_cadang;

-- ----- BLOK 6 | D.2 ROLLBACK. Seluruh blok ini dijalankan dalam SATU KALI klik Go.
START TRANSACTION;
UPDATE suku_cadang SET stok = stok - 20 WHERE nama_suku_cadang = 'Kabel NYM 2x1.5';
ROLLBACK;

-- ----- BLOK 7 | D.2 Bukti ROLLBACK: stok TETAP 45, bukan 25
SELECT nama_suku_cadang, stok FROM suku_cadang WHERE nama_suku_cadang = 'Kabel NYM 2x1.5';

-- ----- BLOK 8 | E.0 Tabel simulasi: salinan struktur laporan TANPA trigger dan FK, agar data berjuta baris cepat dimuat
CREATE TABLE laporan_simulasi (
  id_laporan       INT AUTO_INCREMENT PRIMARY KEY,
  id_pengguna      INT NOT NULL,
  id_fasilitas     INT NOT NULL,
  tanggal_lapor    DATETIME NOT NULL,
  tingkat_urgensi  ENUM('Rendah','Sedang','Tinggi') NOT NULL
) ENGINE=InnoDB;

-- ----- BLOK 9 | E.0 Isi data per BATCH 100.000 baris (ringan untuk XAMPP). Jalankan 3 kali: ganti angka OFFSET 0 -> 100000 -> 200000 (di 3 tempat) lalu Kirim, hasil akhir 300.000 baris.
INSERT INTO laporan_simulasi (id_pengguna, id_fasilitas, tanggal_lapor, tingkat_urgensi)
SELECT (SELECT MIN(id_pengguna)  FROM pengguna),
       (SELECT MIN(id_fasilitas) FROM fasilitas),
       DATE_ADD(DATE_ADD('2026-01-01 00:00:00', INTERVAL ((n + 0) MOD 330) DAY), INTERVAL ((n + 0) MOD 86400) SECOND),
       ELT(1 + ((n + 0) MOD 3), 'Rendah', 'Sedang', 'Tinggi')
FROM (
  SELECT a.d*10000 + b.d*1000 + c.d*100 + e.d*10 + f.d AS n
  FROM (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
       (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
       (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
       (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) e,
       (SELECT 0 d UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) f
) x;

-- ----- BLOK 10 | E.0 Cek jumlah baris tabel simulasi (harus 300000 setelah 3 batch)
SELECT COUNT(*) AS jumlah_baris FROM laporan_simulasi;

-- ----- BLOK 11 | E.1 Memahami index: daftar index SEBELUM dibuat (hanya PRIMARY)
SHOW INDEX FROM laporan_simulasi;

-- ----- BLOK 12 | E.2 Query SEBELUM index (catat waktunya)
SELECT id_laporan, id_pengguna, tanggal_lapor, tingkat_urgensi
FROM laporan_simulasi
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- ----- BLOK 13 | E.2 EXPLAIN SEBELUM index. Harapan: type=ALL, key=NULL, rows sekitar jumlah seluruh baris
EXPLAIN
SELECT id_laporan, id_pengguna, tanggal_lapor, tingkat_urgensi
FROM laporan_simulasi
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- ----- BLOK 14 | E.3 Membuat index pada kolom tanggal_lapor
CREATE INDEX idx_simulasi_tanggal ON laporan_simulasi(tanggal_lapor);

-- ----- BLOK 15 | E.3 Periksa index setelah dibuat
SHOW INDEX FROM laporan_simulasi;

-- ----- BLOK 16 | E.4 Query SETELAH index (catat waktunya)
SELECT id_laporan, id_pengguna, tanggal_lapor, tingkat_urgensi
FROM laporan_simulasi
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- ----- BLOK 17 | E.4 EXPLAIN SETELAH index. Harapan: type=range, key=idx_simulasi_tanggal, rows jauh lebih sedikit dari jumlah seluruh baris
EXPLAIN
SELECT id_laporan, id_pengguna, tanggal_lapor, tingkat_urgensi
FROM laporan_simulasi
WHERE tanggal_lapor >= '2026-10-01'
  AND tanggal_lapor <  '2026-11-01';

-- ----- BLOK 18 | E.4 (opsional) Simulasi lain: EXPLAIN query JOIN pada data besar
EXPLAIN
SELECT g.nama_gedung, COUNT(*) AS jumlah_laporan
FROM laporan_simulasi s
JOIN fasilitas f ON f.id_fasilitas = s.id_fasilitas
JOIN ruangan   r ON r.id_ruangan   = f.id_ruangan
JOIN gedung    g ON g.id_gedung    = r.id_gedung
GROUP BY g.nama_gedung;

-- ----- BLOK 19 | E.6 Index TIDAK terpakai: fungsi DATE() pada kolom (type=ALL)
EXPLAIN SELECT id_laporan FROM laporan_simulasi
WHERE DATE(tanggal_lapor) = '2026-10-05';

-- ----- BLOK 20 | E.6 Index terpakai: kondisi yang sama ditulis sebagai rentang (type=range)
EXPLAIN SELECT id_laporan FROM laporan_simulasi
WHERE tanggal_lapor >= '2026-10-05'
  AND tanggal_lapor <  '2026-10-06';

-- ----- BLOK 21 | E.7 Hapus tabel simulasi setelah selesai
DROP TABLE laporan_simulasi;
