import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/image_result.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // 批量上传图片初始化
  Future<Map<String, dynamic>> uploadInitImages(
      List<File> images, String userId) async {
    var uri = Uri.parse('$baseUrl/api/init/upload');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId;

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
        ),
      );
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      throw Exception('上传失败: ${response.statusCode}');
    }
  }

  // 图片搜索
  Future<List<ImageResult>> searchImages(String searchText,
      {double threshold = 0.5}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': searchText,
        'threshold': threshold,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((item) => ImageResult.fromJson(item))
          .toList();
    } else {
      throw Exception('搜索失败: ${response.statusCode}');
    }
  }

  // 文生图
  Future<String> generateImage(String text, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/generate/image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['image_path'];
    } else {
      throw Exception('生成失败: ${response.statusCode}');
    }
  }

  // 图生文
  Future<String> generateText(File image, String userId) async {
    var uri = Uri.parse('$baseUrl/api/generate/text');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId;
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
      ),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['text'];
    } else {
      throw Exception('生成失败: ${response.statusCode}');
    }
  }
}
