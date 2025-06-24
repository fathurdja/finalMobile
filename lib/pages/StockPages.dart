import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/services/product_services.dart';

class StockPage extends StatelessWidget {
  final ProductService _productService = ProductService();

  // Fungsi untuk menentukan warna stock berdasarkan jumlah
  Color getStockColor(int stock) {
    if (stock <= 5) {
      return Colors.red; // Stock sedikit = merah
    } else if (stock <= 20) {
      return Colors.orange; // Stock sedang = orange
    } else {
      return Colors.green; // Stock banyak = hijau
    }
  }

  // Fungsi untuk membuat card produk y
  Widget buildProductCard(Product product) {
    Color stockColor = getStockColor(product.jumlahStok);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        shadowColor: Color(0xFF3B82F6).withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFF3B82F6).withOpacity(0.05)],
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon produk
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: Color(0xFF3B82F6),
                  size: 28,
                ),
              ),

              SizedBox(width: 16),

              // Info produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product.namaBarang,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Harga
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                        Text(
                          "Rp ${product.harga}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stock info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: stockColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: stockColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.warehouse, color: stockColor, size: 20),
                    SizedBox(height: 4),
                    Text(
                      "Stock",
                      style: TextStyle(
                        fontSize: 12,
                        color: stockColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${product.jumlahStok}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: stockColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan ringkasan stock
  Widget buildStockSummary(List<Product> products) {
    int totalProducts = products.length;
    int lowStock = products.where((p) => p.jumlahStok <= 5).length;
    int totalStock = products.fold(0, (sum, p) => sum + p.jumlahStok);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3B82F6).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "📊 Ringkasan Stock",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Total produk
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.inventory, color: Colors.white, size: 24),
                      SizedBox(height: 4),
                      Text(
                        "$totalProducts",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Produk",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Total stock
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.warehouse, color: Colors.white, size: 24),
                      SizedBox(height: 4),
                      Text(
                        "$totalStock",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Total Stock",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Stock rendah
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        lowStock > 0
                            ? Colors.red.withOpacity(0.2)
                            : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning,
                        color: lowStock > 0 ? Colors.red[200] : Colors.white,
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "$lowStock",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: lowStock > 0 ? Colors.red[200] : Colors.white,
                        ),
                      ),
                      Text(
                        "Stock Rendah",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              lowStock > 0 ? Colors.red[200] : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar yang cantik
      appBar: AppBar(
        title: Text(
          "📦 Daftar Stok",
          style: TextStyle(
            fontSize: 22,
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // Background dengan gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Product>>(
          future: _productService.fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!;
              return Column(
                children: [
                  // Ringkasan stock di atas
                  buildStockSummary(products),

                  // List produk
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return buildProductCard(product);
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              // Error state
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    SizedBox(height: 16),
                    Text(
                      'Oops! Gagal memuat stok',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Loading state
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B82F6),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat data stok...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
