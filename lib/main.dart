import 'package:flutter/material.dart';
import 'package:katalog_tani/widgets/detail_barang_page.dart';

import 'models/barang_tani.dart';

void main() {
  runApp(const TaniMartApp());
}

class TaniMartApp extends StatelessWidget {
  const TaniMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaniMart Katalog',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F8F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16834B),
        ),
      ),
      home: const KatalogPage(),
    );
  }
}

// ============================================================
// KATALOG PAGE
// ============================================================

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  late final TextEditingController searchControllerBeranda;
  late final TextEditingController searchControllerProduk;
  late final FocusNode searchFocusNodeBeranda;
  late final FocusNode searchFocusNodeProduk;

  String kataKunciBeranda = '';
  String kataKunciProduk = '';
  String kategoriAktif = 'Semua';

  bool hargaNaik = true;

  int bottomIndex = 0;

  final Set<String> favorit = {};
  final Map<String, int> keranjang = {};

  // Simulasi notifikasi
  final List<Map<String, String>> notifikasi = [
    {
      'judul': 'Selamat datang di TaniMart!',
      'isi': 'Temukan berbagai kebutuhan pertanian terbaik.',
      'waktu': 'Baru saja',
    },
    {
      'judul': 'Stok Benih Melon tersedia',
      'isi': 'Benih Melon Golden Harapan tersedia 25 bungkus.',
      'waktu': '5 menit lalu',
    },
    {
      'judul': 'Produk baru tersedia',
      'isi': 'Pupuk dan alat pertanian terbaru telah ditambahkan.',
      'waktu': '1 jam lalu',
    },
  ];

  // ============================================================
  // DATA PRODUK
  // ============================================================

  final List<BarangTani> semuaBarang = [
    BarangTani(
      nama: 'Benih Tomat Mutiara',
      kategori: 'Bibit',
      harga: 12000,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://i.ibb.co.com/FqnjQhkB/Chat-GPT-Image-Sep-1-2026-10-46-36-AM.png',
      stok: 324,
    ),
    BarangTani(
      nama: 'Benih Terong Ungu',
      kategori: 'Bibit',
      harga: 13500,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://i.ibb.co.com/qLBxryWr/Chat-GPT-Image-Sep-1-2026-11-33-10-AM.png',
      stok: 49,
    ),
    BarangTani(
      nama: 'Pupuk Organik Granul',
      kategori: 'Pupuk',
      harga: 28000,
      satuan: 'Karung',
      satuanStok: 'Karung',
      gambar:
          'https://i.ibb.co.com/V0FLDH0B/Chat-GPT-Image-Sep-1-2026-11-03-38-AM.png',
      stok: 144,
    ),
    BarangTani(
      nama: 'Pupuk NPK Daun Hijau',
      kategori: 'Pupuk',
      harga: 42000,
      satuan: 'karung',
      satuanStok: 'Karung',
      gambar:
          'https://i.ibb.co.com/SDBhcKbX/Chat-GPT-Image-Sep-1-2026-11-36-01-AM.png',
      stok:256,
    ),
    BarangTani(
      nama: 'Sekop Tangan Baja',
      kategori: 'Alat',
      harga: 32000,
      satuan: 'Buah',
      satuanStok: 'Buah',
      gambar:
          'https://i.ibb.co.com/vxZJxHhZ/Chat-GPT-Image-Sep-1-2026-11-37-21-AM.png',
      stok: 6561,
    ),
    BarangTani(
      nama: 'Gunting Pangkas Premium',
      kategori: 'Alat',
      harga: 47000,
      satuan: 'Buah',
      satuanStok: 'Buah',
      gambar:
          'https://i.ibb.co.com/Wp3FSPsg/Chat-GPT-Image-Sep-1-2026-11-41-35-AM.png',
      stok: 0,
    ),
    BarangTani(
      nama: 'Selang Taman Fleksibel 10 Meter Super Panjang',
      kategori: 'Alat',
      harga: 65000,
      satuan: 'Buah',
      satuanStok: 'Buah',
      gambar:
          'https://i.ibb.co.com/VcNDJSQD/Chat-GPT-Image-Sep-1-2026-11-43-43-AM.png',
      stok: 1296,
    ),
    BarangTani(
      nama: 'Benih Melon Golden Harapan',
      kategori: 'Bibit',
      harga: 18500,
      satuan: 'Bungkus',
      satuanStok: 'Bungkus',
      gambar:
          'https://i.ibb.co.com/Myf1W1Jg/Chat-GPT-Image-Sep-1-2026-11-46-01-AM.png',
      stok: 625,
    ),
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    searchControllerBeranda = TextEditingController();
    searchControllerProduk = TextEditingController();
    searchFocusNodeBeranda = FocusNode();
    searchFocusNodeProduk = FocusNode();
  }

  @override
  void dispose() {
    searchControllerBeranda.dispose();
    searchControllerProduk.dispose();
    searchFocusNodeBeranda.dispose();
    searchFocusNodeProduk.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTER PRODUK
  // ============================================================

  List<BarangTani> get barangTersaring {
    final kataKunci = bottomIndex == 1
      ? kataKunciProduk
      : kataKunciBeranda;

    final hasil = semuaBarang.where((barang) {
      final cocokNama =
          barang.nama.toLowerCase().contains(kataKunci);

      final cocokKategori =
          barang.kategori.toLowerCase().contains(kataKunci);

      final cocokPencarian =
          kataKunci.isEmpty || cocokNama || cocokKategori;

      final cocokFilterKategori =
          kategoriAktif == 'Semua' ||
              barang.kategori == kategoriAktif;

      return cocokPencarian && cocokFilterKategori;
    }).toList();

    hasil.sort(
      (a, b) {
        final aHabis = a.stok == 0;
        final bHabis = b.stok == 0;

        if (aHabis != bHabis) {
          return aHabis ? 1 : -1;
        }

        return hargaNaik
            ? a.harga.compareTo(b.harga)
            : b.harga.compareTo(a.harga);
      },
    );

    return hasil;
  }

  List<BarangTani> get barangFavorit {
    final hasil = semuaBarang
        .where((barang) => favorit.contains(barang.nama))
        .toList();

    hasil.sort((a, b) {
      if ((a.stok == 0) != (b.stok == 0)) {
        return a.stok == 0 ? 1 : -1;
      }
      return a.harga.compareTo(b.harga);
    });

    return hasil;
  }

  int hitungTotalStok() {
    return barangTersaring.fold(
      0,
      (total, barang) => total + barang.stok,
    );
  }

  int hitungStokHabis() {
    return barangTersaring
        .where((barang) => barang.stok == 0)
        .length;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8DCC8),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD5F0DC),
                Color(0xFFB8DCC8),
                Color(0xFFF1D29B),
              ],
              stops: [0.0, 0.58, 1.0],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: -110,
                right: -85,
                child: IgnorePointer(
                  child: Container(
                    width: 290,
                    height: 290,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF7AD79B).withValues(alpha: 0.16),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -140,
                left: -100,
                child: IgnorePointer(
                  child: Container(
                    width: 330,
                    height: 330,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF2C66D).withValues(alpha: 0.13),
                    ),
                  ),
                ),
              ),
              IndexedStack(
                index: bottomIndex,
                children: [
                  _buildHomePage(),
                  _buildProductPage(),
                  _buildFavoritePage(),
                  _buildAccountPage(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHomePage() {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9ED8AE),
                  Color(0xFF63B9AD),
                  Color(0xFFE9B86D),
                ],
                stops: [0.0, 0.52, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 185,
          right: -105,
          child: IgnorePointer(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF66C7B2).withValues(alpha: 0.18),
              ),
            ),
          ),
        ),
        Positioned(
          top: 620,
          left: -125,
          child: IgnorePointer(
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF4C86D).withValues(alpha: 0.16),
              ),
            ),
          ),
        ),
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            SliverToBoxAdapter(
              child: _buildSearchBar(isProductPage: false),
            ),

            SliverToBoxAdapter(
              child: _buildCategorySection(),
            ),

            SliverToBoxAdapter(
              child: _buildStatistics(),
            ),

            SliverToBoxAdapter(
              child: _buildProductHeader(
                barangTersaring.length,
              ),
            ),

            if (barangTersaring.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _tampilanKosong(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  30,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final barang = barangTersaring[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 14),
                        child: _buildPremiumProductCard(barang),
                      );
                    },
                    childCount: barangTersaring.length,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064D2D),
            Color(0xFF0C7040),
            Color(0xFF23A765),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TaniMart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Katalog Sarana Pertanian',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _showCartSheet,
                    child: Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (keranjang.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: 7,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD166),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${keranjang.values.fold<int>(0, (total, jumlah) => total + jumlah)}',
                          style: const TextStyle(
                            color: Color(0xFF5A3410),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    borderRadius:
                        BorderRadius.circular(30),
                    onTap: () {
                      _showNotificationPage();
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  if (notifikasi.isNotEmpty)
                    Positioned(
                      top: -2,
                      right: -1,
                      child: Container(
                        padding:
                            const EdgeInsets.all(4),
                        decoration:
                            const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${notifikasi.length}',
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Selamat datang! 👋',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Temukan kebutuhan\npertanianmu.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              height: 1.12,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 19,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Produk berkualitas untuk kebun lebih produktif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar({required bool isProductPage}) {
    final controller = isProductPage
        ? searchControllerProduk
        : searchControllerBeranda;
    final focusNode = isProductPage
        ? searchFocusNodeProduk
        : searchFocusNodeBeranda;
    final kataKunci = isProductPage
        ? kataKunciProduk
        : kataKunciBeranda;

    return Transform.translate(
      offset: const Offset(0, 5),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isProductPage
                  ? const [Color(0xFF243B72), Color(0xFF4169A1)]
                  : const [Color(0xFF0D6B52), Color(0xFF239B82)],
            ),
            borderRadius:
                BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF07543F).withValues(alpha: 0.30),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: true,
            readOnly: false,
            showCursor: true,
            enableInteractiveSelection: true,
            autocorrect: false,
            enableSuggestions: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            textInputAction:
                TextInputAction.search,
            onChanged: (value) {
              setState(() {
                if (isProductPage) {
                  kataKunciProduk = value.toLowerCase().trim();
                } else {
                  kataKunciBeranda = value.toLowerCase().trim();
                }
              });
            },
            onTap: () {
              FocusScope.of(context).requestFocus(focusNode);
            },
            onTapOutside: (_) {
              focusNode.unfocus();
            },
            onSubmitted: (_) {
              focusNode.unfocus();
            },
            cursorColor: const Color(0xFFFFD166),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
                hintText: isProductPage
                  ? 'Cari di semua produk...'
                  : 'Cari di beranda...',
              hintStyle: const TextStyle(
                color: Color(0xFFD7F4E5),
                fontSize: 13,
              ),
              prefixIcon: IconButton(
                onPressed: () {
                  focusNode.requestFocus();
                },
                tooltip: 'Cari barang',
                icon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFFFD166),
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (kataKunci.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        controller.clear();
                        setState(() {
                          if (isProductPage) {
                            kataKunciProduk = '';
                          } else {
                            kataKunciBeranda = '';
                          }
                        });
                      },
                      tooltip: 'Hapus pencarian',
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  IconButton(
                    onPressed: _showFilterSheet,
                    tooltip: 'Buka filter',
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFFFFD166),
                    ),
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF123D3A),
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.62,
          minChildSize: 0.42,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SafeArea(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Filter produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Text(
                  'Kategori',
                  style: TextStyle(
                    color: Color(0xFFBDE8D7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ...['Semua', 'Bibit', 'Pupuk', 'Alat'].map(
                  (kategori) => RadioListTile<String>(
                    value: kategori,
                    groupValue: kategoriAktif,
                    activeColor: const Color(0xFFFFD166),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      kategori,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        kategoriAktif = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Divider(color: Color(0x557AD6B5)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.swap_vert_rounded,
                    color: Color(0xFFFFD166),
                  ),
                  title: const Text(
                    'Urutkan harga',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    hargaNaik ? 'Termurah ke termahal' : 'Termahal ke termurah',
                    style: const TextStyle(color: Color(0xFFBDE8D7)),
                  ),
                  trailing: Switch(
                    value: hargaNaik,
                    activeColor: const Color(0xFFFFD166),
                    onChanged: (value) {
                      setState(() {
                        hargaNaik = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategorySection() {
    final kategori = [
      {
        'nama': 'Semua',
        'icon': Icons.grid_view_rounded,
      },
      {
        'nama': 'Bibit',
        'icon': Icons.spa_rounded,
      },
      {
        'nama': 'Pupuk',
        'icon': Icons.grass_rounded,
      },
      {
        'nama': 'Alat',
        'icon': Icons.handyman_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        0,
        18,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.only(right: 16),
            child: Text(
              'Kategori',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF18201B),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection:
                  Axis.horizontal,
              physics:
                  const BouncingScrollPhysics(),
              itemCount: kategori.length,
              separatorBuilder:
                  (_, __) =>
                      const SizedBox(width: 9),
              itemBuilder:
                  (context, index) {
                final item =
                    kategori[index];

                final nama =
                    item['nama'] as String;

                final icon =
                    item['icon'] as IconData;

                final aktif =
                    kategoriAktif == nama;

                final warnaKategori = switch (nama) {
                  'Bibit' => const Color(0xFF2E9B68),
                  'Pupuk' => const Color(0xFFD28A19),
                  'Alat' => const Color(0xFFD35D70),
                  _ => const Color(0xFF148C91),
                };

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      kategoriAktif = nama;
                    });
                  },
                  child: AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 220,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration:
                        BoxDecoration(
                      color: aktif
                          ? warnaKategori
                          : warnaKategori.withValues(alpha: 0.20),
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                      border: Border.all(
                        color: warnaKategori.withValues(alpha: 0.72),
                      ),
                      boxShadow: aktif
                          ? [
                              BoxShadow(
                                color: warnaKategori.withValues(alpha: 0.38),
                                blurRadius: 12,
                                offset:
                                    const Offset(
                                  0,
                                  5,
                                ),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: warnaKategori.withValues(alpha: 0.16),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: aktif
                              ? Colors.white
                              : warnaKategori,
                        ),
                        const SizedBox(
                            width: 7),
                        Text(
                          nama,
                          style: TextStyle(
                            color: aktif
                                ? Colors.white
                              : warnaKategori.withValues(alpha: 0.95),
                            fontWeight:
                                FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon:
                  Icons.inventory_2_rounded,
              title: 'Produk',
              value:
                  '${barangTersaring.length}',
              subtitle: 'item',
              colors: const [
                Color(0xFF087F8C),
                Color(0xFF21B6A8),
              ],
              iconColor: Color(0xFFBDF7EA),
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _statCard(
              icon:
                  Icons.warehouse_rounded,
              title: 'Stok',
              value:
                  '${hitungTotalStok()}',
              subtitle: 'unit',
              colors: const [
                Color(0xFFB86B00),
                Color(0xFFE3A92E),
              ],
              iconColor: Color(0xFFFFF0B3),
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _statCard(
              icon:
                  Icons.favorite_rounded,
              title: 'Favorit',
              value:
                  '${favorit.length}',
              subtitle: 'produk',
              colors: const [
                Color(0xFFB83D61),
                Color(0xFFE66D83),
              ],
              iconColor: Color(0xFFFFD7DF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required List<Color> colors,
    required Color iconColor,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: colors.last.withValues(alpha: 0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: colors.first,
              size: 19,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFFFF8E7),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT HEADER
  // ============================================================

  Widget _buildProductHeader(int jumlah) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        25,
        16,
        14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk Pertanian',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        Color(0xFF18201B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pilih kebutuhan terbaik untuk kebunmu',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF7C857F),
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            borderRadius:
                BorderRadius.circular(12),
            onTap: () {
              setState(() {
                hargaNaik = !hargaNaik;
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9,
              ),
              decoration:
                  BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D8B63),
                    Color(0xFF32B77B),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0A7957),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF16834B).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    hargaNaik
                        ? Icons
                            .arrow_upward_rounded
                        : Icons
                            .arrow_downward_rounded,
                    size: 15,
                    color:
                      Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hargaNaik
                        ? 'Termurah'
                        : 'Termahal',
                    style:
                        const TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w800,
                        color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildPremiumProductCard(
    BarangTani barang,
  ) {
    final stokHabis =
        barang.stok == 0;

    final stokSedikit =
        barang.stok > 0 &&
            barang.stok <= 5;

    final isFavorit =
        favorit.contains(barang.nama);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(23),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailBarangPage(
                barang: barang,
                onAddToCart: (jumlah) {
                  _tambahKeKeranjang(barang, jumlah);
                },
              ),
            ),
          );
        },
        child: Container(
          padding:
              const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: stokHabis
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A5158),
                      Color(0xFF737B83),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF104F43),
                      Color(0xFF167D6A),
                      Color(0xFF239C7D),
                    ],
                  ),
            borderRadius:
                BorderRadius.circular(23),
            border: Border.all(
                color: stokHabis
                  ? const Color(0xFFB3BAC1)
                  : const Color(0xFF62D1A5),
            ),
            boxShadow: [
              BoxShadow(
                color: stokHabis
                  ? const Color(0xFF252A2F).withValues(alpha: 0.35)
                  : const Color(0xFF064438).withValues(alpha: 0.35),
                blurRadius: 22,
                offset:
                    const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // GAMBAR IMG BB
              // ==================================================

              Container(
                width: 100,
                height: 125,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFEAF7EF),
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                clipBehavior:
                    Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      barang.gambar,
                      fit: BoxFit.cover,

                      loadingBuilder:
                          (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress ==
                            null) {
                          return child;
                        }

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(
                              0xFF16834B,
                            ),
                          ),
                        );
                      },

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons
                                .image_not_supported_rounded,
                            size: 38,
                            color:
                                Colors.grey,
                          ),
                        );
                      },
                    ),

                    if (stokHabis)
                      Container(
                        color: Colors.black
                            .withOpacity(
                          0.30,
                        ),
                      ),

                    if (stokHabis)
                      Positioned(
                        left: 7,
                        right: 7,
                        bottom: 7,
                        child: Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 5,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .red
                                .shade600,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              8,
                            ),
                          ),
                          child:
                              const Text(
                            'HABIS',
                            textAlign:
                                TextAlign.center,
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 9,
                              fontWeight:
                                  FontWeight
                                      .w900,
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      top: 7,
                      right: 7,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isFavorit) {
                              favorit.remove(
                                barang.nama,
                              );
                            } else {
                              favorit.add(
                                barang.nama,
                              );
                            }
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration:
                              BoxDecoration(
                            color: isFavorit
                                              ? const Color(0xFFFFDDE3)
                                              : const Color(0xFFD8F2E5),
                            border: Border.all(
                              color: isFavorit
                                  ? const Color(0xFFFFA8B5)
                                  : const Color(0xFFD7E9DD),
                            ),
                            shape:
                                BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorit
                                ? Icons
                                    .favorite_rounded
                                : Icons
                                    .favorite_border_rounded,
                            color: isFavorit
                              ? const Color(0xFFE84A5F)
                                : const Color(
                                    0xFF16834B,
                                  ),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 13),

              // ==================================================
              // INFORMASI
              // ==================================================

              Expanded(
                child: SizedBox(
                  height: 125,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD166),
                                    Color(0xFFFFB84D),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  7,
                                ),
                              ),
                              child: Text(
                                barang.kategori
                                    .toUpperCase(),
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                      0xFF5A3410,
                                  ),
                                  fontSize: 9,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  letterSpacing:
                                      0.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 5),

                          const Icon(
                            Icons
                                .chevron_right_rounded,
                            color:
                                Color(0xFFB0B8B3),
                            size: 19,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        barang.nama,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 15,
                          height: 1.2,
                          fontWeight:
                              FontWeight.w900,
                          color:
                              Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        'Rp${_formatHarga(barang.harga)}',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFFFFD166),
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      Text(
                        '/ ${barang.satuan}',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFFC8F0DC),
                          fontSize: 9,
                        ),
                      ),

                      const SizedBox(
                          height: 5),

                      if (stokHabis)
                        const Text(
                          'Stok sedang kosong',
                          style:
                              TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        )
                      else if (stokSedikit)
                        Text(
                          '⚠ Tersisa ${barang.stok} unit',
                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFFFFD166,
                            ),
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        )
                      else
                        Text(
                          '✓ Stok tersedia: ${barang.stok}',
                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFFD1F5E1,
                            ),
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT PAGE
  // ============================================================

  Widget _buildProductPage() {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildSimplePageHeader(
            icon: Icons.inventory_2_rounded,
            title: 'Semua Produk',
            subtitle:
                '${barangTersaring.length} produk ditemukan',
          ),
        ),

        SliverToBoxAdapter(
          child: _buildSearchBar(isProductPage: true),
        ),

        SliverToBoxAdapter(
          child: _buildCategorySection(),
        ),

        if (barangTersaring.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _tampilanKosong(),
          )
        else
          SliverPadding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              30,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child:
                        _buildPremiumProductCard(
                      barangTersaring[index],
                    ),
                  );
                },
                childCount:
                    barangTersaring.length,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // FAVORITE PAGE
  // ============================================================

  Widget _buildFavoritePage() {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8F3D62),
                  Color(0xFFC75C79),
                  Color(0xFFE5A06D),
                ],
                stops: [0.0, 0.56, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          right: -100,
          child: IgnorePointer(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD166).withValues(alpha: 0.22),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -110,
          left: -90,
          child: IgnorePointer(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7B2CBF).withValues(alpha: 0.20),
              ),
            ),
          ),
        ),
        CustomScrollView(
          physics:
              const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildSimplePageHeader(
                icon:
                    Icons.favorite_rounded,
                title: 'Favorit Saya',
                subtitle:
                    '${favorit.length} produk disimpan',
              ),
            ),

            if (barangFavorit.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      30,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration:
                              const BoxDecoration(
                            color: Color(0xFFFFD7DF),
                            shape:
                                BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons
                                .favorite_border_rounded,
                            size: 48,
                            color: Color(0xFFB83D61),
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        const Text(
                          'Belum ada favorit',
                          style:
                              TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        const Text(
                          'Tekan ikon ❤️ pada produk yang ingin kamu simpan.',
                          textAlign:
                              TextAlign.center,
                          style:
                              TextStyle(
                            color: Color(0xFFFFF1F4),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  30,
                ),
                sliver: SliverList(
                  delegate:
                      SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),
                        child:
                            _buildPremiumProductCard(
                          barangFavorit[index],
                        ),
                      );
                    },
                    childCount:
                        barangFavorit.length,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
// ============================================================
// ACCOUNT PAGE
// ============================================================

Widget _buildAccountPage() {
  return Stack(
    fit: StackFit.expand,
    clipBehavior: Clip.hardEdge,
    children: [
      // ============================================================
      // FULL BACKGROUND AKUN
      // ============================================================
      Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF102A43),
                Color(0xFF155E63),
                Color(0xFFB8782C),
              ],
              stops: [0.0, 0.58, 1.0],
            ),
          ),
        ),
      ),

      // ============================================================
      // DEKORASI KANAN
      // ============================================================
      Positioned(
        top: 180,
        right: -100,
        child: IgnorePointer(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7ED6C2).withValues(
                alpha: 0.17,
              ),
            ),
          ),
        ),
      ),

      // ============================================================
      // DEKORASI BAWAH
      // ============================================================
      Positioned(
        bottom: -130,
        left: -90,
        child: IgnorePointer(
          child: Container(
            width: 310,
            height: 310,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD166).withValues(
                alpha: 0.18,
              ),
            ),
          ),
        ),
      ),

      // ============================================================
      // CONTENT
      // ============================================================
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ========================================================
            // HEADER AKUN
            // ========================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                22,
                25,
                22,
                30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF064D2D),
                    Color(0xFF16834B),
                    Color(0xFF23A765),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 43,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Color(0xFF16834B),
                    ),
                  ),

                  const SizedBox(height: 13),

                  const Text(
                    'Pengguna TaniMart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Petani • Pengguna TaniMart',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========================================================
            // MENU AKUN
            // ========================================================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  // PRODUK FAVORIT
                  _accountMenu(
                    icon: Icons.favorite_rounded,
                    title: 'Produk Favorit',
                    subtitle:
                        '${favorit.length} produk tersimpan',
                    onTap: () {
                      setState(() {
                        bottomIndex = 2;
                      });
                    },
                  ),

                  // NOTIFIKASI
                  _accountMenu(
                    icon: Icons.notifications_rounded,
                    title: 'Notifikasi',
                    subtitle:
                        '${notifikasi.length} pemberitahuan',
                    onTap: _showNotificationPage,
                  ),

                  // TENTANG TANIMART
                  _accountMenu(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang TaniMart',
                    subtitle:
                        'Katalog sarana pertanian',
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),

                  // PENGATURAN
                  _accountMenu(
                    icon: Icons.settings_rounded,
                    title: 'Pengaturan',
                    subtitle:
                        'Preferensi aplikasi',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Pengaturan TaniMart siap dikembangkan.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Ruang bawah agar menu terakhir tidak terlalu mepet
            const SizedBox(height: 100),
          ],
        ),
      ),
    ],
  );
}

// ============================================================
// ACCOUNT MENU
// ============================================================

Widget _accountMenu({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(
      bottom: 11,
    ),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF173F52),
          Color(0xFF1C6B6C),
        ],
      ),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xFF5EBBA8),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF061D2A).withValues(
            alpha: 0.28,
          ),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD166),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF713F12),
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFFD2F2E8),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFFFFD166),
      ),
    ),
  );
}

  // ============================================================
  // SIMPLE HEADER
  // ============================================================

  Widget _buildSimplePageHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        23,
      ),
      decoration:
          const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF075E35),
            Color(0xFF16834B),
          ],
        ),
        borderRadius:
            BorderRadius.only(
          bottomLeft:
              Radius.circular(28),
          bottomRight:
              Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATION
  // ============================================================

  void _tambahKeKeranjang(BarangTani barang, int jumlah) {
    if (jumlah <= 0 || barang.stok <= 0) {
      return;
    }

    final jumlahValid = jumlah.clamp(1, barang.stok);

    setState(() {
      final jumlahLama = keranjang[barang.nama] ?? 0;
      keranjang[barang.nama] = jumlahLama + jumlahValid;
      barang.stok -= jumlahValid;
    });
  }

  void _showCartSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF102A43),
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final items = semuaBarang
                .where((barang) => (keranjang[barang.nama] ?? 0) > 0)
                .toList();
            final totalJumlah = items.fold<int>(
              0,
              (total, barang) => total + (keranjang[barang.nama] ?? 0),
            );
            final subtotal = items.fold<int>(
              0,
              (total, barang) =>
                  total + barang.harga * (keranjang[barang.nama] ?? 0),
            );
            final diskonPersen = totalJumlah >= 25
                ? 10
                : totalJumlah >= 10
                    ? 5
                    : 0;
            final diskon = subtotal * diskonPersen ~/ 100;

            return SafeArea(
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.65,
                minChildSize: 0.35,
                maxChildSize: 0.92,
                builder: (context, scrollController) {
                  return ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      const Text(
                        'Keranjang Belanja',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xFFFFD166),
                                size: 56,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Keranjang masih kosong',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        ...items.map(
                          (barang) {
                            final jumlah = keranjang[barang.nama] ?? 0;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF155E63),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF5EBBA8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          barang.nama,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$jumlah x Rp${_formatHarga(barang.harga)}',
                                          style: const TextStyle(
                                            color: Color(0xFFFFD166),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final jumlahDihapus =
                                          keranjang[barang.nama] ?? 0;
                                      setState(() {
                                        barang.stok += jumlahDihapus;
                                        keranjang.remove(barang.nama);
                                      });
                                      setSheetState(() {});
                                    },
                                    tooltip: 'Hapus dari keranjang',
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFFFFB4C0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        _cartPriceRow(
                          'Subtotal',
                          'Rp${_formatHarga(subtotal)}',
                        ),
                        _cartPriceRow(
                          'Diskon $diskonPersen%',
                          diskon == 0
                              ? 'Belum tersedia'
                              : '- Rp${_formatHarga(diskon)}',
                        ),
                        const Divider(color: Color(0x557AD6B5)),
                        _cartPriceRow(
                          'Total pembayaran',
                          'Rp${_formatHarga(subtotal - diskon)}',
                          emphasized: true,
                        ),
                      ],
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _cartPriceRow(String label, String value, {bool emphasized = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFD2F2E8),
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFFFFD166),
              fontSize: emphasized ? 16 : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _NotificationPage(
          notifications:
              notifikasi,
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF103F3A),
                  Color(0xFF176B61),
                  Color(0xFFB8782C),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF74D6B2)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF061D2A).withValues(alpha: 0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD166),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Color(0xFF315B35),
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'TaniMart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Teman terbaik untuk kebun produktif',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFE7A5),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Temukan bibit, pupuk, dan alat pertanian pilihan dalam satu katalog yang praktis, jelas, dan siap membantu setiap langkah kebunmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE2F7EF),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(
                        child: _AboutFeature(
                          icon: Icons.search_rounded,
                          label: 'Mudah dicari',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _AboutFeature(
                          icon: Icons.inventory_2_rounded,
                          label: 'Stok jelas',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _AboutFeature(
                          icon: Icons.shopping_cart_rounded,
                          label: 'Siap dibeli',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD166),
                        foregroundColor: const Color(0xFF315B35),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _tampilanKosong() {
    return Padding(
      padding:
          const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFEAF7EF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 52,
              color:
                  Color(0xFF16834B),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Barang tidak ditemukan',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w900,
              color:
                  Color(0xFF18201B),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Coba gunakan nama barang atau kategori lain.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color:
                  Color(0xFF7C857F),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              final controller = bottomIndex == 1
                  ? searchControllerProduk
                  : searchControllerBeranda;
              controller.clear();

              setState(() {
                kategoriAktif = 'Semua';
                if (bottomIndex == 1) {
                  kataKunciProduk = '';
                } else {
                  kataKunciBeranda = '';
                }
              });
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Tampilkan Semua',
            ),
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFF16834B,
              ),
              foregroundColor:
                  Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 13,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF102A43),
            Color(0xFF155E63),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFF5EBBA8),
            width: 1.5,
          ),
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 72,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: const Color(0xFFFFD166),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF172B4D)
                  : const Color(0xFFD2F2E8),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF172B4D)
                  : const Color(0xFFD2F2E8),
              size: 24,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: bottomIndex,
          onDestinationSelected:
              (index) {
            setState(() {
              bottomIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 72,
          indicatorColor: const Color(0xFFFFD166),
          destinations: [
        const NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: 'Beranda',
        ),

        const NavigationDestination(
          icon: Icon(
            Icons.inventory_2_outlined,
          ),
          selectedIcon: Icon(
            Icons.inventory_2_rounded,
          ),
          label: 'Produk',
        ),

        NavigationDestination(
          icon: Badge(
            isLabelVisible:
                favorit.isNotEmpty,
            label: Text(
              '${favorit.length}',
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
            ),
          ),
          selectedIcon: const Icon(
            Icons.favorite_rounded,
          ),
          label: 'Favorit',
        ),

        const NavigationDestination(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          selectedIcon: Icon(
            Icons.person_rounded,
          ),
          label: 'Akun',
        ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FORMAT HARGA
  // ============================================================

  String _formatHarga(int harga) {
    final text = harga.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 &&
          (text.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(text[i]);
    }

    return buffer.toString();
  }
}

class _AboutFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AboutFeature({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFD166), size: 22),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// NOTIFICATION PAGE
// ============================================================

class _NotificationPage extends StatelessWidget {
  final List<Map<String, String>>
      notifications;

  const _NotificationPage({
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241B3B),
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        backgroundColor:
            Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF241B3B),
                    Color(0xFF4B286D),
                    Color(0xFFB96A43),
                  ],
                  stops: [0.0, 0.58, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 90,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD166).withValues(alpha: 0.20),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -90,
            child: IgnorePointer(
              child: Container(
                width: 290,
                height: 290,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2EC4B6).withValues(alpha: 0.20),
                ),
              ),
            ),
          ),
          ListView.builder(
            padding:
                const EdgeInsets.all(16),
            itemCount:
                notifications.length,
            itemBuilder:
                (context, index) {
              final item =
                  notifications[index];

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                padding:
                    const EdgeInsets.all(15),
                decoration:
                    BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF3B2557),
                      Color(0xFF5C3374),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color: const Color(0xFFB98AD1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF160E2B).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration:
                      BoxDecoration(
                    color: const Color(0xFFFFD166),
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .notifications_rounded,
                    color: Color(0xFF5A3410),
                  ),
                ),

                const SizedBox(
                    width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        item['judul'] ??
                            '',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),

                      const SizedBox(
                          height: 5),

                      Text(
                        item['isi'] ?? '',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFFEADCF5),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(
                          height: 7),

                      Text(
                        item['waktu'] ?? '',
                        style:
                            const TextStyle(
                          color:
                              Color(0xFFFFD166),
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              );
            },
          ),
        ],
      ),
    );
  }
}