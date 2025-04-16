import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_list_app/Model/role_model.dart';
// import '../models/role_model.dart';

class RoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Role>> getRoles() async {
    final snapshot = await _firestore.collection('roles').get();
    return snapshot.docs
        .map((doc) => Role.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<Role>> getUserRoles(List<String> roleIds) async {
    if (roleIds.isEmpty) return [];
    final snapshot = await _firestore
        .collection('roles')
        .where(FieldPath.documentId, whereIn: roleIds)
        .get();
    return snapshot.docs
        .map((doc) => Role.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateRolePermissions(
      String roleId, List<String> permissions) async {
    await _firestore.collection('roles').doc(roleId).update({
      'permissions': permissions,
    });
  }
}