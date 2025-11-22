import 'dart:io';
import 'dart:convert';
import '../models/expense.dart';
import '../models/recurring_expense.dart';
import '../models/one_time_expense.dart';

class ExpenseManager {
  final List<Expense> _expenses = [];
  final String _dataFile = 'expenses.json';

  // Tambah pengeluaran
  void addExpense(Expense expense) {
    _expenses.add(expense);
    print('✅ Pengeluaran #${expense.id} ditambahkan');
  }

  // Dapatkan semua pengeluaran
  List<Expense> get allExpenses => List.unmodifiable(_expenses);

  int get count => _expenses.length;

  bool get isEmpty => _expenses.isEmpty;

  // Cari berdasarkan ID
  Expense? getExpenseById(int id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // Metode filter
  List<Expense> getByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> get thisMonth {
    return _expenses.where((e) => e.isThisMonth).toList();
  }

  List<Expense> get unpaid {
    return _expenses.where((e) => !e.isPaid).toList();
  }

  List<RecurringExpense> get recurringExpenses {
    return _expenses.whereType<RecurringExpense>().toList();
  }

  List<OneTimeExpense> get oneTimeExpenses {
    return _expenses.whereType<OneTimeExpense>().toList();
  }

  // Statistik
  double get totalSpending {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalUnpaid {
    return _expenses
        .where((e) => !e.isPaid)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get averageExpense {
    if (_expenses.isEmpty) return 0;
    return totalSpending / _expenses.length;
  }

  Expense? get largestExpense {
    if (_expenses.isEmpty) return null;
    return _expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  Set<String> get allCategories {
    return _expenses.map((e) => e.category).toSet();
  }

  Map<String, double> get categoryBreakdown {
    final breakdown = <String, double>{};
    for (final expense in _expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0) + expense.amount;
    }
    return breakdown;
  }

  // Metode sorting
  List<Expense> get sortedByAmountDesc {
    final sorted = List<Expense>.from(_expenses);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }

  List<Expense> get sortedByDateDesc {
    final sorted = List<Expense>.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // Update
  bool updateExpense(int id, {
    String? description,
    double? amount,
    String? category,
    String? notes,
    bool? isPaid,
  }) {
    final expense = getExpenseById(id);
    if (expense == null) return false;

    if (description != null) expense.description = description;
    if (amount != null) expense.amount = amount;
    if (category != null) expense.category = category;
    if (notes != null) expense.notes = notes;
    if (isPaid != null) expense.isPaid = isPaid;

    print('✏️  Pengeluaran #$id diperbarui');
    return true;
  }

  // Hapus
  bool deleteExpense(int id) {
    final initialLength = _expenses.length;
    _expenses.removeWhere((e) => e.id == id);
    final removed = _expenses.length < initialLength;

    if (removed) {
      print('🗑️  Pengeluaran #$id dihapus');
    }
    return removed;
  }

  // Tandai sudah bayar
  bool markAsPaid(int id, String paymentMethod) {
    final expense = getExpenseById(id);
    if (expense == null) return false;

    expense.isPaid = true;
    expense.paymentMethodName = paymentMethod;
    print('✅ Pengeluaran #$id ditandai lunas');
    return true;
  }

  // Cari
  List<Expense> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _expenses.where((e) =>
      e.description.toLowerCase().contains(lowerQuery) ||
      e.category.toLowerCase().contains(lowerQuery) ||
      (e.notes?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  // Laporan
  void printSummary() {
    print('\\n${"═" * 50}');
    print('💰 RINGKASAN PENGELUARAN'.padRight(50));
    print('${"═" * 50}');
    print('Total pengeluaran: $count');
    print('Total dikeluarkan: \$\\${totalSpending.toStringAsFixed(2)}');
    print('Rata-rata: \$\\${averageExpense.toStringAsFixed(2)}');
    print('Belum dibayar: \$\\${totalUnpaid.toStringAsFixed(2)}');

    final largest = largestExpense;
    if (largest != null) {
      print('Terbesar: ${largest.description} (${largest.formattedAmount})');
    }

    final recurring = recurringExpenses;
    if (recurring.isNotEmpty) {
      final yearlyRecurring = recurring.fold(0.0, (sum, e) => sum + e.yearlyTotal);
      print('Berkala tahunan: \$\\${yearlyRecurring.toStringAsFixed(2)}');
    }

    print('${"═" * 50}\\n');
  }

  void printCategoryReport() {
    print('\\n📊 RINCIAN KATEGORI\\n');
    final breakdown = categoryBreakdown;
    final total = totalSpending;

    if (breakdown.isEmpty) {
      print('Tidak ada pengeluaran untuk ditampilkan');
      return;
    }

    breakdown.forEach((category, amount) {
      final percentage = total > 0 ? (amount / total) * 100 : 0;
      final count = _expenses.where((e) => e.category == category).length;

      print('$category:');
      print('  Jumlah: \$\\${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)');
      print('  Hitungan: $count pengeluaran');
      print('');
    });
  }

  void printMonthlyReport() {
    print('\\n📅 LAPORAN BULANAN\\n');
    final monthly = thisMonth;

    if (monthly.isEmpty) {
      print('Tidak ada pengeluaran bulan ini');
      return;
    }

    final total = monthly.fold(0.0, (sum, e) => sum + e.amount);
    final unpaidAmount = monthly.where((e) => !e.isPaid).fold(0.0, (sum, e) => sum + e.amount);

    print('Bulan ini: ${monthly.length} pengeluaran');
    print('Total dikeluarkan: \$\\${total.toStringAsFixed(2)}');
    print('Belum dibayar: \$\\${unpaidAmount.toStringAsFixed(2)}');
    print('\\nPengeluaran:');

    for (final expense in monthly) {
      print('  ${expense.summary}');
    }
    print('');
  }

  // Simpan/Muat
  Future<void> saveToFile() async {
    try {
      final data = _expenses.map((e) => e.toMap()).toList();
      final json = const JsonEncoder.withIndent('  ').convert(data);
      await File(_dataFile).writeAsString(json);
      print('💾 ${_expenses.length} pengeluaran disimpan');
    } catch (e) {
      print('❌ Error saat menyimpan: $e');
    }
  }

  Future<void> loadFromFile() async {
    try {
      if (!await File(_dataFile).exists()) {
        print('Tidak ada data tersimpan');
        return;
      }

      final json = await File(_dataFile).readAsString();
      final data = jsonDecode(json) as List<dynamic>;

      _expenses.clear();
      for (final item in data) {
        final map = item as Map<String, dynamic>;
        final type = map['type'] as String? ?? 'regular';

        if (type == 'recurring') {
          _expenses.add(RecurringExpense.fromMap(map));
        } else if (type == 'onetime') {
          _expenses.add(OneTimeExpense.fromMap(map));
        } else {
          _expenses.add(Expense.fromMap(map));
        }
      }

      print('📂 ${_expenses.length} pengeluaran dimuat');
    } catch (e) {
      print('❌ Error saat memuat: $e');
    }
  }
}
