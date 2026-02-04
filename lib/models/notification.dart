class LocalNotification {
  final int? id;
  final String title;
  final String description;
  final String? image;
  final bool isRead;
  final DateTime createdAt;

  LocalNotification({
    this.id,
    required this.title,
    required this.description,
    this.image,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'image': image,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
    // Hanya sertakan id jika bukan null (untuk update)
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory LocalNotification.fromMap(Map<String, dynamic> map) {
    return LocalNotification(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['image'],
      isRead: map['is_read'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
