import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_klmpk6/model/product.dart';


class ProductService {
  final String apiUrl = "https://66c43c4db026f3cc6cee7678.mockapi.io/product"; // Ganti URL sesuai API kamu

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data produk');
    }
  }
   Future<void> reduceStock(String productId, int qtyToReduce) async {
  final url = "$apiUrl/$productId";

  final getResp = await http.get(Uri.parse(url));
  if (getResp.statusCode != 200) {
    throw Exception("Gagal ambil produk dengan ID $productId");
  }

  final data = jsonDecode(getResp.body);
  final int currentStock = data['jumlah_stok'];

  final int updatedStock = currentStock - qtyToReduce;
  if (updatedStock < 0) throw Exception("Stok tidak cukup");

  final patchResp = await http.patch(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"jumlah_stok": updatedStock}),
  );

  if (patchResp.statusCode != 200) {
    throw Exception("Gagal update stok");
  }
}

}
