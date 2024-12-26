import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Fetch characters from the API
  static Future<List<dynamic>> fetchCharacters() async {
    final response = await http.get(Uri.parse('https://narutodb.xyz/api/character'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['characters'];  // Return the characters list
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
