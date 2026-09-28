// lib/screens/favorites.dart
import 'package:flutter/material.dart';

import 'home.dart';

class FavoritesPage extends StatefulWidget {
  final List<Country> favoriteList;
  final Function(Country) onDeleteFavorite;

  const FavoritesPage({
    super.key,
    required this.favoriteList,
    required this.onDeleteFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Countries')),
      body: widget.favoriteList.isEmpty
          ? const Center(child: Text('Go like a country or smth'))
          : ListView.builder(
              itemCount: widget.favoriteList.length,
              itemBuilder: (context, index) {
                final item = widget.favoriteList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: item.flagsPng != null
                        ? Image.network(
                            item.flagsPng!,
                            width: 40,
                            errorBuilder: (c, o, s) => const Icon(Icons.flag),
                          )
                        : const Icon(Icons.flag),
                    title: Text(item.name),
                    subtitle: Text(item.region),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.onDeleteFavorite(item);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item.name} deleted from favorites',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
