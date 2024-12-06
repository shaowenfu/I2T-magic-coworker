import uuid
from datetime import datetime

def generate_user_id():
    """生成用户ID"""
    return f"user_{str(uuid.uuid4())[:8]}"

def generate_image_id():
    """生成图片ID"""
    return f"img_{str(uuid.uuid4())[:8]}"

def generate_text_id():
    """生成文本ID"""
    return f"txt_{str(uuid.uuid4())[:8]}" 