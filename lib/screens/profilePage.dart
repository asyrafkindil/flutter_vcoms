import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  _signOut() {
    return;
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
          child: Column(
            children: [
              Text(
                'Najiha',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
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
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
