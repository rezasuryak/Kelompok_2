// 02_query_transportasi.js
// Pengujian Aggregation Pipeline (Seleksi $match, Join $lookup, Proyeksi $project) & Execution Plan

db = db.getSiblingDB("transport_db");

// Eksekusi Query Utama (Selection Pushdown)
print("=== HASIL QUERY TRANSPORTASI ===");
const hasil = db.trips.aggregate([
  { $match: { route_id: 12, started_at: { $gte: "2026-11-01" } } },
  { $lookup: { from: "routes", localField: "route_id", foreignField: "route_id", as: "rute" } },
  { $unwind: "$rute" },
  { $project: { _id: 0, trip_id: 1, started_at: 1, route_name: "$rute.route_name" } }
]).toArray();
printjson(hasil);

// Inspeksi Execution Plan & Statistik Eksekusi
print("=== EXECUTION STATS ===");
const stats = db.trips.explain("executionStats").aggregate([
  { $match: { route_id: 12, started_at: { $gte: "2026-11-01" } } },
  { $lookup: { from: "routes", localField: "route_id", foreignField: "route_id", as: "rute" } },
  { $unwind: "$rute" },
  { $project: { _id: 0, trip_id: 1, started_at: 1, route_name: "$rute.route_name" } }
]);
printjson(stats);
