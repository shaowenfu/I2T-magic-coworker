from app import db
from datetime import datetime

class Text(db.Model):
    __tablename__ = 'texts'
    
    text_id = db.Column(db.String(255), primary_key=True)
    user_id = db.Column(db.String(255), db.ForeignKey('users.user_id'), nullable=False)
    created_time = db.Column(db.DateTime, default=datetime.utcnow)
    category = db.Column(db.String(50))
    feature_vector = db.Column(db.JSON)
    content = db.Column(db.Text)
    
    def __repr__(self):
        return f'<Text {self.text_id}>'
