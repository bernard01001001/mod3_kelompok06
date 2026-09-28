// lib/screens/favorites_history.dart
import 'package:flutter/material.dart';

import 'home.dart';

class FavoritesHistoryPage extends StatefulWidget {
  final List<Country> favoriteList;
  final List<Country> historyList;
  final Function(Country) onDeleteFavorite;
  final Function(Country) onDeleteHistory;
  final VoidCallback onClearHistory;

  const FavoritesHistoryPage({
    super.key,
    required this.favoriteList,
    required this.historyList,
    required this.onDeleteFavorite,
    required this.onDeleteHistory,
    required this.onClearHistory,
  });

  @override
  State<FavoritesHistoryPage> createState() => _FavoritesHistoryPageState();
}

class _FavoritesHistoryPageState extends State<FavoritesHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorit & Riwayat'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favorit'),
              Tab(icon: Icon(Icons.history), text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Favorit
            widget.favoriteList.isEmpty
                ? const Center(child: Text('Belum ada favorit.'))
                : ListView.builder(
                    itemCount: widget.favoriteList.length,
                    itemBuilder: (context, index) {
                      final item = widget.favoriteList[index];
                      return ListTile(
                        leading: item.flagsPng != null
                            ? Image.network(item.flagsPng!, width: 40)
                            : const Icon(Icons.flag),
                        title: Text(item.name),
                        subtitle: Text(item.region),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.onDeleteFavorite(item);
                            });
                          },
                        ),
                      );
                    },
                  ),

            // Tab Riwayat dengan Hard Delete (satu per satu atau hapus semua)
            widget.historyList.isEmpty
                ? const Center(child: Text('Belum ada riwayat.'))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Hard Delete Semua Riwayat'),
                          onPressed: () {
                            setState(() {
                              widget.onClearHistory();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.historyList.length,
                          itemBuilder: (context, index) {
                            final item = widget.historyList[index];
                            return ListTile(
                              leading: item.flagsPng != null
                                  ? Image.network(item.flagsPng!, width: 40)
                                  : const Icon(Icons.flag),
                              title: Text(item.name),
                              subtitle: Text(item.region),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Hard Delete spesifik
                                  setState(() {
                                    widget.onDeleteHistory(item);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
