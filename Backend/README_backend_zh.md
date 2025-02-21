# AI 图像搜索与生成后端

<div align="center">

![Python](https://img.shields.io/badge/python-3.8%2B-blue)
![Flask](https://img.shields.io/badge/flask-2.0%2B-green)
![PostgreSQL](https://img.shields.io/badge/postgresql-13%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
[![文档](https://img.shields.io/badge/文档-最新-brightgreen.svg)](./API.md)

基于 Flask 和现代 AI 模型构建的强大图像搜索和生成后端服务

[特性](#特性) • [快速开始](#快速开始) • [架构](#架构) • [API](#api) • [开发](#开发) • [English](./README_backend.md)

</div>

## ✨ 特性

- 🔍 **基于向量的图像搜索** - 将图像转换为向量进行高效相似度搜索
- 🎨 **文本生成图像** - 使用 FLUX 模型根据文本描述生成图像
- 📝 **图像生成文本** - 使用 InternVL2 模型从图像生成文本描述
- 🗄️ **高效存储** - 基于 PostgreSQL 的向量存储，具有优化的索引
- 🌐 **RESTful API** - 文档完善的 API 端点，具有全面的错误处理
- 🔐 **身份验证** - 基于 JWT 的用户认证系统

## 🚀 快速开始

### 环境要求

```bash
python 3.8+
postgresql 13+
```

### 安装步骤

```bash
# 克隆仓库
git clone https://github.com/yourusername/project-name.git

# 安装依赖
pip install -r requirements.txt

# 设置环境变量
cp .env.example .env
# 编辑 .env 配置

# 初始化数据库
flask db upgrade

# 运行服务器
python run.py
```

## 🏗️ 架构

```
backend/
├── app/                    # 应用核心
│   ├── models/            # 数据库模型
│   ├── routes/            # API 路由
│   ├── services/          # 业务逻辑
│   └── utils/             # 辅助工具
├── config.py              # 配置文件
└── run.py                 # 入口文件
```

## 💾 数据库设计

<details>
<summary>点击展开数据库架构</summary>

### 核心表

| 表名 | 描述 |
|------|------|
| users | 用户信息与认证 |
| images | 图像元数据与向量 |
| texts | 文本描述与向量 |
| image_text_relations | 图像-文本关系 |

</details>

## 🔌 API

详细的 API 文档请查看 [API.md](./API.md)

### 主要端点

| 端点 | 方法 | 描述 |
|------|------|------|
| `/api/init/upload` | POST | 初始化图像数据库 |
| `/api/search` | POST | 搜索相似图像 |
| `/api/generate/image` | POST | 从文本生成图像 |
| `/api/generate/text` | POST | 从图像生成文本 |

## 🛠️ 开发

### 技术栈

- **框架：** Flask + SQLAlchemy
- **数据库：** PostgreSQL
- **AI 模型：**
  - CLIP（向量编码）
  - FLUX（文本生成图像）
  - InternVL2（图像生成文本）

### 运行测试

```bash
pytest tests/
```

### 开发进度

<details>
<summary>查看进度时间线</summary>

#### 2024年3月21日
- ✅ 基础框架搭建
- ✅ 数据库模型实现
- ✅ 核心服务实现
- ✅ API 端点开发

#### 2024年3月22日
- ✅ API 响应标准化
- ✅ 分页功能实现
- ✅ 模型加载优化
- ✅ 语言切换支持

</details>

## 📝 待办事项

- [ ] 用户认证实现
- [ ] 向量存储优化
- [ ] 图像搜索性能改进
- [ ] 缓存机制
- [ ] 日志系统
- [ ] 模型性能监控

## 🤝 贡献

欢迎贡献！请先阅读我们的[贡献指南](CONTRIBUTING.md)。

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- FLUX 模型团队
- InternVL2 模型团队
- 所有贡献者

---

<div align="center">
由 AI 图像搜索团队用 ❤️ 制作
</div> 