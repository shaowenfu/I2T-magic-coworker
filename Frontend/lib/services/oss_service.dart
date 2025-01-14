import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

class FileManager {
  // 私有构造函数，防止类被实例化
  FileManager._internal();

  // 唯一实例，通过工厂构造函数获取
  static final FileManager instance = FileManager._internal();

  // 工厂构造函数
  factory FileManager() => instance;

  // 从环境变量或配置文件中读取
  static const String bucket = String.fromEnvironment('OSS_BUCKET');
  static const String url = String.fromEnvironment('OSS_URL');
  static const String ossAccessKeyId =
      String.fromEnvironment('OSS_ACCESS_KEY_ID');
  static const String ossAccessKeySecret =
      String.fromEnvironment('OSS_ACCESS_KEY_SECRET');

  // 过期时间
  static String expiration = DateTime.now()
      .add(const Duration(hours: 1))
      .toUtc()
      .toString()
      .replaceAll(' ', 'T');

  Future<String?> uploadFile(
    File file,
  ) async {
    final String? url = await upload(file: file);
    debugPrint('url:$url');
    return url;
  }

  /**
   * @params file 要上传的文件对象
   * @params rootDir 阿里云oss设置的根目录文件夹名字
   * @param fileType 文件类型例如jpg,mp4等
   * @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
   * @param onSendProgress 传的进度事件
   * 参考文档https://help.aliyun.com/zh/oss/developer-reference/postobject#section-mcg-hq4-y1k
   */

  static Future<String?> upload({
    required File file,
    String rootDir = 'folder',
  }) async {
    String policyText =
        '{"expiration": "$expiration","conditions": [{"bucket": "$bucket" },["content-length-range", 0, 1048576000]]}';
    // 获取签名
    String signature = getSignature(policyText);
    BaseOptions options = BaseOptions();
    options.responseType = ResponseType.plain;
    //创建dio对象
    Dio dio = Dio(options);
    // 生成oss的路径和文件名：folder/2023829/test.mp4
    String pathName =
        '$rootDir/${getDate()}/${getRandom(12)}.${getFileType(file.path)}';
    // 请求参数的form对象
    FormData data = FormData.fromMap({
      'key': pathName,
      'policy': getPolicyBase64(policyText),
      'OSSAccessKeyId': ossAccessKeyId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(file.path),
    });

    Response response;
    CancelToken uploadCancelToken = CancelToken();
    try {
      // 发送请求
      response = await dio.post(url,
          data: data,
          cancelToken: uploadCancelToken,
          onSendProgress: (int count, int data) {});
      if (response.statusCode == 200) {
        print('文件上传成功${response.data}');
      }
      // 成功后返回文件访问路径
      return '$url/$pathName';
    } catch (e) {
      print(e);
    }
  }

  /**
   * 下载文件（图片、视频等
   * url:文件url
   */
  Future<String?> download(
      {required String url, required String fileType}) async {
    BaseOptions options = BaseOptions();
    options.responseType = ResponseType.bytes;
    Dio dio = Dio(options);

    try {
      final response = await dio.get<Uint8List>(url);
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      // 创建文件名
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileType';
      // 完整的文件路径
      final filePath = '${tempDir.path}/$fileName';

      // 将数据写入文件
      final file = File(filePath);
      await file.writeAsBytes(response.data!);

      // 返回本地文件路径
      return filePath;
    } catch (e) {
      debugPrint('下载失败: $e');
      return null;
    }
  }

  Future<void> _saveImageToFile(Response response, String fileType) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDir.path}/image.$fileType';
      File file = File(filePath);
      await file.writeAsBytes(response.data);
      print('Image saved to file: $filePath');
    } catch (error) {
      print('Error while saving image: $error');
    }
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = 'abcdefghijklmnopqlstuvwxyzABCDEFGHIJKLMNOPQLSTUVWXYZ';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String? getImageNameByPath(String? filePath) {
    return filePath?.substring(filePath.lastIndexOf("/") + 1, filePath.length);
  }

  /**
   * 获取文件类型
   */
  static String getFileType(String path) {
    print(path);
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  // 获取policy的base64
  static getPolicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    return policy_base64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyText_utf8 = utf8.encode(policyText);
    //进行base64编码
    String policy_base64 = base64.encode(policyText_utf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policy_base64);
    //进行utf8 编码
    List<int> key = utf8.encode(ossAccessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signature_pre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signature_pre);
    return signature;
  }
}
