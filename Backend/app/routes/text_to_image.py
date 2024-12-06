from flask import Blueprint, request, jsonify
from app.services.ai_service import AIService
from app.services.image_service import ImageService
from app.services.user_service import UserService
from app.models.image import Image
from app.models.text import Text
from app.utils.id_generator import generate_image_id, generate_text_id
from app.utils.constants import ImageCategory, TextCategory
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
        # 确保用户存在
        user = UserService.get_or_create_user(user_id)

        # 优化prompt
        generate_prompt = AIService.generate_txt_from_text(text)
        # 生成图片
        generated_image_url = AIService.generate_image_from_text(generate_prompt)

        # 保存到数据库
        image = Image(
            img_id=generate_image_id(),
            user_id=user_id,
            image_path=generated_image_url,
            category=ImageCategory.AI_GENERATED
        )
        db.session.add(image)

        # 保存文本
        text_record = Text(
            text_id=generate_text_id(),
            user_id=user_id,
            content=text,
            category=TextCategory.USER_INPUT
        )
        db.session.add(text_record)

        db.session.commit()

        return jsonify({
            'image_id': image.img_id,
            'image_path': generated_image_url
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
