# 项目名称

## 项目简介
我希望构建一个前后端分离的图片搜索、生成应用，主要功能包括：

- **图片向量化存储：** 将用户上传的图片编码成向量，存储到数据库中。
- **图片搜索：** 用户输入关键词，系统根据关键词生成向量，并在数据库中查找相似图片。
- **文生图：** 用户输入文本描述，系统生成对应的图片。
- **图生文：** 用户上传图片，系统生成对应的文本描述。

我已经准备好了前端界面和 PostgreSQL 数据库，现在需要构建 Python 后端。

## 总体思路

1. **配置 Flask 和 SQLAlchemy**：
    - 配置与 PostgreSQL 数据库的连接。
    - 使用 SQLAlchemy 定义数据库表的 ORM 模型。
    - **Pillow:** 图像处理库
    - **transformers:** Hugging Face的预训练模型库，用于文本生成和向量化
    - psycopg2：用于连接PostgreSQL数据库。
    - Flask-Migrate：用于数据库迁移。
    - Flask-RESTful：用于快速创建RESTful API。
2. **实现 RESTful API**：
    - 定义四组核心功能的接口，包括数据库初始化、图片搜索、文生图和图生文。
3. **封装数据库操作**：
    - 提供统一的数据库操作接口以简化代码。
4. **文件处理与模型调用**：
    - 使用工具库处理图片和文本（如 `Pillow` 或 `torch`）。
    - 调用预训练模型处理向量编码和生成任务。
5. **前后端交互**：
    - 定义接口端点与 Flutter 前端通信。

## 项目结构

```
backend/
├── app/                         # 应用主目录
│   ├── __init__.py             # 应用初始化，创建Flask实例，注册蓝图
│   ├── models/                 # 数据模型目录
│   │   ├── __init__.py         # 模型包初始化
│   │   ├── user.py             # 用户模型：用户信息表结构
│   │   ├── image.py            # 图片模型：图片信息和向量存储
│   │   └── text.py             # 文本模型：文本描述存储
│   ├── routes/                 # 路由目录
│   │   ├── __init__.py         # 路由包初始化，导出所有蓝图
│   │   ├── init_db.py          # 数据库初始化接口：处理图片上传和向量化
│   │   ├── search.py           # 图片搜索接口：处理文本搜索请求
│   │   ├── text_to_image.py    # 文生图路由：处理文本生成图片请求
│   │   └── image_to_text.py    # 图生文路由：处理图片生成文本请求
│   ├── services/               # 服务层目录
│   │   ├── __init__.py         # 服务包初始化
│   │   ├── ai_service.py       # AI服务：处理模型调用和生成任务
│   │   ├── image_service.py    # 图片服务：处理图片上传和压缩
│   │   └── vector_service.py   # 向量服务：处理向量计算和相似度搜索
│   └── utils/                  # 工具目录
│       ├── __init__.py         # 工具包初始化
│       └── helpers.py          # 辅助函数：图片处理和向量计算等通用功能
├── config.py                   # 配置文件：数据库配置、API密钥等
└── run.py                      # 应用入口：启动Flask服务器
```

## 数据库设计：

**表一：图片存储**

| Keys |      img_ID（main key) | Text_ID | user_id | created_time | catagory | feature_vector | image_path |
| --- | --- | --- | --- | --- | --- | --- | --- |
| describe | 图片编号 | 关联文本 | 关联用户 | 创建时间 | 图片来源 | 图片向量 | 图片路径 |
| instance | 01 | 02 | 123456 | 2024/12/3 15:21 | 用户上传 | (JSON) |  |
|  |  |  |  |  | AI生成 |  |  |

**表二：用户**

| keys | user_id（main key) | username | email | password | register | last_sign_in |
| --- | --- | --- | --- | --- | --- | --- |
| describe | 用户唯一标识 | 用户名字（string类型)） | 用户邮箱（默认为null） | 密码 | 注册时间 | 上一次登录时间 |
| instance | 01 | sherwen | 3378*****@**mail.com | 123456 | 2024/12/3 15:21 | 2024/12/3 15:21 |

表三：文本存储

| keys | Text_ID | img_ID | user_id | created_time | catagory | feature_vector |
| --- | --- | --- | --- | --- | --- | --- |
| describe | 文本编号 | 关联图像（默认为空） | 关联用户 | 创建时间 | 文本来源 | 文本向量 |
| instance | 02 | 01 | 123456 | 2024/12/3 15:21 | 用户上传 | (JSON) |
|  |  |  |  |  | AI生成 |  |

## 功能特性
核心功能：
1. 前置条件：相册数据库初始化
    - 步骤：
        1. 下载安装软件
        2. 给予软件相册访问权限
        3. 选择上传相册中的需要检索的图片（包含一键全部上传选项）
        4. 选中图片发送到后端并编码成向量储存在数据库中
        5. 显示上传进度
        6. 初始化数据库完成
2. 相册图片搜索
    - 交互效果:
        1. 用户输入关键词，点击搜索按钮
        2. 文本将被发送到后端进行编码
        3. 编码后的文本向量在后端与数据库中的所有图片向量计算相似度
        4. 后端返回相似度大于某个阈值的所有图片
        5. 前端显示图片
3. 文案配图（文生图）
    - 交互效果
        1. 用户输入描述文本，点击生成按钮
        2. 描述文本被发送到后端
        3. 后端调用大模型生成图片
        4. 后端返回图片
        5. 前端显示图片
4. 图片生成文案
    - 交互效果
        1. 用户导入相册图片
        2. 图片发送到后端
        3. 后端调用大模型生成文本描述
        4. 后端返回文本描述
        5. 前端展示文本

## 技术栈

- **后端框架：** Flask + SQLAlchemy
- **数据库：** PostgreSQL
- **AI模型：** 
  - CLIP：用于图文向量化
  - Stable Diffusion：用于文生图
  - GPT-2：用于图生文
- **工具库：**
  - Pillow：图像处理
  - transformers：模型调用
  - psycopg2：PostgreSQL连接
  - Flask-Migrate：数据库迁移

## 安装说明

### 1. 环境准备
```bash
# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
.\venv\Scripts\activate  # Windows

# 安装所有依赖
pip install -r requirements.txt
```

### 2. 配置
1. 修改 `config.py` 中的数据库连接信息：
```python
SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost:5432/your_database'
```

2. 设置API密钥（如果使用）：
```python
OPENAI_API_KEY = "your-api-key"
```

### 3. 数据库初始化
```bash
# 初始化迁移
flask db init

# 创建迁移脚本
flask db migrate -m "initial migration"

# 应用迁移
flask db upgrade
```

### 4. 运行服务器
```bash
python run.py
```

## API接口说明

### 1. 相册初始化
- **接口：** POST /api/init/upload
- **参数：** 
  - images: 图片文件列表（multipart/form-data）
  - user_id: 用户ID

### 2. 图片搜索
- **接口：** POST /api/search
- **参数：** 
  ```json
  {
    "text": "搜索文本",
    "threshold": 0.5
  }
  ```

### 3. 文生图
- **接口：** POST /api/generate/image
- **参数：** 
  ```json
  {
    "text": "图片描述",
    "user_id": "用户ID"
  }
  ```

### 4. 图生文
- **接口：** POST /api/generate/text
- **参数：** 
  - image: 图片文件（multipart/form-data）
  - user_id: 用户ID

## 开发进展

### 2024-03-xx
- [x] 完成基础框架搭建
- [x] 实现数据库模型
- [x] 实现核心服务层
- [x] 完成API接口开发

### 待办事项
- [ ] 添加用户认证
- [ ] 优化向量检索性能
- [ ] 添加缓存机制
- [ ] 完善错误处理
- [ ] 添加日志系统
