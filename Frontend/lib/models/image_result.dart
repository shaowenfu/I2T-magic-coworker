class ImageResult {
  final int imageId;
  final String imagePath;
  final double similarity;

  ImageResult({
    required this.imageId,
    required this.imagePath,
    this.similarity = 0.0,
  });

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      imageId: json['image_id'],
      imagePath: json['image_path'],
      similarity: json['similarity'] ?? 0.0,
    );
  }
}
