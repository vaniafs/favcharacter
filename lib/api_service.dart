import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class ApiService {
  final Uri apiUrl = Uri.parse("https://hp-api.onrender.com/api/characters");

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Character> characters =
      body.map((dynamic item) => Character.fromJson(item)).toList();
      return characters;
    } else {
      throw "Failed to load characters";
    }
  }
}
