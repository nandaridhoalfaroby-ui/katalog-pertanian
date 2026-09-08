import 'package:flutter/material.dart';
import '../models/barang_tani.dart';
import 'pemilih_jumlah.dart';

class DetailBarangPage extends StatefulWidget {
  final BarangTani barang;
  final ValueChanged<int> onAddToCart;

  const DetailBarangPage({
    super.key,
    required this.barang,
    required this.onAddToCart,
  });

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  int jumlahDipilih = 1;

  @override
  Widget build(BuildContext context) {
    final bool stokHabis = widget.barang.stok == 0;
    final bool stokSedikit = widget.barang.stok > 0 && widget.barang.stok <= 5;
    final int stokTersisa =
      (widget.barang.stok - (jumlahDipilih - 1))
        .clamp(0, widget.barang.stok);

    return Scaffold(
      backgroundColor: stokHabis
          ? const Color(0xFF343A40)
          : const Color(0xFF061B12),

      body: Stack(
        children: [
          // ============================================================
          // BACKGROUND PREMIUM
          // ============================================================
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: stokHabis
                    ? const [
                        Color(0xFF252A2F),
                        Color(0xFF4A5158),
                        Color(0xFF737B83),
                        Color(0xFF252A2F),
                      ]
                    : const [
                        Color(0xFF03150D),
                        Color(0xFF073A25),
                        Color(0xFF0B5A37),
                        Color(0xFF031B12),
                      ],
              ),
            ),
          ),

          // Glow atas
          if (!stokHabis)
            Positioned(
            top: -120,
            right: -90,
            child: _GlowCircle(
              size: 280,
              color: const Color(0xFF20D477),
            ),
          ),

          // Glow kiri
          if (!stokHabis)
            Positioned(
            top: 300,
            left: -140,
            child: _GlowCircle(
              size: 300,
              color: const Color(0xFF0EA765),
            ),
          ),

          // ============================================================
          // CONTENT
          // ============================================================
          SafeArea(
            child: Column(
              children: [
                // ======================================================
                // CUSTOM APP BAR
                // ======================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    8,
                  ),
                  child: Row(
                    children: [
                      _GlassIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            'Detail Produk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),

                      _GlassIconButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Produk ditambahkan ke favorit ❤️',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ======================================================
                // SCROLL CONTENT
                // ======================================================
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      30,
                    ),
                    child: Column(
                      children: [
                        // ==================================================
                        // IMAGE CARD
                        // ==================================================
                        _buildProductImage(
                          context,
                          stokHabis,
                        ),

                        const SizedBox(height: 18),

                        // ==================================================
                        // MAIN INFORMATION CARD
                        // ==================================================
                        _buildMainInformation(
                          context,
                          stokHabis,
                          stokSedikit,
                        ),

                        const SizedBox(height: 14),

                        // ==================================================
                        // STOCK CARD
                        // ==================================================
                        _buildStockCard(
                          stokHabis,
                          stokSedikit,
                          stokTersisa,
                        ),

                        const SizedBox(height: 14),

                        // ==================================================
                        // PRODUCT INFORMATION
                        // ==================================================
                        _buildInformationCard(stokHabis),

                        const SizedBox(height: 18),

                        if (!stokHabis)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pilih jumlah',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                PemilihJumlah(
                                  stok: widget.barang.stok,
                                  harga: widget.barang.harga,
                                  onChanged: (jumlah) {
                                    setState(() {
                                      jumlahDipilih = jumlah;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 18),

                        _buildCartCard(
                          context,
                          stokHabis,
                        ),
                      ],
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

  // ================================================================
  // PRODUCT IMAGE
  // ================================================================
  Widget _buildProductImage(
    BuildContext context,
    bool stokHabis,
  ) {
    return Container(
      width: double.infinity,
      height: 330,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: stokHabis
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9AA1A8),
                  Color(0xFF626A72),
                  Color(0xFF3F464D),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB9F7D2),
                  Color(0xFF58D895),
                  Color(0xFF16834B),
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: (stokHabis
                ? const Color(0xFF5A626A)
                : const Color(0xFF21D477))
              .withOpacity(0.20),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: stokHabis
                ? const [Color(0xFF343A40), Color(0xFF555D65)]
                : const [Color(0xFF153F2C), Color(0xFF09291C)],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.045),
                ),
              ),
            ),

            Positioned(
              bottom: -80,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                    color: (stokHabis
                        ? const Color(0xFFD5D9DD)
                        : const Color(0xFF20D477))
                      .withOpacity(0.06),
                ),
              ),
            ),

            // Product image
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Image.network(
                  widget.barang.gambar,
                  fit: BoxFit.contain,

                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF6AF0A6),
                      ),
                    );
                  },

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_rounded,
                            size: 64,
                            color: Colors.white38,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Category badge
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                    color: (stokHabis
                        ? const Color(0xFF20252A)
                        : Colors.black)
                      .withOpacity(0.28),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.eco_rounded,
                      size: 15,
                      color: stokHabis
                          ? const Color(0xFFE1E5E8)
                          : const Color(0xFF7CF4AA),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.barang.kategori.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stock badge
            if (stokHabis)
              Positioned(
                top: 18,
                right: 18,
                child: _statusBadge(
                  'STOK HABIS',
                  const Color(0xFF687078),
                ),
              )
            else if (widget.barang.stok <= 5)
              Positioned(
                top: 18,
                right: 18,
                child: _statusBadge(
                  'STOK TERBATAS',
                  const Color(0xFFFFA726),
                ),
              )
            else
              Positioned(
                top: 18,
                right: 18,
                child: _statusBadge(
                  'TERSEDIA',
                  const Color(0xFF22C978),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // MAIN INFORMATION
  // ================================================================
  Widget _buildMainInformation(
    BuildContext context,
    bool stokHabis,
    bool stokSedikit,
  ) {
    final int stokTersisa =
      (widget.barang.stok - (jumlahDipilih - 1))
        .clamp(0, widget.barang.stok);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: stokHabis
            ? const Color(0xFF4A5158)
            : const Color(0xFF0B281B).withOpacity(0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.barang.nama,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.2,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp${widget.barang.harga}',
                style: TextStyle(
                  color: stokHabis
                      ? const Color(0xFFE1E5E8)
                      : const Color(0xFF67E89D),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '/ ${widget.barang.satuan}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            height: 1,
            color: Colors.white.withOpacity(0.07),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _miniInfo(
                  Icons.category_rounded,
                  'Kategori',
                  widget.barang.kategori,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniInfo(
                  Icons.inventory_2_rounded,
                  'Stok',
                  stokHabis
                      ? 'Habis'
                      : '$stokTersisa ${widget.barang.satuanStok}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // STOCK CARD
  // ================================================================
  Widget _buildStockCard(
    bool stokHabis,
    bool stokSedikit,
    int stokTersisa,
  ) {
    final bool stokTersisaHabis = stokHabis || stokTersisa <= 0;
    final bool stokTersisaSedikit =
      !stokTersisaHabis && stokTersisa <= 5;

    final Color statusColor = stokTersisaHabis
        ? Colors.redAccent
      : stokTersisaSedikit
            ? const Color(0xFFFFB13B)
            : const Color(0xFF2FE08A);

    final String statusText = stokTersisaHabis
        ? 'Stok sedang kosong'
      : stokTersisaSedikit
            ? 'Stok hampir habis'
            : 'Stok tersedia';

    final IconData icon = stokTersisaHabis
        ? Icons.remove_shopping_cart_rounded
      : stokTersisaSedikit
            ? Icons.warning_amber_rounded
            : Icons.check_circle_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: stokTersisaHabis
          ? const Color(0xFF5B636B)
          : statusColor.withOpacity(0.09),
        border: Border.all(
            color: stokTersisaHabis
              ? const Color(0xFFAEB5BB)
              : statusColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                    stokTersisaHabis
                      ? 'Silakan cek kembali nanti.'
                      : '$stokTersisa ${widget.barang.satuanStok.toLowerCase()} tersedia',
                  style: TextStyle(
                    color: stokTersisaHabis
                        ? const Color(0xFFD4D8DC)
                        : Colors.white54,
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

  // ================================================================
  // INFORMATION CARD
  // ================================================================
  Widget _buildInformationCard(bool stokHabis) {
    final int stokTersisa =
      (widget.barang.stok - (jumlahDipilih - 1))
        .clamp(0, widget.barang.stok);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: stokHabis
          ? const Color(0xFF424950)
          : const Color(0xFF0A2418),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: stokHabis
                  ? const Color(0xFFE1E5E8)
                  : const Color(0xFF65E99D),
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'Informasi Produk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _infoRow(
            'Nama Produk',
            widget.barang.nama,
          ),

          _infoRow(
            'Kategori',
            widget.barang.kategori,
          ),

          _infoRow(
            'Satuan',
            widget.barang.satuan,
          ),

          _infoRow(
            'Harga',
            'Rp${widget.barang.harga}',
          ),

          _infoRow(
            'Stok',
            '$stokTersisa ${widget.barang.satuanStok}',
            last: true,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CART CARD
  // ================================================================
  Widget _buildCartCard(
    BuildContext context,
    bool stokHabis,
  ) {
    final subtotal = jumlahDipilih * widget.barang.harga;
    final diskonPersen = jumlahDipilih >= 25
        ? 10
        : jumlahDipilih >= 10
            ? 5
            : 0;
    final total = subtotal - (subtotal * diskonPersen ~/ 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: stokHabis
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A5158), Color(0xFF666E76)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF123D3A), Color(0xFF176B61)],
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: stokHabis
              ? const Color(0xFFB3BAC1)
              : const Color(0xFF62D1A5),
        ),
        boxShadow: [
          BoxShadow(
            color: stokHabis
              ? const Color(0xFF252A2F).withValues(alpha: 0.35)
              : const Color(0xFF031B18).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart_rounded,
                color: stokHabis
                  ? const Color(0xFFE1E5E8)
                  : const Color(0xFFFFD166),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Masukkan ke Keranjang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$jumlahDipilih ${widget.barang.satuan.toLowerCase()}',
                style: const TextStyle(
                  color: Color(0xFFD2F2E8),
                  fontSize: 12,
                ),
              ),
              Text(
                'Rp${_formatHarga(total)}',
                style: TextStyle(
                  color: stokHabis
                      ? const Color(0xFFE1E5E8)
                      : const Color(0xFFFFD166),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          if (diskonPersen > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Diskon $diskonPersen% diterapkan',
              style: TextStyle(
                color: stokHabis
                    ? const Color(0xFFD4D8DC)
                    : const Color(0xFFB8F0D7),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 14),
          _buildActionButton(context, stokHabis),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool stokHabis,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: stokHabis
            ? null
            : () {
                final jumlahDibeli = jumlahDipilih;
                widget.onAddToCart(jumlahDibeli);
                setState(() {
                  jumlahDipilih = 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF16834B),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${widget.barang.nama} tersedia $jumlahDibeli ${widget.barang.satuan.toLowerCase()}.',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
            backgroundColor: stokHabis
              ? const Color(0xFF687078)
              : const Color(0xFF24D37D),
            disabledBackgroundColor: const Color(0xFF687078),
            foregroundColor: stokHabis
              ? const Color(0xFFE1E5E8)
              : const Color(0xFF032016),
            disabledForegroundColor: const Color(0xFFD4D8DC),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              stokHabis
                  ? Icons.remove_shopping_cart_rounded
                  : Icons.shopping_bag_rounded,
            ),
            const SizedBox(width: 9),
            Text(
              stokHabis
                  ? 'Stok Habis'
                  : 'Masukkan ke Keranjang',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHarga(int harga) {
    final text = harga.toString();
    final buffer = StringBuffer();

    for (int index = 0; index < text.length; index++) {
      if (index > 0 && (text.length - index) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(text[index]);
    }

    return buffer.toString();
  }

  // ================================================================
  // MINI INFO
  // ================================================================
  Widget _miniInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF62E99A),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // INFO ROW
  // ================================================================
  Widget _infoRow(
    String label,
    String value, {
    bool last = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!last)
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.05),
          ),
      ],
    );
  }

  // ================================================================
  // STATUS BADGE
  // ================================================================
  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.90),
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ==================================================================
// GLASS ICON BUTTON
// ==================================================================

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// GLOW CIRCLE
// ==================================================================

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.07),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}
