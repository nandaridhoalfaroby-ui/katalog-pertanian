import 'package:flutter/material.dart';

class PemilihJumlah extends StatefulWidget {
  final int stok;
  final int harga;
  final ValueChanged<int> onChanged;

  const PemilihJumlah({
    super.key,
    required this.stok,
    required this.harga,
    required this.onChanged,
  });

  @override
  State<PemilihJumlah> createState() => _PemilihJumlahState();
}

class _PemilihJumlahState extends State<PemilihJumlah> {
  int jumlah = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.stok <= 0) {
      return const Text(
        'Stok habis',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (jumlah > widget.stok) {
      jumlah = widget.stok;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuantityButton(
              icon: Icons.remove_rounded,
              tooltip: 'Kurangi jumlah',
              enabled: jumlah > 1,
              onPressed: () {
                setState(() {
                  jumlah--;
                });
                widget.onChanged(jumlah);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                '$jumlah',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            _buildQuantityButton(
              icon: Icons.add_rounded,
              tooltip: 'Tambah jumlah',
              enabled: jumlah < widget.stok,
              onPressed: () {
                setState(() {
                  jumlah++;
                });
                widget.onChanged(jumlah);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Total: Rp${_formatHarga(jumlah * widget.harga)}',
          style: const TextStyle(
            color: Color(0xFFFFD166),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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

  Widget _buildQuantityButton({
    required IconData icon,
    required String tooltip,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF16834B)
              : const Color(0xFFE0E7E2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon),
          color: Colors.white,
          disabledColor: const Color(0xFF9AA59E),
          tooltip: tooltip,
        ),
      ),
    );
  }
}