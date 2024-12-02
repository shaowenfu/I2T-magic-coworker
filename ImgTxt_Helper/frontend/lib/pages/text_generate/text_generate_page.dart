import 'package:flutter/material.dart';

class TextGeneratePage extends StatefulWidget {
  const TextGeneratePage({super.key});

  @override
  State<TextGeneratePage> createState() => _TextGeneratePageState();
}

class _TextGeneratePageState extends State<TextGeneratePage> {
  bool _isLoading = false;
  final List<Map<String, String>> _imageCards = [];

  Future<void> _uploadImage() async {
    // TODO: 实现图片选择和上传
    setState(() {
      // 模拟添加新的图片卡片
      _imageCards.add({
        'imagePath': 'assets/images/sample.jpg',
        'description': '等待生成描述...',
      });
    });
  }

  Future<void> _generateDescription(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 调用后端API生成描述
      await Future.delayed(const Duration(seconds: 2)); // 模拟网络请求
      setState(() {
        _imageCards[index]['description'] = '这是一张美丽的风景照片，展现了大自然的壮丽景色...';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成失败: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageDetail(Map<String, String> card) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              card['imagePath']!,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                card['description']!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: 实现分享功能
                  },
                  child: const Text('分享'),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: 实现保存功能
                  },
                  child: const Text('保存'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(Map<String, String> card, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showImageDetail(card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(card['imagePath']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['description']!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (card['description'] == '等待生成描述...')
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _generateDescription(index),
                          child: const Text('生成文案'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 顶部Logo和名称
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB6D6F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 24,
                      color: Color(0xFF8C3718),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I2T magic',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF404040),
                        ),
                      ),
                      Text(
                        '图文助手',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF80848C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 上传按钮
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C3718),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                ),
                label: const Text(
                  '上传图片',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 图片卡片网格
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _imageCards.length,
                      itemBuilder: (context, index) {
                        return _buildImageCard(_imageCards[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
