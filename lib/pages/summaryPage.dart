import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/pages/homePage.dart';

class SummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final String paymentMethod;
  final int total;

  SummaryPage({
    required this.orderItems,
    required this.paymentMethod,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Transaksi")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Barang yang dibeli:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ...orderItems.map((item) {
                    final product = item['product'] as Product;
                    final qty = item['qty'] as int;
                    return ListTile(
                      title: Text("${product.namaBarang} x$qty"),
                      trailing: Text("Rp ${product.harga * qty}"),
                    );
                  }).toList(),
                  Divider(),
                  ListTile(
                    title: Text("Metode Pembayaran"),
                    trailing: Text(paymentMethod),
                  ),
                  ListTile(title: Text("Total"), trailing: Text("Rp $total")),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.home),
              label: Text("Kembali ke Beranda"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
