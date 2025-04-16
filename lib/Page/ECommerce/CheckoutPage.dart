import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {


  //  CheckoutScreen({super.key});

  

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {



  Future<void> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    print(snapshot.docs);
    // allProducts = snapshot.docs.map((doc) {
    //   final data = doc.data();
    //   return Product(
    //     data['name'],
    //     data['price'].toDouble(),
    //     data['weight'].toDouble(),
    //   );
    // }).toList();

    // notifyListeners();
  }

    final model = Provider.of<CheckoutModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: model.allProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Cart Items",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: model.allProducts.map((item) {
                      return FilterChip(
                        label: Text(item.name),
                        selected: model.cartItems.contains(item.name),
                        onSelected: (bool selected) {
                          model.toggleItem(item.name);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text("Subtotal: \$${model.subtotal.toStringAsFixed(2)}"),
                  Text(
                      "Delivery Fee: \$${model.deliveryFee.toStringAsFixed(2)}"),
                  Text(
                      "Discount: -\$${model.totalDiscount.toStringAsFixed(2)}"),
                  const Divider(),
                  Text("Total: \$${model.finalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  DropdownButton<String>(
                    value: model.location,
                    items: ['Local', 'Remote'].map((loc) {
                      return DropdownMenuItem(value: loc, child: Text(loc));
                    }).toList(),
                    onChanged: (val) => model.updateLocation(val!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>  model.submitOrder(),
                    child: const Text("Place Order"),
                  )
                ],
              ),
            ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final double weight;

  Product(this.name, this.price, this.weight);
}

class CheckoutModel with ChangeNotifier {
  List<String> cartItems = [];
  String location = 'Local';
// List<Product> allProducts = [];

  final List<Product> allProducts = [
    Product("Laptop", 800, 2.5),
    Product("Headphones", 100, 0.5),
    Product("Mouse", 40, 0.2),
    Product("Keyboard", 60, 0.8),
  ];

  double get subtotal => cartItems.fold(0, (sum, name) {
        return sum + allProducts.firstWhere((p) => p.name == name).price;
      });

  double get totalWeight => cartItems.fold(0, (sum, name) {
        return sum + allProducts.firstWhere((p) => p.name == name).weight;
      });

  double get deliveryFee {
    double baseFee = location == "Remote" ? 10 : 5;
    double weightFee = totalWeight * 0.5;
    return baseFee + weightFee;
  }

  double get cartDiscount {
    if (subtotal >= 1000) return subtotal * 0.12;
    if (subtotal >= 500) return subtotal * 0.08;
    if (subtotal >= 100) return subtotal * 0.05;
    return 0;
  }

  double get comboDiscount {
    if (cartItems.contains("Laptop") && cartItems.contains("Headphones")) {
      return (subtotal - cartDiscount) * 0.10;
    }
    return 0;
  }

  double get totalDiscount => cartDiscount + comboDiscount;

  double get finalAmount => subtotal - totalDiscount + deliveryFee;

  void toggleItem(String name) {
    if (cartItems.contains(name)) {
      cartItems.remove(name);
    } else {
      cartItems.add(name);
    }
    notifyListeners();
  }

  void updateLocation(String loc) {
    location = loc;
    notifyListeners();
  }

  void submitOrder() async {
    await FirebaseFirestore.instance.collection('orders').add({
      'items': cartItems,
      'subtotal': subtotal,
      'discount': totalDiscount,
      'deliveryFee': deliveryFee,
      'finalAmount': finalAmount,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<CheckoutModel>(context);

//     print(model.allProducts.length);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Checkout")),
//       body: 
//       // model.allProducts.isEmpty
//       //     ? const Center(child: CircularProgressIndicator())
//       //     : 
//           Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Cart Items",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: model.allProducts.map((item) {
//                       return FilterChip(
//                         avatar: CircleAvatar(
//                           backgroundImage: NetworkImage(item.imageUrl),
//                         ),
//                         label: Text(item.name),
//                         selected: model.cartItems.contains(item.name),
//                         onSelected: (bool selected) {
//                           model.toggleItem(item.name);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   Text("Subtotal: \$${model.subtotal.toStringAsFixed(2)}"),
//                   Text(
//                       "Delivery Fee: \$${model.deliveryFee.toStringAsFixed(2)}"),
//                   Text(
//                       "Discount: -\$${model.totalDiscount.toStringAsFixed(2)}"),
//                   const Divider(),
//                   Text("Total: \$${model.finalAmount.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   DropdownButton<String>(
//                     value: model.location,
//                     items: ['Local', 'Remote'].map((loc) {
//                       return DropdownMenuItem(value: loc, child: Text(loc));
//                     }).toList(),
//                     onChanged: (val) => model.updateLocation(val!),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () => model.submitOrder(),
//                     child: const Text("Place Order"),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class Product {
//   final String name;
//   final double price;
//   final double weight;
//   final String imageUrl;

//   Product(this.name, this.price, this.weight, this.imageUrl);
// }

// class CheckoutModel with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Product> allProducts = [];
//   List<String> cartItems = [];
//   String location = 'Local';

//   void listenToProducts() {
//     _firestore.collection('products').snapshots().listen((snapshot) {
//       allProducts = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Product(
//           data['name'],
//           data['price'].toDouble(),
//           data['weight'].toDouble(),
//           data['imageUrl'],
//         );
//       }).toList();
//       notifyListeners();
//     });
//   }

//   double get subtotal => cartItems.fold(0, (sum, name) {
//         return sum + allProducts.firstWhere((p) => p.name == name).price;
//       });

//   double get totalWeight => cartItems.fold(0, (sum, name) {
//         return sum + allProducts.firstWhere((p) => p.name == name).weight;
//       });

//   double get deliveryFee {
//     double baseFee = location == "Remote" ? 10 : 5;
//     double weightFee = totalWeight * 0.5;
//     return baseFee + weightFee;
//   }

//   double get cartDiscount {
//     if (subtotal >= 1000) return subtotal * 0.12;
//     if (subtotal >= 500) return subtotal * 0.08;
//     if (subtotal >= 100) return subtotal * 0.05;
//     return 0;
//   }

//   double get comboDiscount {
//     if (cartItems.contains("Laptop") && cartItems.contains("Headphones")) {
//       return (subtotal - cartDiscount) * 0.10;
//     }
//     return 0;
//   }

//   double get totalDiscount => cartDiscount + comboDiscount;

//   double get finalAmount => subtotal - totalDiscount + deliveryFee;

//   void toggleItem(String name) {
//     if (cartItems.contains(name)) {
//       cartItems.remove(name);
//     } else {
//       cartItems.add(name);
//     }
//     notifyListeners();
//   }

//   void updateLocation(String loc) {
//     location = loc;
//     notifyListeners();
//   }

//   void submitOrder() async {
//     await _firestore.collection('orders').add({
//       'items': cartItems,
//       'subtotal': subtotal,
//       'discount': totalDiscount,
//       'deliveryFee': deliveryFee,
//       'finalAmount': finalAmount,
//       'location': location,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     debugPrint("Order placed: \$${finalAmount.toStringAsFixed(2)}");
//   }
// }
