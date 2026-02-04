class ClientModel {
  final String expiredDate;
  final String berlangganan;
  final String paket;
  final int price;
  final String pppoeUser;
  final String tipeKoneksi;
  final String email;
  final String roleId;
  final String name;
  final String alamat;
  final String latLng;
  final String phoneNumber;

  ClientModel({
    required this.expiredDate,
    required this.berlangganan,
    required this.paket,
    required this.price,
    required this.pppoeUser,
    required this.tipeKoneksi,
    required this.email,
    required this.roleId,
    required this.name,
    required this.alamat,
    required this.latLng,
    required this.phoneNumber,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      expiredDate: json['expired_date'] ?? '',
      berlangganan: json['berlangganan'] ?? '',
      paket: json['paket'] ?? '',
      price: json['price'] ?? '',
      pppoeUser: json['pppoe_user'] ?? '',
      tipeKoneksi: json['tipe_koneksi'] ?? '',
      email: json['email'] ?? '',
      roleId: json['role_id'] ?? '',
      name: json['name'] ?? '',
      alamat: json['alamat'] ?? '',
      latLng: json['lat_lng'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expired_date': expiredDate,
      'berlangganan': berlangganan,
      'paket': paket,
      'price': price,
      'pppoe_user': pppoeUser,
      'tipe_koneksi': tipeKoneksi,
      'email': email,
      'role_id': roleId,
      'name': name,
      'alamat': alamat,
      'lat_lng': latLng,
      'phone_number': phoneNumber,
    };
  }
}
