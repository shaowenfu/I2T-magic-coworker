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
    """批量上传图片URL初始化数据库"""
    data = request.get_json()
    print('data',data)
    
    if not data or 'image_urls' not in data or 'user_id' not in data:
        return jsonify({'error': '缺少必要参数'}), 400
        
    image_urls = data['image_urls']
    user_id = data['user_id']
    
    print('image_urls',image_urls)
    print('user_id',user_id)

    try:
        # 确保用户存在
        user = UserService.get_or_create_user(user_id)
        
        results = []
        for image_url in image_urls:
            try:
                # 生成图片ID
                img_id = generate_image_id()
                # 存储图片向量
                image = VectorService.store_image_vector(image_url, user_id, img_id)
                print('image',image)
                results.append({
                    'image_id': image.img_id,
                    'image_url': image_url,
                    'status': 'success'
                })
            except Exception as e:
                results.append({
                    'image_url': image_url,
                    'status': 'error',
                    'message': str(e)
                })
        
        return jsonify({
            'message': f'成功处理 {len([r for r in results if r.get("status") == "success"])} 张图片',
            'results': results
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
