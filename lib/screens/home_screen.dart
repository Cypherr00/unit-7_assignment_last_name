// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import '/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureCharacters;
  late List<ExpandedTileController> _controllers;

  @override
  void initState() {
    super.initState();
    futureCharacters = ApiService.fetchCharacters(); // Fetch characters on init
  }

  // Initialize the controllers
  void _initializeControllers(int count) {
    _controllers = List.generate(count, (_) => ExpandedTileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Naruto Characters"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureCharacters,  // Fetch the data from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;
            _initializeControllers(characters.length);  // Initialize controllers for the list

            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                // Safe checks for image and jutsu to avoid errors
                final imageUrl = character['images'] != null && character['images'].isNotEmpty
                    ? character['images'][0]
                    : 'https://via.placeholder.com/50'; // Default image if no image is available

                final jutsu = character['jutsu'] != null ? character['jutsu'].join(', ') : 'No Jutsu Available';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ExpandedTile(
                    controller: _controllers[index],
                    theme: const ExpandedTileThemeData(
                      headerColor: Colors.blue,
                
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    title: Text(
                      character['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description: $jutsu',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    // Show image in the header of the tile
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);  // Fallback image on error
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}
