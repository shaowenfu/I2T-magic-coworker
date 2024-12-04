from flask import Blueprint, request, jsonify
from app.services.vector_service import VectorService

search_bp = Blueprint('search', __name__)

@search_bp.route('/api/search', methods=['POST'])
def search_images():
    """根据文本搜索相似图片"""
    data = request.get_json()
    
    if not data or 'text' not in data:
        return jsonify({'error': '缺少搜索文本'}), 400
        
    text = data['text']
    threshold = data.get('threshold', 0.5)  # 相似度阈值，默认0.5
    
    try:
        similar_images = VectorService.search_similar_images(text, threshold)
        
        return jsonify({
            'results': [
                {
                    'image_id': result['image'].img_id,
                    'image_path': result['image'].image_path,
                    'similarity': result['similarity']
                }
                for result in similar_images
            ]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500
