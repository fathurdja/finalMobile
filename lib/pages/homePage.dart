import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/pages/StockPages.dart';
import 'package:kasir_klmpk6/pages/orderPage.dart';
import 'package:kasir_klmpk6/pages/transactionPage.dart';
import 'package:kasir_klmpk6/services/transactionService.dart';
import 'package:kasir_klmpk6/widget/cardSaldo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<int> totalSaldoFuture;

  @override
  void initState() {
    super.initState();
    totalSaldoFuture = fetchTotalUangMasuk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🧾 Aplikasi KasirKu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // ⬇️ Ganti dengan FutureBuilder
            FutureBuilder<int>(
              future: totalSaldoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Gagal memuat saldo"),
                  );
                } else {
                  int totalSaldo = snapshot.data ?? 0;
                  return CardSaldo(saldo: totalSaldo, user: "fathur");
                }
              },
            ),
            // Menu Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildMenuButton(
                    context,
                    'Stok Barang',
                    Icons.inventory_2,
                    StockPage(),
                    const Color(0xFF3B82F6).withOpacity(0.8),
                  ),
                  const SizedBox(height: 20),
                  buildMenuButton(
                    context,
                    'Order',
                    Icons.shopping_cart,
                    OrderPage(),
                    const Color(0xFF10B981).withOpacity(0.7),
                  ),
                  const SizedBox(height: 20),
                  buildMenuButton(
                    context,
                    'Transaksi',
                    Icons.receipt_long,
                    TransactionPage(),
                    const Color(0xFF8B5CF6).withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk hitung total dari API
  Future<int> fetchTotalUangMasuk() async {
    try {
      final transaksi = await TransactionService().fetchTransactions();
      // Pastikan tx.total adalah int
      int total = transaksi.fold(0, (sum, tx) => sum + tx.total);
      return total;
    } catch (e) {
      debugPrint("Gagal menghitung total uang masuk: $e");
      return 0;
    }
  }

  // Fungsi buat tombol menu tetap sama
  Widget buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
        ),
      ),
    );
  }
}
