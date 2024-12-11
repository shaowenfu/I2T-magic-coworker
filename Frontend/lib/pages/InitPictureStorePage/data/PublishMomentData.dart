class PublishMomentData {
  int? code;
  String? message;
  dynamic data;

  PublishMomentData({this.code, this.message, this.data});

  PublishMomentData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}
