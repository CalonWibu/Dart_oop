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

  // Method boolean - mengembalikan true atau false
  bool isMajorExpense() {
    return _amount > 100;
  }

  bool isThisMonth() {
    DateTime now = DateTime.now();
    return _date.year == now.year && _date.month == now.month;
  }

  bool isThisWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return _date.isAfter(startOfWeek) && _date.isBefore(endOfWeek);
  }

  bool isToday() {
    DateTime now = DateTime.now();
    return _date.year == now.year &&
           _date.month == now.month &&
           _date.day == now.day;
  }

  bool isCategory(String category) {
    return _category == category;
  }

  bool isOlderThan(int days) {
    DateTime now = DateTime.now();
    int difference = now.difference(_date).inDays;
    return difference > days;
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

  print('Kopi pengeluaran besar? ${coffee.isMajorExpense()}');
  print('Kopi bulan ini? ${coffee.isThisMonth()}');
  print('Kopi hari ini? ${coffee.isToday()}');
  print('Kopi kategori Makanan? ${coffee.isCategory("Makanan")}');

  print('\nLaptop pengeluaran besar? ${laptop.isMajorExpense()}');
  print('Laptop lebih dari 3 hari yang lalu? ${laptop.isOlderThan(3)}');
}
