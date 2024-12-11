import 'package:flutter/material.dart';
import 'package:i2t_magic_frontend/services/oss_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/api_service.dart';
import '../../common/services_locator.dart';
import 'dart:io';

const Color kPrimaryColor = Color(0xFF456173); // 深蓝灰色
const Color kAccentColor = Color(0xFF4EBF4B); // 绿色
const Color kSecondaryColor = Color(0xFFF2B872); // 浅橙色
const Color kTertiaryColor = Color(0xFFBF895A); // 棕色
const Color kErrorColor = Color(0xFFA62317); // 红色

class InitPictureStorePage extends StatefulWidget {
  const InitPictureStorePage({Key? key}) : super(key: key);

  @override
  State<InitPictureStorePage> createState() => _InitPictureStorePageState();
}

class _InitPictureStorePageState extends State<InitPictureStorePage> {
  final ScrollController _imgController = ScrollController();
  List<XFile> images = [];
  final ApiService _apiService = getIt<ApiService>();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isImagesLoaded = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.photos.status;
    setState(() {
      _hasPermission = status.isGranted;
    });

    if (!status.isGranted) {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.photos.request();
    setState(() {
      _hasPermission = status.isGranted;
    });

    if (!status.isGranted) {
      if (mounted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要相册权限'),
        content: const Text('请在设置中允许访问相册，以便上传照片'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
              setState(() {
                _hasPermission = true;
              });
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("上传照片", style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('需要相册访问权限才能上传照片'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requestPermission,
                child: const Text('授予权限'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("上传照片", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildImageList(),
            const SizedBox(height: 20),
            _buildButtons(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kSecondaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _openGallery,
          child: const Text("选择图片", style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kTertiaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _loadAllImages,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text("全部加载", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: images.isEmpty
          ? Center(
              child: Text(
                "暂无图片",
                style: TextStyle(
                  color: kPrimaryColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              controller: _imgController,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: _buildImageItem,
            ),
    );
  }

  Widget _buildImageItem(BuildContext context, int index) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(images[index].path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(Icons.error, color: kErrorColor),
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadAllImages() async {
    setState(() => _isLoading = true);

    try {
      // 从服务器获取图片URL列表
      final imageList = await _apiService.getUserImages('sherwen'); // 替换实际用户ID

      // 清空当前图片列表
      setState(() {
        images.clear();
      });

      // 下载并添加每张图片
      for (var imageData in imageList) {
        final localPath =
            await _apiService.downloadImage(imageData['image_path']);
        if (localPath != null) {
          setState(() {
            images.add(XFile(localPath));
          });
        }
      }

      // 标记图片已加载
      _isImagesLoaded = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载图片失败: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openGallery() async {
    if (!_hasPermission) {
      await _requestPermission();
      if (!_hasPermission) return;
    }

    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          images.addAll(selectedImages);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kAccentColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: images.isEmpty ? Colors.grey : kAccentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: images.isEmpty ? null : _handleSubmit,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "提交",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_isImagesLoaded) {
      // 如果图片是从服务器加载的，直接返回
      Navigator.pop(context);
      return;
    }

    try {
      setState(() => _isLoading = true);

      // 上传新选择的图片到OSS
      final List<String> uploadedUrls = [];
      for (XFile image in images) {
        final file = File(image.path);
        final url = await FileManager().uploadFile(file);
        if (url != null) {
          uploadedUrls.add(url);
        }
      }

      // 发送URL列表到后端
      await _apiService.uploadInitImages(uploadedUrls, 'sherwen');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('上传成功')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('上传失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
