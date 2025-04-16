import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:product_list_app/Widgets/role_based_widget.dart';
import 'package:provider/provider.dart';

import '../../widgets/permission_checker.dart';

class FinanceDashboard extends StatelessWidget {
  const FinanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoles = Provider.of<List<Role>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Financial Overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Invoices Section (visible only with manage_invoices permission)
            PermissionChecker(
              userRoles: userRoles,
              permission: 'manage_invoices',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invoice Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInvoiceItem('INV-2023-001', '\$1,250.00', 'Paid'),
                          const Divider(),
                          _buildInvoiceItem('INV-2023-002', '\$3,450.00', 'Pending'),
                          const Divider(),
                          _buildInvoiceItem('INV-2023-003', '\$2,100.00', 'Overdue'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to invoice creation
                    },
                    child: const Text('Create New Invoice'),
                  ),
                ],
              ),
            ),

            // Budget Section (visible only with view_budget permission)
            PermissionChecker(
              userRoles: userRoles,
              permission: 'view_budget',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Budget Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildBudgetItem('Q1', '\$25,000', '\$22,450'),
                          const Divider(),
                          _buildBudgetItem('Q2', '\$25,000', '\$18,200'),
                          const Divider(),
                          _buildBudgetItem('Q3', '\$25,000', '\$27,800'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Financial Reports (visible only to senior finance roles)
            RoleBasedWidget(
              userRoles: userRoles,
              allowedRoles: ['Senior Finance Manager'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Financial Reports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildReportChip('Annual Report 2023'),
                      _buildReportChip('Q3 Financials'),
                      _buildReportChip('Tax Documents'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(String id, String amount, String status) {
    Color statusColor = Colors.grey;
    if (status == 'Paid') statusColor = Colors.green;
    if (status == 'Overdue') statusColor = Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(amount),
        Chip(
          label: Text(status),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle: TextStyle(color: statusColor),
        ),
      ],
    );
  }

  Widget _buildBudgetItem(String quarter, String budgeted, String actual) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(quarter, style: const TextStyle(fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Budgeted: $budgeted'),
            Text('Actual: $actual'),
          ],
        ),
      ],
    );
  }

  Widget _buildReportChip(String title) {
    return Chip(
      label: Text(title),
      avatar: const Icon(Icons.description, size: 18),
      onDeleted: () {
        // Download or view action
      },
      deleteIcon: const Icon(Icons.download),
    );
  }
}