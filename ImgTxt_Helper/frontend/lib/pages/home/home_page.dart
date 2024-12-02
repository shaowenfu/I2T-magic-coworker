import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB6D6F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: Color(0xFF8C3718),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'I2T Magic',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF404040),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '欢迎使用 I2T Magic！轻松探索你的相册',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF80848C),
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
        'image': 'assets/images/guide.jpg',
      },
      {
        'title': '搜索示例',
        'description': '输入关键词即可快速找到相关图片',
        'image': 'assets/images/search.jpg',
      },
      {
        'title': '生成展示',
        'description': '快速生成符合文案需求的配图',
        'image': 'assets/images/generate.jpg',
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
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(carouselItems[index]['image']!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    carouselItems[index]['description']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
      },
      {
        'title': '相册图片搜索',
        'description': '通过关键词搜索相册中的图片',
        'icon': Icons.search,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
      },
      {
        'title': '文案配图',
        'description': '根据文字描述生成相应的图片',
        'icon': Icons.image,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
      },
      {
        'title': '图片生成文案',
        'description': '根据图片生成文字描述',
        'icon': Icons.text_fields,
        'gradient': const [Color(0xFFB6D6F2), Color(0xFF8C3718)],
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
            // TODO: 导航到对应页面
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
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
