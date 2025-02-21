# I2T Magic - AI图文助手 🎨

<div align="center">

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

English | [简体中文](README_frontend_zh.md)

基于Flutter开发的AI图文创作助手应用，支持图生文和文生图功能，提供智能图片搜索和相册管理功能。

![应用预览](image-1.png)

</div>

## ✨ 主要功能

<table>
  <tr>
    <td width="50%">
      <h3>🖼️ 图生文功能</h3>
      <ul>
        <li>支持单张/多张图片选择</li>
        <li>图片自动上传至阿里云OSS</li>
        <li>AI智能生成图片描述文案</li>
        <li>图文卡片式展示，支持查看详情</li>
        <li>支持删除历史记录</li>
      </ul>
    </td>
    <td width="50%">
      <h3>✍️ 文生图功能</h3>
      <ul>
        <li>支持文本描述生成AI图片</li>
        <li>支持选择图片尺寸（小/中/大）</li>
        <li>支持多种艺术风格</li>
        <li>生成图片自动保存至本地</li>
        <li>支持实时生成进度展示</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h3>🔍 智能搜索</h3>
      <ul>
        <li>支持关键词搜索相册图片</li>
        <li>显示图片相似度匹配分数</li>
        <li>支持图片预览和查看详情</li>
      </ul>
    </td>
    <td width="50%">
      <h3>📁 相册管理</h3>
      <ul>
        <li>支持批量上传初始化相册</li>
        <li>支持查看所有已上传图片</li>
        <li>自动同步云端存储</li>
      </ul>
    </td>
  </tr>
</table>

## 🛠️ 技术栈

- **前端框架**: Flutter 3.x
- **状态管理**: Provider
- **网络请求**: Dio
- **图片处理**: image_picker
- **存储服务**: 阿里云OSS

## 📦 项目结构

```
lib/
  ├── models/          # 数据模型
  ├── pages/           # 页面组件
  │   ├── generate/    # 文生图
  │   ├── search/      # 图片搜索
  │   └── text_generate/ # 图生文
  ├── services/        # API服务
  └── main.dart        # 入口文件
```

## 🚀 快速开始

1. **环境要求**
   ```bash
   flutter --version  # 确保安装Flutter 3.x
   ```

2. **安装**
   ```bash
   git clone https://github.com/username/i2t_magic_frontend.git
   cd i2t_magic_frontend
   flutter pub get
   ```

3. **配置**
   ```dart
   // lib/constants/app_constants.dart
   const baseUrl = 'http://localhost:5000';  // API接口地址
   ```

4. **运行**
   ```bash
   flutter run
   ```

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 开源协议

本项目采用 MIT 协议 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📧 联系方式

项目维护者 - [@username](https://github.com/username)

项目链接: [https://github.com/username/i2t_magic_frontend](https://github.com/username/i2t_magic_frontend) 