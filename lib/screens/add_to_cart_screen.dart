import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../providers/cart.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  int quantity = 1;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    price = widget.product.price * quantity;
  }

  _increaseQuantity() {
    setState(() {
      quantity++;
      price = widget.product.price * quantity;
    });
  }

  _decreaseQuantity() {
    setState(() {
      quantity--;
      if (quantity < 1) {
        quantity = 1;
      }
    });
  }

  _addToCart() {
    Cart cart = new Cart();
    cart.name = widget.product.name;
    cart.price = widget.product.price;
    cart.quantity = quantity;
    cart.productId = widget.product.id;
    cart.photoPath = widget.product.photoPath;
    Provider.of<CartProvider>(context, listen: false).addToCart(cart);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.product.name} added to cart'),
      duration: Duration(milliseconds: 1000),
    ));
    Navigator.pop(context);
  }

  Widget _imageContainer(String path) {
    return CachedNetworkImage(
      imageUrl: '$STORAGE_URL/$path',
      imageBuilder: (context, imageProvider) {
        return Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 1.0, spreadRadius: 1.0, offset: Offset(1, 1)),
            ],
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text('Error loading image'),
          ],
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(child: CircularProgressIndicator(value: downloadProgress.progress));
      },
    );
  }

  Widget _descriptionContainer(String description) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Description',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(height: 1, color: Colors.grey[400]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$description',
              style: TextStyle(fontSize: 16, fontFamily: 'Arial', color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityContainer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Quantity:',
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: _decreaseQuantity,
        ),
        Text('$quantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _increaseQuantity,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product.name}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              _imageContainer(widget.product.photoPath),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      _descriptionContainer(widget.product.description),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _quantityContainer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(255, 63, 111, 1),
                          ),
                          icon: Icon(Icons.add_shopping_cart_rounded),
                          onPressed: _addToCart,
                          label: Text('Add'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
