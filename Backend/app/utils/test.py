import requests

from app.utils.decoder_JSON import decode_generate_t2i_response, decode_generate_t2t_response, extract_image_urls, \
    print_images

# if __name__ == '__main__' :
#     # text = input("输入绘图提示词：")
#     text = '一只可爱的小狗'
#
#     url = "https://api.siliconflow.cn/v1/chat/completions"
#
#     payload = {
#         "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
#         "messages": [
#             {
#                 "role": "user",
#                 "content": f"Please translate and refine the following Chinese prompt{text} into a detailed and enriched "
#                            "English prompt suitable for image generation models. "
#             }
#         ]
#     }
#     headers = {
#         "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
#         "Content-Type": "application/json"
#     }
#
#     response = requests.request("POST", url, json=payload, headers=headers)
#     # 检查响应状态码
#     if response.status_code == 200:
#         # 尝试解析JSON响应
#         try:
#             data = response.json()
#             print("Response Data:", data)
#             content = decode_generate_t2t_response(data)
#             print(content)
#         except ValueError:
#             print("Response is not in JSON format")
#     else:
#         print("Failed to get a successful response")
#         print("Status Code:", response.status_code)
#         print("Response Text:", response.text)
#
#     url = "https://api.siliconflow.cn/v1/images/generations"
#
#     payload = {
#         "model": "black-forest-labs/FLUX.1-dev",
#         "prompt": "a lovely dog",
#         "image_size": "768x1024",
#         "seed": 1,
#         "num_inference_steps": 30,
#         "prompt_enhancement": True
#     }
#     headers = {
#         "Authorization": "Bearer sk-apicdtvngpwcxtyutoftsmxgsxwltoftncmzbaeehbrbqlem",
#         "Content-Type": "application/json"
#     }
#
#     response = requests.request("POST", url, json=payload, headers=headers)
#
#     # 检查响应状态码
#     if response.status_code == 200:
#         # 尝试解析JSON响应
#         try:
#             data = response.json()
#             print("Response Data:", data)
#             # 解码响应
#             img_url = decode_generate_t2i_response(data)
#         except ValueError:
#             print("Response is not in JSON format")
#     elif response.status_code == 503:
#         print("Failed to get a successful response")
#         print("Status Code:", response.status_code)
#         print("Response Text:", response.text)
#     else:
#         print("Failed to get a successful response")
#         print("Status Code:", response.status_code)
#         print("Response Text:", response.text)
#
#     while (response.status_code != 200):
#         response = requests.request("POST", url, json=payload, headers=headers)
#
#         # 检查响应状态码
#         if response.status_code == 200:
#             # 尝试解析JSON响应
#             try:
#                 data = response.json()
#                 print("Response Data:", data)
#                 # 解码响应
#                 img_url = decode_generate_t2i_response(data)
#             except ValueError:
#                 print("Response is not in JSON format")
#         elif response.status_code == 503:
#             print("Failed to get a successful response")
#             print("Status Code:", response.status_code)
#             print("Response Text:", response.text)
#         else:
#             print("Failed to get a successful response")
#             print("Status Code:", response.status_code)
#             print("Response Text:", response.text)
#
#     json_str = response.json()
#     # 提取images中的url
#     img_urls_images = extract_image_urls(json_str, 'images')
#     print("Image URLs from 'images':")
#     print_images(img_urls_images)
#
#     # 提取data中的url
#     img_urls_data = extract_image_urls(json_str, 'data')
#     print("\nImage URLs from 'data':")
#     print_images(img_urls_data)

