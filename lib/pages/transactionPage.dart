import 'package:flutter/material.dart';
import 'package:kasir_klmpk6/model/transaction.dart';
import 'package:kasir_klmpk6/services/transactionService.dart';


class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Transaksi")),
      body: FutureBuilder<List<TransactionModel>>(
        future: TransactionService().fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final transactions = snapshot.data!;
            if (transactions.isEmpty) {
              return Center(child: Text("Belum ada transaksi"));
            }
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ExpansionTile(
                  title: Text("Rp ${tx.total} • ${tx.paymentMethod}"),
                  subtitle: Text(tx.timestamp.toLocal().toString()),
                  children: tx.items.map((item) {
                    return ListTile(
                      title: Text("${item['nama_barang']} x${item['qty']}"),
                      trailing: Text("Rp ${item['subtotal']}"),
                    );
                  }).toList(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
