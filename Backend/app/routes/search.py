from flask import Blueprint, request, jsonify, current_app
from app.services.vector_service import VectorService
from PIL import Image
import requests
from transformers import ChineseCLIPProcessor, ChineseCLIPModel
import torch
from app import db

search_bp = Blueprint('search', __name__)

@search_bp.route('/api/search', methods=['POST'])
def search_images():
    """根据文本搜索相似图片"""
    print('request', request)
    data = request.get_json()
    print('data', data)
    
    if not data or 'text' not in data:
        return jsonify({'error': '缺少搜索文本'}), 400
        
    text = data['text']
    user_id = data.get('user_id')
    print('user_id', user_id)
    print('text', text)
    
    try:
        # 加载模型和处理器
        model = ChineseCLIPModel.from_pretrained("OFA-Sys/chinese-clip-vit-base-patch16")
        processor = ChineseCLIPProcessor.from_pretrained("OFA-Sys/chinese-clip-vit-base-patch16")
        
        # 获取数据库中的图片路径
        vector_service = VectorService(db.session)
        # 获取图片路径
        images = vector_service.get_image_paths(user_id)
        
        # 收集所有有效的图片
        valid_images = [img for img in images if img.feature_vector]
        if not valid_images:
            return jsonify({'results': []})
            
        # 计算每个图片的相似度分数
        logits_list = []
        valid_images_list = []
        
        for img in valid_images:
            try:
                # 从URL获取图片
                response = requests.get(img.image_path, stream=True)
                image = Image.open(response.raw)
                
                # 计算文本和图片的相似度
                inputs = processor(text=[text], images=image, return_tensors="pt")
                outputs = model(**inputs)
                logits = outputs.logits_per_image[0].item()  # 获取logits值
                
                logits_list.append(logits)
                valid_images_list.append(img)
                
            except Exception as e:
                print(f"处理图片 {img.image_path} 时出错: {str(e)}")
                continue
        
        # 对所有logits进行softmax处理
        if logits_list:
            logits_tensor = torch.tensor(logits_list)
            probs = torch.nn.functional.softmax(logits_tensor, dim=0)
            
            # 将概率转换为相似度分数
            similarity_scores = [
                {
                    'image': img,
                    'similarity': float(prob * 100)  # 转换为百分比
                }
                for img, prob in zip(valid_images_list, probs)
            ]
            
            # 按相似度排序
            sorted_results = sorted(similarity_scores, key=lambda x: x['similarity'], reverse=True)
            # 如果结果大于等于5张，返回前5张，否则返回所有结果
            final_results = sorted_results[:5] if len(sorted_results) >= 5 else sorted_results
            print('final_results', final_results)
            
            return jsonify({
                'results': [
                    {
                        'image_id': result['image'].img_id,
                        'image_path': result['image'].image_path,
                        'similarity': round(result['similarity'], 2)  # 保留两位小数
                    }
                    for result in final_results
                ]
            })
        else:
            return jsonify({'results': []})
    except Exception as e:
        print(f"搜索过程发生错误: {str(e)}")
        return jsonify({'error': str(e)}), 500
