import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcoms/screens/checkout_screen.dart';

import '../models/cart.dart';
import '../providers/cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: cart.carts.length > 0
                      ? ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          separatorBuilder: (context, index) => Divider(color: Colors.grey),
                          itemCount: cart.carts.length,
                          itemBuilder: (context, index) => _buildCartList(cart.carts[index]),
                        )
                      : ListTile(
                          title: Text('No item added to cart..', style: TextStyle(fontFamily: 'Arial')),
                        ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      "Total (${cart.carts.length} items): RM " + cart.total.toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Checkout'),
                  style: ElevatedButton.styleFrom(primary: Color.fromRGBO(255, 63, 111, 1)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(totalPrice: cart.total),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartList(Cart cart) {
    return ListTile(
      title: Text('${cart.name}'),
      subtitle: Text('RM ${(cart.price * cart.quantity).toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              // cartList[index].quantity--;
              int tempQuantity = cart.quantity - 1;
              if (tempQuantity == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Remove item from cart."),
                      content: Text("Confirm removing item from cart?"),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Confirm"),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).removeFromCart(cart);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                // cartList.removeAt(index);
              } else {
                setState(() {
                  cart.quantity--;
                });
              }
            },
          ),
          Text(cart.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                cart.quantity++;
              });
            },
          ),
        ],
      ),
    );
  }
}
