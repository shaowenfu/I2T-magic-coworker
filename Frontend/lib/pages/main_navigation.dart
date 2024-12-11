import 'package:flutter/material.dart';
import 'package:i2t_magic_frontend/pages/InitPictureStorePage/init_picture_store_page.dart';
import 'package:i2t_magic_frontend/pages/home/home_page.dart';
import 'package:i2t_magic_frontend/pages/search/search_page.dart';
import 'package:i2t_magic_frontend/pages/generate/generate_page.dart';
import 'package:i2t_magic_frontend/pages/text_generate/text_generate_page.dart';

const Color kPrimaryColor = Color(0xFF456173); // 深蓝灰色
const Color kAccentColor = Color(0xFFBF895A); // 棕色
const Color kSecondaryColor = Color(0xFFF2B872); // 浅橙色
const Color kTertiaryColor = Color(0xFF4EBF4B); // 绿色
const Color kErrorColor = Color(0xFFA62317); // 红色

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const InitPictureStorePage(),
    const SearchPage(),
    const HomePage(),
    const GeneratePage(),
    const TextGeneratePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: kAccentColor,
          unselectedItemColor: kPrimaryColor.withOpacity(0.5),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: [
            _buildNavItem(Icons.storage, '初始化', 0),
            _buildNavItem(Icons.search, '搜索', 1),
            _buildNavItem(Icons.home, '首页', 2),
            _buildNavItem(Icons.image, '配图', 3),
            _buildNavItem(Icons.text_fields, '文案', 4),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final double size = isSelected ? 30.0 : 24.0;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isSelected ? kAccentColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: size,
              color: isSelected ? kAccentColor : kPrimaryColor.withOpacity(0.5),
            ),
            if (isSelected)
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: kAccentColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Icon(
          icon,
          size: size,
          color: kAccentColor,
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }
}
