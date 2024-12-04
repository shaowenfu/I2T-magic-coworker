from PIL import Image as PILImage
import os
from flask import current_app
from app.utils.helpers import save_image
from datetime import datetime

class ImageService:
    @staticmethod
    def process_upload(file, user_id):
        """处理上传的图片"""
        # 生成唯一文件名
        filename = f"{user_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.jpg"
        
        # 保存图片
        file_path = save_image(file, filename)
        
        # 压缩图片
        with PILImage.open(file_path) as img:
            # 如果图片太大，进行压缩
            if max(img.size) > 1024:
                img.thumbnail((1024, 1024))
                img.save(file_path, quality=85, optimize=True)
        
        return file_path
    
    @staticmethod
    def get_image_path(image_id):
        """获取图片路径"""
        return os.path.join(current_app.config['UPLOAD_FOLDER'], f"{image_id}.jpg")
