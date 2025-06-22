class Product {
  final String id;
  final String namaBarang;
  final int jumlahStok;
  final int harga;

  Product({
    required this.id,
    required this.namaBarang,
    required this.jumlahStok,
    required this.harga,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      namaBarang: json['nama_barang'],
      jumlahStok: json['jumlah_stok'],
      harga: json['harga'],
    );
  }
}
