from flask import Blueprint, request, jsonify
from app.models.relation import ImageTextRelation
from app.services.ai_service import AIService
from app.services.image_service import ImageService
from app.services.user_service import UserService
from app.models.image import Image
from app.models.text import Text
from app.utils.id_generator import generate_image_id, generate_relation_id, generate_text_id
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
    user_id = data['user_id']
    selectedSize= data['size']
    print('selectedSize',selectedSize)
    print('text',text)
    print('user_id',user_id)
    try:
        print("进入generate_image函数")
        # 确保用户存在
        user = UserService.get_or_create_user(user_id)

        # 优化prompt
        generate_prompt = AIService.generate_txt_from_text(text,flag='prompt_enhancement')
        print("优化后的prompt",generate_prompt)
        # 生成图片
        generated_image_url = AIService.generate_image_from_text(generate_prompt,selectedSize)
        print("生成后的图片url",generated_image_url)
        print("开始保存到数据库")
        # 保存到数据库
        image = Image(
            img_id=generate_image_id(),
            user_id=user_id,
            image_path=generated_image_url,
            category=ImageCategory.AI_GENERATED
        )
        db.session.add(image)

        # 提交事务确保 img_id 可用
        db.session.commit()

        # 将图片下载保存到本地
        image_path = ImageService.download_image(generated_image_url, image.img_id)
        print("图片保存到本地", image_path)

        # 保存文本
        text_record = Text(
            text_id=generate_text_id(),
            user_id=user_id,
            content=text,
            category=TextCategory.USER_INPUT
        )
        db.session.add(text_record)

        # 提交事务确保 text_id 可用
        db.session.commit()

        # 保存图像和文本关系表
        image_text_relation = ImageTextRelation(
            id=generate_relation_id(),
            img_id=image.img_id,
            text_id=text_record.text_id
        )
        db.session.add(image_text_relation)

        # 提交事务
        db.session.commit()

        print("返回response：",jsonify({
            'image_id': image.img_id,
            'image_path': image_path
        }))
        return jsonify({
            'image_id': image.img_id,
            'image_path': image_path
        })
    except Exception as e:
        db.session.rollback()
        print("出现错误:",str(e))
        return jsonify({'error': str(e)}), 500
