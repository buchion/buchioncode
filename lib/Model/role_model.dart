class Role {
  final String id;
  final String name;
  final List<String> permissions;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Role.fromFirestore(Map<String, dynamic> data, String id) {
    return Role(
      id: id,
      name: data['name'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'permissions': permissions,
    };
  }
}