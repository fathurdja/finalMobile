import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');


  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Cash',
      'icon': Icons.money,
      'color': Color(0xFF10B981),
      'description': 'Pembayaran tunai langsung',
    },
    {
      'name': 'QRIS',
      'icon': Icons.qr_code_scanner,
      'color': Color(0xFF8B5CF6),
      'description': 'Scan QR untuk pembayaran digital',
    },
    {
      'name': 'Transfer Bank',
      'icon': Icons.account_balance,
      'color': Color(0xFF3B82F6),
      'description': 'Transfer ke rekening bank',
    },
  ];

  int get total => widget.orderItems.fold(0, (sum, item) {
    final product = item['product'] as Product;
    final qty = item['qty'] as int;
    return sum + (product.harga * qty);
  });

  int get totalItems => widget.orderItems.fold(0, (sum, item) => sum + (item['qty'] as int));

  String formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Future<void> handleBayar() async {
    setState(() => isLoading = true);

    final newTransaction = TransactionModel(
      id: '',
      items: widget.orderItems,
      paymentMethod: selectedPayment,
      total: total,
      timestamp: DateTime.now(),
      idTransaksi: await generateTransactionId()
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
          builder: (_) => SummaryPage(
            orderItems: widget.orderItems,
            paymentMethod: selectedPayment,
            total: total,
          ),
        ),
        (route) => false, // ini akan menghapus semua halaman sebelumnya dari stack
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Gagal memproses pembayaran: $e")),
            ],
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildPaymentMethodCard(Map<String, dynamic> method) {
    final bool isSelected = selectedPayment == method['name'];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: isSelected ? 8 : 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: isSelected
                  ? [method['color'].withOpacity(0.1), Colors.white]
                  : [Colors.white, Color(0xFF3B82F6).withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: isSelected
                ? Border.all(color: method['color'], width: 2)
                : null,
          ),
          child: RadioListTile<String>(
            value: method['name'],
            groupValue: selectedPayment,
            onChanged: (val) => setState(() => selectedPayment = val!),
            contentPadding: EdgeInsets.all(16),
            activeColor: method['color'],
            title: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: method['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    method['icon'],
                    color: method['color'],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? method['color'] : Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        method['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOrderSummary() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long, color: Color(0xFF3B82F6)),
                  SizedBox(width: 12),
                  Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Order Items
              Container(
                height: 120,
                child: ListView.builder(
                  itemCount: widget.orderItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.orderItems[index];
                    final product = item['product'] as Product;
                    final qty = item['qty'] as int;
                    final subtotal = product.harga * qty;
                    
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${product.namaBarang} x$qty',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Text(
                            currencyFormat.format(subtotal),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              Divider(height: 24),
              
              // Total Items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    '$totalItems item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Total Payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    currencyFormat.format(total),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: isLoading ? null : handleBayar,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Memproses Pembayaran...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Bayar dengan $selectedPayment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '💳 Metode Pembayaran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
            // Header Info
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pilih cara pembayaran yang paling mudah untuk Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Payment Methods
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...paymentMethods.map((method) => buildPaymentMethodCard(method)),
                    
                    SizedBox(height: 20),
                    
                    // Order Summary
                    buildOrderSummary(),
                    
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Payment Button
            buildPaymentButton(),
            
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  Future<String> generateTransactionId() async {
  // Format tanggal hari ini: yyyyMMdd
  final today = DateFormat('yyyyMMdd').format(DateTime.now());

  // Dapatkan nomor urut terakhir hari ini dari database
  // Misal Anda punya TransactionService.getLastTransactionNumber(today)
  int lastNumber = await TransactionService().getLastTransactionNumber(today);

  // Jika belum ada transaksi hari ini, mulai dari 1
  int newNumber = lastNumber + 1;

  // Format nomor urut jadi 4 digit, misalnya 1 => 0001
  String formattedNumber = newNumber.toString().padLeft(4, '0');

  // Bentuk ID Transaksi lengkap
  return "TRX-$today-$formattedNumber";
}

}