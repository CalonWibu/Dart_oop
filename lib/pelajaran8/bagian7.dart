abstract class PaymentMethod {
  String get name;
  String get icon;

  void processPayment(double amount);

  bool validate() {
    return true;
  }

  void showReceipt(double amount) {
    print('\n${"─" * 35}');
    print('$icon STRUK');
    print('${"─" * 35}');
    print('Metode Pembayaran: $name');
    print('Jumlah: \$${amount.toStringAsFixed(2)}');
    print('Status: ✅ Sukses');
    print('Tanggal: ${DateTime.now().toString().split('.')[0]}');
    print('${"─" * 35}\n');
  }
}

class CreditCard extends PaymentMethod {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  String get name => 'Kartu Kredit';

  @override
  String get icon => '💳';

  @override
  bool validate() {
    if (cardNumber.length != 16) return false;
    if (cvv.length != 3) return false;
    return true;
  }

  @override
  void processPayment(double amount) {
    if (!validate()) {
      print('❌ Detail kartu tidak valid');
      return;
    }

    print('$icon Memproses pembayaran kartu kredit...');
    print('Pemegang kartu: $cardHolder');
    print('Kartu: ****${cardNumber.substring(12)}');
    print('Kadaluarsa: $expiryDate');
    showReceipt(amount);
  }
}

class DebitCard extends PaymentMethod {
  final String cardNumber;
  final String pin;
  double balance;

  DebitCard({
    required this.cardNumber,
    required this.pin,
    required this.balance,
  });

  @override
  String get name => 'Kartu Debit';

  @override
  String get icon => '💳';

  @override
  bool validate() {
    return pin.length == 4 && balance > 0;
  }

  @override
  void processPayment(double amount) {
    if (!validate()) {
      print('❌ PIN tidak valid atau saldo tidak cukup');
      return;
    }

    if (balance < amount) {
      print('❌ Saldo tidak cukup. Saldo: \$${balance.toStringAsFixed(2)}');
      return;
    }

    balance -= amount;
    print('$icon Memproses pembayaran kartu debit...');
    print('Kartu: ****${cardNumber.substring(12)}');
    print('Saldo baru: \$${balance.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}

class Cash extends PaymentMethod {
  @override
  String get name => 'Tunai';

  @override
  String get icon => '💵';

  @override
  void processPayment(double amount) {
    print('$icon Pembayaran tunai diterima');
    print('Jumlah: \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}

class DigitalWallet extends PaymentMethod {
  final String walletName;
  final String email;
  final String password;

  DigitalWallet({
    required this.walletName,
    required this.email,
    required this.password,
  });

  @override
  String get name => walletName;

  @override
  String get icon => '📱';

  @override
  bool validate() {
    return email.contains('@') && password.length >= 6;
  }

  @override
  void processPayment(double amount) {
    if (!validate()) {
      print('❌ Kredensial tidak valid');
      return;
    }

    print('$icon Menghubungkan ke $walletName...');
    print('Akun: $email');
    print('Mengotorisasi pembayaran...');
    showReceipt(amount);
  }
}

class BankTransfer extends PaymentMethod {
  final String accountNumber;
  final String bankName;
  final String routingNumber;

  BankTransfer({
    required this.accountNumber,
    required this.bankName,
    required this.routingNumber,
  });

  @override
  String get name => 'Transfer Bank';

  @override
  String get icon => '🏦';

  @override
  void processPayment(double amount) {
    print('$icon Memulai transfer bank...');
    print('Bank: $bankName');
    print('Rekening: ****${accountNumber.substring(accountNumber.length - 4)}');
    print('Kode routing: $routingNumber');
    print('⏳ Transfer tertunda (1-3 hari kerja)');
    showReceipt(amount);
  }
}

class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  PaymentMethod? paymentMethod;
  bool isPaid;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now(),
       isPaid = false;

  void payWith(PaymentMethod method) {
    print('\n${"═" * 40}');
    print('MEMPROSES PEMBAYARAN');
    print('${"═" * 40}');
    print('Pengeluaran: $description');
    print('Jumlah: \$${amount.toStringAsFixed(2)}');
    print('Kategori: $category');
    print('');

    method.processPayment(amount);
    paymentMethod = method;
    isPaid = true;
  }

  void printDetails() {
    String status = isPaid ? '✅ Dibayar' : '❌ Belum dibayar';
    String payment = paymentMethod != null
        ? '${paymentMethod!.icon} ${paymentMethod!.name}'
        : 'Tidak ada metode pembayaran';

    print('$description: \$${amount.toStringAsFixed(2)} [$category]');
    print('Status: $status | Pembayaran: $payment');
  }
}

void main() {
  print('💰 SISTEM PEMBAYARAN PENGELUARAN\n');

  var expenses = [
    Expense(description: 'Sewa bulanan', amount: 1200.0, category: 'Tagihan'),
    Expense(description: 'Belanja', amount: 127.50, category: 'Makanan'),
    Expense(description: 'Kopi', amount: 4.50, category: 'Makanan'),
    Expense(description: 'Laptop', amount: 899.99, category: 'Elektronik'),
  ];

  var creditCard = CreditCard(
    cardNumber: '4532123456789012',
    cardHolder: 'John Doe',
    expiryDate: '12/26',
    cvv: '123',
  );

  var debitCard = DebitCard(
    cardNumber: '5105105105105100',
    pin: '1234',
    balance: 5000.0,
  );

  var paypal = DigitalWallet(
    walletName: 'PayPal',
    email: 'john@example.com',
    password: 'secure123',
  );

  var cash = Cash();

  expenses[0].payWith(creditCard);
  expenses[1].payWith(debitCard);
  expenses[2].payWith(cash);
  expenses[3].payWith(paypal);

  print('\n${"═" * 40}');
  print('RINGKASAN PEMBAYARAN');
  print('${"═" * 40}\n');

  for (var expense in expenses) {
    expense.printDetails();
    print('');
  }
}