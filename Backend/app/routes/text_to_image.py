from flask import Blueprint, request, jsonify
from app.services.ai_service import AIService
from app.services.image_service import ImageService
from app.models.image import Image
from app.models.text import Text
from app import db

text_to_image_bp = Blueprint('text_to_image', __name__)

@text_to_image_bp.route('/api/generate/image', methods=['POST'])
def generate_image():
    """根据文本生成图片"""
    data = request.get_json()
    
    if not data or 'text' not in data:
        return jsonify({'error': '缺少文本描述'}), 400
        
    text = data['text']
    user_id = data.get('user_id')
    
    try:
        # 生成图片
        generated_image = AIService.generate_image_from_text(text)
        
        # 保存图片
        image_path = ImageService.process_upload(generated_image, user_id)
        
        # 保存到数据库
        image = Image(
            user_id=user_id,
            image_path=image_path,
            category='AI生成'
        )
        db.session.add(image)
        
        # 保存文本
        text_record = Text(
            user_id=user_id,
            img_id=image.img_id,
            content=text,
            category='用户输入'
        )
        db.session.add(text_record)
        
        db.session.commit()
        
        return jsonify({
            'image_id': image.img_id,
            'image_path': image_path
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500 