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
        
        #判断是否创建上传文件夹
        upload_folder = os.path.join(current_app.instance_path, 'uploads')
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)
        
        # 保存图片到指定路径
        file_path = os.path.join(upload_folder, filename)
        file.save(file_path)
        
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
