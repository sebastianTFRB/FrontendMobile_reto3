class Lead {
  final int id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? preferredArea;
  final double? budget;
  final String? urgency;
  final String? category;
  final double? intentScore;
  final String? notes;
  final String? status;

  Lead({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.preferredArea,
    this.budget,
    this.urgency,
    this.category,
    this.intentScore,
    this.notes,
    this.status,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      preferredArea: json['preferred_area'],
      budget: json['budget']?.toDouble(),
      urgency: json['urgency'],
      category: json['category'],
      intentScore: json['intent_score']?.toDouble(),
      notes: json['notes'],
      status: json['status'],
    );
  }
}
