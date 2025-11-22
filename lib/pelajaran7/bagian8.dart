class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  void printDetails() {
    print('📝 $description ($category)');
    print('   Biaya: Rp ${amount.toStringAsFixed(2)}');
    print('   Tanggal: ${date.year}-${date.month}-${date.day}');
    print('   Tipe: Biasa');
  }
}

class RecurringExpense extends Expense {
  final String frequency;

  RecurringExpense({
    required String description,
    required double amount,
    required String category,
    required this.frequency,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: DateTime.now(),
        );

  double yearlyTotal() {
    switch (frequency.toLowerCase()) {
      case 'bulanan':
        return amount * 12;
      case 'mingguan':
        return amount * 52;
      case 'tahunan':
        return amount;
      default:
        return amount;
    }
  }

  @override
  void printDetails() {
    print('🔄 $description ($category)');
    print('   Biaya: Rp ${amount.toStringAsFixed(2)} / $frequency');
    print('   Total setahun: Rp ${yearlyTotal().toStringAsFixed(2)}');
    print('   Tipe: Berulang');
  }
}

class OneTimeExpense extends Expense {
  final String occasion;

  OneTimeExpense({
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    required this.occasion,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: date,
        );

  @override
  void printDetails() {
    print('⚡ $description ($category)');
    print('   Biaya: Rp ${amount.toStringAsFixed(2)}');
    print('   Tanggal: ${date.year}-${date.month}-${date.day}');
    print('   Anjuran: $occasion');
    print('   Tipe: Sekali Pakai');
  }
}

class ExpenseManager {
  final List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  List<Expense> getAllExpenses() => List.from(_expenses);

  List<RecurringExpense> getRecurringExpenses() {
    List<RecurringExpense> recurring = [];
    for (var expense in _expenses) {
      if (expense is RecurringExpense) {
        recurring.add(expense);
      }
    }
    return recurring;
  }

  List<OneTimeExpense> getOneTimeExpenses() {
    List<OneTimeExpense> oneTime = [];
    for (var expense in _expenses) {
      if (expense is OneTimeExpense) {
        oneTime.add(expense);
      }
    }
    return oneTime;
  }

  double getYearlyRecurringCost() {
    double total = 0;
    for (var expense in getRecurringExpenses()) {
      total += expense.yearlyTotal();
    }
    return total;
  }

  Map<String, int> getTypeCounts() {
    int regular = 0;
    int recurring = 0;
    int oneTime = 0;

    for (var expense in _expenses) {
      if (expense is RecurringExpense) {
        recurring++;
      } else if (expense is OneTimeExpense) {
        oneTime++;
      } else {
        regular++;
      }
    }

    return {
      'biasa': regular,
      'berulang': recurring,
      'sekaliPakai': oneTime,
    };
  }

  void printSummary() {
    print('\n═══════════════════════════════════');
    print('💰 RINGKASAN PENGELUARAN');
    print('═══════════════════════════════════');

    var counts = getTypeCounts();
    print('Total pengeluaran: ${_expenses.length}');
    print('  Biasa: ${counts['biasa']}');
    print('  Berulang: ${counts['berulang']}');
    print('  Sekali pakai: ${counts['sekaliPakai']}');

    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount;
    }
    print('\nTotal pengeluaran: Rp ${total.toStringAsFixed(2)}');

    double yearlyRecurring = getYearlyRecurringCost();
    print('Berulang tahunan: Rp ${yearlyRecurring.toStringAsFixed(2)}');

    print('═══════════════════════════════════\n');
  }

  void printAllExpenses() {
    print('SEMUA PENGELUARAN:\n');
    for (var expense in _expenses) {
      expense.printDetails();
      print('');
    }
  }
}

void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense(
    description: 'Kopi',
    amount: 4.50,
    category: 'Makanan',
    date: DateTime.now(),
  ));
  manager.addExpense(RecurringExpense(
    description: 'Netflix',
    amount: 15.99,
    category: 'Hiburan',
    frequency: 'bulanan',
  ));
  manager.addExpense(OneTimeExpense(
    description: 'Kado ulang tahun',
    amount: 75.0,
    category: 'Hadiah',
    date: DateTime.now(),
    occasion: 'ulang_tahun',
  ));
  manager.addExpense(RecurringExpense(
    description: 'Gym',
    amount: 45.0,
    category: 'Kesehatan',
    frequency: 'bulanan',
  ));
  manager.addExpense(OneTimeExpense(
    description: 'Servis mobil',
    amount: 350.0,
    category: 'Transport',
    date: DateTime.now(),
    occasion: 'darurat',
  ));
  manager.addExpense(Expense(
    description: 'Makan siang',
    amount: 12.50,
    category: 'Makanan',
    date: DateTime.now(),
  ));

  manager.printSummary();
  manager.printAllExpenses();

  print('🔄 RINCIAN PENGELUARAN BERULANG:');
  for (var expense in manager.getRecurringExpenses()) {
    print('${expense.description}: Rp ${expense.amount}/${expense.frequency}');
    print('   → Rp ${expense.yearlyTotal().toStringAsFixed(2)}/tahun');
  }
}