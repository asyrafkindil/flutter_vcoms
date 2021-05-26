import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './screens/landingPage.dart';
import './screens/navigationBar.dart';

// void main() {
//   runApp(MyApp());
// }

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return MaterialApp(
          key: Key('auth_${auth.isAuthenticated}'),
          debugShowCheckedModeBanner: false,
          title: 'VCOMS',
          theme: ThemeData(
            fontFamily: 'MuseoModerno',
            primaryColor: Color.fromRGBO(255, 63, 111, 1),
          ),
          home: auth.isAuthenticated
              ? NavigationBarPage(selectedIndex: 1)
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                      ? Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : LandingPage(),
                ));
    });
  }
}
