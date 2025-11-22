abstract class PaymentMethod {
  String get name;
  String get icon;

  void processPayment(double amount);

  void showReceipt(double amount) {
    print('-----------------------------------');
    print('$icon STRUK PEMBAYARAN');
    print('Metode: $name');
    print('Total: \$${amount.toStringAsFixed(2)}');
    print('Status: Sukses');
    print('-----------------------------------');
  }
}

abstract class Refundable {
  bool canRefund();
  void processRefund(double amount);
}

class CreditCard extends PaymentMethod implements Refundable {
  final String cardNumber;
  final String cardHolder;
  final List<double> transactions = [];

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
  });

  @override
  String get name => 'Kartu Kredit';

  @override
  String get icon => '💳';

  @override
  void processPayment(double amount) {
    transactions.add(amount);
    print('$icon Mendebet \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }

  @override
  bool canRefund() {
    return transactions.isNotEmpty;
  }

  @override
  void processRefund(double amount) {
    if (!canRefund()) {
      print('❌ Tidak ada transaksi untuk direfund');
      return;
    }

    print('🔄 Memproses refund \$${amount.toStringAsFixed(2)}');
    print('   Refund akan muncul dalam 3-5 hari kerja');
    transactions.add(-amount);
  }
}

class Cash extends PaymentMethod {
  @override
  String get name => 'Tunai';

  @override
  String get icon => '💵';

  @override
  void processPayment(double amount) {
    print('$icon Pembayaran tunai: \$${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}

void main() {
  var card = CreditCard(
    cardNumber: '4532123456789012',
    cardHolder: 'John Doe',
  );
  var cash = Cash();

  card.processPayment(100.0);

  if (card is Refundable) {
    card.processRefund(50.0);
  }

  print('');

  cash.processPayment(50.0);

  if (cash is Refundable) {
    (cash as Refundable).processRefund(25.0);
  } else {
    print('❌ Pembayaran tunai tidak dapat direfund');
  }
}