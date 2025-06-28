import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/pages/cartPage.dart';
import 'package:kasir_klmpk6/services/product_services.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Product>> _futureProducts;
  Map<String, int> cart = {}; // productId: qty

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService().fetchProducts();
  }

  void addToCart(Product product) {
    setState(() {
      cart[product.id] = (cart[product.id] ?? 0) + 1;
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      if (cart.containsKey(product.id)) {
        if (cart[product.id]! > 1) {
          cart[product.id] = cart[product.id]! - 1;
        } else {
          cart.remove(product.id);
        }
      }
    });
  }

  void goToCart(List<Product> products) {
    final orderItems = products
        .where((p) => cart.containsKey(p.id))
        .map((p) => {
              'product': p,
              'qty': cart[p.id]!,
            })
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(cartItems: orderItems),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    final qty = cart[product.id] ?? 0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
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
            child: Row(
              children: [
                // Product Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.inventory_2,
                    color: Color(0xFF3B82F6),
                    size: 30,
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
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
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
                        onPressed: qty > 0 ? () => removeFromCart(product) : null,
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
                        onPressed: () => addToCart(product),
                        padding: EdgeInsets.all(8),
                        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
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

  Widget buildCartFloatingButton(List<Product> products) {
    int totalItem = cart.values.fold(0, (sum, qty) => sum + qty);
    double totalPrice = products
        .where((p) => cart.containsKey(p.id))
        .fold(0.0, (sum, p) => sum + (p.harga * cart[p.id]!));

    if (totalItem == 0) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () => goToCart(products),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Keranjang ($totalItem item)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currencyFormat.format(totalPrice),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
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

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🛒 Order Barang',
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
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!;
              return Stack(
                children: [
                  Column(
                    children: [
                      // Header Section
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Pilih Produk',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tambahkan produk ke keranjang belanja Anda',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      // Products List
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 100),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return buildProductCard(products[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  // Floating Cart Button
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: buildCartFloatingButton(products),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Gagal memuat produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat produk...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}