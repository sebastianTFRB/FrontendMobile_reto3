class Property {
  final int id;
  final int agencyId;
  final String title;
  final String? description;
  final double price;
  final String? area;
  final String? location;
  final int bedrooms;
  final int bathrooms;
  final String? status;
  final String? propertyType;
  final bool parking;
  final List<dynamic>? photos;

  Property({
    required this.id,
    required this.agencyId,
    required this.title,
    this.description,
    required this.price,
    this.area,
    this.location,
    required this.bedrooms,
    required this.bathrooms,
    this.status,
    this.propertyType,
    required this.parking,
    this.photos,
  });

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? 0,
      agencyId: map['agency_id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] as String?,
      price: (map['price'] != null ? (map['price'] as num).toDouble() : 0.0),
      area: map['area'] as String?,
      location: map['location'] as String?,
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      status: map['status'] as String?,
      propertyType: map['property_type'] as String?,
      parking: map['parking'] ?? false,
      photos: map['photos'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agency_id': agencyId,
      'title': title,
      'description': description,
      'price': price,
      'area': area,
      'location': location,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'status': status,
      'property_type': propertyType,
      'parking': parking,
      'photos': photos,
    };
  }
}
