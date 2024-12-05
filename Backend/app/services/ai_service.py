from transformers import pipeline
from flask import current_app
import torch
from PIL import Image
import io

from app.utils.decoder_JSON import decode_generate_image_response


class AIService:
    @staticmethod
    def generate_image_from_text(text):
        """文本生成图片"""
        import requests

        url = "https://api.siliconflow.cn/v1/images/generations"

        payload = {
            "model": "stabilityai/stable-diffusion-3-5-large",
            "prompt": "<string>",
            "negative_prompt": "<string>",
            "image_size": "1024x1024",
            "batch_size": 2,
            "seed": 4999999999,
            "num_inference_steps": 25,
            "guidance_scale": 50,
            "prompt_enhancement": False
        }
        headers = {
            "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
            "Content-Type": "application/json"
        }

        response = requests.request("POST", url, json=payload, headers=headers)
        # 解码响应
        img_url = decode_generate_image_response(response)

        return img_url
    
    @staticmethod
    def generate_text_from_image(image):
        """图片生成文本"""
        image_to_text = pipeline("image-to-text", 
                               model="nlpconnect/vit-gpt2-image-captioning")
        text = image_to_text(image)[0]['generated_text']
        return text
