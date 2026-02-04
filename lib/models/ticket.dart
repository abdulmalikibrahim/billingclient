class TicketModel {
  final String kodeTicket;
  final String tipeProblem;
  final String problem;
  final String status;
  final String difficulty;
  final String createdDate;
  final String namaTeknisi;

  TicketModel({
    required this.kodeTicket,
    required this.tipeProblem,
    required this.problem,
    required this.status,
    required this.difficulty,
    required this.createdDate,
    required this.namaTeknisi,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      kodeTicket: json['kode_ticket'] ?? '',
      tipeProblem: json['tipe_problem'] ?? '',
      problem: json['problem'] ?? '',
      status: json['status'] ?? '',
      difficulty: json['difficulty'] ?? '',
      createdDate: json['created_date'] ?? '',
      namaTeknisi: json['nama_teknisi'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_ticket': kodeTicket,
      'tipe_problem': tipeProblem,
      'problem': problem,
      'status': status,
      'difficulty': difficulty,
      'created_date': createdDate,
      'nama_teknisi': namaTeknisi,
    };
  }
}
