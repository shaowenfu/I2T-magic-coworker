# I2T Magic - AI图文助手

一个基于Flutter开发的AI图文创作助手应用，支持图生文和文生图功能，提供智能图片搜索和相册管理功能。

## ✨ 主要功能

### 🖼️ 图生文功能
- ✅ 支持从相册选择单张/多张图片
- ✅ 图片自动上传至阿里云OSS
- ✅ AI智能生成图片描述文案
- ✅ 图文卡片式展示，支持查看详情
- ✅ 支持删除历史记录
- 🚧 支持分享和保存功能（开发中）

### ✍️ 文生图功能
- ✅ 支持文本描述生成AI图片
- ✅ 支持选择图片尺寸（Small/Medium/Large）
- ✅ 支持多种艺术风格（写实/艺术/卡通等）
- ✅ 生成图片自动保存至本地
- ✅ 支持实时生成进度展示

### 🔍 智能搜索
- ✅ 支持关键词搜索相册图片
- ✅ 显示图片相似度匹配分数
- ✅ 支持图片预览和查看详情

### 📁 相册管理
- ✅ 支持批量上传初始化相册
- ✅ 支持查看所有已上传图片
- ✅ 自动同步云端存储

## 🛠️ 技术栈

- **前端框架**: Flutter 3.x
- **状态管理**: Provider
- **网络请求**: Dio
- **图片处理**: image_picker
- **存储服务**: Aliyun OSS
- ✅ 支持查看图文详情
- 🚧 支持分享功能（开发中）
- 🚧 支持保存功能（开发中）

### 文生图功能
- ✅ 支持文本输入生成图片
- ✅ 生成图片自动保存
- ✅ 历史记录展示
- 🚧 更多功能开发中...

## 技术栈

- Flutter
- Aliyun OSS
- RESTful API
- Provider状态管理

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