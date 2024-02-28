import 'package:flutter/material.dart';
import 'api_service.dart';
import 'character.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Character>> futureCharacters;
  late List<Character> favoriteCharacters = [];

  @override
  void initState() {
    super.initState();
    futureCharacters = ApiService().fetchCharacters();
    _loadFavoriteCharacters();
  }

  void _loadFavoriteCharacters() async {
    List<Character> characters = await DatabaseService.characters();
    setState(() {
      favoriteCharacters = characters;
    });
  }

  bool _isCharacterFavorite(Character character) {
    return favoriteCharacters.any((favChar) => favChar.name == character.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            List<Character> characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                Character character = characters[index];
                bool isFavorite = _isCharacterFavorite(character);
                return ListTile(
                  leading: Image.network(character.image),
                  title: Text(character.name),
                  subtitle: Text(character.gender),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () async {
                      if (!_isCharacterFavorite(character)) {
                        await DatabaseService.insertCharacter(character);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added to Favorites"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        _loadFavoriteCharacters();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("This character is already in favorites"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
