// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

// class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  // Replace with your login logic
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance
                .signInAnonymously()
                .then((onValue) => {
                  print(onValue),
                });
          },
          child: const Text('Login Anonymously'),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> roles = [];
  List<String> permissions = [];

  @override
  void initState() {
    super.initState();
    fetchUserRoles();
  }

  Future<void> fetchUserRoles() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    roles = List<String>.from(userDoc['roles']);

    final rolesSnapshot =
        await FirebaseFirestore.instance.collection('roles').get();
    for (final role in roles) {
      final roleDoc = rolesSnapshot.docs.firstWhere((doc) => doc.id == role);
      permissions.addAll(List<String>.from(roleDoc['permissions']));
    }

    setState(() {});
  }

  bool hasPermission(String permission) => permissions.contains(permission);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          if (hasPermission('view_salaries'))
            const Card(child: ListTile(title: Text('Employee Salaries'))),
          if (hasPermission('view_invoices'))
            const Card(child: ListTile(title: Text('Invoices'))),
          if (hasPermission('approve_leaves'))
            const Card(child: ListTile(title: Text('Leave Approvals'))),
          if (hasPermission('modify_schedules'))
            const Card(child: ListTile(title: Text('Company Schedules'))),
        ],
      ),
    );
  }
}
