from app import db
from datetime import datetime

class ImageTextRelation(db.Model):
    __tablename__ = 'image_text_relations'
    
    id = db.Column(db.Integer, primary_key=True)
    img_id = db.Column(db.String(255), db.ForeignKey('images.img_id'), nullable=False)
    text_id = db.Column(db.String(255), db.ForeignKey('texts.text_id'), nullable=False)
    created_time = db.Column(db.DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f'<ImageTextRelation {self.id}>' 