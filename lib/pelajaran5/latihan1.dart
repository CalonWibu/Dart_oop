

class Expense {
  String description;
  double amount;
  String category;
  final DateTime _date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required DateTime date,
  }) : _date = date;

  int getWeekNumber() {
  final firstThursday = DateTime(_date.year, 1, 4);
  final diff = _date.difference(
    firstThursday.subtract(Duration(days: firstThursday.weekday - 1)),
  );
  return (diff.inDays / 7).floor() + 1;
}


  int getQuarter() {
    return ((_date.month - 1) / 3).floor() + 1;
  }

  bool isWeekend() {
    return _date.weekday == DateTime.saturday || _date.weekday == DateTime.sunday;
  }
}

void main() {
  var expense = Expense(
    description: 'Brunch akhir pekan',
    amount: 45.00,
    category: 'Makanan',
    date: DateTime(2025, 10, 11), // Sabtu
  );

  print('Kuartal: ${expense.getQuarter()}');
  print('Akhir pekan? ${expense.isWeekend()}');
  print('Minggu ke: ${expense.getWeekNumber()}');
}