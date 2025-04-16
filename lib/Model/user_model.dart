class  AppUser {
  final String id;
  final String email;
  final List<String> roleIds;

  AppUser({
    required this.id,
    required this.email,
    required this.roleIds,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      roleIds: List<String>.from(data['roles'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'roles': roleIds,
    };
  }
}