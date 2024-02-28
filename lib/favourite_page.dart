import 'package:flutter/material.dart';
import 'database.dart';
import 'character.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Character>> futureFavoriteCharacters;

  @override
  void initState() {
    super.initState();
    futureFavoriteCharacters = DatabaseService.characters(); // Panggil sebagai metode statis
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Page"),
      ),
      body: FutureBuilder<List<Character>>(
        future: futureFavoriteCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            List<Character> favoriteCharacters = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(favoriteCharacters[index].image),
                  title: Text(favoriteCharacters[index].name),
                  subtitle: Text(favoriteCharacters[index].gender),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      DatabaseService.deleteCharacter(
                          favoriteCharacters[index].name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Removed from Favorites"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      setState(() {
                        favoriteCharacters.removeAt(index);
                      });
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