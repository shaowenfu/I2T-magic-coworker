from app import db
from datetime import datetime

class Image(db.Model):
    __tablename__ = 'images'
    
    img_id = db.Column(db.Integer, primary_key=True)
    text_id = db.Column(db.Integer, db.ForeignKey('texts.text_id'), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    created_time = db.Column(db.DateTime, default=datetime.utcnow)
    category = db.Column(db.String(20), nullable=False)  # 用户上传/AI生成
    feature_vector = db.Column(db.JSON, nullable=False)  # 存储向量
    image_path = db.Column(db.String(255), nullable=False)
