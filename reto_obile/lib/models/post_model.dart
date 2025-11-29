class Post {
  final String id;
  final String title;
  final String? description;
  final List<String> photos;
  final List<String> videos;
  final int companyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    this.description,
    required this.photos,
    required this.videos,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      photos: List<String>.from(json['photos'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      companyId: json['company_id'] is int
          ? json['company_id'] as int
          : int.tryParse(json['company_id'].toString()) ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
