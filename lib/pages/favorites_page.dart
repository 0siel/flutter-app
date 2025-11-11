import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/my_app_state.dart';
import 'package:flutter_application_1/pages/details_page.dart';

//Favorites page
//Gurda la l'ogica para mostrar las imagenes favoritas
//y permite navegar a la pagina de detalles al tocar una imagen
//Utiliza Provider para acceder al estado de la aplicacion
//y muestra una lista de ListTile con las imagenes favoritas
//cada ListTile tiene una imagen en miniatura, un titulo y un subtitulo
//al tocar un ListTile navega a la pagina de detalles correspondiente
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
        for (var imageUrl in appState.favorites)
          ListTile(
            leading: Image.network(
              'https://corsproxy.io/?$imageUrl',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
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
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 56);
              },
            ),
            title: Text('Favorite Cat'),
            subtitle: Text(
              imageUrl,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(imageUrl: imageUrl),
                ),
              );
            },
          ),
      ],
    );
  }
}
