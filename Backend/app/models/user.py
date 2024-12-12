from app.extensions import db
from datetime import datetime

class User(db.Model):
    __tablename__ = 'users'
    
    user_id = db.Column(db.String(255), primary_key=True)
    username = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255))
    password = db.Column(db.String(255), nullable=False)
    register = db.Column(db.DateTime, server_default=db.text('CURRENT_TIMESTAMP'))
    last_sign_in = db.Column(db.DateTime, server_default=db.text('CURRENT_TIMESTAMP'))
    
    # 关联
    images = db.relationship('Image', backref='user', lazy=True)
    texts = db.relationship('Text', backref='user', lazy=True)
    
    def __repr__(self):
        return f'<User {self.username}>'
