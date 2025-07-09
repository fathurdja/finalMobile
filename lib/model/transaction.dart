class TransactionModel {
  final String id;
  final String paymentMethod;
  final int total;
  final DateTime timestamp;
  final List<Map<String, dynamic>> items;
  final String idTransaksi;

  TransactionModel({
    required this.id,
    required this.paymentMethod,
    required this.total,
    required this.timestamp,
    required this.items,
    required this.idTransaksi,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      paymentMethod: json['payment_method'],
      total: json['total'],
      timestamp: DateTime.parse(json['timestamp']),
      items: List<Map<String, dynamic>>.from(json['items']),
      idTransaksi: json['id_transaksi'],
    );
  }
}
