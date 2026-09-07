import 'package:flutter/material.dart';

class PemilihJumlah extends StatefulWidget {
  final int stok;
  final ValueChanged<int> onChanged;

  const PemilihJumlah({
    super.key,
    required this.stok,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: jumlah > 1
              ? () {
                  setState(() {
                    jumlah--;
                  });
                  widget.onChanged(jumlah);
                }
              : null,
        ),
        Text(
          '$jumlah',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
            ),
        ),
        IconButton(
          onPressed: jumlah < widget.stok
              ? () {
                  setState(() {
                    jumlah++;
                  });
                  widget.onChanged(jumlah);
                }
              : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}