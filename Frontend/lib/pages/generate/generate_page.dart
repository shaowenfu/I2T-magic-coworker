import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/oss_service.dart';

// 添加颜色常量
const Color kPrimaryColor = Color(0xFF456173); // 深蓝灰色
const Color kAccentColor = Color(0xFF4EBF4B); // 绿色
const Color kSecondaryColor = Color(0xFFF2B872); // 浅橙色
const Color kTertiaryColor = Color(0xFFBF895A); // 棕色
const Color kErrorColor = Color(0xFFA62317); // 红色

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedSize = 'Small';
  String _selectedStyle = 'Photorealistic';
  bool _isGenerating = false;
  String? _generatedImagePath;
  final List<String> _styleOptions = [
    'Photorealistic',
    'Artistic',
    'Cartoon',
    'Sketch',
    'Abstract',
  ];

  final ApiService _apiService = ApiService();
  Timer? _imageCheckTimer;

  Future<void> _generateImage() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      debugPrint('开始生成图片...');
      final imageUrl = await _apiService.generateImage(
          _descriptionController.text, '123456', _selectedSize, _selectedStyle);
      debugPrint('图片生成成功，OSS地址: $imageUrl');

      // 下载图片到本地
      final localPath = await FileManager().download(
        url: imageUrl,
        fileType: 'jpg',
      );

      if (localPath != null) {
        setState(() {
          _generatedImagePath = localPath;
        });
        debugPrint('图片下载成功，本地路径: $_generatedImagePath');
      } else {
        throw Exception('图片下载失败');
      }
    } catch (e) {
      debugPrint('图片生成失败: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成失败: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '输入文字，AI智能生成图片',
                            style: TextStyle(
                              fontSize: 12,
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 文本描述输入区域
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe your image...',
                        hintStyle:
                            TextStyle(color: kPrimaryColor.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 图片尺寸选择
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Dimensions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'Small',
                          groupValue: _selectedSize,
                          activeColor: kAccentColor,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        Text('Small', style: TextStyle(color: kPrimaryColor)),
                        Radio(
                          value: 'Medium',
                          groupValue: _selectedSize,
                          activeColor: kAccentColor,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        Text('Medium', style: TextStyle(color: kPrimaryColor)),
                        Radio(
                          value: 'Large',
                          groupValue: _selectedSize,
                          activeColor: kAccentColor,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        Text('Large', style: TextStyle(color: kPrimaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 风格选项
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Style Options',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedStyle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      dropdownColor: Colors.white,
                      style: TextStyle(color: kPrimaryColor),
                      icon: Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                      items: _styleOptions.map((String style) {
                        return DropdownMenuItem<String>(
                          value: style,
                          child: Text(style),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStyle = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 生成按钮
              ElevatedButton(
                onPressed: _isGenerating ? null : _generateImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isGenerating
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Generate Image',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // 图片展示
              if (_generatedImagePath != null)
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_generatedImagePath!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('图片加载错误: $error');
                        return _buildErrorWidget();
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageCheckTimer?.cancel();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget([String? message]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 48, color: kErrorColor),
          const SizedBox(height: 8),
          Text(
            message ?? '图片加载失败',
            style: TextStyle(color: kErrorColor),
          ),
        ],
      ),
    );
  }
}
