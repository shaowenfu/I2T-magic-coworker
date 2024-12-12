import re

import requests
from transformers import pipeline
from flask import current_app
import torch
from PIL import Image
import io

from app.utils.decoder_JSON import decode_generate_t2i_response,decode_generate_t2t_response


class AIService:
    @staticmethod
    def generate_txt_from_text(text,flag):
        print("text:",text)
        if flag == 'prompt_enhancement':
            print("进入generate_txt_from_text函数，开始优化prompt")
            content = (f"Please refine（if it is in Chinese, translate into English first) the following prompt'生成符合以下描述的写实照片风格的图片：{text}' into a detailed and enriched "
                      "English prompt suitable for image generation models. Please just give the new prompt directly without any additional description or tips.")
        else:
            print("进入generate_txt_from_text函数，开始优化description") 
            content = f'''"{text}"以上是一段英文的文案，请根据这段描述，用中文生成一段吸引人的文案，我需要用作社交平台的文案。要求：1.不单纯翻译，而是用有感染力和艺术感的语言 2.重新组织内容，简短，一两句话即可。忽略转义字符，并以适合中文语言习惯的方式表达原文的意境和深意。3.牢记是用于社交媒体的文案，不要太冗长文学化，要简短。最后，注意只需要输出文案即可，不要有多余的解释说明内容。再次强调，只输出相应的中文文案！！！'''

        # 请根据这段描述，用中文生成一段吸引人的文案，我需要用作社交平台的文案。要求：
        #                       1.不单纯翻译，而是用有感染力和艺术感的语言 2.重新组织内容，简短，一两句话即可。忽略转义字符，并以适合中文语言习惯的方式表达原文的意境和深意。3.牢记是用于社交媒体的文案，不要太冗长文学化，要简短。最后，注意只需要输出文案即可，不要有多余的解释说明内容。再次强调，只输出相应的中文文案！！！
        # 模型一：免费，但是老是出现错误
        # url = "https://api.siliconflow.cn/v1/chat/completions"
        #
        # payload = {
        #     "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
        #     "messages": [
        #         {
        #             "role": "user",
        #             "content": content
        #         }
        #     ]
        # }
        # headers = {
        #     "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
        #     "Content-Type": "application/json"
        # }
        #
        # response = requests.request("POST", url, json=payload, headers=headers)
        # 检查响应状态码

        # 模型二：
        import requests

        url = "https://api.siliconflow.cn/v1/chat/completions"

        payload = {
            "model": "meta-llama/Meta-Llama-3.1-405B-Instruct",
            "messages": [
                {
                    "role": "user",
                    "content": content
                }
            ]
        }
        headers = {
            "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
            "Content-Type": "application/json"
        }

        response = requests.request("POST", url, json=payload, headers=headers)

        print('response:',response.text)

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

        if flag == 'prompt_enhancement':
            return content
        # 保留中文字符和常见中文标点符号，移除其他内容
        text = re.sub(r'[^\u4e00-\u9fa5，。！？；：、]', '', content)
        # 移除多余的空白（如果需要清理残留空格）
        text = re.sub(r'\s+', '', text)
        print("清理之后的图片文案：",text.strip())

        return text.strip()

    @staticmethod
    def generate_image_from_text(text,selectedSize):
        """文本生成图片"""
        print("进入generate_image_from_text函数，开始生成图片")
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
        import requests

        url = "https://api.siliconflow.cn/v1/chat/completions"

        payload = {
            "model": "Pro/OpenGVLab/InternVL2-8B",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image_url",
                            "image_url": {
                                "detail": "high",
                                "url": f"{image}"
                            }
                        }
                    ]
                },
                {
                    "role": "user",
                    "content": "I want to share this photo on social media and need your help crafting the perfect caption. It should be strikingly unique, captivating, and deeply meaningful. Let the words stand out with a distinctive tone and charm!"
                }
            ]
        }
        headers = {
            "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
            "Content-Type": "application/json"
        }

        # 打印请求信息
        print(f"请求URL: {url}")
        print(f"请求头: {headers}")
        print(f"请求体: {payload}")
        
        response = requests.request("POST", url, json=payload, headers=headers)

        print(response.text)
        
        if response.status_code == 200:
            try:
                result = response.json()
                generated_text = result['choices'][0]['message']['content']
                return generated_text
            except Exception as e:
                print(f"Error parsing response: {e}")
                return "无法生成描述"
        else:
            print(f"API request failed with status code: {response.status_code}")
            return "生成描述失败"


