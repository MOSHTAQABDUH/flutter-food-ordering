class FoodModel {
  int status;
  String message;
  List<Food> foods;

  FoodModel({this.status, this.message, this.foods});

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        status: json["status"],
        message: json["message"],
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
      );
}

class Food {
  List<String> images;
  String id;
  String name;
  String description;
  double price;
  int rating;
  Shop shop;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Food({
    this.images,
    this.id,
    this.name,
    this.description,
    this.price,
    this.rating,
    this.shop,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        images: List<String>.from(json["images"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        rating: json["rating"],
        shop: Shop.fromJson(json["shop"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}

class Shop {
  String id;
  String name;
  String email;

  Shop({this.id, this.name, this.email});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );
}

enum FoodTypes {
  StreetFood,
  All,
  Coffee,
  Asian,
  Burger,
  Dessert,
}
