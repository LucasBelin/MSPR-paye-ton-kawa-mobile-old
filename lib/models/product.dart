class Product {
  String id;
  String name;
  String stock;
  ProductDetails details;

  Product(
      {required this.id,
      required this.name,
      required this.stock,
      required this.details});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      stock: json['stock'].toString(),
      details: ProductDetails.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'details': details.toJson(),
    };
  }
}

class ProductDetails {
  String color;
  String description;
  String price;

  ProductDetails(
      {required this.color, required this.description, required this.price});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      color: json['color'],
      description: json['description'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'description': description,
      'price': price,
    };
  }
}
