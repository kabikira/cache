import 'dart:convert';

class MockApi {
  Future<Map<String, dynamic>> fetchDummyData() async {
    // 疑似的なネットワーク遅延を再現
    await Future.delayed(const Duration(milliseconds: 500));

    // ダミーURLを想定したレスポンス
    const mockJson = '''
    {
      "id": 123,
      "title": "ダミーデータ",
      "status": "ok",
      "items": [
        {"name": "item1", "value": 10},
        {"name": "item2", "value": 20}
      ]
    }
    ''';

    return jsonDecode(mockJson) as Map<String, dynamic>;
  }
}
