import './expense.dart';

class RecurringExpense extends Expense {
  String frequency;
  DateTime? nextDueDate;

  // Named constructor untuk recurring expense baru
  RecurringExpense.create({
    required String description,
    required double amount,
    required String category,
    required this.frequency,
    DateTime? date,
    this.nextDueDate,
    String? notes,
    bool isPaid = false,
  }) : super.create(
    description: description,
    amount: amount,
    category: category,
    date: date,
    notes: notes,
    isPaid: isPaid,
  ) {
    this.nextDueDate ??= _calculateNextDueDate();
  }

  // Private constructor untuk memuat dari data
  RecurringExpense._fromData({
    required int id,
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    required this.frequency,
    this.nextDueDate,
    String? notes,
    required bool isPaid,
    String? paymentMethodName,
  }) : super.fromData(
    id: id,
    description: description,
    amount: amount,
    category: category,
    date: date,
    notes: notes,
    isPaid: isPaid,
    paymentMethodName: paymentMethodName,
  );

  DateTime _calculateNextDueDate() {
    switch (frequency) {
      case 'harian':
        return date.add(const Duration(days: 1));
      case 'mingguan':
        return date.add(const Duration(days: 7));
      case 'bulanan':
        return DateTime(date.year, date.month + 1, date.day);
      case 'tahunan':
        return DateTime(date.year + 1, date.month, date.day);
      default:
        return date;
    }
  }

  double get yearlyTotal {
    switch (frequency) {
      case 'harian': return amount * 365;
      case 'mingguan': return amount * 52;
      case 'bulanan': return amount * 12;
      case 'tahunan': return amount;
      default: return amount;
    }
  }

  bool isDueSoon(int daysThreshold) {
    final dueDate = nextDueDate;
    if (dueDate == null) return false;
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    return daysUntilDue <= daysThreshold && daysUntilDue >= 0;
  }

  @override
  void printDetails() {
    print('─────────────────────────────────────');
    print('🔄 PENGELUARAN BERKALA #$id');
    print('$categoryEmoji $description');
    print('Jumlah: $formattedAmount/$frequency');
    print('Total Tahunan: \$\\${yearlyTotal.toStringAsFixed(2)}');
    print('Kategori: $category');
    print('Pembayaran Terakhir: $formattedDate');
    final dueDate = nextDueDate;
    if (dueDate != null) {
      print('Jatuh Tempo Berikutnya: ${dueDate.day}/${dueDate.month}/${dueDate.year}');
      if (isDueSoon(3)) {
        print('⚠️  Segera jatuh tempo!');
      }
    }
    print('Status: ${isPaid ? "✅ Lunas" : "❌ Belum Bayar"}');
    if (notes != null && notes!.isNotEmpty) {
      print('Catatan: $notes');
    }
    print('─────────────────────────────────────');
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['type'] = 'recurring';
    map['frequency'] = frequency;
    map['nextDueDate'] = nextDueDate?.toIso8601String();
    return map;
  }

  // Named constructor untuk memuat dari Map
  factory RecurringExpense.fromMap(Map<String, dynamic> map) {
    return RecurringExpense._fromData(
      id: map['id'] as int,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      frequency: map['frequency'] as String,
      nextDueDate: map['nextDueDate'] != null
          ? DateTime.parse(map['nextDueDate'] as String)
          : null,
      notes: map['notes'] as String?,
      isPaid: map['isPaid'] as bool,
      paymentMethodName: map['paymentMethodName'] as String?,
    );
  }
}
