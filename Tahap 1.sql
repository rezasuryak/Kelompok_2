SELECT g.id_gedung,
       g.nama_gedung,
       COUNT(DISTINCT l.id_laporan)                       AS total_laporan,
       COALESCE(SUM(p.status_penanganan = 'Menunggu'), 0) AS jml_menunggu,
       COALESCE(SUM(p.status_penanganan = 'Diproses'), 0) AS jml_diproses,
       COALESCE(SUM(p.status_penanganan = 'Selesai'),  0) AS jml_selesai
FROM gedung g
LEFT JOIN ruangan   r ON r.id_gedung    = g.id_gedung
LEFT JOIN fasilitas f ON f.id_ruangan   = r.id_ruangan
LEFT JOIN laporan   l ON l.id_fasilitas = f.id_fasilitas
LEFT JOIN perbaikan p ON p.id_laporan   = l.id_laporan
GROUP BY g.id_gedung, g.nama_gedung;
