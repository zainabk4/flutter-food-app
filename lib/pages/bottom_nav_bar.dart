import 'package:flutter/material.dart';
import 'package:food_app/pages/cart_page.dart';
import 'package:food_app/pages/categories_page.dart';
import 'package:food_app/pages/profile_page.dart';
import '../Helper/profile_wrapper.dart';
import '../HomePage/main_home_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    MainHomePage(),
    CategoriesPage(),
    const CartPage(),
    const ProfileWrapper(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF6A4C93).withOpacity(0.15), // Royal Plum shadow
                blurRadius: 12,
                offset: const Offset(0, 4)
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onClicked,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF6A4C93), // Royal Plum primary
            unselectedItemColor: Color(0xFF1A1A2E).withOpacity(0.4), // Royal Plum muted
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A4C93), // Royal Plum primary
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E).withOpacity(0.4), // Royal Plum muted
            ),
            items: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.category, "Orders", 1),
              _buildNavItem(Icons.shopping_cart, "Cart", 2),
              _buildNavItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index == currentIndex;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 0, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
            color: Color(0xFF6A4C93).withOpacity(0.15), // Royal Plum primary with opacity
            borderRadius: BorderRadius.circular(15)
        )
            : null,
        child: Icon(icon, size: isSelected ? 28 : 24),
      ),
      label: label,
    );
  }

  void onClicked(int value) {
    setState(() {
      currentIndex = value;
    });
  }
}