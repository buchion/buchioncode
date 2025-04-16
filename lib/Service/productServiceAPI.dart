import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';
import 'package:product_list_app/Model/Product.dart';

class ProductService {
  final String apiUrl = 'https://fakestoreapi.com/products';

  // Future<List<Product>> fetchProductsByCategory(String category) async {
  //   try {
  //     String url = category == 'All'
  //         ? 'https://fakestoreapi.com/products'
  //         : 'https://fakestoreapi.com/products/category/${Uri.encodeComponent(category.toLowerCase())}';

  //     print(url);

  //     final response = await http.get(Uri.parse(url));

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
        
  //       return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  //     }
  //   } catch (e) {
  //     getCachedProducts(category);
  //     print('Error: $e');
  //   }

  //   return [];
  // }

  Future<List<Product>> fetchProductsByCategory(String category) async {
  try {
    String url = category == 'All'
        ? 'https://fakestoreapi.com/products'
        : 'https://fakestoreapi.com/products/category/${Uri.encodeComponent(category.toLowerCase())}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final products = data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();

      await cacheCategoryProducts(category, products); // ✅ Cache success result

      return products;
    }
  } catch (e) {
    print('Error: $e');
    return await getCachedProducts(category); // ✅ Return cache fallback
  }

  return []; // optional fallback
}


  Future<void> cacheCategoryProducts(
      String category, List<Product> products) async {
    final box = await Hive.openBox<List>('product_cached');

    await box.put(category, products.map((p) => p.toJson()).toList());
  }

  Future<List<Product>> getCachedProducts(String category) async {
    final box = await Hive.openBox<List>('product_cached');
    final cached = box.get(category);

    print(cached);

    if (cached != null) {
      return (cached)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<List<Product>> fetchProducts({int page = 1, int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final allProducts = data.map((e) => Product.fromJson(e)).toList();

        final box = await Hive.openBox<Product>('products');
        await box.clear();
        await box.addAll(allProducts);

        final start = (page - 1) * limit;
        final end = start + limit;
        return allProducts.sublist(
            start, end > allProducts.length ? allProducts.length : end);
      }
    } catch (_) {
      final box = await Hive.openBox<Product>('products');
      final cached = box.values.toList();

      final start = (page - 1) * limit;
      final end = start + limit;
      return cached.sublist(start, end > cached.length ? cached.length : end);
    }

    throw Exception("Failed to load products");
  }
}
