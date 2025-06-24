import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardSaldo extends StatelessWidget {
  final int saldo;
  final String user;

  const CardSaldo({super.key, required this.saldo, required this.user});

  @override
  Widget build(BuildContext context) {
    String tanggal = DateFormat('d MMMM y').format(DateTime.now());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.blue.withOpacity(0.2),
        child: Container(
          height: 160, // Tinggi lebih proporsional
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, const Color(0xFF3B82F6).withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Selamat Datang $user',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tanggal,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  // Ikon dompet
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF3B82F6),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Informasi saldo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Uang Masuk",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${saldo.toString()}",
                        style: const TextStyle(
                          fontSize: 20,
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
    );
  }
}
