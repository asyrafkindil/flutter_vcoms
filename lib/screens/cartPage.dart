import 'package:flutter/material.dart';
import 'package:vcoms/models/cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int itemsCount = 0;
  double totalPrice = 0;

  List<Cart> cartList = [
    new Cart(
      productId: 1,
      name: 'Red Velvet',
      quantity: 1,
      price: 50.50,
    ),
    new Cart(
      productId: 1,
      name: 'Brownies',
      quantity: 1,
      price: 20.50,
    ),
    new Cart(
      productId: 1,
      name: 'Carrot Cake',
      quantity: 1,
      price: 40.50,
    ),
    new Cart(
      productId: 1,
      name: 'Vanilla Cake',
      quantity: 1,
      price: 50.50,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    itemsCount = cartList.length;
    totalPrice = 0;
    cartList.forEach((cart) {
      totalPrice += (cart.price * cart.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey),
                itemCount: cartList.length,
                itemBuilder: (context, index) => _buildCartList(index),
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Total ($itemsCount items): RM " + totalPrice.toStringAsFixed(2),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Checkout'),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(255, 63, 111, 1)),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  _confirmRemoveItem(int index) {
    setState(() {
      cartList.removeAt(index);
    });
  }

  Widget _buildCartList(int index) {
    return ListTile(
      title: Text(cartList[index].name ?? ''),
      subtitle: Text('RM ' +
          (cartList[index].price * cartList[index].quantity).toStringAsFixed(2)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              // cartList[index].quantity--;
              int tempQuantity = cartList[index].quantity - 1;
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
                            _confirmRemoveItem(index);
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
                  cartList[index].quantity--;
                });
              }
            },
          ),
          Text(cartList[index].quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                cartList[index].quantity++;
              });
            },
          ),
        ],
      ),
    );
  }
}
