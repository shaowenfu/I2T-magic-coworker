from app.models.user import User
from app.utils.id_generator import generate_user_id
from app import db

class UserService:
    @staticmethod
    def get_user(user_id):
        """获取用户信息"""
        return User.query.filter_by(user_id=user_id).first()
    
    @staticmethod
    def create_user(user_id=None, username=None):
        """创建新用户，如果只提供user_id，则使用user_id作为username"""
        try:
            # 如果没有提供user_id，生成新的
            if not user_id:
                user_id = generate_user_id()
            
            # 如果没有提供username，使用user_id
            if not username:
                username = f"user_{user_id}"
            
            user = User(
                user_id=user_id,
                username=username,
                password="default_password"  # 在实际应用中应该使用安全的密码机制
            )
            db.session.add(user)
            db.session.commit()
            return user
        except Exception as e:
            db.session.rollback()
            raise e
    
    @staticmethod
    def get_or_create_user(user_id):
        """获取用户，如果不存在则创建"""
        user = UserService.get_user(user_id)
        if not user:
            user = UserService.create_user(user_id)
        return user 