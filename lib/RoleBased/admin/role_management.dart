import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:product_list_app/Service/role_service.dart';
import 'package:provider/provider.dart';


class RoleManagement extends StatefulWidget {
  final Role role;

  const RoleManagement({super.key, required this.role});

  @override
  State<RoleManagement> createState() => _RoleManagementState();
}

class _RoleManagementState extends State<RoleManagement> {
  late List<String> _permissions;
  final List<String> _availablePermissions = [
    'view_salaries',
    'edit_salaries',
    'approve_leave',
    'manage_invoices',
    'edit_schedules',
    'manage_users',
  ];

  @override
  void initState() {
    super.initState();
    _permissions = List.from(widget.role.permissions);
  }

  @override
  Widget build(BuildContext context) {
    final roleService = Provider.of<RoleService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.role.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Permissions for ${widget.role.name}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _availablePermissions.length,
                itemBuilder: (context, index) {
                  final permission = _availablePermissions[index];
                  return CheckboxListTile(
                    title: Text(permission),
                    value: _permissions.contains(permission),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _permissions.add(permission);
                        } else {
                          _permissions.remove(permission);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await roleService.updateRolePermissions(
                      widget.role.id, _permissions);
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}