# API 使用指南

## 基础信息

- **基础URL：** `http://localhost:5000`
- **响应格式：** JSON
- **请求头：** 
  ```
  Content-Type: application/json
  ```

## API 详细说明

### 1. 相册初始化 API

用于批量上传图片并初始化数据库。

- **接口：** `POST /api/init/upload`
- **Content-Type:** `multipart/form-data`
- **参数：**
  ```javascript
  {
    images: File[],  // 图片文件列表
    user_id: string  // 用户ID
  }
  ```
- **响应示例：**
  ```json
  {
    "message": "成功处理 3 张图片",
    "results": [
      {
        "image_id": 1,
        "status": "success"
      },
      {
        "filename": "image2.jpg",
        "status": "error",
        "message": "文件格式不支持"
      }
    ]
  }
  ```
- **错误响应：**
  ```json
  {
    "error": "没有上传文件"
  }
  ```
- **Flutter 调用示例：**
  ```dart
  Future<void> uploadImages(List<File> images, String userId) async {
    var uri = Uri.parse('http://localhost:5000/api/init/upload');
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
    if (response.statusCode == 200) {
      print('上传成功');
    } else {
      print('上传失败');
    }
  }
  ```

### 2. 图片搜索 API

根据文本描述搜索相似图片。

- **接口：** `POST /api/search`
- **请求体：**
  ```json
  {
    "text": "一只橙色的猫",
    "threshold": 0.5  // 可选，相似度阈值
  }
  ```
- **响应示例：**
  ```json
  {
    "results": [
      {
        "image_id": 1,
        "image_path": "/uploads/user_1/20240312_123456.jpg",
        "similarity": 0.85
      },
      {
        "image_id": 2,
        "image_path": "/uploads/user_1/20240312_123457.jpg",
        "similarity": 0.75
      }
    ]
  }
  ```
- **Flutter 调用示例：**
  ```dart
  Future<List<ImageResult>> searchImages(String searchText) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': searchText,
        'threshold': 0.5,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List)
          .map((item) => ImageResult.fromJson(item))
          .toList();
    } else {
      throw Exception('搜索失败');
    }
  }
  ```

### 3. 文生图 API

根据文本描述生成图片。

- **接口：** `POST /api/generate/image`
- **请求体：**
  ```json
  {
    "text": "一只可爱的卡通猫咪",
    "user_id": "123"
  }
  ```
- **响应示例：**
  ```json
  {
    "image_id": 5,
    "image_path": "/uploads/generated/20240312_123458.jpg"
  }
  ```
- **Flutter 调用示例：**
  ```dart
  Future<String> generateImage(String text, String userId) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/generate/image'),
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
      throw Exception('生成失败');
    }
  }
  ```

### 4. 图生文 API

根据图片生成文本描述。

- **接口：** `POST /api/generate/text`
- **Content-Type:** `multipart/form-data`
- **参数：**
  ```javascript
  {
    image: File,    // 图片文件
    user_id: string // 用户ID
  }
  ```
- **响应示例：**
  ```json
  {
    "text_id": 3,
    "text": "一只橙色的猫咪正在窗台上晒太阳"
  }
  ```
- **Flutter 调用示例：**
  ```dart
  Future<String> generateText(File image, String userId) async {
    var uri = Uri.parse('http://localhost:5000/api/generate/text');
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
      throw Exception('生成失败');
    }
  }
  ```

## 错误处理

所有API在发生错误时都会返回以下格式的响应：

```json
{
  "error": "错误描述信息"
}
```

常见错误码：
- 400：请求参数错误
- 401：未授权
- 404：资源不存在
- 500：服务器内部错误

## 注意事项

1. 图片上传限制：
   - 支持的格式：JPG、PNG、WEBP
   - 最大文件大小：16MB
   - 建议图片分辨率：不超过1024x1024

2. 接���调用建议：
   - 批量上传图片时建议添加进度提示
   - 生成任务可能需要较长时间，建议添加加载提示
   - 搜索时考虑添加防抖处理

3. 错误处理建议：
   - 实现统一的错误处理机制
   - 为用户提供友好的错误提示
   - 添加重试机制

4. 图片分类：
   - User upload: 'user_upload'
   - AI generated: 'ai_generated'

5. 文本分类：
   - User input: 'user_input'
   - AI generated: 'ai_generated'

## 开发环境设置

1. 配置基础URL：
```dart
const baseUrl = 'http://localhost:5000';  // 开发环境
// const baseUrl = 'https://api.yourserver.com';  // 生产环境
```

2. 添加请求拦截器：
```dart
class ApiClient {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 10),
  ));

  ApiClient() {
    dio.interceptors.add(LogInterceptor());  // 添加日志拦截器
  }
}
``` 