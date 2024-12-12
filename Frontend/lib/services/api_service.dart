import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/image_result.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../services/oss_service.dart';
import '../services/user_service.dart';

class ApiService {
  final http.Client client;
  final Dio _dio;

  ApiService({http.Client? client, Dio? dio})
      : client = client ?? http.Client(),
        _dio = dio ?? Dio();

  static const String baseUrl = 'http://10.0.2.2:5000';
  static final _logger = Logger('ApiService');

  // 批量上传图片初始化
  Future<Map<String, dynamic>> uploadInitImages(
      List<String> imageUrls, String userId) async {
    var uri = Uri.parse('$baseUrl/api/init/upload');
    debugPrint('开始发送URL列表到后端');
    final body = {
      'user_id': userId,
      'image_urls': imageUrls,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('上传失败: ${response.statusCode}');
    }
  }

  // 图片搜索
  Future<List<ImageResult>> searchImages(String searchText,
      {double threshold = 0.5}) async {
    final userId = UserService().userId;
    if (userId == null) throw Exception('未登录');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'text': searchText,
          'threshold': threshold,
        }),
      );

      debugPrint('服务器响应状态码: ${response.statusCode}');
      debugPrint('服务器响应内容: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<ImageResult> results = [];

        for (var item in data['results']) {
          // 解析每个搜索结果
          String imageUrl = item['image_path'];
          double similarity = item['similarity'].toDouble();
          String imageId = item['image_id'];

          // 下载图片
          String? localPath = await downloadImage(imageUrl);

          if (localPath != null) {
            results.add(ImageResult(
              imageId: imageId,
              imagePath: localPath,
              imageUrl: imageUrl,
              similarity: similarity,
            ));
          }
        }

        return results;
      } else {
        throw Exception('搜索失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('搜索出错: $e');
      throw Exception('搜索失败: $e');
    }
  }

  // 文生图
  Future<String> generateImage(String text, String userId, String selectedSize,
      String selectedStyle) async {
    try {
      const url = '$baseUrl/api/generate/image';
      debugPrint('正在接服务器...');
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
      throw Exception('请超时，请稍后重���');
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

  Future<void> publishMoment(List<XFile> images) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final imageFiles =
        await Future.wait(images.map((image) => _processImage(image)));

    final formData = FormData.fromMap({
      "photos": imageFiles,
    });

    final response = await _dio.post(
      '/v1/moment/publish',
      data: formData,
      options: Options(
        headers: {"x-token": token},
      ),
    );

    if (response.data['code'] != 200) {
      throw Exception(response.data['message'] ?? '发布失败');
    }
  }

  Future<MultipartFile> _processImage(XFile image) async {
    final bytes = await image.readAsBytes();
    return MultipartFile.fromBytes(
      bytes,
      filename: image.name,
      contentType: MediaType("image", "jpg"),
    );
  }

  Future<String?> downloadImage(String url) async {
    // 调用oss_service中的下载方法
    return await FileManager().download(
      url: url,
      fileType: 'jpg',
    );
  }

  Future<List<Map<String, dynamic>>> getUserImages() async {
    final userId = UserService().userId;
    if (userId == null) throw Exception('未登录');

    try {
      debugPrint('获取图片列表');
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/images/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint('服务器响应状态码: ${response.statusCode}');
      debugPrint('服务器响应内容: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 200) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        throw Exception(data['message']);
      } else {
        throw Exception('获取图片列表失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('获取图片列表失败: $e');
      throw Exception('获取图片列表失败: $e');
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    debugPrint('发送登录请求');
    debugPrint('用户名: $username');
    debugPrint('密码: $password');
    const url = '$baseUrl/api/auth/login';
    try {
      debugPrint('发送请求：$url');
      final response = await _dio.post(url, data: {
        'username': username,
        'password': password,
      });

      if (response.data != null) {
        // 保存用户信息
        await UserService().saveUserInfo(
          userId: username, // 或者使用服务器返回的user_id
          token: response.data['token'], // 如果服务器返回token
        );
      }

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register(
      String username, String password) async {
    debugPrint('发送注册请求');
    debugPrint('用户名: $username');
    debugPrint('密码: $password');
    const url = '$baseUrl/api/auth/register';
    try {
      debugPrint('发送请求：$url');
      debugPrint('请求数据：$username, $password');
      final response = await _dio.post(url, data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } catch (e) {
      debugPrint('注册失败: $e');
      rethrow;
    }
  }
}

extension on http.StreamedResponse {
  get body => null;
}
