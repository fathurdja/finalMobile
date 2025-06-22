import 'package:flutter/material.dart';
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

  Widget buildCartButton(List<Product> products) {
    int totalItem = cart.values.fold(0, (sum, qty) => sum + qty);
    return ElevatedButton.icon(
      onPressed: totalItem > 0 ? () => goToCart(products) : null,
      icon: Icon(Icons.shopping_cart),
      label: Text('Lihat Keranjang ($totalItem)'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Barang")),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final qty = cart[product.id] ?? 0;

                      return ListTile(
                        title: Text(product.namaBarang),
                        subtitle: Text("Rp ${product.harga}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: qty > 0
                                  ? () {
                                      setState(() {
                                        if (qty > 1) {
                                          cart[product.id] = qty - 1;
                                        } else {
                                          cart.remove(product.id);
                                        }
                                      });
                                    }
                                  : null,
                            ),
                            Text(qty.toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => addToCart(product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildCartButton(products),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat produk: ${snapshot.error}'),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
