class TransactionModel {
  final int idInvoice;
  final String tanggal;
  final String token;
  final int nominal;
  final String jenisPembayaran;
  final String status;

  TransactionModel({
    required this.idInvoice,
    required this.tanggal,
    required this.token,
    required this.nominal,
    required this.jenisPembayaran,
    required this.status,
  });

  /// FROM JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      idInvoice: json['id_invoice'],
      tanggal: json['tanggal'],
      token: json['token'],
      nominal: json['nominal'],
      jenisPembayaran: json['jenis_pembayaran'],
      status: json['status'],
    );
  }

  /// TO JSON (optional, kalau perlu kirim balik)
  Map<String, dynamic> toJson() {
    return {
      'id_invoice': idInvoice,
      'tanggal': tanggal,
      'token': token,
      'nominal': nominal,
      'jenis_pembayaran': jenisPembayaran,
      'status': status,
    };
  }
}
