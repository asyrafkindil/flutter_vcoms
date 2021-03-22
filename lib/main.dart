import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'screens/landingPage.dart';

// void main() {
//   runApp(MyApp());
// }

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VCOMS',
      theme: ThemeData(
        fontFamily: 'MuseoModerno',
        primaryColor: Color.fromRGBO(255, 63, 111, 1),
      ),
      home: Scaffold(
        body: LandingPage(),
      ),
    );
  }
}
