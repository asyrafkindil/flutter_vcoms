class Cart {
  int count;
  int productId;
  String name;
  int quantity;
  double price;
  String photoPath;

  Cart({this.count, this.productId, this.name, this.quantity, this.price, this.photoPath});

  Map<String, dynamic> toJson() {
    return {
      'product_id': this.productId,
      'quantity': this.quantity,
      'price': (this.price * this.quantity),
    };
  }
}
