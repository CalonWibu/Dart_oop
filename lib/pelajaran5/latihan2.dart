class Expense {
  final String description;
  final double _amount;
  final String category;

  Expense({
    required this.description,
    required double amount,
    required this.category,
  }) : _amount = amount;

  double getAmountRounded() {
    return _amount.roundToDouble();
  }

double getDailyAverage(int days) {
  if (days <= 0) return 0;
  return _amount / days;
}

double projectedYearly() {
  return _amount * 12;
}

String getFormattedAmount() {
  return 'Rp${_amount.toStringAsFixed(2)}';
}
}

void main() {
  var subscription = Expense(
    description: 'Netflix',
    amount: 15.99,
    category: 'Hiburan',
  );

  print('Jumlah: ${subscription.getFormattedAmount()}');
  print('Dibulatkan: Rp${subscription.getAmountRounded().toStringAsFixed(2)}');
  print('Rata-rata harian (30 hari): Rp${subscription.getDailyAverage(30).toStringAsFixed(2)}');
  print('Proyeksi tahunan: Rp${subscription.projectedYearly().toStringAsFixed(2)}');
}