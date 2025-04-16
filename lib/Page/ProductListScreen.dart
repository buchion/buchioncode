import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:product_list_app/Model/Product.dart';
import 'package:product_list_app/Service/productServiceAPI.dart';
import 'package:product_list_app/Utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int page = 1;

  bool isLoading = false;
  List<Product> products = [];
  final ProductService _productService = ProductService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final searchNode = FocusNode();
  final searchCtrl = TextEditingController();

  String searchQuery = '';
  List<Product> allCategoryProducts = [];

  String? selectedCategory;
  // List<String> categories = [
  //   'All',
  //   'Electronics',
  //   'Jewelery',
  //   'Men\'s clothing',
  //   'Women\'s clothing'
  // ];

  bool showSearch = false;
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  void _applySearchFilter() {
    if (searchQuery.isEmpty) {
      filteredProducts = allCategoryProducts;
    } else {
      filteredProducts = allCategoryProducts.where((product) {
        return product.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  // void _filterByCategory() async {
  //   final cached = await getCachedProducts(selectedCategory!);

  //   if (cached.isNotEmpty) {
  //     setState(() {
  //       allCategoryProducts = cached;
  //       _applySearchFilter();
  //     });
  //     return;
  //   }

  //   final fetched =
  //       await _productService.fetchProductsByCategory(selectedCategory!);

  //   if (fetched.isNotEmpty) {
  //     await cacheCategoryProducts(selectedCategory!, fetched);
  //   }

  //   setState(() {
  //     allCategoryProducts = fetched;
  //     _applySearchFilter();
  //   });
  // }

  void _filterByCategory() async {
    List<Product> cached = await getCachedProducts(selectedCategory!);
    if (cached.isNotEmpty) {
      print('Loaded ${selectedCategory!} from cache');
      setState(() => filteredProducts = cached);
      return;
    }
    final fetched =
        await _productService.fetchProductsByCategory(selectedCategory!);

    print(fetched);

    if (fetched.isNotEmpty) {
      await cacheCategoryProducts(selectedCategory!, fetched);
    }
    setState(() => filteredProducts = fetched);
  }

  Future<void> cacheCategoryProducts(
      String category, List<Product> products) async {
    final box = await Hive.openBox<List>('product_cached');

    // Store list of products as Map
    await box.put(category, products.map((p) => p.toJson()).toList());
  }

  Future<List<Product>> getCachedProducts(String category) async {
    final box = await Hive.openBox<List>('product_cached');
    box.clear();
    final cached = box.get(category);

    if (cached != null) {
      return (cached)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = 'All';
    _loadProducts();
    _filterByCategory();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Product> newProducts =
          await _productService.fetchProducts(page: page);
      setState(() {
        products.addAll(newProducts);
        page++;
      });
    } catch (e) {
      // Handle error
    }

    setState(() {
      isLoading = false;
    });
  }

  void _onRefresh() async {
    setState(() {
      page = 1;
      // products.clear();
    });
    await _loadProducts();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await _loadProducts();
    _refreshController.loadComplete();
  }

  List categoryData = [
    // {Icon: Icons.star, "Text": "All", Color: Colors.blue[700], "Category": "All"},
    {
      Icon: null,
      SvgPicture: SvgPicture.asset(
        'assets/marketicons/jewelry.svg',
        width: 35,
        height: 35,
      ),
      "Text": "Jewelery",
      "Category": "Jewelery",
    },
    {
      Icon: null,
      SvgPicture: SvgPicture.asset(
        'assets/marketicons/electronics.svg',
        width: 35,
        height: 35,
      ),
      "Text": "Electronics",
      "Category": "Electronics",
    },
    {
      Icon: null,
      SvgPicture: SvgPicture.asset(
        'assets/marketicons/dress.svg',
        width: 35,
        height: 35,
      ),
      "Text": "Dresses",
      "Category": "Women's clothing",
    },

    {
      Icon: null,
      SvgPicture: SvgPicture.asset(
        'assets/marketicons/shirt.svg',
        width: 35,
        height: 35,
      ),
      "Text": "Shirts",
      "Category": "Men's clothing",
    },
    {
      Icon: null,
      SvgPicture: SvgPicture.asset(
        'assets/marketicons/trousers.svg',
        width: 35,
        height: 35,
      ),
      "Text": "Trousers",
      "Category": "Men's clothing",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: showSearch == true ? null : const Text('Products'),
        centerTitle: false,
        actions: [
          // SizedBox(
          //   // width: width * .1,
          //   child: DropdownButton<String>(
          //     menuWidth: width * .3,
          //     value: selectedCategory,
          //     onChanged: (newCategory) {
          //       setState(() {
          //         selectedCategory = newCategory!;
          //         _filterByCategory();
          //       });
          //     },
          //     items: categories.map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),

          if (showSearch == false) ...[
            // Row(
            //   children: [

            IconButton(
                onPressed: () {
                  setState(() {
                    showSearch = true;
                  });
                  // Navigator.pushNamed( context, SearchProductPage.routeName);
                },
                icon: const Icon(CupertinoIcons.search,
                    size: 30, color: Colors.blue)),
          ],
          if (showSearch == true) ...[
            SizedBox(
              width: width,
              child: TextFormField(
                controller: searchCtrl,
                style: const TextStyle(fontWeight: FontWeight.w400),
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchCtrl.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: const Icon(CupertinoIcons.xmark),
                  ),
                  hintText: 'Search for anything',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onChanged: (String value) {
                  _applySearchFilter();
                  if (value.isNotEmpty) {
                    // searchProducts(value);
                  }
                  setState(() {});
                },
                onEditingComplete: () {
                  // searchProductText();
                  // FocusScope.of(context).unfocus();
                },
              ),
            )
          ],
        ],
      ),
      body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          child: Column(
            children: [
              SizedBox(
                height: 80.0,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      const SizedBox(
                        width: 20,
                      ),
                      for (var cats in categoryData) ...[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory =
                                  cats["Category"].toString().toLowerCase();
                              _filterByCategory();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: cats[Icon].runtimeType == IconData
                                      ? Icon(
                                          cats[Icon],
                                          size: 35,
                                          color: cats[Color],
                                        )
                                      : cats[SvgPicture],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                cats["Text"].toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ]),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return ListTile(
                      title: Text(product.title),
                      subtitle: Row(
                        children: [
                          Text("₦${product.price.toString()}"),
                          const SizedBox(
                            width: 10,
                          ),
                          // Text(product.category.toString()),
                          buildStarRating(double.parse(product.rating.rate)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(${product.rating.count.toString()})",
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      leading: CachedNetworkImage(
                        imageUrl: product.image,
                        height: 80,
                        width: 50,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
