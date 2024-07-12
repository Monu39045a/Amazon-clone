import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/admin/screens/adminappbar.dart';
import 'package:amazon_clone/features/admin/screens/order_screen.dart';
import 'package:amazon_clone/features/admin/screens/products_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _pages = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const ProductScreen(),
    const Center(
      child: Text("Analytics Page"),
    ),
    const OrderScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _pages = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AdminAppBar(),
      ),
      body: pages[_pages],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pages,
        selectedItemColor: GlobalVariables.selectedNavBar,
        unselectedItemColor: GlobalVariables.unselectedNavBar,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // Add Products
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _pages == 0
                        ? GlobalVariables.selectedNavBar
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),

          //Analytics
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _pages == 1
                        ? GlobalVariables.selectedNavBar
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.analytics_outlined,
              ),
            ),
            label: '',
          ),

          //Orders
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _pages == 2
                        ? GlobalVariables.selectedNavBar
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.all_inbox_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
