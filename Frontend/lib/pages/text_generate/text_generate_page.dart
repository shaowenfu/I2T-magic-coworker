import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../services/oss_service.dart';

class TextGeneratePage extends StatefulWidget {
  const TextGeneratePage({super.key});

  @override
  State<TextGeneratePage> createState() => _TextGeneratePageState();
}

class _TextGeneratePageState extends State<TextGeneratePage> {
  bool _isLoading = false;
  final List<Map<String, String>> _imageCards = [];
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imagePath;
  final FileManager _fileManager = FileManager.instance;

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _imageFile = File(image.path);
    debugPrint('图片路径: ${_imageFile!.path}');

    try {
      final int cardIndex = _imageCards.length;
      setState(() {
        _imageCards.add({
          'imagePath': image.path,
          'description': '正在上传图片...',
        });
      });
      const String? ossUrl =
          "https://i2t-magic-coworker.oss-cn-chengdu.aliyuncs.com/folder/20241210/pOTYMpALUBso.jpg";
      // final String? ossUrl = await _fileManager.uploadFile(_imageFile!);
      debugPrint('OSS URL: $ossUrl');
      if (ossUrl == null) {
        throw Exception('上传到OSS失败');
      }
      _imagePath = ossUrl;

      await _generateDescription(cardIndex);
    } catch (e) {
      debugPrint('处理失败: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('处理失败: ${e.toString()}')),
      );
    }
  }

  Future<void> _generateDescription(int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('开始生成描述');
      final description = await _apiService.generateText(
        _imagePath!,
        'user_123',
      );
      debugPrint('生成描述成功: $description');
      setState(() {
        _imageCards[index]['description'] = description;
      });
    } catch (e) {
      debugPrint('生成描述失败: ${e.toString()}');
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
            Image.file(
              File(card['imagePath']!),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                card['description']!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            OverflowBar(
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

  void _deleteCard(int index) {
    setState(() {
      _imageCards.removeAt(index);
    });
  }

  Widget _buildImageCard(Map<String, String> card, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '图片 ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666666),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFF8C3718),
                    ),
                    onPressed: () => _deleteCard(index),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _showImageDetail(card),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(card['imagePath']!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                card['description']!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF333333),
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
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _imageCards.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildImageCard(_imageCards[index], index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
