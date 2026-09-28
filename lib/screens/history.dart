// lib/screens/history.dart
import 'package:flutter/material.dart';

import 'home.dart';

class HistoryPage extends StatefulWidget {
  final List<Country> historyList;
  final Function(Country) onDeleteHistory;
  final VoidCallback onClearHistory;

  const HistoryPage({
    super.key,
    required this.historyList,
    required this.onDeleteHistory,
    required this.onClearHistory,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (widget.historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              tooltip: 'Delete',
              onPressed: () {
                _showDeleteAllDialog();
              },
            ),
        ],
      ),
      body: widget.historyList.isEmpty
          ? const Center(child: Text("Go look up a country, it's empty here."))
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
                    label: const Text('Delete All'),
                    onPressed: () {
                      _showDeleteAllDialog();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.historyList.length,
                    itemBuilder: (context, index) {
                      final item = widget.historyList[index];
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
                                  errorBuilder: (c, o, s) =>
                                      const Icon(Icons.flag),
                                )
                              : const Icon(Icons.flag),
                          title: Text(item.name),
                          subtitle: Text(item.region),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Hard Delete item spesifik
                              setState(() {
                                widget.onDeleteHistory(item);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All History?'),
        content: const Text(
          'This will delete your entire history permanently.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                widget.onClearHistory();
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
