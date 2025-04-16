import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/permission_checker.dart';

class HRDashboard extends StatelessWidget {
  const HRDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoles = Provider.of<List<Role>>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('HR Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HR Manager View', style: TextStyle(fontSize: 24)),
            
            // Only visible if user has view_salaries permission
            PermissionChecker(
              userRoles: userRoles,
              permission: 'view_salaries',
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee Salaries', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('John Doe: \$75,000'),
                      Text('Jane Smith: \$82,000'),
                      Text('Mike Johnson: \$68,000'),
                    ],
                  ),
                ),
              ),
            ),

            // Only visible if user has approve_leave permission
            PermissionChecker(
              userRoles: userRoles,
              permission: 'approve_leave',
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pending Leave Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('John Doe: Vacation (5 days)'),
                      Text('Jane Smith: Sick Leave (2 days)'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}