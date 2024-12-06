from flask import Blueprint, request, jsonify
from app.services.image_service import ImageService
from app.services.vector_service import VectorService
from app.services.user_service import UserService
from app.utils.id_generator import generate_image_id
from werkzeug.utils import secure_filename
import os

init_bp = Blueprint('init_db', __name__)

@init_bp.route('/api/init/upload', methods=['POST'])
def upload_images():
    """批量上传图片初始化数据库"""
    if 'images' not in request.files:
        return jsonify({'error': '没有上传文件'}), 400
        
    files = request.files.getlist('images')
    user_id = request.form.get('user_id')
    
    try:
        # 确保用户存在
        user = UserService.get_or_create_user(user_id)
        
        results = []
        for file in files:
            if file.filename:
                try:
                    # 生成图片ID
                    img_id = generate_image_id()
                    # 处理并保存图片
                    image_path = ImageService.process_upload(file, user_id, img_id)
                    # 存储图片向量
                    image = VectorService.store_image_vector(image_path, user_id, img_id)
                    results.append({
                        'image_id': image.img_id,
                        'status': 'success'
                    })
                except Exception as e:
                    results.append({
                        'filename': file.filename,
                        'status': 'error',
                        'message': str(e)
                    })
        
        return jsonify({
            'message': f'成功处理 {len([r for r in results if r.get("status") == "success"])} 张图片',
            'results': results
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
