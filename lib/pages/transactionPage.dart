import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Gap(40),
            Icon(Icons.receipt, color: Colors.white),
            Gap(5),
            Text(
              "Riwayat Transaksi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
                  icon: const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    DateFormat('dd MMMM yyyy').format(selectedDate),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(150, 40), // Lebar otomatis
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tx = filtered[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF3B82F6).withOpacity(0.1),
                                Colors.white,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                "${currencyFormat.format(tx.total)} • ${tx.paymentMethod}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                                      trailing: Text(
                                        currencyFormat.format(item['harga']),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
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
