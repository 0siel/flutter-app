import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/my_app_state.dart'; // <-- UPDATE THIS
import 'package:flutter_application_1/pages/details_page.dart'; // <-- ADD THIS

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
                // --- ADD InkWell WIDGET HERE ---
                child: InkWell(
                  onTap: () {
                    // This is the navigation magic!
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(imageUrl: url),
                      ),
                    );
                  },
                  child: Card(
                    // ... (rest of your Card widget) ...
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
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
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
