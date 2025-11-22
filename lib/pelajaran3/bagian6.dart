class Expense {
  String description;
  double amount;
  String category;
  DateTime date;
  String? notes;
  bool isPaid;

  // Constructor biasa dengan named parameter
  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.notes,
    this.isPaid = false,
  }) : date = date ?? DateTime.now();

  // Named constructor: expense cepat (hari ini, belum lunas)
  Expense.quick(
    this.description,
    this.amount,
    this.category, {
    this.notes,
  }) : date = DateTime.now(),
       isPaid = false;

  // Named constructor: tagihan bulanan (kategori tagihan, hari ini, lunas)
  Expense.bill(
    this.description,
    this.amount, {
    this.notes,
  }) : category = 'Tagihan',
       date = DateTime.now(),
       isPaid = true;

  // Named constructor: langganan berulang
  Expense.subscription({
    required this.description,
    required this.amount,
    this.notes,
  }) : category = 'Hiburan',
       date = DateTime.now(),
       isPaid = true;

  void printDetails() {
    String paid = isPaid ? '✅' : '❌';
    String noteText = notes != null ? ' - $notes' : '';
    print('$paid $description: \$${amount.toStringAsFixed(2)} [$category]$noteText');
  }
}

void main() {
  print('PENGELUARAN OKTOBER:\n');

  // Berbagai cara membuat expense
  var coffee = Expense.quick('Kopi', 4.50, 'Makanan');

  var rent = Expense.bill('Sewa', 1200.0, notes: 'Pembayaran Oktober');

  var netflix = Expense.subscription(
    description: 'Netflix',
    amount: 15.99,
    notes: 'Paket premium',
  );

  var dinner = Expense(
    description: 'Makan malam kencan',
    amount: 85.50,
    category: 'Makanan',
    notes: 'Perayaan anniversary',
  );

  coffee.printDetails();
  rent.printDetails();
  netflix.printDetails();
  dinner.printDetails();
}
