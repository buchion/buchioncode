import 'package:hive_ce/hive.dart';

// part 'Product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  // @HiveField(3)
  // final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    // required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print(json['rating']);

    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      // description: json['description'].toString(),
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        // 'description': description,
        'category': category,
        'image': image,
        'rating': rating.toJson(),
      };
}

@HiveType(typeId: 1)
class Rating extends HiveObject {
  @HiveField(0)
  final String rate;

  @HiveField(1)
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    print(json["rate"]);
    print(json["rate"].toString().runtimeType);
    return Rating(
      rate: json['rate'].toString(), // double.parse(json['rate'].toString()),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'count': count,
      };
}
