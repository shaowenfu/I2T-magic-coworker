from app import db
from datetime import datetime

class User(db.Model):
    __tablename__ = 'users'
    
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True)
    password = db.Column(db.String(128), nullable=False)
    register_time = db.Column(db.DateTime, default=datetime.utcnow)
    last_sign_in = db.Column(db.DateTime, default=datetime.utcnow)
    
    # 关联
    images = db.relationship('Image', backref='user', lazy=True)
    texts = db.relationship('Text', backref='user', lazy=True)
