import 'package:flutter/material.dart';
import 'package:product_list_app/Model/role_model.dart';
import 'package:product_list_app/Model/user_model.dart';
import 'package:product_list_app/RoleBased/RolesHome.dart';
import 'package:product_list_app/RoleBased/auth/login_screen.dart';
import 'package:product_list_app/Service/auth_service.dart';
import 'package:product_list_app/Service/role_service.dart';
import 'package:product_list_app/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'screens/auth/login_screen.dart';
// import 'services/auth_service.dart';
// import 'services/role_service.dart';
// import 'screens/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }



class RoleHomeWrapper extends StatelessWidget {
  const RoleHomeWrapper({super.key});


  @override
  Widget build(BuildContext context) {


    return 
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<RoleService>(create: (_) => RoleService()),
        StreamProvider<AppUser?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Role-Based App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        
        //  ElevatedButton(onPressed: () async {
        //   await AuthService().createTestUsers();
        // }, child: Text("Create User")), // const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppUser?>();

    if (user == null) {
      return const LoginScreen();
    } else {
      return FutureBuilder<List<Role>>(
        future: Provider.of<RoleService>(context).getUserRoles(user.roleIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Provider<List<Role>>.value(
            value: snapshot.data ?? [],
            child: const RolesHome(),
          );
        },
      );
    }
  }
}