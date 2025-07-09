import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/model/transaction.dart';

class TransactionService {
  final String baseUrl =
      "https://66c43c4db026f3cc6cee7678.mockapi.io/transaksi";

  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data transaksi");
    }
  }

  Future<void> sendTransaction(TransactionModel tx) async {
    // Ubah orderItems jadi list data sederhana
    final List<Map<String, dynamic>> items =
        tx.items.map((item) {
          final Product p = item['product'] as Product;
          final int qty = item['qty'] ?? 0;

          final int harga = p.harga;
          final int subtotal = harga * qty;

          return {
            "id": p.id,
            "nama_barang": p.namaBarang,
            "harga": harga,
            "qty": qty,
            "subtotal": subtotal,
          };
        }).toList();

    final body = {
      "payment_method": tx.paymentMethod,
      "id_transaksi": tx.idTransaksi,
      "total": tx.total,
      "timestamp": tx.timestamp.toIso8601String(),
      "items": items,
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      print("✅ Transaksi berhasil dikirim");
    } else {
      throw Exception(
        "Gagal kirim transaksi: ${response.statusCode} ${response.body}",
      );
    }
  }
  Future<int> getLastTransactionNumber(String date) async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    // Ambil semua transaksi hari ini
    final todayTransactions = data.where((tx) {
      final idTransaksi = tx['idTransaksi'] ?? '';
      return idTransaksi.startsWith("TRX-$date-");
    }).toList();

    if (todayTransactions.isEmpty) {
      return 0; // Belum ada transaksi hari ini
    }

    // Urutkan descending, cari nomor terbesar
    todayTransactions.sort((a, b) {
      final aNum = int.parse(a['idTransaksi'].split('-').last);
      final bNum = int.parse(b['idTransaksi'].split('-').last);
      return bNum.compareTo(aNum);
    });

    final lastId = todayTransactions.first['idTransaksi'];
    final lastNumber = int.parse(lastId.split('-').last);
    return lastNumber;

  } else {
    throw Exception("Gagal mengambil data transaksi");
  }
}


}
