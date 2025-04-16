import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';


class PermissionChecker extends StatelessWidget {
  final List<Role> userRoles;
  final String permission;
  final Widget child;

  const PermissionChecker({
    super.key,
    required this.userRoles,
    required this.permission,
    required this.child,
  });

  bool get hasPermission {
    return userRoles.any((role) => role.permissions.contains(permission));
  }

  @override
  Widget build(BuildContext context) {
    return hasPermission ? child : const SizedBox.shrink();
  }
}