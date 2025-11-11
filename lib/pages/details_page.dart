import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/cat_details.dart';
import 'package:flutter_application_1/providers/my_app_state.dart';

class DetailsPage extends StatelessWidget {
  final String imageUrl;

  const DetailsPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var appState = context.read<MyAppState>();
    // Get the sticky fictional data for this image
    final details = appState.getCatDetails(imageUrl);

    return Scaffold(
      // This AppBar will automatically add a "Back" button
      appBar: AppBar(
        title: Text(details.name), // Show the cat's name in the title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Image
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                'https://corsproxy.io/?$imageUrl',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) =>
                    Center(child: Icon(Icons.broken_image, size: 100)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetailTile(Icons.person, 'Owner', details.owner),
                  _buildDetailTile(
                    Icons.cake,
                    'Age',
                    '${details.age} years old',
                  ),
                  _buildDetailTile(
                    Icons.pets,
                    'Favorite Food',
                    details.favoriteFood,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 16)),
    );
  }
}
