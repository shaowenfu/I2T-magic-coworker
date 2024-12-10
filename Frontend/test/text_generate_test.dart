import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  const String OSSAccessKeyId = '<yourAccessKeyId>';
  const String accessKeySecret = '<yourAccessKeySecret>';
  const String policy =
      "{\"expiration\": \"2120-01-01T12:00:00.000Z\",\"conditions\": [[\"content-length-range\", 0, 104857600]]}";
  const String url = 'https://yourBucketName.oss-cn-hangzhou.aliyuncs.com';
  final dio = Dio();

  String getSignature(String encodePolicy) {
    var key = utf8.encode(accessKeySecret);
    var bytes = utf8.encode(encodePolicy);
    var hmacSha1 = Hmac(sha1, key);
    Digest sha1Result = hmacSha1.convert(bytes);
    print("sha1Result:$sha1Result");
    String signature = base64Encode(sha1Result.bytes);
    print("signature:$signature");
    return signature;
  }

  group('OSS Upload Tests', () {
    test('should generate correct signature', () {
      String encodePolicy = base64Encode(utf8.encode(policy));
      String signature = getSignature(encodePolicy);
      expect(signature, isNotEmpty);
    });

    test('should upload file successfully', () async {
      // 创建测试文件
      final testFile = File('test/test_image.jpg');
      String encodePolicy = base64Encode(utf8.encode(policy));
      String signature = getSignature(encodePolicy);
      String fileName = 'test_${DateTime.now().millisecondsSinceEpoch}.jpg';

      var formData = FormData.fromMap({
        'key': fileName,
        'success_action_status': 200,
        'OSSAccessKeyId': OSSAccessKeyId,
        'policy': encodePolicy,
        'Signature': signature,
        'Content-Type': 'image/jpeg',
        'file': await MultipartFile.fromFile(testFile.path),
      });

      var response = await dio.post(
        url,
        data: formData,
        onSendProgress: (int sent, int total) {
          print('Upload progress: $sent/$total');
        },
      );

      expect(response.statusCode, equals(200));
      expect('$url/$fileName', isNotEmpty);
    });
  });
}
