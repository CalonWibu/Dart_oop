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
}

class Cryptocurrency extends PaymentMethod {
  final String walletAddress;
  final String coinType;

  Cryptocurrency({
    required this.walletAddress,
    required this.coinType,
  });

  @override
  String get name => 'Dompet $coinType';

  @override
  String get icon => '₿';

  @override
  bool validate() {
    return walletAddress.isNotEmpty && walletAddress.length > 20;
  }

  @override
  void processPayment(double amount) {
    if (!validate()) {
      print('❌ Alamat wallet tidak valid');
      return;
    }

    print('$icon Memproses pembayaran $coinType...');
    print('Wallet: ${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}');
    print('⏳ Menunggu konfirmasi blockchain...');
    showReceipt(amount);
  }
}

void main() {
  var btc = Cryptocurrency(
    walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
    coinType: 'Bitcoin',
  );

  var expense = Expense(
    description: 'Pembelian online',
    amount: 250.0,
    category: 'Belanja',
  );

  expense.payWith(btc);
}