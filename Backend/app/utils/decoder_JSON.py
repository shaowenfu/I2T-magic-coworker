import json

def decode_generate_image_response(json_response):
    try:
        # 解析JSON字符串
        response_data = json.loads(json_response)

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

