# I2T Magic Frontend

I2T Magic (Image to Text Magic) 是一个图文助手应用，提供图片搜索、文生图、图生文等功能。

## 功能特性

- 图片搜索：通过文本描述搜索相似图片
- 文生图：根据文本描述生成相应的图片
- 图生文：自动为图片生成文字描述
- 图片库初始化：批量上传图片建立初始图片库

## 技术栈

- Flutter
- Dart
- HTTP 网络请求
- 图片处理
- 权限管理

## 开始使用

### 环境要求

- Flutter 3.0.0 或更高版本
- Dart 2.17.0 或更高版本
- Android Studio / VS Code

### 安装步骤

1. 克隆项目
我来帮你更新README文档，添加项目相关信息和使用说明：

```bash
git clone https://github.com/your-username/i2t_magic_frontend.git
```

2. 安装依赖
```bash
cd i2t_magic_frontend
flutter pub get
```

3. 运行项目
```bash
flutter run
```

### 配置说明

1. 在 `lib/services/api_service.dart` 中配置后端API地址：
```dart
static const String baseUrl = 'http://your-api-server:5000';
```

2. 确保设备有相应权限（相册访问等）

## API 接口

应用使用以下主要API端点：

- `/api/search` - 图片搜索
- `/api/generate/image` - 文生图
- `/api/generate/text` - 图生文
- `/api/init/upload` - 批量上传图片

## 项目结构

```
lib/
  ├── models/          # 数据模型
  ├── pages/           # 页面
  │   ├── generate/    # 文生图
  │   ├── search/      # 图片搜索
  │   └── text_generate/ # 图生文
  ├── services/        # API服务
  └── main.dart        # 入口文件
```

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 联系方式

项目维护者 - [@your-username](https://github.com/your-username)

项目链接: [https://github.com/your-username/i2t_magic_frontend](https://github.com/your-username/i2t_magic_frontend)