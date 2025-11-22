class Expense {
  String _description;
  double _amount;
  String _category;
  DateTime _date;
  String? _notes;
  bool _isPaid;

  static const List<String> validCategories = [
    'Makanan', 'Transport', 'Tagihan', 'Hiburan', 'Kesehatan', 'Belanja', 'Lainnya'
  ];

  Expense({
    required String description,
    required double amount,
    required String category,
    DateTime? date,
    String? notes,
    bool isPaid = false,
  }) : _description = description,
       _amount = amount,
       _category = category,
       _date = date ?? DateTime.now(),
       _notes = notes,
       _isPaid = isPaid {
    if (_amount < 0) throw Exception('Jumlah tidak boleh negatif');
    if (_description.trim().isEmpty) throw Exception('Deskripsi tidak boleh kosong');
    if (!validCategories.contains(_category)) {
      _category = 'Lainnya';
    }
  }

  // Getters
  String get description => _description;
  double get amount => _amount;
  String get category => _category;
  DateTime get date => _date;
  String? get notes => _notes;
  bool get isPaid => _isPaid;

  // Setters
  set amount(double value) {
    if (value < 0) throw Exception('Jumlah tidak boleh negatif');
    _amount = value;
  }

  set isPaid(bool value) => _isPaid = value;
  set notes(String? value) => _notes = value;

  // Method pengecekan boolean
  bool isMajorExpense() => _amount > 100;
  bool isThisMonth() {
    DateTime now = DateTime.now();
    return _date.year == now.year && _date.month == now.month;
  }
  bool isToday() {
    DateTime now = DateTime.now();
    return _date.year == now.year && _date.month == now.month && _date.day == now.day;
  }
  bool isCategory(String cat) => _category == cat;
  bool isOlderThan(int days) => DateTime.now().difference(_date).inDays > days;

  // Method formatting
  String getFormattedAmount() => 'Rp${_amount.toStringAsFixed(2)}';

  String getFormattedDate() {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                           'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${_date.day} ${months[_date.month - 1]} ${_date.year}';
  }

  String getCategoryEmoji() {
    switch (_category) {
      case 'Makanan': return '🍔';
      case 'Transport': return '🚗';
      case 'Tagihan': return '💡';
      case 'Hiburan': return '🎬';
      case 'Kesehatan': return '💊';
      case 'Belanja': return '🛍️';
      default: return '📝';
    }
  }

  String getSummary() {
    String emoji = isMajorExpense() ? '🔴' : '🟢';
    return '$emoji $_description: ${getFormattedAmount()} [$_category]';
  }

  String getFullDisplay() {
    String paid = _isPaid ? '✅' : '❌';
    String noteText = _notes != null ? ' - $_notes' : '';
    return '$paid ${getCategoryEmoji()} $_description: ${getFormattedAmount()}$noteText';
  }

  // Method kalkulasi
  int getDaysAgo() => DateTime.now().difference(_date).inDays;

  double getTax({double taxRate = 0.10}) => _amount * taxRate;

  double getTotalWithTax({double taxRate = 0.10}) => _amount + getTax(taxRate: taxRate);

  double getPercentageOf(double total) {
    if (total == 0) return 0;
    return (_amount / total) * 100;
  }

  double splitAmount(int numberOfPeople) {
    if (numberOfPeople <= 0) return _amount;
    return _amount / numberOfPeople;
  }

  // Method perbandingan
  bool isMoreExpensiveThan(Expense other) => _amount > other._amount;
  bool isSameCategory(Expense other) => _category == other._category;
  bool isNewerThan(Expense other) => _date.isAfter(other._date);

  int compareByAmount(Expense other) {
    if (_amount < other._amount) return -1;
    if (_amount > other._amount) return 1;
    return 0;
  }

  // Method aksi
  void markAsPaid() {
    _isPaid = true;
  }

  void markAsUnpaid() {
    _isPaid = false;
  }

  void addNote(String note) {
    if (_notes == null || _notes!.isEmpty) {
      _notes = note;
    } else {
      _notes = '$_notes; $note';
    }
  }

  void printDetails() {
    print('─────────────────────────────');
    print('${getCategoryEmoji()} $_description');
    print('💰 ${getFormattedAmount()}');
    print('📁 $_category');
    print('📅 ${getFormattedDate()}');
    print('${_isPaid ? "✅" : "❌"} ${_isPaid ? "Lunas" : "Belum Lunas"}');
    if (_notes != null && _notes!.isNotEmpty) {
      print('📝 $_notes');
    }
    print('🕒 ${getDaysAgo()} hari yang lalu');
  }
}

void main() {
  print('🏦 DEMO CLASS EXPENSE \n');

  var expenses = [
    Expense(description: 'Kopi pagi', amount: 4.50, category: 'Makanan'),
    Expense(description: 'Uber ke kantor', amount: 12.00, category: 'Transport'),
    Expense(description: 'Laptop', amount: 899.99, category: 'Belanja', isPaid: true),
    Expense(description: 'Belanja bulanan', amount: 127.50, category: 'Makanan', notes: 'Belanja mingguan'),
  ];

  // Print semua ringkasan
  print('RINGKASAN:');
  for (var expense in expenses) {
    print(expense.getSummary());
  }

  // Hitung total
  double total = 0;
  for (var expense in expenses) {
    total += expense.amount;
  }

  print('\n─────────────────────────────');
  print('Total: Rp${total.toStringAsFixed(2)}');

  // Tampilkan persentase
  print('\nPERSENTASE:');
  for (var expense in expenses) {
    print('${expense.description}: ${expense.getPercentageOf(total).toStringAsFixed(1)}%');
  }

  // Tampilkan pengeluaran bulan ini
  print('\nBULAN INI:');
  for (var expense in expenses) {
    if (expense.isThisMonth()) {
      print(expense.getFullDisplay());
    }
  }

  // Tampilkan pengeluaran besar
  print('\nPENGELUARAN BESAR (>Rp100):');
  for (var expense in expenses) {
    if (expense.isMajorExpense()) {
      expense.printDetails();
    }
  }
}
