class Expense {
  // Properti private
  String _description;
  double _amount;
  String _category;
  DateTime _date;
  String? _notes;
  bool _isPaid;

  // List kategori yang valid
  static const List<String> validCategories = [
    'Makanan',
    'Transportasi',
    'Tagihan',
    'Hiburan',
    'Kesehatan',
    'Belanja',
    'Lainnya',
  ];

  // Constructor dengan validasi
  Expense({
    required String description,
    required double amount,
    required String category,
    DateTime? date,
    String? notes,
    bool isPaid = false,
  }) : _description = description,
       _amount = amount,
       _category = category,
       _date = date ?? DateTime.now(),
       _notes = notes,
       _isPaid = isPaid {
    // Validasi amount
    if (_amount < 0) {
      throw Exception('Jumlah tidak boleh negatif');
    }

    // Validasi description
    if (_description.trim().isEmpty) {
      throw Exception('Deskripsi tidak boleh kosong');
    }

    // Validasi category
    if (!validCategories.contains(_category)) {
      print('⚠️ Kategori tidak valid "$_category". Diubah menjadi "Lainnya".');
      _category = 'Lainnya';
    }
  }

  // Named constructor alternatif
  Expense.cepat({
    required String description,
    required double amount,
    required String category,
  }) : this(
    description: description,
    amount: amount,
    category: category,
    date: DateTime.now(),
  );

  // Getter (read-only)
  String get description => _description;
  double get amount => _amount;
  String get category => _category;
  DateTime get date => _date;
  String? get notes => _notes;
  bool get isPaid => _isPaid;

  // Computed getter
  bool get isPengeluaranBesar => _amount > 100;
  String get jumlahFormatted => 'Rp${_amount.toStringAsFixed(2)}';
  String get tanggalFormatted => _date.toString().split(' ')[0];

  String get categoryEmoji {
    switch (_category) {
      case 'Makanan': return '🍔';
      case 'Transportasi': return '🚗';
      case 'Tagihan': return '💡';
      case 'Hiburan': return '🎬';
      case 'Kesehatan': return '💊';
      case 'Belanja': return '🛍️';
      default: return '📝';
    }
  }

  // Setter dengan validasi
  set amount(double value) {
    if (value < 0) {
      throw Exception('Jumlah tidak boleh negatif');
    }
    _amount = value;
  }

  set description(String value) {
    if (value.trim().isEmpty) {
      throw Exception('Deskripsi tidak boleh kosong');
    }
    _description = value.trim();
  }

  set category(String value) {
    if (!validCategories.contains(value)) {
      throw Exception('Kategori tidak valid: $value');
    }
    _category = value;
  }

  set notes(String? value) {
    _notes = value;
  }

  set isPaid(bool value) {
    _isPaid = value;
  }

  // Method
  void tandaiSudahBayar() {
    _isPaid = true;
    print('✅ Ditandai sudah bayar: $_description');
  }

  void tandaiBelumBayar() {
    _isPaid = false;
    print('❌ Ditandai belum bayar: $_description');
  }

  void tambahCatatan(String note) {
    if (_notes == null || _notes!.isEmpty) {
      _notes = note;
    } else {
      _notes = '$_notes; $note';
    }
  }

  void cetakDetail() {
    String statusBayar = _isPaid ? '✅ Lunas' : '❌ Belum lunas';
    String textCatatan = _notes != null ? '\n   📝 $_notes' : '';

    print('─────────────────────────────');
    print('$categoryEmoji $_description');
    print('💰 $jumlahFormatted');
    print('📁 $_category');
    print('📅 $tanggalFormatted');
    print('$statusBayar$textCatatan');
  }
}

void main() {
  print('🏦 EXPENSE MANAGER DENGAN VALIDASI\n');

  // Membuat expense yang valid
  var coffee = Expense.cepat(
    description: 'Kopi pagi',
    amount: 4.50,
    category: 'Makanan',
  );
  var sewa = Expense(
    description: 'Sewa bulanan',
    amount: 1200.0,
    category: 'Tagihan',
    date: DateTime.now(),
    isPaid: true,
  );

  coffee.cetakDetail();
  print('');
  sewa.cetakDetail();

  print('\n📝 UJI VALIDASI:\n');

  // Test setter
  print('Mengubah jumlah kopi menjadi 5.00...');
  coffee.amount = 5.00;
  print('✅ Berhasil! Jumlah baru: ${coffee.jumlahFormatted}');

  try {
    print('\nMencoba set jumlah negatif...');
    coffee.amount = -10;
  } catch (e) {
    print('❌ Error tertangkap: $e');
  }

  try {
    print('\nMencoba set deskripsi kosong...');
    coffee.description = '';
  } catch (e) {
    print('❌ Error tertangkap: $e');
  }

  try {
    print('\nMencoba kategori tidak valid...');
    coffee.category = 'KategoriTidakValid';
  } catch (e) {
    print('❌ Error tertangkap: $e');
  }

  print('\n✅ Menambahkan catatan yang valid...');
  coffee.tambahCatatan('Dibeli di Starbucks');
  coffee.cetakDetail();
}
