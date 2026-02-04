class TransactionDetailModel {
  final String nama;
  final String paket;
  final String berlangganan;
  final String invoice;
  final String orderId;
  final String createdDate;
  final String? paymentDate;
  final int biayaLain;
  final int tagihan;
  final int ppn;
  final int discount;
  final int feeAdmin;
  final int totalPayment;
  final String paymentPeriod;
  final String method;
  final String status;
  final String nomorTujuan;
  final String penerima;
  final String keterangan;
  final String? urlPayment;
  final String? urlCheckStatus;
  final String? urlPrintInvoice;

  TransactionDetailModel({
    required this.nama,
    required this.paket,
    required this.berlangganan,
    required this.invoice,
    required this.orderId,
    required this.createdDate,
    required this.paymentDate,
    required this.biayaLain,
    required this.tagihan,
    required this.ppn,
    required this.discount,
    required this.feeAdmin,
    required this.totalPayment,
    required this.paymentPeriod,
    required this.method,
    required this.status,
    required this.nomorTujuan,
    required this.penerima,
    required this.keterangan,
    required this.urlPayment,
    required this.urlCheckStatus,
    required this.urlPrintInvoice,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {

    int parseInt(dynamic value) {
      if (value == null) return 0;
      return int.tryParse(value.toString()) ?? 0;
    }

    return TransactionDetailModel(
      nama: json['nama']?.toString() ?? '-',
      paket: json['paket']?.toString() ?? '-',
      berlangganan: json['berlangganan']?.toString() ?? '-',
      invoice: json['invoice']?.toString() ?? '-',
      orderId: json['order_id']?.toString() ?? '-',
      createdDate: json['created_date'],
      paymentDate: json['payment_date'],
      biayaLain: parseInt(json['biaya_lain']),
      tagihan: parseInt(json['tagihan']),
      ppn: parseInt(json['ppn']),
      discount: parseInt(json['discount']),
      feeAdmin: parseInt(json['fee_admin']),
      totalPayment: parseInt(json['total_payment']),
      paymentPeriod: json['payment_period']?.toString() ?? '-',
      method: json['method']?.toString() ?? '-',
      status: json['status']?.toString() ?? '-',
      nomorTujuan: json['nomor_tujuan']?.toString() ?? '-',
      penerima: json['penerima']?.toString() ?? '-',
      keterangan: json['keterangan']?.toString() ?? '-',
      urlPayment: json['url_payment']?.toString(),
      urlCheckStatus: json['url_check_status']?.toString(),
      urlPrintInvoice: json['url_print_invoice']?.toString(),
    );
  }
}
