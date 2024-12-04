from app import db
from datetime import datetime

class Text(db.Model):
    __tablename__ = 'texts'
    
    text_id = db.Column(db.Integer, primary_key=True)
    img_id = db.Column(db.Integer, db.ForeignKey('images.img_id'), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    created_time = db.Column(db.DateTime, default=datetime.utcnow)
    category = db.Column(db.String(20), nullable=False)  # 用户输入/AI生成
    feature_vector = db.Column(db.JSON, nullable=False)  # 存储向量
    content = db.Column(db.Text, nullable=False)
