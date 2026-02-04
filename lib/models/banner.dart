class BannerModel {
  final String id;
  final String? name;
  final String? imageBanner;
  final String? bodyBanner;
  final String? linkBanner; // ✅ property baru

  BannerModel({
    required this.id,
    this.name,
    this.imageBanner,
    this.bodyBanner,
    this.linkBanner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      name: json['name']?.toString(),
      imageBanner: json['image_banner']?.toString(),
      bodyBanner: json['body_banner']?.toString(),
      linkBanner: json['link_banner']?.toString(), // ✅ parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_banner': imageBanner,
      'body_banner': bodyBanner,
      'link_banner': linkBanner, // ✅ include
    };
  }
}
