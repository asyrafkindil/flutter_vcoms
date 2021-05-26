import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../config.dart';
import '../providers/auth.dart';
import '../screens/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> _user = {};
  List _orderHistories = [];

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchOrderHistories();
  }

  Future<void> _fetchUser() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.get(Uri.parse('$API_URL/user'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          _user = json.decode(response.body);
        });
      } else {
        print(response.body);
        throw new Exception('[ProfilePage]: fetchUser, HTTP_ERROR[${response.statusCode}]');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _fetchOrderHistories() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.post(Uri.parse('$API_URL/order/histories'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${authProvider.token}',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          _orderHistories = json.decode(response.body);
          print(_orderHistories);
        });
      } else {
        print(response.body);
        throw new Exception('[ProfilePage]: _fetchOrderHistories, HTTP_ERROR[${response.statusCode}]');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  _signOut() {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      authProvider.logout();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
    return;
  }

  _getStatusDescription(int status) {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Ready to Pickup';
      case 3:
        return 'Collected by customer';
      default:
        return '';
    }
  }

  Widget _buildOrderHistory() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('ORDERID#${_orderHistories[index]['id']}', style: TextStyle(fontFamily: 'Arial')),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_orderHistories[index]['created_at']}', style: TextStyle(fontFamily: 'Arial')),
              Text('Status: ${_getStatusDescription(_orderHistories[index]['status'])}', style: TextStyle(fontFamily: 'Arial')),
              _buildProductList(index),
            ],
          ),
          trailing: Text('RM ${_orderHistories[index]['grand_total']}', style: TextStyle(fontFamily: 'Arial')),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[500]),
      itemCount: _orderHistories.length,
    );
  }

  Widget _buildProductList(orderIndex) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${_orderHistories[orderIndex]['products'][index]['name']}', style: TextStyle(fontFamily: 'Arial')),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RM ${_orderHistories[orderIndex]['products'][index]['price']}', style: TextStyle(fontFamily: 'Arial')),
              Text('Quantity: ${_orderHistories[orderIndex]['products'][index]['pivot']['quantity']}', style: TextStyle(fontFamily: 'Arial')),
            ],
          ),
        );
      },
      itemCount: _orderHistories[orderIndex]['products'].length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: _signOut,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_user['name']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'MuseoModerno',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_user['email']}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'Arial',
                  ),
                ),
                // SizedBox(height: 10),
                // Text(
                //   "Balance: RM 0",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 20,
                //     fontFamily: 'MuseoModerno',
                //   ),
                // ),
                // SizedBox(height: 20),
                // RaisedButton(child: Text('Add Money')),
                Divider(color: Colors.grey),
                Text(
                  "Order History",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.left,
                ),
                _buildOrderHistory(),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 20),
                //   width: MediaQuery.of(context).size.width * 0.6,
                //   child: Text(""),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
