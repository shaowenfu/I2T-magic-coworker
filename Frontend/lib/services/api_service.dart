import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/image_result.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const String baseUrl = 'http://10.0.2.2:5000';
  static final _logger = Logger('ApiService');

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
  Future<String> generateImage(String text, String userId, String selectedSize,
      String selectedStyle) async {
    try {
      const url = '$baseUrl/api/generate/image';
      debugPrint('正在连接服务器...');
      debugPrint('请求URL: $url');
      debugPrint('请求参数: text=$text, userId=$userId');
      debugPrint('请求参数: size=$selectedSize, style=$selectedStyle');

      final response = await client
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'text': text,
              'user_id': userId,
              'size': selectedSize,
              'style': selectedStyle,
            }),
          )
          .timeout(const Duration(seconds: 60)); // 增加超时时间

      debugPrint('服务器响应状态码: ${response.statusCode}');
      debugPrint('服务器响应内容: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imagePath = data['image_path'];
        return imagePath;
      } else {
        throw Exception('生成失败: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      debugPrint('连接错误: $e');
      throw Exception('无法连接到服务器，请检查网络连接和服务器状态');
    } on TimeoutException catch (e) {
      debugPrint('请求超时');
      throw Exception('请超时，请稍后重试');
    } catch (e) {
      debugPrint('其他错误: $e');
      throw Exception('生成失败: $e');
    }
  }

  // 图生文
  Future<String> generateText(String imagePath, String userId) async {
    debugPrint('开始调用接口');
    debugPrint('图片路径: $imagePath');
    debugPrint('用户ID: $userId');
    var uri = Uri.parse('$baseUrl/api/generate/text');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId;
    request.fields['image_path'] = imagePath;

    debugPrint('开始发送请求：$request');
    var response = await request.send();
    debugPrint('请求发送完毕');
    debugPrint('服务器响应状态码: ${response.statusCode}');
    debugPrint('服务器响应内容: ${response.body}');
    var responseData = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['text'];
    } else {
      throw Exception('生成失败: ${response.statusCode}');
    }
  }
}

extension on http.StreamedResponse {
  get body => null;
}
