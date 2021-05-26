import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../providers/auth.dart';
import '../screens/add_to_cart_screen.dart';
import '../widgets/category_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _categoryId = -1;
  String _keyword = '';
  List<Product> _productList = [];
  List<Category> _categoryList = [];
  List<Product> _productListFilter = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryList();
    _fetchProduct();
  }

  Future<void> _fetchCategoryList() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<Category> categoryList = [];
    try {
      final response = await http.get(
        Uri.parse('$API_URL/categories'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${authProvider.token}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((json) {
          categoryList.add(Category.fromJson(json));
        });
        setState(() {
          _categoryList = categoryList;
        });
      } else {
        print(response.body);
        throw new Exception('[HomePage]: _fetchCategoryList, HTTP_ERROR[${response.statusCode}]');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _fetchProduct() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.get(Uri.parse('$API_URL/products'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        List<Product> products = [];
        List jsonData = json.decode(response.body);
        jsonData.forEach((json) {
          products.add(Product.fromJson(json));
        });
        setState(() {
          _productListFilter = _productList = products;
        });
      } else {
        print(response.body);
        throw new Exception('[HomePage]: _fetchProduct, HTTP_ERROR[${response.statusCode}]');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _filterCategory(categoryId) {
    setState(() {
      _categoryId = categoryId;
      _filterShop();
    });
  }

  _filterShop() {
    _productListFilter = _productList.where((Product product) {
      if (_categoryId == -1) {
        return _keyword.isEmpty ? true : product.name.toLowerCase().contains(_keyword.toLowerCase());
      } else {
        if (_keyword.isEmpty) {
          return product.categoryId == _categoryId;
        } else {
          return (product.name.toLowerCase().contains(_keyword.toLowerCase()) && product.categoryId == _categoryId);
        }
      }
    }).toList();
  }

  Widget _displayImage(String path) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      height: 130,
      width: double.infinity,
      imageUrl: '$STORAGE_URL/$path',
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
              _productListFilter = _productList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
            });
          },
        ),
      ),
      body: Column(
        children: [
          CategoryContainer(_categoryList, _filterCategory),
          SizedBox(height: 10),
          Expanded(child: _userHome(context)),
        ],
      ),
    );
  }

  Widget _userHome(context) {
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
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: _productListFilter.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      _displayImage(_productListFilter[index].photoPath),
                      ListTile(
                        title: Text(_productListFilter[index].name),
                        // subtitle: Text(_productListFilter[index].description),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddToCartScreen(product: _productListFilter[index])),
                            );
                            return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${_productListFilter[index].name} added to cart.'),
                              duration: const Duration(milliseconds: 500),
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
        )
      ],
    );
  }
}
