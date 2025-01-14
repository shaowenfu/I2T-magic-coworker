import os

class Config:
    # 数据库配置
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'postgresql://postgres:password@localhost:5432/I2T_magic_db?client_encoding=utf8')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # OSS配置
    OSS_ACCESS_KEY_ID = os.getenv('OSS_ACCESS_KEY_ID')  # 从环境变量获取
    OSS_ACCESS_KEY_SECRET = os.getenv('OSS_ACCESS_KEY_SECRET')  # 从环境变量获取
    OSS_ENDPOINT = os.getenv('OSS_ENDPOINT', 'https://oss-cn-chengdu.aliyuncs.com')
    OSS_BUCKET_NAME = os.getenv('OSS_BUCKET_NAME', 'i2t-magic-coworker')
    
    # API密钥配置
    OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
    
    # 其他配置
    SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key')
    DEBUG = os.getenv('FLASK_DEBUG', 'True').lower() == 'true'
