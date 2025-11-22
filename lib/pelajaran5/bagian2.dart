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

  // Method formatting
  String getFormattedAmount() {
    return 'Rp${_amount.toStringAsFixed(2)}';
  }

  String getFormattedDate() {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${_date.day} ${months[_date.month - 1]} ${_date.year}';
  }

  String getShortDate() {
    return '${_date.day}/${_date.month}/${_date.year}';
  }

  String getSummary() {
    String emoji = _amount > 100 ? '🔴' : '🟢';
    return '$emoji $_description: ${getFormattedAmount()} [$_category]';
  }

  String getDetailedSummary() {
    return '''
$_description
Jumlah: ${getFormattedAmount()}
Kategori: $_category
Tanggal: ${getFormattedDate()}
''';
  }

  String getCategoryEmoji() {
    switch (_category) {
      case 'Makanan': return '🍔';
      case 'Transport': return '🚗';
      case 'Tagihan': return '💡';
      case 'Hiburan': return '🎬';
      case 'Kesehatan': return '💊';
      case 'Belanja': return '🛍️';
      default: return '📝';
    }
  }

  String getFullDisplay() {
    return '${getCategoryEmoji()} $_description - ${getFormattedAmount()}';
  }
}

void main() {
  var coffee = Expense(
    description: 'Kopi',
    amount: 4.50,
    category: 'Makanan',
  );

  var laptop = Expense(
    description: 'Laptop',
    amount: 899.99,
    category: 'Elektronik',
    date: DateTime(2025, 10, 5),
  );

  print(coffee.getSummary());
  print(coffee.getFormattedDate());
  print(coffee.getFullDisplay());

  print('\n${laptop.getDetailedSummary()}');
}
