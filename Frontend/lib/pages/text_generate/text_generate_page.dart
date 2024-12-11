import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../services/oss_service.dart';

// 添加颜色常量
const Color kPrimaryColor = Color(0xFF456173); // 深蓝灰色
const Color kAccentColor = Color(0xFF4EBF4B); // 绿色
const Color kSecondaryColor = Color(0xFFF2B872); // 浅橙色
const Color kTertiaryColor = Color(0xFFBF895A); // 棕色
const Color kErrorColor = Color(0xFFA62317); // 红色

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.file(
                File(card['imagePath']!),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                card['description']!,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: 实现分享功能
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kAccentColor,
                    ),
                    child: const Text('分享'),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: 实现保存功能
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: kTertiaryColor,
                    ),
                    child: const Text('保存'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                    ),
                    child: const Text('关闭'),
                  ),
                ],
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: kPrimaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '图片 ${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: kErrorColor,
                    ),
                    onPressed: () => _deleteCard(index),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _showImageDetail(card),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(card['imagePath']!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Text(
                card['description']!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: kPrimaryColor.withOpacity(0.8),
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
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 24,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I2T magic',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        '图文助手',
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryColor.withOpacity(0.7),
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
                  backgroundColor: kAccentColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                ),
                label: const Text(
                  '上传图片',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
