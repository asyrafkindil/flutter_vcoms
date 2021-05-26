class Product {
  int id;
  String name;
  String description;
  double price;
  int categoryId;
  String photoPath;

  Product({this.id, this.name, this.description, this.price, this.categoryId, this.photoPath});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['category_id'],
      photoPath: json['photo_path'],
    );
  }
}
