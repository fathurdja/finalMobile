import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/pages/StockPages.dart';
import 'package:kasir_klmpk6/pages/orderPage.dart';
import 'package:kasir_klmpk6/pages/transactionPage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

// fungsi untuk membuat tombol menu
  Widget buildMenuButton(BuildContext context, String title, IconData icon, Widget page, Color color) {
    return Container(
     child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      //shadowColor: Color.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8),color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          leading: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Icon(icon,size: 32, color: Colors.white),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_forward_ios, color: Colors.white, size:20),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Color(0xFF3B82F6),
                Color(0xFF1D4ED8),
                
              ] ,
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
            )
          ),
        ),
      ),

      //bagroud
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[
              Color(0xFF3B82F6).withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          //header 
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('👋 Selamat Datang!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pilih menu untuk mulai mengelola toko Anda',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Menu Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMenuButton(
                  context,
                  'Stok Barang',
                  Icons.inventory_2,StockPage(),
                  Color(0xFF3B82F6).withOpacity(0.8),
                  ),
                  SizedBox(height: 20),
                  buildMenuButton(
                  context,
                  'Order Barang',
                  Icons.shopping_cart,OrderPage(),
                  Color(0xFF10B981).withOpacity(0.7)
                  ),
                  SizedBox(height: 20),
                  buildMenuButton(
                  context,
                  'Transaksi',
                  Icons.receipt_long,TransactionPage(),
                  Color(0xFF8B5CF6).withOpacity(0.6),
                  ),

                
                ],
              ),
            ),
          
          ],
        ),
      ),

     
     
    );
  }
}
