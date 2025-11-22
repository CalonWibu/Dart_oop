class Expense {
  String _description;
  double _amount;
  String _category;
  DateTime _date;

  // Named constructor dengan null safety
  Expense({
    required String description,
    required double amount,
    required String category,
    DateTime? date,
  }) : _description = description,
       _amount = amount,
       _category = category,
       _date = date ?? DateTime.now();

  // Getters
  String get description => _description;
  double get amount => _amount;
  String get category => _category;
  DateTime get date => _date;

  // Method dengan parameter posisional opsional
  void printDetails([bool showEmoji = false]) {
    String emoji = showEmoji ? getCategoryEmoji() : '';
    print('$emoji $_description: Rp${_amount.toStringAsFixed(2)} [$_category]');
  }

  // Method dengan beberapa parameter opsional
  String format({
    bool showDate = false,
    bool showCategory = true,
    bool showEmoji = false,
    String currency = 'Rp',
  }) {
    String result = _description;

    if (showEmoji) {
      result = '${getCategoryEmoji()} $result';
    }

    result += ': $currency${_amount.toStringAsFixed(2)}';

    if (showCategory) {
      result += ' [$_category]';
    }

    if (showDate) {
      result += ' (${_date.toString().split(' ')[0]})';
    }

    return result;
  }

  String getCategoryEmoji() {
    switch (_category) {
      case 'Makanan': return '🍔';
      case 'Transport': return '🚗';
      case 'Tagihan': return '💡';
      default: return '📝';
    }
  }

  // Method dengan callback opsional
  void process({void Function(String)? onComplete}) {
    // Melakukan proses
    print('Memproses pengeluaran: $_description');

    // Panggil callback jika tersedia
    if (onComplete != null) {
      onComplete('✅ Pengeluaran berhasil diproses');
    }
  }
}

void main() {
  var coffee = Expense(
    description: 'Kopi',
    amount: 4.50,
    category: 'Makanan',
  );

  // Berbagai cara memanggil printDetails
  coffee.printDetails();
  coffee.printDetails(true);

  // Berbagai cara memformat
  print('\n${coffee.format()}');
  print(coffee.format(showEmoji: true));
  print(coffee.format(showDate: true, showEmoji: true));
  print(coffee.format(currency: '€', showCategory: false));

  // Using callback
  print('');
  coffee.process(onComplete: (message) {
    print(message);
  });
}