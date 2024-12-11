class ImageResult {
  final String imageId;
  final String imagePath;
  final String imageUrl;
  final double similarity;

  ImageResult({
    required this.imageId,
    required this.imagePath,
    required this.imageUrl,
    required this.similarity,
  });

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      imageId: json['image_id'],
      imagePath: json['image_path'],
      imageUrl: json['image_path'],
      similarity: json['similarity'].toDouble(),
    );
  }
}
