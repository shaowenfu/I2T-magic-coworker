import 'package:flutter/material.dart';

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

  Future<void> _generateImage() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入图片描述')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // TODO: 调用后端API生成图片
      await Future.delayed(const Duration(seconds: 3)); // 模拟网络请求
      setState(() {
        _generatedImagePath = 'assets/images/generated_sample.jpg';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成失败: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
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
              const SizedBox(height: 24),

              // 文本描述输入区域
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Text Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Describe your image...',
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image Dimensions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040),
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'Small',
                          groupValue: _selectedSize,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        const Text('Small'),
                        Radio(
                          value: 'Medium',
                          groupValue: _selectedSize,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        const Text('Medium'),
                        Radio(
                          value: 'Large',
                          groupValue: _selectedSize,
                          onChanged: (value) {
                            setState(() => _selectedSize = value.toString());
                          },
                        ),
                        const Text('Large'),
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Style Options',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedStyle,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
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

              // ��成按钮
              ElevatedButton(
                onPressed: _isGenerating ? null : _generateImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C3718),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
                    ? const SizedBox(
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
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // 生成的图片展示
              if (_generatedImagePath != null)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(_generatedImagePath!),
                      fit: BoxFit.cover,
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
    _descriptionController.dispose();
    super.dispose();
  }
}
