import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/pages/StockPages.dart';
import 'package:kasir_klmpk6/pages/orderPage.dart';
import 'package:kasir_klmpk6/pages/transactionPage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildMenuButton(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.teal),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aplikasi Kasir')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildMenuButton(context, "Lihat Stok", Icons.inventory_2, StockPage()),
          buildMenuButton(context, "Order Barang", Icons.shopping_cart, OrderPage()),
          buildMenuButton(context, "Transaksi", Icons.receipt_long, TransactionPage()),
        ],
      ),
    );
  }
}
