from flask import Blueprint, request, jsonify
from app.services.ai_service import AIService
from app.services.image_service import ImageService
from app.models.text import Text
from app import db

image_to_text_bp = Blueprint('image_to_text', __name__)

@image_to_text_bp.route('/api/generate/text', methods=['POST'])
def generate_text():
    """根据图片生成文本描述"""
    if 'image' not in request.files:
        return jsonify({'error': '没有上传图片'}), 400
        
    file = request.files['image']
    user_id = request.form.get('user_id')
    
    try:
        # 处理上传的图片
        image_path = ImageService.process_upload(file, user_id)
        
        # 生成文本描述
        generated_text = AIService.generate_text_from_image(image_path)
        
        # 保存到数据库
        text = Text(
            user_id=user_id,
            content=generated_text,
            category='AI生成'
        )
        db.session.add(text)
        db.session.commit()
        
        return jsonify({
            'text_id': text.text_id,
            'text': generated_text
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
