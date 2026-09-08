import 'package:flutter/material.dart';

import '../models/barang_tani.dart';
import 'pemilih_jumlah.dart';

class BarangTaniCard extends StatelessWidget {
  final BarangTani barang;
  final VoidCallback onTap;

  const BarangTaniCard({
    super.key,
    required this.barang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stokHabis = barang.stok <= 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barang.ikonKategori(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      barang.nama,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                barang.kategori,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Rp ${barang.harga} / ${barang.satuan}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              if (stokHabis)
                const Text(
                  'STOK HABIS',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Text(
                  'Stok Tersedia: ${barang.stok} ${barang.satuanStok}',
                ),

              const Spacer(),

              if (!stokHabis)
                PemilihJumlah(
                  stok: barang.stok,
                  harga: barang.harga,
                  onChanged: (_) {},
                )
              else
                const Text(
                  'Tidak dapat dimasukkan ke keranjang',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}