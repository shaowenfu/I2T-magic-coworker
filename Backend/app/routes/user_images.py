from flask import Blueprint, jsonify
from app.models.image import Image
from app import db

bp = Blueprint('user_images', __name__)

@bp.route('/api/user/images/<string:user_id>', methods=['GET'])
def get_user_images(user_id):
    """
    获取指定用户的所有图片路径
    
    Args:
        user_id (int): 用户ID
        
    Returns:
        JSON响应，包含图片路径列表
    """
    try:
        print('开始获取用户图片')
        try:
            # 查询指定user_id且image_path不为空的记录
            images = Image.query.filter(
                Image.user_id == user_id,
                Image.image_path.isnot(None),
                Image.image_path != ''
            ).all()
        except Exception as e:
            print(f"查询数据库失败: {str(e)}")
            return jsonify({
                'code': 500,
                'message': f'查询数据库失败: {str(e)}',
                'data': None
            }), 500
        print('images',images)
        # 提取图片路径
        image_paths = [
            {
                'img_id': image.img_id,
                'image_path': image.image_path
            } 
            for image in images
        ]
        print('image_paths',image_paths)
        return jsonify({
            'code': 200,
            'message': '获取成功',
            'data': image_paths
        })
        
    except Exception as e:
        print(f"获取用户图片失败: {str(e)}")
        return jsonify({
            'code': 500,
            'message': f'获取图片列表失败: {str(e)}',
            'data': None
        }), 500 