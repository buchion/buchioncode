import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:product_list_app/Service/role_service.dart';
import 'package:provider/provider.dart';

import 'role_management.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = Provider.of<RoleService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: FutureBuilder<List<Role>>(
        future: roleService.getRoles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final roles = snapshot.data!;

          return ListView.builder(
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return ListTile(
                title: Text(role.name),
                subtitle: Text(role.permissions.join(', ')),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoleManagement(role: role),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}