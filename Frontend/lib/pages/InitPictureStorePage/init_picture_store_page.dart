import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class InitPictureStorePage extends StatefulWidget {
  const InitPictureStorePage({super.key});

  @override
  InitPictureStorePageState createState() => InitPictureStorePageState();
}

class InitPictureStorePageState extends State<InitPictureStorePage> {
  bool _hasPermission = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _checkAlbumPermission();
  }

  // 检查相册权限
  Future<void> _checkAlbumPermission() async {
    final permissionStatus = await Permission.photos.status;
    setState(() {
      _hasPermission = permissionStatus.isGranted;
    });
  }

  // 请求相册权限
  Future<void> _requestAlbumPermission() async {
    final permissionStatus = await Permission.photos.request();
    setState(() {
      _hasPermission = permissionStatus.isGranted;
    });
    if (!_hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('未获得相册访问权限，请授予权限后重试')),
      );
    }
  }

  // 打开相册选择图片
  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _selectedImages = pickedFiles;
    });
  }

  // 模拟图片上传
  Future<void> _uploadImages() async {
    if (_selectedImages == null || _selectedImages!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择图片')),
      );
      return;
    }

    for (int i = 0; i < _selectedImages!.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _uploadProgress = (i + 1) / _selectedImages!.length;
        });
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('所有图片上传完成')),
    );

    setState(() {
      _selectedImages = null;
      _uploadProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('相册数据库初始化'),
        backgroundColor: const Color(0xFFB6D6F2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 权限状态
            if (!_hasPermission)
              ElevatedButton.icon(
                onPressed: _requestAlbumPermission,
                icon: const Icon(Icons.lock, color: Colors.white),
                label: const Text('请求相册权限'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            if (_hasPermission) ...[
              // 选择图片按钮
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo, color: Colors.white),
                label: const Text('选择图片'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              // 显示已选图片数量及缩略图
              if (_selectedImages != null && _selectedImages!.isNotEmpty) ...[
                Text(
                  '已选择 ${_selectedImages!.length} 张图片',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.file(
                          File(_selectedImages![index].path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 10),
              // 上传按钮
              ElevatedButton.icon(
                onPressed: _uploadImages,
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text('上传图片'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 20),
              // 上传进度条
              if (_uploadProgress > 0)
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '上传进度：${(_uploadProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
