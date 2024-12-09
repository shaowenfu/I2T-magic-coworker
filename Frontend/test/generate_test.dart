import 'package:flutter_test/flutter_test.dart';
import 'package:i2t_magic_frontend/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'generate_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ApiService apiService;
  late http.Client mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  test('生成图片 - 成功场景', () async {
    when(mockClient.post(
      Uri.parse('${ApiService.baseUrl}/api/generate/image'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
          '{"image_path": "images/test.jpg"}',
          200,
        ));

    const testPrompt = '一只可爱的小猫咪在草地上玩耍';
    const testUserId = '123456';

    final imagePath = await apiService.generateImage(testPrompt, testUserId, "Small","photo");
    expect(imagePath, 'images/test.jpg');
  });
}
