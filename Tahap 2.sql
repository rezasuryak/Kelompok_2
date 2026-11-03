SHOW CREATE TABLE rekap_laporan_gedung;




DELETE FROM rekap_laporan_gedung;

INSERT INTO rekap_laporan_gedung
  (id_gedung, total_laporan, jml_menunggu, jml_diproses, jml_selesai, terakhir_diperbarui)
SELECT g.id_gedung,
       COUNT(DISTINCT l.id_laporan),
       COALESCE(SUM(p.status_penanganan = 'Menunggu'), 0),
       COALESCE(SUM(p.status_penanganan = 'Diproses'), 0),
       COALESCE(SUM(p.status_penanganan = 'Selesai'),  0),
       NOW()
FROM gedung g
LEFT JOIN ruangan   r ON r.id_gedung    = g.id_gedung
LEFT JOIN fasilitas f ON f.id_ruangan   = r.id_ruangan
LEFT JOIN laporan   l ON l.id_fasilitas = f.id_fasilitas
LEFT JOIN perbaikan p ON p.id_laporan   = l.id_laporan
GROUP BY g.id_gedung;
