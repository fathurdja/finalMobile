import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/pages/homePage.dart';
import 'package:kasir_klmpk6/pages/printbluetooth.dart'; // Pastikan import halaman Printbluetooth kamu!

class SummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final String paymentMethod;
  final int total;

  SummaryPage({
    super.key,
    required this.orderItems,
    required this.paymentMethod,
    required this.total,
  });
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt, color: Colors.white),
            Gap(5),
            Text(
              "Detail Transaksi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Barang yang dibeli:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView(
                  children: [
                    ...orderItems.map((item) {
                      final product = item['product'] as Product;
                      final qty = item['qty'] as int;
                      return ListTile(
                        title: Text("${product.namaBarang} x$qty", style: TextStyle(fontWeight: FontWeight.bold),),
                        trailing: Text(currencyFormat.format(product.harga), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                      );
                    }).toList(),
                    Divider(color: Colors.black,),
                    ListTile(
                      title: Text(
                        "Metode Pembayaran",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        paymentMethod,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(currencyFormat.format(total), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        buttonSize: Size(70, 70),
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        animatedIconTheme: IconThemeData(color: Colors.white, size: 30),
        children: [
          SpeedDialChild(
            backgroundColor: Colors.red,
            child: Icon(Icons.home, color: Colors.white),
            label: 'Beranda',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false,
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.print, color: Colors.white),
            label: 'Cetak Struk',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => Printbluetooth(
                        orderItems: orderItems,
                        paymentMethod: paymentMethod,
                        total: total,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
