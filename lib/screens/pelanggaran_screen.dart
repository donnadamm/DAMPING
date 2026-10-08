import 'package:flutter/material.dart';
import 'catat_pelanggaran_screen.dart';

class PelanggaranScreen extends StatefulWidget {
  const PelanggaranScreen({super.key});

  @override
  State<PelanggaranScreen> createState() => _PelanggaranScreenState();
}

class _PelanggaranScreenState extends State<PelanggaranScreen> {
  String selectedFilter = 'Semua';

  final List<Map<String, dynamic>> pelanggaran = [
    {
      'nama': 'Andi Pratama',
      'kelas': 'X RPL 1',
      'pelanggaran': 'Terlambat masuk sekolah',
      'tanggal': '12 Sep 2026',
      'poin': 5,
      'status': 'SP 1',
    },
    {
      'nama': 'Citra Lestari',
      'kelas': 'X RPL 1',
      'pelanggaran': 'Membolos',
      'tanggal': '10 Sep 2026',
      'poin': 20,
      'status': 'SP 2',
    },
    {
      'nama': 'Budi Santoso',
      'kelas': 'X RPL 2',
      'pelanggaran': 'Tidak memakai atribut',
      'tanggal': '09 Sep 2026',
      'poin': 5,
      'status': 'Normal',
    },
    {
      'nama': 'Deni Kurniawan',
      'kelas': 'X RPL 2',
      'pelanggaran': 'Tidak mengerjakan tugas',
      'tanggal': '08 Sep 2026',
      'poin': 10,
      'status': 'SP 1',
    },
    {
      'nama': 'Siti Aminah',
      'kelas': 'X RPL 1',
      'pelanggaran': 'Terlambat masuk sekolah',
      'tanggal': '07 Sep 2026',
      'poin': 5,
      'status': 'Normal',
    },
  ];

  List<Map<String, dynamic>> get filteredPelanggaran {
    if (selectedFilter == 'Semua') {
      return pelanggaran;
    }

    return pelanggaran
        .where((item) => item['status'] == selectedFilter)
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'SP 1':
        return const Color(0xFFFFE1E5);
      case 'SP 2':
        return const Color(0xFFFFE8C7);
      default:
        return const Color(0xFFDDF5E3);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'SP 1':
        return const Color(0xFFE5394F);
      case 'SP 2':
        return const Color(0xFFE88A00);
      default:
        return const Color(0xFF42A85F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        title: const Text(
          'Pelanggaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Nanti diarahkan ke halaman catat pelanggaran
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nama siswa atau pelanggaran...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF2C7DEB),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),

          // FILTER
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterButton('Semua'),
                _buildFilterButton('SP 1'),
                _buildFilterButton('SP 2'),
                _buildFilterButton('Normal'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // JUMLAH DATA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${filteredPelanggaran.length} Pelanggaran',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF163B75),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.filter_list,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: filteredPelanggaran.length,
              itemBuilder: (context, index) {
                final item = filteredPelanggaran[index];

                return _buildPelanggaranCard(item);
              },
            ),
          ),
        ],
      ),

      // TOMBOL TAMBAH
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2C7DEB),
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigasi ke halaman Catat Pelanggaran
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CatatPelanggaranScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    final bool isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C7DEB) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2C7DEB)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            filter,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPelanggaranCard(Map<String, dynamic> item) {
    final String status = item['status'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Nanti menuju detail pelanggaran
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AVATAR
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5F0FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item['nama'][0],
                    style: const TextStyle(
                      color: Color(0xFF2C7DEB),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // DATA
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF163B75),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item['kelas'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['pelanggaran'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${item['tanggal']} • +${item['poin']} poin',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: getStatusTextColor(status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
