import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/pages/paymentPage.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    items = widget.cartItems;
  }

  void tambahQty(int index) {
    setState(() {
      items[index]['qty']++;
    });
  }

  void kurangQty(int index) {
    setState(() {
      if (items[index]['qty'] > 1) {
        items[index]['qty']--;
      } else {
        items.removeAt(index);
      }
    });
  }

  int get total => items.fold(0, (sum, item) {
    final product = item['product'] as Product;
    final qty = item['qty'] as int;
    return sum + (product.harga * qty);
  });

  int get totalItems => items.fold(0, (sum, item) => sum + (item['qty'] as int));

  String formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Widget buildCartItem(int index) {
    final product = items[index]['product'] as Product;
    final qty = items[index]['qty'] as int;
    final subtotal = product.harga * qty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFF3B82F6).withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Product Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.namaBarang,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            currencyFormat.format(product.harga),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item dihapus dari keranjang'),
                            backgroundColor: Colors.red[400],
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Quantity Controls & Subtotal
                Row(
                  children: [
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Color(0xFF3B82F6)),
                            onPressed: () => kurangQty(index),
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                          Container(
                            width: 40,
                            child: Text(
                              qty.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Color(0xFF3B82F6)),
                            onPressed: () => tambahQty(index),
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Subtotal
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          currencyFormat.format(subtotal),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');


  Widget buildTotalSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
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
              
              Divider(height: 24),
              
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
              colors: items.isEmpty 
                ? [Colors.grey[300]!, Colors.grey[400]!]
                : [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: items.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentPage(orderItems: items),
                      ),
                    );
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    color: items.isEmpty ? Colors.grey[600] : Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    items.isEmpty ? 'Keranjang Kosong' : 'Lanjut ke Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: items.isEmpty ? Colors.grey[600] : Colors.white,
                    ),
                  ),
                  if (items.isNotEmpty) ...[
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Color(0xFF3B82F6).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Color(0xFF3B82F6).withOpacity(0.6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Keranjang Masih Kosong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Silakan tambahkan produk\nke keranjang terlebih dahulu',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.shopping_bag_outlined),
            label: Text('Mulai Belanja'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🛒 Keranjang Belanja',
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
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Hapus Semua?'),
                    content: Text('Apakah Anda yakin ingin mengosongkan keranjang?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            items.clear();
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Keranjang dikosongkan'),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                        },
                        child: Text('Hapus', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: items.isEmpty
            ? buildEmptyCart()
            : Column(
                children: [
                  // Header Info
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF3B82F6)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Periksa kembali pesanan Anda sebelum melanjutkan ke pembayaran',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: items.length,
                      itemBuilder: (context, index) => buildCartItem(index),
                    ),
                  ),
                  
                  // Total Section
                  buildTotalSection(),
                  
                  // Payment Button
                  buildPaymentButton(),
                  
                  SizedBox(height: 16),
                ],
              ),
      ),
    );
  }
}