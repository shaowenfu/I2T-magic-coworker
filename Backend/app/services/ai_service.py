import requests
from transformers import pipeline
from flask import current_app
import torch
from PIL import Image
import io

from app.utils.decoder_JSON import decode_generate_t2i_response,decode_generate_t2t_response


class AIService:
    @staticmethod
    def generate_txt_from_text(text):
        url = "https://api.siliconflow.cn/v1/chat/completions"

        payload = {
            "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
            "messages": [
                {
                    "role": "user",
                    "content": f"Please translate and refine the following Chinese prompt{text} into a detailed and enriched "
                               "English prompt suitable for image generation models. Please just give the new prompt"
                }
            ]
        }
        headers = {
            "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
            "Content-Type": "application/json"
        }

        response = requests.request("POST", url, json=payload, headers=headers)
        # 检查响应状态码
        if response.status_code == 200:
            # 尝试解析JSON响应
            try:
                data = response.json()
                print("Response Data:", data)
                content = decode_generate_t2t_response(data)
                print(content)
            except ValueError:
                print("Response is not in JSON format")
        else:
            print("Failed to get a successful response")
            print("Status Code:", response.status_code)
            print("Response Text:", response.text)

        return content

    @staticmethod
    def generate_image_from_text(text,selectedSize):
        """文本生成图片"""
        import requests
        if selectedSize == 'Small':
            image_size = "768x512"
        elif selectedSize == 'Medium':
            image_size = "768x1024"
        elif selectedSize == 'Large':
            image_size = "1024x1024"
        # payload = {
        #     "model": "black-forest-labs/FLUX.1-dev",
        #     "prompt": f"{text}",
        #     "image_size": "768x1024",
        #     "seed": 1,
        #     "num_inference_steps": 30,
        #     "prompt_enhancement": True
        # }
        # headers = {
        #     "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
        #     "Content-Type": "application/json"
        # }
        url = "https://api.siliconflow.cn/v1/images/generations"

        payload = {
            "model": "black-forest-labs/FLUX.1-schnell",
            "image_size": f"{image_size}",
            "prompt_enhancement": True,
            "prompt": f"{text}"
        }
        headers = {
            "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
            "Content-Type": "application/json"
        }


        response = requests.request("POST", url, json=payload, headers=headers)

        # 检查响应状态码
        if response.status_code == 200:
            # 尝试解析JSON响应
            try:
                data = response.json()
                print("Response Data:", data)
                # 解码响应
                img_url = decode_generate_t2i_response(data)
            except ValueError:
                print("Response is not in JSON format")
        elif response.status_code == 503:
            print("Failed to get a successful response")
            print("Status Code:", response.status_code)
            print("Response Text:", response.text)
        else:
            print("Failed to get a successful response")
            print("Status Code:", response.status_code)
            print("Response Text:", response.text)



        return img_url
    
    @staticmethod
    def generate_text_from_image(image):
        """图片生成文本"""
        image_to_text = pipeline("image-to-text", 
                               model="nlpconnect/vit-gpt2-image-captioning")
        text = image_to_text(image)[0]['generated_text']
        return text


