class BarangTani {
  final String nama;
  final String kategori;
  final int harga;
  final String satuan;
  final String satuanStok;
  final String gambar;
  int stok;

   BarangTani({
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.satuan,
    required this.satuanStok,
    required this.gambar,
    required this.stok,
  });

double hargaSetelahDiskon(int jumlah) {
  final total = harga * jumlah;

  if (jumlah >= 25) {
    return total * 0.90;
    } else if (jumlah >= 10) {
    return total * 0.95;
  }

  return total.toDouble();
}

int nilaiStok () {
  return harga * stok;
}

bool bisaDibeli(int jumlah) {
  return stok > 0 && jumlah > 0 && jumlah <= stok;
}

String ikonKategori() {
  switch (kategori.toLowerCase()) {
    case 'bibit':
      return '🌱';
    case 'pupuk':
      return '🪴';
    case 'alat':
      return '🛠️';
    default:
      return '📦';
      }
  }
}
