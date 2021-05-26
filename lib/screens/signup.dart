import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password, _conPassword;

  void toast(String data) {
    Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  void _submitForm() {
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      return;
    }

    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      authProvider.register(_name, _email, _password);
      print("Register Success");
      toast('Register success.');
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e.toString());
      toast(e.toString());
    }
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        SizedBox(height: 5),
        // Email field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Arial'),
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val.isEmpty) return 'Full name is required.';
              return null;
            },
            onSaved: (val) => _name = val,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Full name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
              errorStyle: TextStyle(fontFamily: 'Arial'),
              icon: Icon(
                Icons.account_circle,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Email field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Arial'),
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              RegExp regExp = new RegExp(r'^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z]{2,5})$');
              if (val.isEmpty)
                return 'Email address is required.';
              else if (!regExp.hasMatch(val)) return 'Enter a valid email address.';
              return null;
            },
            onSaved: (val) => _email = val,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Email address',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
              errorStyle: TextStyle(fontFamily: 'Arial'),
              icon: Icon(
                Icons.email,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Password field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Arial'),
            obscureText: true,
            validator: (val) {
              if (val.isEmpty)
                return 'Password is required.';
              else if (val.length < 8) return 'Password must have at least 8 characters.';
              return null;
            },
            onSaved: (val) => _password = val,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
              errorStyle: TextStyle(fontFamily: 'Arial'),
            ),
          ),
        ),
        SizedBox(height: 20),
        // Confirm Password field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Arial'),
            obscureText: true,
            validator: (val) {
              if (val.isEmpty)
                return 'Confirm password is required.';
              else if (val != _password) return 'Confirm password do not match your password.';
              return null;
            },
            onSaved: (val) => _conPassword = val,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
              errorStyle: TextStyle(fontFamily: 'Arial'),
              icon: Icon(
                Icons.lock,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
        // Sign Up Button
        InkWell(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 60),
        // Login Line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already a registered user?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Text(
                  'Log In here',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 138, 120, 1),
                Color.fromRGBO(255, 114, 117, 1),
                Color.fromRGBO(255, 63, 111, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        'VCOMS',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'MuseoModerno',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                      color: Color.fromRGBO(252, 188, 126, 1),
                    ),
                  ),
                  _buildSignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
