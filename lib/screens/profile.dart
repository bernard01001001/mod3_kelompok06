// lib/screens/profile.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onHomeTap;
  const ProfilePage({super.key, this.onHomeTap});

  // Data masing-masing anggota kelompok
  final List<Map<String, String>> teamMembers = const [
    {
      'Nama': 'Sharon Tabitha Santoso',
      'NIM': '21120124120016',
      'Foto': 'https://via.placeholder.com/150',
      'Deskripsi': 'Kelompok 6',
    },
    {
      'Nama': 'Nurul Kumala',
      'NIM': '21120124140113',
      'Foto': 'https://via.placeholder.com/150',
      'Deskripsi': 'Kelompok 6',
    },
    {
      'Nama': 'Dinda Azra Ariefah',
      'NIM': '21120124120039',
      'Foto': 'https://via.placeholder.com/150',
      'Deskripsi': 'Kelompok 6',
    },
    {
      'Nama': 'Bernard Ivan Salim',
      'NIM': '21120123130000',
      'Foto': 'https://via.placeholder.com/150',
      'Deskripsi': 'Kelompok 6',
    },
  ];

  // Fungsi untuk menampilkan info detail anggota saat diklik
  void _showMemberDetail(BuildContext context, Map<String, String> member) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(member['Foto']!),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              Text(
                member['Nama']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NIM: ${member['NIM']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                member['Deskripsi'] ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: onHomeTap),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Members',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return InkWell(
                  onTap: () => _showMemberDetail(context, member),
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundImage: NetworkImage(member['Foto']!),
                            onBackgroundImageError: (_, __) {},
                            child: const Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            member['Nama']!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
