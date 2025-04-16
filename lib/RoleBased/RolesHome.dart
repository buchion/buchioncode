import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:product_list_app/Model/user_model.dart';
import 'package:product_list_app/Service/auth_service.dart';
import 'package:product_list_app/Service/role_service.dart';
import 'package:product_list_app/RoleBased/finance/finance_dashboard.dart';
import 'package:product_list_app/RoleBased/manager/manager_dashboard.dart';
import 'package:provider/provider.dart';

import '../widgets/role_based_widget.dart';
import '../widgets/permission_checker.dart';
import 'admin/admin_panel.dart';
import 'hr/hr_dashboard.dart';

class RolesHome extends StatelessWidget {
  const RolesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final roleService = Provider.of<RoleService>(context);
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<List<Role>>(
      future: roleService.getUserRoles(user.roleIds),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userRoles = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Role-Based App'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authService.signOut(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                RoleBasedWidget(
                  userRoles: userRoles,
                  allowedRoles: const ['Admin'],
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanel(),
                        ),
                      );
                    },
                    child: const Text('Admin Panel'),
                  ),
                ),
                RoleBasedWidget(
                  userRoles: userRoles,
                  allowedRoles: const ['HR Manager'],
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HRDashboard(),
                        ),
                      );
                    },
                    child: const Text('HR Dashboard'),
                  ),
                ),

                RoleBasedWidget(
                  userRoles: userRoles,
                  allowedRoles: const ['Finance Manager'],
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinanceDashboard(),
                        ),
                      );
                    },
                    child: const Text('Finance Dashboard'),
                  ),
                ),

                RoleBasedWidget(
                  userRoles: userRoles,
                  allowedRoles: const ['General Manager'],
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerDashboard(),
                        ),
                      );
                    },
                    child: const Text('Manager Dashboard'),
                  ),
                ),

                PermissionChecker(
                  userRoles: userRoles,
                  permission: 'view_salaries',
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'Salary Information (visible only to users with view_salaries permission)'),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Your Roles:'),

                Column(
                  children: userRoles
                      .map((role) => ListTile(
                            title: Text(role.name, style: const TextStyle(color: Colors.black),),
                            subtitle: Text(role.permissions.join(', ')),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
