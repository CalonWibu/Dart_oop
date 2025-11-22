class Expense {
  static int _idCounter = 0;

  final int id;
  String description;
  double amount;
  String category;
  DateTime date;
  String? notes;
  bool isPaid;
  String? paymentMethodName;

  // Named constructor untuk membuat expense baru
  Expense.create({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.notes,
    this.isPaid = false,
    this.paymentMethodName,
  }) : id = ++_idCounter,
       date = date ?? DateTime.now() {
    _validate();
  }

  // Private constructor untuk memuat dari data yang sudah ada
  Expense._fromData({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    required this.isPaid,
    this.paymentMethodName,
  });

  // Public constructor untuk memuat dari data yang sudah ada
  Expense.fromData({
    required int id,
    required String description,
    required double amount,
    required String category,
    required DateTime date,
    String? notes,
    required bool isPaid,
    String? paymentMethodName,
  }) : this._fromData(
    id: id,
    description: description,
    amount: amount,
    category: category,
    date: date,
    notes: notes,
    isPaid: isPaid,
    paymentMethodName: paymentMethodName,
  );

  // Validasi
  void _validate() {
    if (amount < 0) {
      throw ArgumentError('Jumlah tidak boleh negatif');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Deskripsi tidak boleh kosong');
    }
  }

  // Getters
  bool get isMajorExpense => amount > 100;

  bool get isThisMonth {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  int get daysAgo => DateTime.now().difference(date).inDays;

  String get formattedAmount => '\$\\${amount.toStringAsFixed(2)}';

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get categoryEmoji {
    switch (category) {
      case 'Makanan': return '🍔';
      case 'Transportasi': return '🚗';
      case 'Tagihan': return '💡';
      case 'Hiburan': return '🎬';
      case 'Kesehatan': return '💊';
      case 'Belanja': return '🛍️';
      default: return '📝';
    }
  }

  String get summary {
    final emoji = isMajorExpense ? '🔴' : '🟢';
    final paid = isPaid ? '✅' : '❌';
    return '$emoji $paid #$id: $description - $formattedAmount [$category]';
  }

  void printDetails() {
    print('─────────────────────────────────────');
    print('ID: #$id');
    print('$categoryEmoji $description');
    print('Jumlah: $formattedAmount');
    print('Kategori: $category');
    print('Tanggal: $formattedDate ($daysAgo hari lalu)');
    print('Status: ${isPaid ? "✅ Lunas" : "❌ Belum Bayar"}');
    if (paymentMethodName != null) {
      print('Pembayaran: $paymentMethodName');
    }
    if (notes != null && notes!.isNotEmpty) {
      print('Catatan: $notes');
    }
    print('─────────────────────────────────────');
  }

  // Convert to/from Map untuk menyimpan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'isPaid': isPaid,
      'paymentMethodName': paymentMethodName,
      'type': 'regular',
    };
  }

  // Named constructor untuk memuat dari Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense._fromData(
      id: map['id'] as int,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
      isPaid: map['isPaid'] as bool,
      paymentMethodName: map['paymentMethodName'] as String?,
    );
  }
}
