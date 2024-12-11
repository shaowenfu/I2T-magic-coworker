import 'package:flutter/material.dart';
import 'package:i2t_magic_frontend/services/oss_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../common/services_locator.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("上传照片"),
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
          onPressed: _openGallery,
          child: const Text("选择图片"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _loadAllImages,
          child: _isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Text("全部加载"),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    return Container(
      height: 100, // 增加高度以便更好地显示图片
      child: images.isEmpty
          ? const Center(child: Text("暂无图片"))
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
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.black26),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.file(
          File(images[index].path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
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
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          images.addAll(selectedImages);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: images.isEmpty ? null : _handleSubmit,
        child: const Text("提交"),
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
