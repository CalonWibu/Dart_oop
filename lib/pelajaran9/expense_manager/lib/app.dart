import 'dart:io';
import 'managers/expense_manager.dart';
import 'models/expense.dart';
import 'models/recurring_expense.dart';
import 'models/one_time_expense.dart';
import 'utils/input_helper.dart';
import 'utils/display_helper.dart';

class ExpenseApp {
  final ExpenseManager _manager = ExpenseManager();
  bool _running = true;

  Future<void> run() async {
    DisplayHelper.clearScreen();
    print('🚀 Memuat...');
    await _manager.loadFromFile();

    while (_running) {
      _showMainMenu();
      final choice = InputHelper.readInt('\\nPilih opsi', min: 1, max: 11);

      DisplayHelper.clearScreen();

      switch (choice) {
        case 1:
          _addExpense();
          break;
        case 2:
          _viewAllExpenses();
          break;
        case 3:
          _viewByCategory();
          break;
        case 4:
          _searchExpenses();
          break;
        case 5:
          _viewExpenseDetails();
          break;
        case 6:
          _updateExpense();
          break;
        case 7:
          _deleteExpense();
          break;
        case 8:
          _markAsPaid();
          break;
        case 9:
          _viewReports();
          break;
        case 10:
          await _saveAndExit();
          break;
        case 11:
          _running = false;
          print('👋 Sampai jumpa!');
          break;
      }

      if (_running && choice != 10 && choice != 11) {
        InputHelper.pause();
      }
    }
  }

  void _showMainMenu() {
    DisplayHelper.clearScreen();
    DisplayHelper.printHeader('💰 Expense Manager v1.0');

    if (!_manager.isEmpty) {
      print('Total: ${_manager.count} pengeluaran | ');
      print('Dikeluarkan: \\${_manager.totalSpending.toStringAsFixed(2)} | ');
      print('Belum Bayar: \\${_manager.totalUnpaid.toStringAsFixed(2)}\\n');
    }

    print('1.  ➕ Tambah Pengeluaran');
    print('2.  📋 Lihat Semua Pengeluaran');
    print('3.  📁 Lihat per Kategori');
    print('4.  🔍 Cari Pengeluaran');
    print('5.  🔎 Lihat Detail Pengeluaran');
    print('6.  ✏️  Perbarui Pengeluaran');
    print('7.  🗑️  Hapus Pengeluaran');
    print('8.  💳 Tandai Sudah Bayar');
    print('9.  📊 Lihat Laporan');
    print('10. 💾 Simpan & Keluar');
    print('11. 🚪 Keluar Tanpa Menyimpan');
  }

  void _addExpense() {
    DisplayHelper.printHeader('➕ Tambah Pengeluaran');

    final type = InputHelper.readChoice('Tipe pengeluaran', [
      'Reguler',
      'Berkala (langganan, tagihan)',
      'Sekali (acara khusus)',
    ]);

    print('');
    final description = InputHelper.readString('Deskripsi');
    final amount = InputHelper.readDouble('Jumlah (\$)', min: 0);

    final category = InputHelper.readChoice('Kategori', [
      'Makanan',
      'Transportasi',
      'Tagihan',
      'Hiburan',
      'Kesehatan',
      'Belanja',
      'Lainnya',
    ]);

    String? notes;
    if (InputHelper.readYesNo('Tambah catatan?')) {
      notes = InputHelper.readString('Catatan');
    }

    try {
      if (type == 'Reguler') {
        _manager.addExpense(Expense.create(
          description: description,
          amount: amount,
          category: category,
          notes: notes,
        ));
      } else if (type == 'Berkala (langganan, tagihan)') {
        final frequency = InputHelper.readChoice('Frekuensi', [
          'harian',
          'mingguan',
          'bulanan',
          'tahunan',
        ]);

        _manager.addExpense(RecurringExpense.create(
          description: description,
          amount: amount,
          category: category,
          frequency: frequency,
          notes: notes,
        ));
      } else {
        final occasion = InputHelper.readChoice('Acara', [
          'ulang tahun',
          'anniversary',
          'hari raya',
          'pernikahan',
          'darurat',
          'liburan',
          'lainnya',
        ]);

        _manager.addExpense(OneTimeExpense.create(
          description: description,
          amount: amount,
          category: category,
          occasion: occasion,
          notes: notes,
        ));
      }

      DisplayHelper.printSuccess('Pengeluaran berhasil ditambahkan!');
    } catch (e) {
      DisplayHelper.printError('Gagal menambah pengeluaran: $e');
    }
  }

  void _viewAllExpenses() {
    DisplayHelper.printHeader('📋 Semua Pengeluaran');

    if (_manager.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    final sortBy = InputHelper.readChoice('Urutkan berdasarkan', [
      'Tanggal (terbaru dulu)',
      'Jumlah (terbesar dulu)',
      'ID',
    ]);

    final List<Expense> expenses;
    if (sortBy == 'Tanggal (terbaru dulu)') {
      expenses = _manager.sortedByDateDesc;
    } else if (sortBy == 'Jumlah (terbesar dulu)') {
      expenses = _manager.sortedByAmountDesc;
    } else {
      expenses = _manager.allExpenses;
    }

    print('');
    for (final expense in expenses) {
      print(expense.summary);
    }

    print('\\nTotal: ${expenses.length} pengeluaran');
  }

  void _viewByCategory() {
    DisplayHelper.printHeader('📁 Lihat per Kategori');

    final categories = _manager.allCategories.toList();
    if (categories.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    final category = InputHelper.readChoice('Kategori', categories);
    final expenses = _manager.getByCategory(category);

    print('');
    if (expenses.isEmpty) {
      DisplayHelper.printInfo('Tidak ada pengeluaran di kategori ini');
      return;
    }

    for (final expense in expenses) {
      print(expense.summary);
    }

    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    print('\\nTotal $category: \\${total.toStringAsFixed(2)}');
  }

  void _searchExpenses() {
    DisplayHelper.printHeader('🔍 Cari Pengeluaran');

    final query = InputHelper.readString('Cari kata kunci');
    final results = _manager.search(query);

    print('');
    if (results.isEmpty) {
      DisplayHelper.printInfo('Tidak ada hasil ditemukan');
      return;
    }

    print('Ditemukan ${results.length} hasil:\\n');
    for (final expense in results) {
      print(expense.summary);
    }
  }

  void _viewExpenseDetails() {
    DisplayHelper.printHeader('🔎 Lihat Detail Pengeluaran');

    if (_manager.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    final id = InputHelper.readInt('Masukkan ID pengeluaran');
    final expense = _manager.getExpenseById(id);

    print('');
    if (expense == null) {
      DisplayHelper.printError('Pengeluaran tidak ditemukan');
      return;
    }

    expense.printDetails();
  }

  void _updateExpense() {
    DisplayHelper.printHeader('✏️  Perbarui Pengeluaran');

    if (_manager.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    final id = InputHelper.readInt('Masukkan ID pengeluaran');
    final expense = _manager.getExpenseById(id);

    if (expense == null) {
      DisplayHelper.printError('Pengeluaran tidak ditemukan');
      return;
    }

    print('\\nDetail saat ini:');
    expense.printDetails();

    print('\\nApa yang ingin diperbarui?');
    print('1. Deskripsi');
    print('2. Jumlah');
    print('3. Kategori');
    print('4. Catatan');
    print('5. Batal');

    final choice = InputHelper.readInt('Pilih', min: 1, max: 5);

    if (choice == 5) {
      print('Dibatalkan');
      return;
    }

    switch (choice) {
      case 1:
        final newDesc = InputHelper.readString('Deskripsi baru');
        _manager.updateExpense(id, description: newDesc);
        break;
      case 2:
        final newAmount = InputHelper.readDouble('Jumlah baru', min: 0);
        _manager.updateExpense(id, amount: newAmount);
        break;
      case 3:
        final newCategory = InputHelper.readChoice('Kategori baru', [
          'Makanan', 'Transportasi', 'Tagihan', 'Hiburan',
          'Kesehatan', 'Belanja', 'Lainnya'
        ]);
        _manager.updateExpense(id, category: newCategory);
        break;
      case 4:
        final newNotes = InputHelper.readString('Catatan baru');
        _manager.updateExpense(id, notes: newNotes);
        break;
    }
  }

  void _deleteExpense() {
    DisplayHelper.printHeader('🗑️  Hapus Pengeluaran');

    if (_manager.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    final id = InputHelper.readInt('Masukkan ID pengeluaran');
    final expense = _manager.getExpenseById(id);

    if (expense == null) {
      DisplayHelper.printError('Pengeluaran tidak ditemukan');
      return;
    }

    print('\\nPengeluaran yang akan dihapus:');
    print(expense.summary);

    if (InputHelper.readYesNo('\\nApakah kamu yakin?')) {
      _manager.deleteExpense(id);
    } else {
      print('Dibatalkan');
    }
  }

  void _markAsPaid() {
    DisplayHelper.printHeader('💳 Tandai Sudah Bayar');

    final unpaid = _manager.unpaid;
    if (unpaid.isEmpty) {
      DisplayHelper.printInfo('Tidak ada pengeluaran yang belum dibayar');
      return;
    }

    print('Pengeluaran yang belum dibayar:\\n');
    for (final expense in unpaid) {
      print(expense.summary);
    }

    print('');
    final id = InputHelper.readInt('Masukkan ID pengeluaran');
    final expense = _manager.getExpenseById(id);

    if (expense == null) {
      DisplayHelper.printError('Pengeluaran tidak ditemukan');
      return;
    }

    if (expense.isPaid) {
      DisplayHelper.printWarning('Pengeluaran ini sudah dibayar');
      return;
    }

    final paymentMethod = InputHelper.readChoice('Metode pembayaran', [
      'Tunai',
      'Kartu Kredit',
      'Kartu Debit',
      'Dompet Digital',
      'Transfer Bank',
      'Lainnya',
    ]);

    _manager.markAsPaid(id, paymentMethod);
  }

  void _viewReports() {
    DisplayHelper.printHeader('📊 Laporan');

    if (_manager.isEmpty) {
      DisplayHelper.printInfo('Belum ada pengeluaran');
      return;
    }

    print('1. Ringkasan');
    print('2. Rincian Kategori');
    print('3. Laporan Bulanan');
    print('4. Semua Laporan');

    final choice = InputHelper.readInt('Pilih', min: 1, max: 4);

    print('');
    switch (choice) {
      case 1:
        _manager.printSummary();
        break;
      case 2:
        _manager.printCategoryReport();
        break;
      case 3:
        _manager.printMonthlyReport();
        break;
      case 4:
        _manager.printSummary();
        _manager.printCategoryReport();
        _manager.printMonthlyReport();
        break;
    }
  }

  Future<void> _saveAndExit() async {
    DisplayHelper.printHeader('💾 Menyimpan');
    await _manager.saveToFile();
    _running = false;
    print('\\n✅ Data tersimpan. Sampai jumpa! 👋');
  }
}
