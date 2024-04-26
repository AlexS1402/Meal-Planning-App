import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  Future<dynamic> fetchTest() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/test'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to make API call: $e');
    }
  }
}
