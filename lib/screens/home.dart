// lib/screens/home.dart
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'detail.dart';

class HomePage extends StatefulWidget {
  final Function(Country) onAddToFavorites;
  final Function(Country) onAddToHistory;

  const HomePage({
    super.key,
    required this.onAddToFavorites,
    required this.onAddToHistory,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countriesFuture;
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];

  String searchQuery = '';
  String selectedRegion = 'All';

  @override
  void initState() {
    super.initState();
    countriesFuture = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List jsonData = jsonDecode(respBody);
      final list = jsonData.map((j) => Country.fromJson(j)).toList();
      setState(() {
        allCountries = list;
        applyFilterAndSort();
      });
      return list;
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  void applyFilterAndSort() {
    setState(() {
      List<Country> temp = allCountries.where((c) {
        final matchesSearch = c.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        final matchesRegion =
            selectedRegion == 'All' ||
            c.region.toLowerCase() == selectedRegion.toLowerCase();
        return matchesSearch && matchesRegion;
      }).toList();

      temp.sort((a, b) {
        int regionCompare = a.region.toLowerCase().compareTo(
          b.region.toLowerCase(),
        );
        if (regionCompare != 0) {
          return regionCompare;
        }
        return a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ); // Jika benua sama, urutkan berdasarkan nama
      });

      filteredCountries = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Country...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                applyFilterAndSort();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const Text(
                  'Filter : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedRegion,
                  items:
                      <String>[
                        'All',
                        'Africa',
                        'Americas',
                        'Asia',
                        'Europe',
                        'Oceania',
                        'Antarctic',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      selectedRegion = newValue;
                      applyFilterAndSort();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (filteredCountries.isEmpty) {
                  return const Center(child: Text('Country not found'));
                }

                return ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, i) {
                    final country = filteredCountries[i];
                    return Card(
                      child: ListTile(
                        leading: country.flagsPng != null
                            ? Image.network(
                                country.flagsPng!,
                                width: 50,
                                errorBuilder: (c, o, s) =>
                                    const Icon(Icons.flag),
                              )
                            : const SizedBox(width: 50),
                        title: Text(country.name),
                        subtitle: Text('Continent: ${country.region}'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            widget.onAddToFavorites(country);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${country.name} added to favorites!',
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          widget.onAddToHistory(country);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(country: country),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }
    List<dynamic>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }
    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}
