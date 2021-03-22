import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../screens/cartPage.dart';
import '../screens/homePage.dart';
import '../screens/profilePage.dart';

class NavigationBarPage extends StatefulWidget {
  // ignore: must_be_immutable
  int selectedIndex;

  NavigationBarPage({@required this.selectedIndex});

  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  PageController _pageController;
  final List<Widget> _pages = [
    ProfilePage(),
    HomePage(),
    CartPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: PageView(
        children: _pages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(255, 63, 111, 1),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color.fromRGBO(255, 63, 111, 1),
        height: 50,
        index: widget.selectedIndex,
        // selectedItemColor: Colors.white,
        // backgroundColor: Color.fromRGBO(255, 63, 111, 1),
        // currentIndex: widget.selectedIndex,
        onTap: onTabTapped,
        items: [
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.account_circle, size: 26, color: Colors.white),
          //   label: 'Profile',
          // ),
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.home, size: 26, color: Colors.white),
          //   label: 'Home',
          // ),
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.add_shopping_cart, size: 26, color: Colors.white),
          //   label: 'Cart',
          // ),

          Icon(Icons.account_circle, size: 26, color: Colors.white),
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.add_shopping_cart, size: 26, color: Colors.white),
        ],
      ),
    );
  }
}
