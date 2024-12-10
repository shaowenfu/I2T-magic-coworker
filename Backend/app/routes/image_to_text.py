from flask import Blueprint, request, jsonify

from app.models import Image, ImageTextRelation
from app.services.ai_service import AIService
from app.services.image_service import ImageService
from app.services.user_service import UserService
from app.models.text import Text
from app.utils.id_generator import generate_text_id, generate_image_id, generate_relation_id
from app.utils.constants import TextCategory, ImageCategory
from app import db

image_to_text_bp = Blueprint('image_to_text', __name__)

@image_to_text_bp.route('/api/generate/text', methods=['POST'])
def generate_text():
    """根据图片生成文本描述"""
    # 添加调试信息
    print('Content-Type:', request.headers.get('Content-Type'))
    print('请求数据:', request.form)
    print('文件数据:', request.files)
    
    # 从表单数据中获取图片URL
    image_url = request.form.get('image_path')
    if not image_url:
        return jsonify({'error': '没有提供图片URL'}), 400
        
    user_id = request.form.get('user_id')
    print('user_id', user_id)
    print('image_url', image_url)
    
    try:
        # 确保用户存在
        user = UserService.get_or_create_user(user_id)
        
        # 使用图片URL生成文本描述
        generated_text = AIService.generate_text_from_image(image_url)  # 需要修改 AIService 以支持 URL

        description = AIService.generate_txt_from_text(generated_text,flag='description')

        # 保存到数据库
        image = Image(
            img_id=generate_image_id(),
            user_id=user_id,
            image_path=image_url,  # 直接使用 OSS URL
            category=ImageCategory.USER_UPLOAD
        )
        db.session.add(image)

        # 提交事务确保 img_id 可用
        db.session.commit()
        
        # 保存到数据库
        text = Text(
            text_id=generate_text_id(),
            user_id=user_id,
            content=description,
            category=TextCategory.AI_GENERATED
        )
        db.session.add(text)

        # 提交事务确保 text_id 可用
        db.session.commit()

        # 保存图像和文本关系表
        image_text_relation = ImageTextRelation(
            id=generate_relation_id(),
            img_id=image.img_id,
            text_id=text.text_id
        )
        db.session.add(image_text_relation)

        # 提交事务
        db.session.commit()
        
        return jsonify({
            'text_id': text.text_id,
            'text': description
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
