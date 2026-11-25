// 03_pengujian_dcl.js
// Implementasi & Pengujian Kontrol Akses (RBAC / Least Privilege) pada MongoDB

db = db.getSiblingDB("transport_db");

// 1. Membuat user report_user dengan hak baca saja (role: read)
// Catatan: Pada MongoDB Atlas Free Tier (M0), pembuatan user dilakukan via menu Database Access.
db.createUser({
  user: "report_user",
  pwd: "<PASSWORD_PLACEHOLDER>",
  roles: [
    { role: "read", db: "transport_db" }
  ]
});

// 2. Memeriksa konfigurasi hak akses user
printjson(db.getUser("report_user"));

// --- SKENARIO PENGUJIAN (Jalankan saat terhubung sebagai report_user) ---
// Uji 1 (Diizinkan):
// db.trips.find({ route_id: 12 });

// Uji 2 (Ditolak - Access Denied):
// db.trips.deleteOne({ trip_id: "T001" });

// 3. Mencabut hak akses baca (REVOKE) sebagai Administrator
db.revokeRolesFromUser("report_user", [
  { role: "read", db: "transport_db" }
]);

// Uji 3 (Ditolak setelah REVOKE):
// db.trips.find({ route_id: 12 });
