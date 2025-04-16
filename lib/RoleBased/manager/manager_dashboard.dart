import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/permission_checker.dart';
import '../../widgets/role_based_widget.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoles = Provider.of<List<Role>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Actions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Manager Tools',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Schedule Management
            PermissionChecker(
              userRoles: userRoles,
              permission: 'edit_schedules',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Company Schedules',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildScheduleItem('Team Meeting', 'Mon 10:00 AM', 'Conference Room A'),
                      const Divider(),
                      _buildScheduleItem('Project Deadline', 'Fri 5:00 PM', 'All Teams'),
                      const Divider(),
                      _buildScheduleItem('Quarterly Review', 'Next Month', 'Main Hall'),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Schedule'),
                        onPressed: () {
                          // Add schedule logic
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Team Management
            RoleBasedWidget(
              userRoles: userRoles,
              allowedRoles: ['General Manager', 'Senior Manager'],
              child: Card(
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Team Management',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildTeamAction(Icons.group, 'View Team'),
                          _buildTeamAction(Icons.person_add, 'Add Member'),
                          _buildTeamAction(Icons.assignment, 'Assign Tasks'),
                          _buildTeamAction(Icons.assessment, 'Performance'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Approval Section
            PermissionChecker(
              userRoles: userRoles,
              permission: 'approve_requests',
              child: Card(
                margin: const EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pending Approvals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildApprovalItem('Leave Request', 'John Doe', 'Pending'),
                      const Divider(),
                      _buildApprovalItem('Expense Report', 'Jane Smith', 'Pending'),
                      const Divider(),
                      _buildApprovalItem('Purchase Order', 'Mike Johnson', 'Pending'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Bulk approve
                            },
                            child: const Text('Approve All'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Review all
                            },
                            child: const Text('Review All'),
                          ),
                        ],
                      ),
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

  Widget _buildScheduleItem(String title, String time, String location) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: Text(title),
      subtitle: Text('$time • $location'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // Edit schedule
        },
      ),
    );
  }

  Widget _buildTeamAction(IconData icon, String label) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        // Action logic
      },
    );
  }

  Widget _buildApprovalItem(String type, String name, String status) {
    return ListTile(
      leading: const Icon(Icons.notifications_active),
      title: Text('$type from $name'),
      subtitle: Text(status),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              // Approve
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              // Reject
            },
          ),
        ],
      ),
    );
  }
}