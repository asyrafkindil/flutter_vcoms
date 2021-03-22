import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productList = [
    new Product(
      name: 'Red Velvet',
      description: 'Delicious cake with red velvet flavour.',
      price: 50.50,
      categoryId: 1,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description:
          'Delicious brownies baked with love. Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text Long text',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'Brownies',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
    new Product(
      name: 'ASD',
      description: 'Delicious brownies baked with love.',
      price: 20.50,
      categoryId: 2,
    ),
  ];

  String _keyword;
  List<Product> _productListFilter;

  @override
  void initState() {
    _productListFilter = productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('VCOMS'),
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search...'),
          onChanged: (value) {
            setState(() {
              _productListFilter = productList
                  .where((element) =>
                      element.name.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
        ),
      ),
      body: userHome(context),
    );
  }

  Widget userHome(context) {
    return Column(
      children: [
        // Card(
        //   child: TextField(
        //     decoration: InputDecoration(
        //         prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        //     onChanged: (value) {},
        //   ),
        // ),
        Expanded(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey),
                padding: EdgeInsets.all(0),
                itemCount: _productListFilter.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://bakingmischief.com/wp-content/uploads/2019/09/small-red-velvet-cake-image-square.jpg'),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(_productListFilter[index].name),
                          subtitle: Text(_productListFilter[index].description),
                          trailing: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Product added to cart.'),
                                duration: const Duration(seconds: 1),
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
