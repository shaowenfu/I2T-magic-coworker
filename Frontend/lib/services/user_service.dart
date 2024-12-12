import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String? _userId;
  String? _token;

  String? get userId => _userId;
  String? get token => _token;

  // 保存用户信息
  Future<void> saveUserInfo({required String userId, String? token}) async {
    _userId = userId;
    _token = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    if (token != null) {
      await prefs.setString('token', token);
    }
  }

  // 加载用户信息
  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id');
    _token = prefs.getString('token');
  }

  // 清除用户信息
  Future<void> clearUserInfo() async {
    _userId = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('token');
  }

  // 检查是否已登录
  bool get isLoggedIn => _userId != null;
}
