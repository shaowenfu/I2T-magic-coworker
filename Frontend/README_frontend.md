# I2T Magic - AI Image & Text Assistant 🎨

<div align="center">

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[简体中文](README_frontend_zh.md) | English

An AI-powered image and text creation assistant built with Flutter, supporting image-to-text generation, text-to-image generation, intelligent image search, and album management.

![App Preview](image-1.png)

</div>

## ✨ Features

<table>
  <tr>
    <td width="50%">
      <h3>🖼️ Image to Text</h3>
      <ul>
        <li>Single/batch image selection</li>
        <li>Automatic upload to Aliyun OSS</li>
        <li>AI-powered description generation</li>
        <li>Card-style display with details</li>
        <li>History management</li>
      </ul>
    </td>
    <td width="50%">
      <h3>✍️ Text to Image</h3>
      <ul>
        <li>Text-based AI image generation</li>
        <li>Multiple size options (S/M/L)</li>
        <li>Various artistic styles</li>
        <li>Auto-save generated images</li>
        <li>Real-time progress tracking</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h3>🔍 Smart Search</h3>
      <ul>
        <li>Keyword-based album search</li>
        <li>Image similarity scoring</li>
        <li>Preview and detail view</li>
      </ul>
    </td>
    <td width="50%">
      <h3>📁 Album Management</h3>
      <ul>
        <li>Batch upload initialization</li>
        <li>View all uploaded images</li>
        <li>Cloud storage sync</li>
      </ul>
    </td>
  </tr>
</table>

## 🛠️ Tech Stack

- **Frontend Framework**: Flutter 3.x
- **State Management**: Provider
- **Network**: Dio
- **Image Processing**: image_picker
- **Storage**: Aliyun OSS

## 📦 Project Structure

```
lib/
  ├── models/          # Data models
  ├── pages/           # Page components
  │   ├── generate/    # Text to image
  │   ├── search/      # Image search
  │   └── text_generate/ # Image to text
  ├── services/        # API services
  └── main.dart        # Entry point
```

## 🚀 Getting Started

1. **Prerequisites**
   ```bash
   flutter --version  # Ensure Flutter 3.x installed
   ```

2. **Installation**
   ```bash
   git clone https://github.com/username/i2t_magic_frontend.git
   cd i2t_magic_frontend
   flutter pub get
   ```

3. **Configuration**
   ```dart
   // lib/constants/app_constants.dart
   const baseUrl = 'http://localhost:5000';  # API endpoint
   ```

4. **Run**
   ```bash
   flutter run
   ```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Contact

Project Maintainer - [@username](https://github.com/username)

Project Link: [https://github.com/username/i2t_magic_frontend](https://github.com/username/i2t_magic_frontend)