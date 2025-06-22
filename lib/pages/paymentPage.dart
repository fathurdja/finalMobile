import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/model/transaction.dart';
import 'package:kasir_klmpk6/pages/summaryPage.dart';
import 'package:kasir_klmpk6/services/product_services.dart';
import 'package:kasir_klmpk6/services/transactionService.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;

  PaymentPage({required this.orderItems});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPayment = "Cash";
  bool isLoading = false;

  int get total => widget.orderItems.fold(0, (sum, item) {
    final product = item['product'] as Product;
    final qty = item['qty'] as int;
    return sum + (product.harga * qty);
  });

  Future<void> handleBayar() async {
    setState(() => isLoading = true);

    final newTransaction = TransactionModel(
      id: '',
      items: widget.orderItems,
      paymentMethod: selectedPayment,
      total: total,
      timestamp: DateTime.now(),
    );

    try {
      // 🔍 Debug print transaksi
      print("==== Transaksi akan dikirim ====");
      print("Metode Bayar: $selectedPayment");
      print("Total: $total");
      for (var item in widget.orderItems) {
        final Product p = item['product'];
        final int qty = item['qty'];
        print(
          "Barang: ${p.namaBarang}, Harga: ${p.harga}, Qty: $qty, Subtotal: ${p.harga * qty}",
        );
      }
      print("=================================");

      // Kirim transaksi
      await TransactionService().sendTransaction(newTransaction);

      // Kurangi stok produk
      for (var item in widget.orderItems) {
        final Product p = item['product'];
        final int qty = item['qty'];
        await ProductService().reduceStock(p.id, qty);
      }

      // Pindah ke SummaryPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (_) => SummaryPage(
                orderItems: widget.orderItems,
                paymentMethod: selectedPayment,
                total: total,
              ),
        ),
        (route) =>
            false, // ini akan menghapus semua halaman sebelumnya dari stack
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal membayar: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Metode Pembayaran")),
      body: Column(
        children: [
          ListTile(
            title: Text("Cash"),
            leading: Radio<String>(
              value: "Cash",
              groupValue: selectedPayment,
              onChanged: (val) => setState(() => selectedPayment = val!),
            ),
          ),
          ListTile(
            title: Text("QRIS"),
            leading: Radio<String>(
              value: "QRIS",
              groupValue: selectedPayment,
              onChanged: (val) => setState(() => selectedPayment = val!),
            ),
          ),
          ListTile(
            title: Text("Transfer Bank"),
            leading: Radio<String>(
              value: "Transfer Bank",
              groupValue: selectedPayment,
              onChanged: (val) => setState(() => selectedPayment = val!),
            ),
          ),
          SizedBox(height: 20),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(onPressed: handleBayar, child: Text("Bayar")),
        ],
      ),
    );
  }
}
