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

  // Method kalkulasi
  int getDaysAgo() {
    DateTime now = DateTime.now();
    return now.difference(_date).inDays;
  }

  double getTax({double taxRate = 0.10}) {
    return _amount * taxRate;
  }

  double getTotalWithTax({double taxRate = 0.10}) {
    return _amount + getTax(taxRate: taxRate);
  }

  double getPercentageOf(double total) {
    if (total == 0) return 0;
    return (_amount / total) * 100;
  }

  double getMonthlyAverage() {
    // Mengasumsikan ini adalah pengeluaran tahunan
    return _amount / 12;
  }

  // Membagi pengeluaran untuk beberapa orang
  double splitAmount(int numberOfPeople) {
    if (numberOfPeople <= 0) return _amount;
    return _amount / numberOfPeople;
  }

  // Menghitung pengeluaran dengan diskon
  double applyDiscount(double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) {
      return _amount;
    }
    return _amount * (1 - discountPercent / 100);
  }
}

void main() {
  var laptop = Expense(
    description: 'Laptop',
    amount: 1000.0,
    category: 'Elektronik',
    date: DateTime(2025, 10, 5),
  );

  print('Jumlah: Rp${laptop.amount}');
  print('Berapa hari lalu: ${laptop.getDaysAgo()}');
  print('Pajak (10%): Rp${laptop.getTax().toStringAsFixed(2)}');
  print('Total dengan pajak: Rp${laptop.getTotalWithTax().toStringAsFixed(2)}');
  print('Dibagi 4 orang: Rp${laptop.splitAmount(4).toStringAsFixed(2)}');
  print('Dengan diskon 20%: Rp${laptop.applyDiscount(20).toStringAsFixed(2)}');

  double totalSpending = 5000.0;
  print('Persentase dari total: ${laptop.getPercentageOf(totalSpending).toStringAsFixed(1)}%');
}
