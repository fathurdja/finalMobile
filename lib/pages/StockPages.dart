import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:kasir_klmpk6/services/product_services.dart';

class StockPage extends StatelessWidget {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Stok')),
      body: FutureBuilder<List<Product>>(
        future: _productService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final p = products[index];
                return ListTile(
                  title: Text(p.namaBarang),
                  subtitle: Text("Rp ${p.harga}"),
                  trailing: Text("Stock: ${p.jumlahStok}"),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat stok: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
