import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_klmpk6/model/transaction.dart';
import 'package:kasir_klmpk6/services/transactionService.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023), // tanggal minimum
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi")),
      body: Column(
        children: [
          // 🔍 Filter Tanggal
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text("Filter Tanggal:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickDate(context),
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                ),
              ],
            ),
          ),

          // 🔄 Daftar Transaksi
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              future: TransactionService().fetchTransactions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allTransactions = snapshot.data!;
                  // Filter hanya transaksi sesuai tanggal
                  final filtered =
                      allTransactions.where((tx) {
                        return DateFormat(
                              'yyyy-MM-dd',
                            ).format(tx.timestamp.toLocal()) ==
                            formattedDate;
                      }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada transaksi di tanggal ini."),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      return ExpansionTile(
                        title: Text("Rp ${tx.total} • ${tx.paymentMethod}"),
                        subtitle: Text(
                          DateFormat(
                            'dd MMM y – HH:mm',
                          ).format(tx.timestamp.toLocal()),
                        ),
                        children:
                            tx.items.map((item) {
                              return ListTile(
                                title: Text(
                                  "${item['nama_barang']} x${item['qty']}",
                                ),
                                trailing: Text("Rp ${item['subtotal']}"),
                              );
                            }).toList(),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
