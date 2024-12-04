from transformers import pipeline
from flask import current_app
import torch
from PIL import Image
import io

class AIService:
    @staticmethod
    def generate_image_from_text(text):
        """文本生成图片"""
        generator = pipeline('text-to-image', 
                           model=current_app.config['TEXT_TO_IMAGE_MODEL'])
        image = generator(text)
        return image[0]
    
    @staticmethod
    def generate_text_from_image(image):
        """图片生成文本"""
        image_to_text = pipeline("image-to-text", 
                               model="nlpconnect/vit-gpt2-image-captioning")
        text = image_to_text(image)[0]['generated_text']
        return text
