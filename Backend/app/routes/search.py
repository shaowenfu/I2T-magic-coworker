from flask import Blueprint, request, jsonify
from app.services.vector_service import VectorService
from PIL import Image
import requests
from transformers import ChineseCLIPProcessor, ChineseCLIPModel

search_bp = Blueprint('search', __name__)

@search_bp.route('/api/search', methods=['POST'])
def search_images():
    """根据文本搜索相似图片"""
    data = request.get_json()
    
    if not data or 'text' not in data:
        return jsonify({'error': '缺少搜索文本'}), 400
        
    text = data['text']
    
    try:
        # 加载模型和处理器
        model = ChineseCLIPModel.from_pretrained("OFA-Sys/chinese-clip-vit-base-patch16")
        processor = ChineseCLIPProcessor.from_pretrained("OFA-Sys/chinese-clip-vit-base-patch16")
        
        # 处理输入文本
        text_inputs = processor(text=text, padding=True, return_tensors="pt")
        text_features = model.get_text_features(**text_inputs)
        text_features = text_features / text_features.norm(p=2, dim=-1, keepdim=True)
        
        # 获取数据库中所有图片并计算相似度
        similar_images = VectorService.compute_similarities(text_features, model, processor)
        
        # 返回相似度最高的5张图片
        top_5_results = sorted(similar_images, key=lambda x: x['similarity'], reverse=True)[:5]
        
        return jsonify({
            'results': [
                {
                    'image_id': result['image'].img_id,
                    'image_path': result['image'].image_path,
                    'similarity': float(result['similarity'])
                }
                for result in top_5_results
            ]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
