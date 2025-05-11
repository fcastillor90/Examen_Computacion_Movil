class Product {
  final int? id;
  final String name;
  final double price;
  final String imageUrl;
  final String? state;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.state = "Activo"
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      price: double.parse(json['product_price'].toString()),
      imageUrl: json['product_image'],
      state: json['product_state'] ?? "Activo"
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['product_id'] = id;
    }
    data['product_name'] = name;
    data['product_price'] = price;
    data['product_image'] = imageUrl;
    if (state != null) {
      data['product_state'] = state;
    }
    return data;
  }

  // For adding a new product (without ID)
  Map<String, dynamic> toAddJson() {
    return {
      'product_name': name,
      'product_price': price,
      'product_image': imageUrl
    };
  }

  // For deleting a product (only ID)
  Map<String, dynamic> toDeleteJson() {
    return {
      'product_id': id
    };
  }
}
