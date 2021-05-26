import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/cart.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key key, this.totalPrice}) : super(key: key);
  final double totalPrice;

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var _selectedItem;
  String _note = '';
  String _phone = '';
  List _branches = [];

  @override
  void initState() {
    super.initState();
    StripeService.init();
    _fetchBranchList();
  }

  Future<void> _fetchBranchList() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await http.get(
        Uri.parse('$API_URL/branches'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        setState(() {
          _branches = jsonData;
          _selectedItem = _branches[0]['id'];
        });
        print(jsonData);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  List<DropdownMenuItem> _buildBranchItems() {
    List<DropdownMenuItem> list = [];
    _branches.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text('${element['name']}'),
        value: element['id'],
      ));
    });
    return list;
  }

  Widget _buildBranch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Pickup Location'),
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedItem,
              items: _buildBranchItems(),
              onChanged: (val) {
                setState(() {
                  _selectedItem = val;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  _payViaNewCard(String amount) async {
    if (_phone.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Alert'),
          content: Text('Phone number is required.', style: TextStyle(fontFamily: 'Arial')),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        ),
      );
      return;
    }
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(amount: amount, currency: 'MYR');
    await dialog.hide();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    if (response.success) {
      await _saveOrder();
      Provider.of<CartProvider>(context, listen: false).clearCart();
      Navigator.pop(context);
    }
  }

  Future<void> _saveOrder() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    List<Cart> carts = cartProvider.carts;
    List jsonData = [];
    carts.forEach((cart) {
      jsonData.add(cart.toJson());
    });

    try {
      final response = await http.post(
        Uri.parse('$API_URL/order-confirmed'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
          'Accept': 'application/json',
        },
        body: {
          'total': widget.totalPrice.toString(),
          'carts': json.encode(jsonData),
          'notes': _note,
          'phone': _phone,
          'branch_id': _selectedItem.toString(),
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  _convertToCent(price) {
    int cent = (price * 100).round();
    return cent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBranch(),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Phone'),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[300]),
                    ),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Arial'),
                      decoration: InputDecoration(
                        hintText: 'eg: 0123456789',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => _phone = val,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Note for the bakery'),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[300]),
                    ),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Arial'),
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Enter your note here',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => _note = val,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Color.fromRGBO(255, 63, 111, 1)),
                icon: Icon(Icons.payment),
                label: Text('MAKE PAYMENT', style: TextStyle(fontFamily: 'Arial', fontSize: 16)),
                onPressed: () {
                  _payViaNewCard(_convertToCent(widget.totalPrice).toString());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
