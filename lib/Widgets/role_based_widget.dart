import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';


class RoleBasedWidget extends StatelessWidget {
  final List<Role> userRoles;
  final List<String> allowedRoles;
  final Widget child;

  const RoleBasedWidget({
    super.key,
    required this.userRoles,
    required this.allowedRoles,
    required this.child,
  });

  bool get isAllowed {
    return userRoles.any((role) => allowedRoles.contains(role.name));
  }

  @override
  Widget build(BuildContext context) {
    return isAllowed ? child : const SizedBox.shrink();
  }
}