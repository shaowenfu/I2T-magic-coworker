from app.utils.helpers import get_image_vector, get_text_vector, calculate_similarity
from app.utils.constants import ImageCategory
from app.extensions import db
from app.models.image import Image as ImageModel
import numpy as np
import requests
from io import BytesIO
from PIL import Image as PILImage
from sqlalchemy import select

class VectorService:
    def __init__(self, db_session):
        self.db_session = db_session
        
    def get_image_paths(self, user_id=None):
        """获取指定用户上传的图片路径"""
        try:
            query = select(ImageModel).where(ImageModel.category == ImageCategory.USER_UPLOAD)
            if user_id:
                query = query.where(ImageModel.user_id == user_id)
                
            result = self.db_session.execute(query)
            images = result.scalars().all()
            # 过滤掉不是http开头的图片路径
            valid_images = [img for img in images if img.image_path.startswith('http')]
            return valid_images
        except Exception as e:
            print(f"获取图片路径失败: {str(e)}")
            return []

    @staticmethod
    def store_image_vector(image_url, user_id, img_id):
        """
        从URL下载图片，生成向量并存储
        """
        try:
            # 从URL下载图片
            try:
                print('开始从oss下载图片')
                response = requests.get(image_url, stream=True)
                if response.status_code == 200:
                    response_content = BytesIO()
                    for chunk in response.iter_content(4096):
                        response_content.write(chunk)
                    response = type('Response', (), {'content': response_content.getvalue()})()
                else:
                    raise Exception(f"下载图片失败,服务器返回状态码: {response.status_code}")
            except Exception as e:
                raise Exception(f"下载图片时发生错误: {str(e)}")
            
            # 将图片数据转换为PIL Image对象
            image = PILImage.open(BytesIO(response.content))
            # 生成图片向量
            image_features = get_image_vector(image)
            print('image_features',image_features)
            # 将tensor转换为numpy数组，再转换为列表
            vector_list = image_features.detach().numpy().tolist()[0]
            print('vector_list',vector_list)
            try:    
                # 存储到数据库
                image_record = ImageModel(
                    img_id=img_id,
                    user_id=user_id,
                    image_path=image_url,  # 使用URL作为图片路径
                    feature_vector=vector_list,
                    category=ImageCategory.USER_UPLOAD
                )
                db.session.add(image_record)
                db.session.commit()
                print("保存到数据库成功")
                return image_record
            except Exception as e:
                print("保存到数据库失败",e)
                db.session.rollback()  # 添加回滚操作
                raise e
            
        except requests.exceptions.RequestException as e:
            print("下载图片失败",e)
            raise Exception(f"下载图片失败: {str(e)}")
        except Exception as e:
            print("处理图片失败",e)
            raise Exception(f"处理图片失败: {str(e)}")

    
    @staticmethod
    def search_similar_images(text, threshold=0.5):
        """搜索相似图片"""
        text_vector = get_text_vector(text)
        images = ImageModel.query.all()
        
        similar_images = []
        for image in images:
            similarity = calculate_similarity(text_vector, image.feature_vector)
            if similarity > threshold:
                similar_images.append({
                    'image': image,
                    'similarity': similarity
                })
        
        return sorted(similar_images, key=lambda x: x['similarity'], reverse=True)
