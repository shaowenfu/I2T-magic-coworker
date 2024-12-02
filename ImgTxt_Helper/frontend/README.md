# 图文助手

一个基于Flutter开发的图文处理应用。

## 开发日志

### 2024-03-xx - 项目初始化
- 使用Flutter创建了项目基础框架
- 设置了应用名称为"图文助手"
- 配置了基础的MaterialApp主题
- 规划了项目目录结构

### 2024-03-xx - 添加欢迎页面
- 创建了欢迎页面（Welcome Page）
- 实现了基础UI布局
- 添加了登录提示对话框
- 配置了页面导航
- 添加了背景图片资源

### 2024-03-xx - 创建基础页面框架
- 创建了基础页面：HomePage、EditorPage、SettingsPage
- 配置了基本路由系统
- 完善了页面跳转逻辑

## 项目结构

```lib/
  ├── main.dart           # 应用程序入口文件
  ├── pages/              # 页面文件目录
  │   ├── home/           # 首页相关文件
  │   ├── editor/         # 编辑器相关文件
  │   └── settings/       # 设置页面相关文件
  ├── widgets/            # 可复用的组件
  ├── models/             # 数据模型
  ├── services/           # 服务类（API调用、数据处理等）
  ├── utils/              # 工具类和辅助函数
  ├── constants/          # 常量定义
  └── themes/             # 主题相关配置