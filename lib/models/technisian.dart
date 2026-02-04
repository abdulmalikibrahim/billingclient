class TechnisianModel {
  final String? idTeknisi;
  final String name;

  TechnisianModel({
    this.idTeknisi,
    required this.name,
  });

  factory TechnisianModel.fromJson(Map<String, dynamic> json) {
    return TechnisianModel(
      idTeknisi: json['id_teknisi'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_teknisi': idTeknisi,
      'name': name,
    };
  }
}
