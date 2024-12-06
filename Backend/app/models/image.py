from app import db
from datetime import datetime

class Image(db.Model):
    __tablename__ = 'images'
    
    img_id = db.Column(db.String(255), primary_key=True)
    user_id = db.Column(db.String(255), db.ForeignKey('users.user_id'), nullable=False)
    created_time = db.Column(db.DateTime, default=datetime.utcnow)
    category = db.Column(db.String(50))
    feature_vector = db.Column(db.JSON)
    image_path = db.Column(db.String(255))
    
    # 关联
    texts = db.relationship('Text', 
                          secondary='image_text_relations',
                          backref=db.backref('images', lazy=True))
    
    def __repr__(self):
        return f'<Image {self.img_id}>'
