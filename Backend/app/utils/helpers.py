import os
from PIL import Image
import torch
from transformers import CLIPProcessor, CLIPModel
from flask import current_app

def save_image(file, filename):
    """保存上传的图片"""
    if not os.path.exists(current_app.config['UPLOAD_FOLDER']):
        os.makedirs(current_app.config['UPLOAD_FOLDER'])
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)
    return file_path

def get_image_vector(image_path):
    """获取图片的向量表示"""
    model = CLIPModel.from_pretrained(current_app.config['MODEL_NAME'])
    processor = CLIPProcessor.from_pretrained(current_app.config['MODEL_NAME'])
    
    image = Image.open(image_path)
    inputs = processor(images=image, return_tensors="pt")
    image_features = model.get_image_features(**inputs)
    
    return image_features.detach().numpy().tolist()[0]

def get_text_vector(text):
    """获取文本的向量表示"""
    model = CLIPModel.from_pretrained(current_app.config['MODEL_NAME'])
    processor = CLIPProcessor.from_pretrained(current_app.config['MODEL_NAME'])
    
    inputs = processor(text=text, return_tensors="pt", padding=True)
    text_features = model.get_text_features(**inputs)
    
    return text_features.detach().numpy().tolist()[0]

def calculate_similarity(vector1, vector2):
    """计算两个向量的余弦相似度"""
    return torch.nn.functional.cosine_similarity(
        torch.tensor(vector1).unsqueeze(0),
        torch.tensor(vector2).unsqueeze(0)
    ).item()

