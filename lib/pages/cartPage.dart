import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index]['product'] as Product;
                final qty = items[index]['qty'] as int;

                return ListTile(
                  title: Text(product.namaBarang),
                  subtitle: Text("Rp ${product.harga} x $qty"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => kurangQty(index),
                      ),
                      Text(qty.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => tambahQty(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Total"),
            trailing: Text("Rp $total"),
          ),
          ElevatedButton(
            onPressed: items.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentPage(orderItems: items),
                      ),
                    );
                  },
            child: Text("Lanjut ke Pembayaran"),
          ),
        ],
      ),
    );
  }
}
