class Expense {
  String description;
  double amount;
  String category;
  DateTime date;
  String? notes;
  bool isPaid;
  String paymentMethod;

  // Constructor utama - kontrol penuh
  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.notes,
    this.isPaid = false,
    this.paymentMethod = 'Tunai',
  }) : date = date ?? DateTime.now();

  // Expense harian cepat, named positional
  Expense.quick(
    this.description,
    this.amount,
    this.category,
  ) : date = DateTime.now(),
      notes = null,
      isPaid = false,
      paymentMethod = 'Tunai';

  // Tagihan bulanan berulang
  Expense.monthlyBill(
    this.description,
    this.amount, {
    this.paymentMethod = 'Auto-bayar',
  }) : category = 'Tagihan',
       date = DateTime.now(),
       notes = 'Berulang bulanan',
       isPaid = true;

  // Pembelian kartu kredit
  Expense.creditCard(
    this.description,
    this.amount,
    this.category, {
    this.notes,
  }) : date = DateTime.now(),
       isPaid = false,
       paymentMethod = 'Kartu Kredit';

  // Pembelian tunai (sudah lunas)
  Expense.cash(
    this.description,
    this.amount,
    this.category, {
    this.notes,
  }) : date = DateTime.now(),
       isPaid = true,
       paymentMethod = 'Tunai';

  // Expense kemarin (untuk saat kamu lupa mencatat)
  Expense.yesterday(
    this.description,
    this.amount,
    this.category,
  ) : date = DateTime.now().subtract(Duration(days: 1)),
      notes = 'Dicatat terlambat',
      isPaid = true,
      paymentMethod = 'Tunai';

  void printDetails() {
    String paid = isPaid ? '✅ Lunas' : '❌ Belum lunas';
    String noteText = notes != null ? '\n   Catatan: $notes' : '';
    print('─────────────────────────────');
    print('$description');
    print('Jumlah: \$${amount.toStringAsFixed(2)}');
    print('Kategori: $category');
    print('Tanggal: ${date.toString().split(' ')[0]}');
    print('Pembayaran: $paymentMethod');
    print('Status: $paid$noteText');
  }

  bool isMajorExpense() => amount > 100;

  String getSummary() {
    String emoji = isMajorExpense() ? '🔴' : '🟢';
    return '$emoji \$${amount.toStringAsFixed(2)} - $description [$category]';
  }
}

void main() {
  print('📊 PELACAK PENGELUARAN\n');

  var expenses = [
    Expense.quick('Kopi pagi', 4.50, 'Makanan'),
    Expense.monthlyBill('Internet', 59.99),
    Expense.creditCard('Belanja', 127.50, 'Makanan', notes: 'Belanja mingguan'),
    Expense.cash('Parkir', 5.00, 'Transport'),
    Expense.yesterday('Makan siang', 15.00, 'Makanan'),
    Expense(
      description: 'Laptop baru',
      amount: 1299.99,
      category: 'Elektronik',
      paymentMethod: 'Kartu Kredit',
      notes: 'Peralatan kerja',
    ),
  ];

  // Print semua ringkasan
  print('Ringkasan:');
  for (var expense in expenses) {
    print(expense.getSummary());
  }

  // Print detail pengeluaran besar
  print('\n\nPENGELUARAN BESAR (>\$100):');
  for (var expense in expenses) {
    if (expense.isMajorExpense()) {
      expense.printDetails();
    }
  }

  // Hitung total
  double total = 0;
  double unpaid = 0;

  for (var expense in expenses) {
    total += expense.amount;
    if (!expense.isPaid) {
      unpaid += expense.amount;
    }
  }

  print('\n─────────────────────────────');
  print('💰 Total Pengeluaran: \$${total.toStringAsFixed(2)}');
  print('❌ Belum Lunas: \$${unpaid.toStringAsFixed(2)}');
  print('✅ Lunas: \$${(total - unpaid).toStringAsFixed(2)}');
}
