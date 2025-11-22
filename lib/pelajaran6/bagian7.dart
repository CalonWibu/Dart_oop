import 'package:intl/intl.dart';

class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final bool isPaid;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.isPaid = false,
  }) : date = date ?? DateTime.now();

  bool isMajorExpense() {
    return amount > 50.00;
  }

  bool isThisMonth() {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  String getSummary() {
    return '$description (\$${amount.toStringAsFixed(2)})';
  }

  String getFullDisplay() {
    String status = isPaid ? '[PAID]' : '[UNPAID]';
    String dateStr = DateFormat('yyyy-MM-dd').format(date);
    return '$status $dateStr | ${category.padRight(10)} | \$${amount.toStringAsFixed(2).padLeft(8)} | $description';
  }
}

class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  void addMultipleExpenses(List<Expense> expenses) {
    _expenses.addAll(expenses);
    print('✅ Ditambahkan ${expenses.length} expenses');
  }

  List<Expense> getAllExpenses() => List.from(_expenses);

  int getCount() => _expenses.length;

  bool isEmpty() => _expenses.isEmpty;

  Expense? getExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) return null;
    return _expenses[index];
  }

  List<Expense> getByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> getByAmountRange(double min, double max) {
    return _expenses.where((e) => e.amount >= min && e.amount <= max).toList();
  }

  List<Expense> getMajorExpenses() {
    return _expenses.where((e) => e.isMajorExpense()).toList();
  }

  List<Expense> getThisMonth() {
    return _expenses.where((e) => e.isThisMonth()).toList();
  }

  List<Expense> getPaidExpenses() {
    return _expenses.where((e) => e.isPaid).toList();
  }

  List<Expense> getUnpaidExpenses() {
    return _expenses.where((e) => !e.isPaid).toList();
  }

  double getTotalSpending() {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double getAverageExpense() {
    if (_expenses.isEmpty) return 0;
    return getTotalSpending() / _expenses.length;
  }

  double getTotalUnpaid() {
    return _expenses
        .where((e) => !e.isPaid)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Expense? getLargestExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  Expense? getSmallestExpense() {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount < b.amount ? a : b);
  }

  int countByCategory(String category) {
    return _expenses.where((e) => e.category == category).length;
  }

  List<String> getAllCategories() {
    return _expenses.map((e) => e.category).toSet().toList();
  }

  Map<String, double> getCategoryBreakdown() {
    Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  Map<String, int> getCategoryCounts() {
    Map<String, int> counts = {};
    for (var expense in _expenses) {
      counts[expense.category] = (counts[expense.category] ?? 0) + 1;
    }
    return counts;
  }

  List<Expense> sortByAmountDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }

  List<Expense> sortByAmountAsc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.amount.compareTo(b.amount));
    return sorted;
  }

  List<Expense> sortByDateDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<Expense> sortByCategory() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.category.compareTo(b.category));
    return sorted;
  }

  bool removeExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) return false;
    _expenses.removeAt(index);
    return true;
  }

  bool removeExpenseByDescription(String description) {
    int initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.description == description);
    return _expenses.length < initialLength;
  }

  int removeByCategory(String category) {
    int initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.category == category);
    return initialLength - _expenses.length;
  }

  void clearAll() {
    _expenses.clear();
  }

  List<Expense> searchByDescription(String query) {
    String lowerQuery = query.toLowerCase();
    return _expenses
        .where((e) => e.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  int findIndexByDescription(String description) {
    return _expenses.indexWhere((e) => e.description == description);
  }

  void printSummary() {
    print('\n═══════════════════════════════════');
    print('💰 RINGKASAN PENGELUARAN');
    print('═══════════════════════════════════');
    print('Total expenses: ${getCount()}');
    print('Total yang dikeluarkan: Rp${getTotalSpending().toStringAsFixed(2)}');
    print('Rata-rata expense: Rp${getAverageExpense().toStringAsFixed(2)}');
    print('Total belum dibayar: Rp${getTotalUnpaid().toStringAsFixed(2)}');

    var largest = getLargestExpense();
    if (largest != null) {
      print('Terbesar: ${largest.description} (Rp${largest.amount})');
    }

    print('═══════════════════════════════════\n');
  }

  void printCategoryReport() {
    print('\n📊 BREAKDOWN KATEGORI\n');
    var breakdown = getCategoryBreakdown();
    var counts = getCategoryCounts();
    double total = getTotalSpending();

    breakdown.forEach((category, amount) {
      double percentage = (amount / total) * 100;
      int count = counts[category] ?? 0;
      print('$category:');
      print('  Jumlah: Rp${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)');
      print('  Banyak: $count expenses');
      print('');
    });
  }

  void printAllExpenses() {
    print('\n📋 SEMUA EXPENSES\n');
    if (_expenses.isEmpty) {
      print('Tidak ada expenses untuk ditampilkan');
      return;
    }

    for (int i = 0; i < _expenses.length; i++) {
      print('${i + 1}. ${_expenses[i].getFullDisplay()}');
    }
    print('');
  }
}

void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true));
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics'));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food'));
  manager.addExpense(Expense(description: 'Gas', amount: 45.00, category: 'Transport'));
  manager.addExpense(Expense(description: 'Groceries', amount: 127.50, category: 'Food', isPaid: true));

  manager.printSummary();
  manager.printCategoryReport();
  manager.printAllExpenses();

  print('🍔 EXPENSES MAKANAN:');
  for (var expense in manager.getByCategory('Food')) {
    print('  ${expense.getSummary()}');
  }

  print('\n🔴 MAJOR EXPENSES:');
  for (var expense in manager.getMajorExpenses()) {
    print('  ${expense.getSummary()}');
  }
}

// dart pub add intl