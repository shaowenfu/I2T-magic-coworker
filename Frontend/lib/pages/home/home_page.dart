import 'package:flutter/material.dart';
import 'package:i2t_magic_frontend/pages/InitPictureStorePage/init_picture_store_page.dart';
import 'package:i2t_magic_frontend/pages/search/search_page.dart';
import 'package:i2t_magic_frontend/pages/generate/generate_page.dart';
import 'package:i2t_magic_frontend/pages/text_generate/text_generate_page.dart';

const Color kPrimaryColor = Color(0xFF456173); // 深蓝灰色
const Color kAccentColor = Color(0xFF4EBF4B); // 绿色
const Color kSecondaryColor = Color(0xFFF2B872); // 浅橙色
const Color kTertiaryColor = Color(0xFFBF895A); // 棕色
const Color kErrorColor = Color(0xFFA62317); // 红色

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'I2T Magic',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '欢迎使用 I2T Magic！轻松探索你的相册',
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final List<Map<String, String>> carouselItems = [
      {
        'title': '新手指引',
        'description': '首次使用请先初始化相册数据库',
        'image': 'assets/images/guide.png',
      },
      {
        'title': '搜索示例',
        'description': '输入关键词即可快速找到相关图片',
        'image': 'assets/images/search.png',
      },
      {
        'title': '生成展示',
        'description': '快速生成符合文案需求的配图',
        'image': 'assets/images/generate.png',
      },
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: carouselItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryColor.withOpacity(0.8),
                  kTertiaryColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carouselItems[index]['title']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    carouselItems[index]['description']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final List<Map<String, dynamic>> features = [
      {
        'title': '数据库初始化',
        'description': '首次使用需要初始化相册数据库',
        'icon': Icons.storage,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
        'page': const InitPictureStorePage(),
      },
      {
        'title': '相册图片搜索',
        'description': '通过关键词搜索相册中的图片',
        'icon': Icons.search,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
        'page': const SearchPage(),
      },
      {
        'title': '文案配图',
        'description': '根据文字描述生成相应的图片',
        'icon': Icons.image,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
        'page': const GeneratePage(),
      },
      {
        'title': '图片生成文案',
        'description': '根据图片生成文字描述',
        'icon': Icons.text_fields,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
        'page': const TextGeneratePage(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(
          title: features[index]['title'],
          description: features[index]['description'],
          icon: features[index]['icon'],
          gradient: features[index]['gradient'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => features[index]['page'],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [kPrimaryColor, kTertiaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCarousel(),
              _buildFeatureGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
