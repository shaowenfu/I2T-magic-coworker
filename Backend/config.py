import os

class Config:
    # 数据库配置
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:fuxiao0714.postgresql@localhost:5432/I2T_magic_db?client_encoding=utf8'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # 文件上传配置
    UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 最大16MB
    
    # AI模型配置
    MODEL_NAME = "openai/clip-vit-base-patch32"  # 用于向量化的模型
    TEXT_TO_IMAGE_MODEL = "stabilityai/stable-diffusion-2-1"  # 用于文生图的模型
    
    # API密钥配置
    OPENAI_API_KEY = "your-api-key"
    
    # 其他配置
    SECRET_KEY = 'your-secret-key'
    DEBUG = True
