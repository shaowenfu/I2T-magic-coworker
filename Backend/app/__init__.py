from flask import Flask
from config import Config
from app.extensions import db, migrate

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # 初始化扩展
    db.init_app(app)
    migrate.init_app(app, db)
    
    # 注册蓝图
    from app.routes import init_bp, search_bp, text_to_image_bp, image_to_text_bp, user_images
    from app.routes.auth import auth_bp
    
    app.register_blueprint(init_bp)
    app.register_blueprint(search_bp)
    app.register_blueprint(text_to_image_bp)
    app.register_blueprint(image_to_text_bp)
    app.register_blueprint(user_images.bp)
    app.register_blueprint(auth_bp)
    
    app.db_session = db.session
    
    return app 