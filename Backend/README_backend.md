# AI-Powered Image Search & Generation Backend

<div align="center">

![Python](https://img.shields.io/badge/python-3.8%2B-blue)
![Flask](https://img.shields.io/badge/flask-2.0%2B-green)
![PostgreSQL](https://img.shields.io/badge/postgresql-13%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
[![Documentation](https://img.shields.io/badge/docs-latest-brightgreen.svg)](./API.md)

A powerful backend service for image search and generation, built with Flask and modern AI models.

[Features](#features) • [Quick Start](#quick-start) • [Architecture](#architecture) • [API](#api) • [Development](#development) • [中文文档](./README_backend_zh.md)

</div>

## ✨ Features

- 🔍 **Vector-based Image Search** - Convert images to vectors for efficient similarity search
- 🎨 **Text-to-Image Generation** - Generate images from text descriptions using FLUX
- 📝 **Image-to-Text Generation** - Generate text descriptions from images using InternVL2
- 🗄️ **Efficient Storage** - PostgreSQL-based vector storage with optimized indexing
- 🌐 **RESTful API** - Well-documented API endpoints with comprehensive error handling
- 🔐 **Authentication** - JWT-based user authentication system

## 🚀 Quick Start

### Prerequisites

```bash
python 3.8+
postgresql 13+
```

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/project-name.git

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Edit .env with your settings

# Initialize database
flask db upgrade

# Run the server
python run.py
```

## 🏗️ Architecture

```
backend/
├── app/                    # Application core
│   ├── models/            # Database models
│   ├── routes/            # API routes
│   ├── services/          # Business logic
│   └── utils/             # Helper utilities
├── config.py              # Configuration
└── run.py                 # Entry point
```

## 💾 Database Schema

<details>
<summary>Click to expand database schema</summary>

### Core Tables

| Table | Description |
|-------|-------------|
| users | User information and authentication |
| images | Image metadata and vectors |
| texts | Text descriptions and vectors |
| image_text_relations | Image-text relationships |

</details>

## 🔌 API

Detailed API documentation can be found in [API.md](./API.md)

### Key Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/init/upload` | POST | Initialize image database |
| `/api/search` | POST | Search for similar images |
| `/api/generate/image` | POST | Generate image from text |
| `/api/generate/text` | POST | Generate text from image |

## 🛠️ Development

### Tech Stack

- **Framework:** Flask + SQLAlchemy
- **Database:** PostgreSQL
- **AI Models:**
  - CLIP (Vector Encoding)
  - FLUX (Text-to-Image)
  - InternVL2 (Image-to-Text)

### Running Tests

```bash
pytest tests/
```

### Development Progress

<details>
<summary>View progress timeline</summary>

#### March 21, 2024
- ✅ Basic framework setup
- ✅ Database models implementation
- ✅ Core services implementation
- ✅ API endpoints development

#### March 22, 2024
- ✅ API response standardization
- ✅ Pagination implementation
- ✅ Model loading optimization
- ✅ Language switching support

</details>

## 📝 Todo

- [ ] User authentication implementation
- [ ] Vector storage optimization
- [ ] Image search performance improvements
- [ ] Caching mechanism
- [ ] Logging system
- [ ] Model performance monitoring

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- FLUX model team
- InternVL2 model team
- All contributors

---

<div align="center">
Made with ❤️ by the AI Image Search Team
</div>
