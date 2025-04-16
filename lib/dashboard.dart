// // ignore_for_file: prefer_const_constructors

// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:cooumobile/Component/boxStorage.Strings.dart';
// import 'package:cooumobile/appstate/AppModel.dart';

// import 'package:cooumobile/views/Activity/activity.dart';
// import 'package:cooumobile/views/Settings/Settings.dart';

// import 'package:cooumobile/views/library/library.dart';

// import 'package:cooumobile/views/market/allproducts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_list_app/Page/ECommerce/CheckoutPage.dart';

import 'package:product_list_app/Page/ProductListScreen.dart';
import 'package:product_list_app/Page/RoleBased/RoleBasedAuth.dart';
import 'package:product_list_app/RoleBased/AuthWrapper.dart';
import 'package:product_list_app/RoleBased/RolesHome.dart';
import 'package:provider/provider.dart';

// final box = GetStorage();

class Dashboard extends StatefulWidget {
  static const String routeName = '/Dashboard';

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // AppModel store = AppModel();
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ProductListScreen(),
    ChangeNotifierProvider(
      create: (_) => CheckoutModel(),
      child: CheckoutScreen(),
    ),
    const RoleHomeWrapper(),
    //  AuthWrapper(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SizedBox(
          // height: 90,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.tray_2,
                  size: 28,
                ),
                activeIcon: Icon(
                  CupertinoIcons.tray_2_fill,
                  size: 32,
                  // color: Colors.black,
                  // color: tabIconMarketColor(colorMode, "dark"),
                ),
                label: '5. SCROLLING',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.cart,
                  size: 28,
                  // color: tabIconLibraryColor(colorMode, "light"),
                ),
                activeIcon: Icon(
                  CupertinoIcons.cart_fill_badge_plus,
                  size: 32,
                  // color: tabIconLibraryColor(colorMode, "dark"),
                ),
                label: ' 3. ECOMMERCE',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.ellipses_bubble_fill,
                  size: 28,
                  // color: tabIconActivityColor(colorMode, "light"),
                ),
                activeIcon: Icon(
                  CupertinoIcons.ellipses_bubble_fill,
                  size: 32,
                  // color: tabIconActivityColor(colorMode, "dark"),
                ),
                label: '2. ROLES',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey[800],
            onTap: _onItemTapped,
          ),
        ));
  }
}
