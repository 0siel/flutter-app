import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Cats App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

Future<List<String>> fetchCatImages() async {
  final url = Uri.parse('https://api.thecatapi.com/v1/images/search?limit=10');
  print('Fetching 10 cat images...');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item['url'] as String).toList();
    } else {
      throw Exception('Failed to fetch images: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching cat images: $e');
    throw Exception('Error: $e');
  }
}

//.....................................

class MyAppState extends ChangeNotifier {
  List<String> images = [];
  List<String> favorites = [];
  bool isLoading = false;

  MyAppState() {
    getImages();
  }

  Future<void> getImages() async {
    isLoading = true;
    notifyListeners();

    try {
      images = await fetchCatImages();
    } catch (e) {
      images = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String url) {
    if (favorites.contains(url)) {
      favorites.remove(url);
    } else {
      favorites.add(url);
    }
    notifyListeners();
  }
}

// ..............................................

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();

      case 1:
        page = FavoritesPage();

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (appState.images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading images'),
            ElevatedButton(
              onPressed: () => appState.getImages(),
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: appState.images.length,
            itemBuilder: (context, index) {
              final url = appState.images[index];
              final isFavorite = appState.favorites.contains(url);

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Image
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          'https://corsproxy.io/?$url',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (_, __, ___) =>
                              Center(child: Icon(Icons.broken_image, size: 50)),
                        ),
                      ),

                      // Like button (top-right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () {
                              appState.toggleFavorite(url);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => appState.getImages(),
            child: Text("Load 10 New Cats"),
          ),
        ),
      ],
    );
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have '
            '${appState.favorites.length} favorites:',
          ),
        ),

        // We loop through the list of URL strings
        for (var imageUrl in appState.favorites)
          ListTile(
            // Use Image.network in the 'leading' spot for a thumbnail
            leading: Image.network(
              'https://corsproxy.io/?$imageUrl',
              width: 56, // Give it a fixed size
              height: 56,
              fit: BoxFit.cover, // Cover the square space
              // Optional: Add a loading spinner for each thumbnail
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                );
              },

              // Optional: Add an error icon if a specific thumbnail fails
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 56);
              },
            ),

            // You can show the URL (truncated) in the subtitle
            title: Text('Favorite Cat'),
            subtitle: Text(
              imageUrl,
              overflow:
                  TextOverflow.ellipsis, // Prevents long URL from breaking UI
              maxLines: 1,
            ),
          ),
      ],
    );
  }
}
