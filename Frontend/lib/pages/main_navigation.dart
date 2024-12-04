import 'package:flutter/material.dart';
import 'package:i2t_magic_frontend/pages/InitPictureStorePage/init_picture_store_page.dart';
import 'package:i2t_magic_frontend/pages/home/home_page.dart';
import 'package:i2t_magic_frontend/pages/search/search_page.dart';
import 'package:i2t_magic_frontend/pages/generate/generate_page.dart';
import 'package:i2t_magic_frontend/pages/text_generate/text_generate_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const InitPictureStorePage(), // 数据库初始化
    const SearchPage(), // 图片搜索
    const HomePage(), // 首页
    const GeneratePage(), // 文生图
    const TextGeneratePage(), // 图生文
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF8C3718),
        unselectedItemColor: const Color(0xFF80848C),
        items: [
          _buildNavItem(Icons.storage, '初始化', 0),
          _buildNavItem(Icons.search, '搜索', 1),
          _buildNavItem(Icons.home, '首页', 2),
          _buildNavItem(Icons.image, '配图', 3),
          _buildNavItem(Icons.text_fields, '生文', 4),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final double size = _selectedIndex == index ? 30.0 : 24.0;
    return BottomNavigationBarItem(
      icon: Icon(icon, size: size),
      label: label,
    );
  }
}
