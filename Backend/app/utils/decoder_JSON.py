import json

def decode_generate_t2i_response(json_response):
    try:
        # 解析JSON字符串
        response_data = json_response

        # 提取生成图片的URL
        image_url = response_data.get('images', [{}])[0].get('url', None)

        # 提取推理时间
        inference_time = response_data.get('timings', {}).get('inference', None)

        # 提取种子值
        seed = response_data.get('seed', None)

        return image_url

    except json.JSONDecodeError:
        print("错误: 无法解析JSON")
        return None


import json


def decode_generate_t2t_response(data):
    try:

        # 提取 "content" 字段的值
        content = data.get("choices", [])[0].get("message", {}).get("content", "")

        return content

    except (json.JSONDecodeError, IndexError, KeyError) as e:
        # 错误处理
        print(f"Error decoding JSON or accessing key: {e}")
        return None


def extract_image_urls(data, key):
    """
    从JSON字符串中提取图片URLs。

    参数:
    json_str (str): JSON字符串。
    key (str): 包含图片URLs的键。

    返回:
    list: 图片URL列表。
    """
    try:
        # 提取指定key中的url
        return [item['url'] for item in data.get(key, [])]
    except json.JSONDecodeError as e:
        print("Failed to decode JSON:", e)
        return []


def print_images(img_urls):
    """
    打印图片URL列表。

    参数:
    img_urls (list): 图片URL列表。
    """
    for i, url in enumerate(img_urls, start=1):
        print(f"Image {i}: {url}")
        display_image_from_url(url)


import requests
from PIL import Image
from io import BytesIO


def display_image_from_url(url):
    """
    根据URL下载并显示图片。

    参数:
    url (str): 图片的URL。
    """
    try:
        # 发送HTTP GET请求获取图片
        response = requests.get(url)
        response.raise_for_status()  # 如果请求返回了一个错误状态码，将抛出异常

        # 使用Pillow加载图片
        image = Image.open(BytesIO(response.content))

        # 显示图片
        image.show()
    except requests.RequestException as e:
        print(f"Failed to retrieve image from {url}: {e}")
    except IOError as e:
        print(f"Failed to display image: {e}")
