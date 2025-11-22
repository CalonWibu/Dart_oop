// BLUEPRINT - Ini adalah class
class Expense {
  String description;
  double amount;
  String category;
  DateTime date;

  // Constructor - diperlukan untuk menginisialisasi semua properties
  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });
}

void main() {
  // Membuat OBJEK dari blueprint
  var coffee = Expense(
    description: 'Kopi',
    amount: 4.50,
    category: 'Makanan',
    date: DateTime.now(),
  );

  var netflix = Expense(
    description: 'Netflix',
    amount: 15.99,
    category: 'Hiburan',
    date: DateTime.now(),
  );

  print('${coffee.description}: \$${coffee.amount}');
  print('${netflix.description}: \$${netflix.amount}');
}
