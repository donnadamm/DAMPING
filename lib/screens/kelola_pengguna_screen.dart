import 'package:flutter/material.dart';
import 'package:damping_app/data/dummy_data.dart';
import 'tambah_pengguna_screen.dart';

class KelolaPenggunaScreen extends StatefulWidget {
  const KelolaPenggunaScreen({super.key});

  @override
  State<KelolaPenggunaScreen> createState() => _KelolaPenggunaScreenState();
}

class _KelolaPenggunaScreenState extends State<KelolaPenggunaScreen> {
  String _selectedFilter = 'Semua';

  // Menggabungkan seluruh data secara dinamis langsung dari DummyData
  List<Map<String, dynamic>> get _listPengguna {
    if (_selectedFilter == 'Guru') return DummyData.guru;
    if (_selectedFilter == 'Orang Tua') return DummyData.orangTua;
    if (_selectedFilter == 'Admin') return DummyData.admin;

    // Jika 'Semua', gabungkan semua data dari DummyData (termasuk akun hasil Register)
    return [
      ...DummyData.admin,
      ...DummyData.guru,
      ...DummyData.orangTua,
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dataTampil = _listPengguna;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kelola Pengguna',
            style: TextStyle(
                color: Color(0xFF0C356A),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0C356A),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama, nomor HP atau role...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter Tab (Pill Buttons)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: ['Semua', 'Guru', 'Orang Tua', 'Admin'].map((filter) {
                bool isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF2C7DEB) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2C7DEB)
                                : Colors.grey.shade300),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // List Pengguna
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: dataTampil.length,
              itemBuilder: (context, index) {
                var user = dataTampil[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFE8F1FF),
                        child: Text(user['nama'][0],
                            style: const TextStyle(
                                color: Color(0xFF2C7DEB),
                                fontWeight: FontWeight.bold)),
                      ),
                      title: Text(user['nama'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C356A),
                              fontSize: 14)),
                      subtitle: Text('${user['role']}\n${user['hp']}',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              height: 1.4)),
                      trailing: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                    Divider(color: Colors.grey.shade200),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // Tombol Mengambang (Floating Action Button) untuk Tambah Pengguna
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke Halaman Tambah, lalu tunggu hasilnya
          bool? isAdded = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TambahPenggunaScreen()),
          );

          // Jika true (ada data ditambahkan), Refresh halaman ini agar list bertambah!
          if (isAdded == true) {
            setState(() {});
          }
        },
        backgroundColor: const Color(0xFF2C7DEB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
