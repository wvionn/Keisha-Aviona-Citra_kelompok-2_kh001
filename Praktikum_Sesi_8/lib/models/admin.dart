class Admin {
  final int id;
  final String name;
  final String email;
  final String department;

  const Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    String parsedDepartment = 'General';
    if (json['department'] != null &&
        json['department'].toString().trim().isNotEmpty) {
      parsedDepartment = json['department'].toString();
    } else if (json['company'] != null && json['company'] is Map) {
      parsedDepartment = json['company']['name']?.toString() ?? 'General';
    }

    return Admin(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      department: parsedDepartment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
    };
  }
}
