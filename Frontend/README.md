# I2T Magic - AI图文助手

一个基于Flutter开发的AI图文创作助手应用，支持图生文和文生图功能。

## 功能特性

### 图生文功能
- ✅ 支持从相册选择图片
- ✅ 图片自动上传至阿里云OSS
- ✅ AI自动生成图片描述文案
- ✅ 图文卡片式展示
- ✅ 支持删除历史记录
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