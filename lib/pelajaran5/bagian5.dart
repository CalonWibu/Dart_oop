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

  // Method perbandingan
  bool isMoreExpensiveThan(Expense other) {
    return _amount > other._amount;
  }

  bool isSameCategory(Expense other) {
    return _category == other._category;
  }

  bool isSameDay(Expense other) {
    return _date.year == other._date.year &&
           _date.month == other._date.month &&
           _date.day == other._date.day;
  }

  bool isNewerThan(Expense other) {
    return _date.isAfter(other._date);
  }

  int compareByAmount(Expense other) {
    if (_amount < other._amount) return -1;
    if (_amount > other._amount) return 1;
    return 0;
  }

  int compareByDate(Expense other) {
    return _date.compareTo(other._date);
  }

  double getDifferenceFrom(Expense other) {
    return (_amount - other._amount).abs();
  }
}

void main() {
  var coffee = Expense(
    description: 'Kopi',
    amount: 4.50,
    category: 'Makanan',
  );

  var lunch = Expense(
    description: 'Makan siang',
    amount: 12.75,
    category: 'Makanan',
  );

  var laptop = Expense(
    description: 'Laptop',
    amount: 899.99,
    category: 'Elektronik',
    date: DateTime(2025, 10, 5),
  );

  print('Makan siang lebih mahal dari kopi? ${lunch.isMoreExpensiveThan(coffee)}');
  print('Makan siang kategori sama dengan kopi? ${lunch.isSameCategory(coffee)}');
  print('Makan siang hari yang sama dengan kopi? ${lunch.isSameDay(coffee)}');
  print('Kopi lebih baru dari laptop? ${coffee.isNewerThan(laptop)}');
  print('Selisih antara makan siang dan kopi: Rp${lunch.getDifferenceFrom(coffee).toStringAsFixed(2)}');
}