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
import oss2
import os

text_to_image_bp = Blueprint('text_to_image', __name__)

# 添加 OSS 配置
def get_oss_bucket():
    # 从环境变量或配置文件获取密钥
    access_key_id = os.getenv('OSS_ACCESS_KEY_ID')  # 替换为环境变量
    access_key_secret = os.getenv('OSS_ACCESS_KEY_SECRET')  # 替换为环境变量
    
    auth = oss2.Auth(access_key_id, access_key_secret)
    endpoint = os.getenv('OSS_ENDPOINT', 'https://oss-cn-chengdu.aliyuncs.com')
    bucket_name = os.getenv('OSS_BUCKET_NAME', 'i2t-magic-coworker')
    return oss2.Bucket(auth, endpoint, bucket_name)

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
        local_image_path = ImageService.download_image(generated_image_url, image.img_id)
        print("图片保存到本地", local_image_path)

        # 上传到 OSS
        try:
            bucket = get_oss_bucket()
            oss_path = f'AIGenerateImage/{image.img_id}.jpg'  # OSS 中的存储路径
            print("oss_path",oss_path)
            
            try:        
                with open(local_image_path, 'rb') as fileobj:
                    bucket.put_object(oss_path, fileobj)
            except Exception as e:
                print("上传到 OSS 失败:", str(e))
                raise Exception("上传图片到 OSS 失败")
            
            # 构建 OSS 访问 URL
            oss_url = f'https://i2t-magic-coworker.oss-cn-chengdu.aliyuncs.com/{oss_path}'
            
            # 更新数据库中的 image_path 为 OSS URL
            image.image_path = oss_url
            db.session.commit()
            
            # 删除本地临时文件
            os.remove(local_image_path)
            
        except Exception as e:
            print("上传到 OSS 失败:", str(e))
            print("详细错误信息:", str(e.__dict__))  # 打印更详细的错误信息
            raise Exception(f"上传图片到 OSS 失败: {str(e)}")

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
            'image_path': oss_url
        }))
        return jsonify({
            'image_id': image.img_id,
            'image_path': oss_url
        })
    except Exception as e:
        db.session.rollback()
        print("出现错误:",str(e))
        return jsonify({'error': str(e)}), 500
