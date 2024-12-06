from app.utils.helpers import get_image_vector, get_text_vector, calculate_similarity
from app.utils.constants import ImageCategory
from app import db
from app.models.image import Image
import numpy as np

class VectorService:
    @staticmethod
    def store_image_vector(image_path, user_id, img_id):
        """存储图片向量"""
        vector = get_image_vector(image_path)
        image = Image(
            img_id=img_id,
            user_id=user_id,
            image_path=image_path,
            feature_vector=vector,
            category=ImageCategory.USER_UPLOAD
        )
        db.session.add(image)
        db.session.commit()
        return image
    
    @staticmethod
    def search_similar_images(text, threshold=0.5):
        """搜索相似图片"""
        text_vector = get_text_vector(text)
        images = Image.query.all()
        
        similar_images = []
        for image in images:
            similarity = calculate_similarity(text_vector, image.feature_vector)
            if similarity > threshold:
                similar_images.append({
                    'image': image,
                    'similarity': similarity
                })
        
        return sorted(similar_images, key=lambda x: x['similarity'], reverse=True)
