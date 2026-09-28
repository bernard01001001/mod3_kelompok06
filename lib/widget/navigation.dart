// lib/widget/navigation.dart
import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/favorites.dart';
import '../screens/history.dart';
import '../screens/profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Country> _favorites = [];
  final List<Country> _history = [];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addToFavorites(Country country) {
    if (!_favorites.any((element) => element.name == country.name)) {
      setState(() {
        _favorites.add(country);
      });
    }
  }

  void _addToHistory(Country country) {
    setState(() {
      _history.removeWhere((element) => element.name == country.name);
      _history.insert(0, country); // Posisi terbaru paling atas
    });
  }

  void _deleteFavorite(Country country) {
    setState(() {
      _favorites.removeWhere((element) => element.name == country.name);
    });
  }

  void _deleteHistory(Country country) {
    setState(() {
      _history.removeWhere((element) => element.name == country.name);
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        onAddToFavorites: _addToFavorites,
        onAddToHistory: _addToHistory,
      ),
      FavoritesPage(
        favoriteList: _favorites,
        onDeleteFavorite: _deleteFavorite,
      ),
      HistoryPage(
        historyList: _history,
        onDeleteHistory: _deleteHistory,
        onClearHistory: _clearHistory,
      ),
      ProfilePage(onHomeTap: () => _onTabTapped(0)),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // Diperlukan jika item > 3
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
