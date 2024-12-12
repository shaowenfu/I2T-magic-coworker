from flask import Blueprint, request, jsonify
from app.models.user import User
from app.services.user_service import UserService
from app.utils.id_generator import generate_user_id
from app.extensions import db
import hashlib
import jwt
import datetime
import os

auth_bp = Blueprint('auth', __name__)

# 用于 JWT 加密的密钥
SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'your-secret-key')

def hash_password(password):
    """对密码进行哈希处理"""
    return hashlib.sha256(password.encode()).hexdigest()

def generate_token(user_id):
    """生成 JWT token"""
    payload = {
        'user_id': user_id,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(days=7)  # token 7天有效期
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

@auth_bp.route('/api/auth/register', methods=['POST'])
def register():
    """用户注册"""
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': '用户名和密码不能为空'}), 400
    
    username = data['username']
    password = data['password']
    
    # 检查用户名是否已存在
    existing_user = User.query.filter_by(username=username).first()
    if existing_user:
        return jsonify({'error': '用户名已存在'}), 400
    
    try:
        # 创建新用户
        user = User(
            user_id=generate_user_id(),
            username=username,
            password=hash_password(password)
        )
        db.session.add(user)
        db.session.commit()
        
        # 生成 token
        token = generate_token(user.user_id)
        
        return jsonify({
            'message': '注册成功',
            'user_id': user.user_id,
            'token': token
        })
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/api/auth/login', methods=['POST'])
def login():
    """用户登录"""
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': '用户名和密码不能为空'}), 400
    
    username = data['username']
    password = data['password']
    
    try:
        # 查找用户
        user = User.query.filter_by(username=username).first()
        
        if not user or user.password != hash_password(password):
            return jsonify({'error': '用户名或密码错误'}), 401
        
        # 生成 token
        token = generate_token(user.user_id)
        
        return jsonify({
            'message': '登录成功',
            'user_id': user.user_id,
            'token': token
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500