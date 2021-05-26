import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  List<Cart> carts = [];

  double get total {
    return carts.fold(0.0, (double currentTotal, Cart nextProduct) {
      return currentTotal + (nextProduct.price * nextProduct.quantity);
    });
  }

  void addToCart(Cart cart) {
    carts.add(cart);
  }

  void removeFromCart(Cart cart) {
    carts.remove(cart);
    notifyListeners();
  }

  void clearCart() {
    carts = [];
    notifyListeners();
  }
}
