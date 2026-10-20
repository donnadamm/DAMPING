import 'package:flutter/material.dart';
import '../services/local_database.dart';
import 'tambah_pengguna_screen.dart';

class KelolaPenggunaScreen extends StatefulWidget {
  final String initialFilter;

  const KelolaPenggunaScreen({
    super.key,
    this.initialFilter = 'Semua',
  });

  @override
  State<KelolaPenggunaScreen> createState() => _KelolaPenggunaScreenState();
}

class _KelolaPenggunaScreenState extends State<KelolaPenggunaScreen> {
  static const Color primaryBlue = Color(0xFF2C7DEB);
  static const Color deepBlue = Color(0xFF0C356A);

  late String _selectedFilter;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, Object?>> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _keyword = '';

  @override
  void initState() {
    super.initState();

    const filters = ['Semua', 'Guru', 'Orang Tua', 'Admin'];
    _selectedFilter =
        filters.contains(widget.initialFilter) ? widget.initialFilter : 'Semua';

    _searchController.addListener(() {
      if (!mounted) return;
      setState(() {
        _keyword = _searchController.text.trim().toLowerCase();
      });
    });

    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await LocalDatabase.instance.getAll(
        'users',
        orderBy: 'name COLLATE NOCASE ASC',
      );

      if (!mounted) return;

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat pengguna: $e';
      });
    }
  }

  String _roleLabel(Object? role) {
    switch (role?.toString()) {
      case 'guru':
        return 'Guru';
      case 'orang_tua':
        return 'Orang Tua';
      case 'admin':
        return 'Admin';
      default:
        return role?.toString() ?? '-';
    }
  }

  List<Map<String, Object?>> get _filteredUsers {
    return _users.where((user) {
      final role = _roleLabel(user['role']);

      if (_selectedFilter != 'Semua' && role != _selectedFilter) {
        return false;
      }

      final name = (user['name'] ?? '').toString().toLowerCase();
      final phone = (user['phone'] ?? '').toString().toLowerCase();
      final roleText = role.toLowerCase();

      return name.contains(_keyword) ||
          phone.contains(_keyword) ||
          roleText.contains(_keyword);
    }).toList();
  }

  int get _activeCount {
    return _filteredUsers.where((user) {
      return (user['is_active'] as int? ?? 1) == 1;
    }).length;
  }

  Future<void> _openAddUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahPenggunaScreen(),
      ),
    );

    if (result == true) {
      await _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(
            color: deepBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: deepBlue,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama, nomor HP atau role...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: _keyword.isNotEmpty
                    ? IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.close),
                      )
                    : null,
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

          // FILTER ROLE
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['Semua', 'Guru', 'Orang Tua', 'Admin'].map((filter) {
                final isSelected = _selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryBlue : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? primaryBlue : Colors.grey.shade300,
                        ),
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

          // JUMLAH PENGGUNA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$_selectedFilter • ${users.length} pengguna',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: deepBlue,
                    ),
                  ),
                ),
                Text(
                  '$_activeCount aktif',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),

          // DAFTAR PENGGUNA
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _loadUsers,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : users.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _keyword.isNotEmpty
                                        ? 'Pengguna tidak ditemukan.'
                                        : 'Belum ada data pengguna.',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadUsers,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final name =
                                    (user['name'] ?? 'Tanpa Nama').toString();
                                final phone = (user['phone'] ?? '-').toString();
                                final role = _roleLabel(user['role']);
                                final isActive =
                                    (user['is_active'] as int? ?? 1) == 1;

                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        radius: 22,
                                        backgroundColor:
                                            const Color(0xFFE8F1FF),
                                        child: Text(
                                          name.isNotEmpty
                                              ? name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: primaryBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: deepBlue,
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          '$role • $phone\n'
                                          '${isActive ? 'Aktif' : 'Nonaktif'}',
                                          style: TextStyle(
                                            color: isActive
                                                ? Colors.grey.shade600
                                                : Colors.red.shade400,
                                            fontSize: 12,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      isThreeLine: true,
                                    ),
                                    Divider(
                                      color: Colors.grey.shade200,
                                      height: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddUser,
        backgroundColor: primaryBlue,
        tooltip: 'Tambah pengguna',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}