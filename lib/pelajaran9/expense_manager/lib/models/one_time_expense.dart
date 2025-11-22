import './expense.dart';

class OneTimeExpense extends Expense {
  String occasion;

  // Named constructor untuk one-time expense baru
  OneTimeExpense.create({
    required String description,
    required double amount,
    required String category,
    required this.occasion,
    DateTime? date,
    String? notes,
    bool isPaid = false,
  }) : super.create(
    description: description,
    amount: amount,
    category: category,
    date: date,
    notes: notes,
    isPaid: isPaid,
  );

  // Private constructor untuk memuat dari data
  OneTimeExpense._fromData({
    required int id,
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    required this.occasion,
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

  bool get isSpecialOccasion {
    return occasion == 'ulang tahun' ||
           occasion == 'anniversary' ||
           occasion == 'hari raya' ||
           occasion == 'pernikahan';
  }

  String get occasionEmoji {
    switch (occasion) {
      case 'ulang tahun': return '🎂';
      case 'anniversary': return '💝';
      case 'hari raya': return '🎄';
      case 'pernikahan': return '💒';
      case 'darurat': return '🚨';
      case 'liburan': return '✈️';
      default: return '🎯';
    }
  }

  @override
  void printDetails() {
    print('─────────────────────────────────────');
    print('🎯 PENGELUARAN SEKALI #$id');
    print('$occasionEmoji $occasion: $description');
    print('$categoryEmoji Kategori: $category');
    print('Jumlah: $formattedAmount');
    print('Tanggal: $formattedDate ($daysAgo hari lalu)');
    print('Status: ${isPaid ? "✅ Lunas" : "❌ Belum Bayar"}');
    if (isSpecialOccasion) {
      print('✨ Acara spesial');
    }
    if (notes != null && notes!.isNotEmpty) {
      print('Catatan: $notes');
    }
    print('─────────────────────────────────────');
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['type'] = 'onetime';
    map['occasion'] = occasion;
    return map;
  }

  // Named constructor untuk memuat dari Map
  factory OneTimeExpense.fromMap(Map<String, dynamic> map) {
    return OneTimeExpense._fromData(
      id: map['id'] as int,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      occasion: map['occasion'] as String,
      notes: map['notes'] as String?,
      isPaid: map['isPaid'] as bool,
      paymentMethodName: map['paymentMethodName'] as String?,
    );
  }
}
