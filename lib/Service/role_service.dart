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

  //   Future<void> initializeDefaultRoles() async {
  //   final defaultRoles = {
  //     'admin': {
  //       'name': 'Admin',
  //       'permissions': [
  //         'manage_users',
  //         'manage_roles',
  //         'view_all_data',
  //         'edit_all_data'
  //       ],
  //     },
  //     'hr_manager': {
  //       'name': 'HR Manager',
  //       'permissions': [
  //         'view_employees',
  //         'manage_employees',
  //         'view_salaries',
  //         'approve_leave'
  //       ],
  //     },
  //     'finance_manager': {
  //       'name': 'Finance Manager',
  //       'permissions': [
  //         'view_invoices',
  //         'manage_invoices',
  //         'view_financial_reports'
  //       ],
  //     },
  //     'general_manager': {
  //       'name': 'General Manager',
  //       'permissions': [
  //         'view_department_data',
  //         'approve_requests',
  //         'manage_schedules'
  //       ],
  //     },
  //   };

  //   final batch = _firestore.batch();

  //   for (final entry in defaultRoles.entries) {
  //     final roleRef = _firestore.collection('roles').doc(entry.key);
  //     batch.set(roleRef, entry.value);
  //   }

  //   await batch.commit();
  // }

    Future<List<Role>> getUserRoles(List<String> roleIds) async {
    if (roleIds.isEmpty) return [];
    
    // Normalize input role IDs to lowercase
    final normalizedRoleIds = roleIds.map((id) => id.toLowerCase()).toList();
    
    try {
      final snapshot = await _firestore
          .collection('roles')
          .where(FieldPath.documentId, whereIn: normalizedRoleIds)
          .get();
          
      return snapshot.docs
          .map((doc) => Role.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching user roles: $e');
      return [];
    }
  }

  // Future<List<Role>> getUserRoles(List<String> roleIds) async {
  //   if (roleIds.isEmpty) return [];
  //   final snapshot = await _firestore
  //       .collection('roles')
  //       .where(FieldPath.documentId, whereIn: roleIds)
  //       .get();

  //   print(snapshot.docs);

  //   return snapshot.docs
  //       .map((doc) => Role.fromFirestore(doc.data(), doc.id))
  //       .toList();
  // }

  Future<void> updateRolePermissions(
      String roleId, List<String> permissions) async {
    await _firestore.collection('roles').doc(roleId).update({
      'permissions': permissions,
    });
  }
}
