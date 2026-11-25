// 04_rancangan_migrasi_pjbl.js
// Rancangan Skema, Query, Indeks, & RBAC Proyek PjBL: fasilitas_kampus (MongoDB)

db = db.getSiblingDB("fasilitas_kampus");

// Contoh Struktur Dokumen Denormalisasi (Embedded Document) pada Koleksi laporan_kerusakan
const contohDokumenLaporan = {
  _id: 1,
  tanggal_lapor: new Date("2026-11-04T05:59:45Z"),
  deskripsi_kerusakan: "AC tidak dingin",
  tingkat_urgensi: "Tinggi",
  pelapor: {
    id_pengguna: 1,
    nama: "Budi Santoso",
    peran: "Mahasiswa"
  },
  fasilitas: {
    id_fasilitas: 1,
    nama_fasilitas: "AC",
    kode_qr: "QR-001",
    spesifikasi: {
      merek: "Daikin",
      daya_pk: 1.5,
      jenis_freon: "R32"
    },
    ruangan: {
      id_ruangan: 1,
      nama_ruangan: "Lab Komputer 1",
      lantai: 2
    },
    gedung: {
      id_gedung: 1,
      nama_gedung: "Gedung A",
      lokasi: "Kampus Utara"
    }
  },
  perbaikan: [
    {
      id_perbaikan: 1,
      status_penanganan: "Diproses",
      biaya_jasa: 200000,
      nama_teknisi: "Pak Andi"
    }
  ]
};

// Rancangan Query Fitur Utama: Pemantauan Daftar Laporan Kerusakan & Perbaikan per Gedung
const queryFiturUtama = [
  {
    $match: {
      "fasilitas.gedung.nama_gedung": "Gedung A",
      tingkat_urgensi: { $in: ["Tinggi", "Sedang"] }
    }
  },
  {
    $project: {
      _id: 1,
      tanggal_lapor: 1,
      deskripsi_kerusakan: 1,
      nama_fasilitas: "$fasilitas.nama_fasilitas",
      spesifikasi: "$fasilitas.spesifikasi",
      nama_ruangan: "$fasilitas.ruangan.nama_ruangan",
      perbaikan: "$perbaikan"
    }
  }
];

// Rancangan Compound Index untuk Optimisasi Query Cost
// db.laporan_kerusakan.createIndex({ "fasilitas.gedung.nama_gedung": 1, tingkat_urgensi: 1, tanggal_lapor: -1 });

// Rancangan RBAC / Least Privilege untuk Pimpinan Monitoring (Read-Only)
// db.createUser({ user: "pimpinan_auditor", pwd: "<PASSWORD_PLACEHOLDER>", roles: [{ role: "read", db: "fasilitas_kampus" }] });
