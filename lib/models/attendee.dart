class Attendee {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final String? designation;
  final int? createdAt;
  final int? updatedAt;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.designation,
    this.createdAt,
    this.updatedAt,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      company: json['company']?.toString(),
      designation: json['designation']?.toString(),
      createdAt: json['createdAt'] is int ? json['createdAt'] : null,
      updatedAt: json['updatedAt'] is int ? json['updatedAt'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (company != null) 'company': company,
      if (designation != null) 'designation': designation,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
    
    // Remove null values for cleaner JSON
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Attendee copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? company,
    String? designation,
    int? createdAt,
    int? updatedAt,
  }) {
    return Attendee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  String toString() {
    return 'Attendee(id: $id, name: $name, email: $email, phone: $phone, company: $company, designation: $designation)';
  }
}
