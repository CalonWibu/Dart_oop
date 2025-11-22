// LEVEL 1: Expense Dasar
class Expense {
  final String description;
  final double amount;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.date,
  });

  void printDetails() {
    print('📄 $description');
    print('   Tanggal: ${date.day}-${date.month}-${date.year}');
    print('   Total: Rp ${amount.toStringAsFixed(2)}');
  }
}

// LEVEL 2: Kategori Utama
class TransportExpense extends Expense {
  final bool isBusinessTrip;

  TransportExpense({
    required String description,
    required double amount,
    required DateTime date,
    this.isBusinessTrip = false,
  }) : super(description: description, amount: amount, date: date);

  @override
  void printDetails() {
    super.printDetails();
    print('   Kategori: Transportasi 🚗');
    print('   Perjalanan Bisnis: ${isBusinessTrip ? "Ya" : "Tidak"}');
  }
}

class FoodExpense extends Expense {
  final String mealTime; // Pagi, Siang, Malam

  FoodExpense({
    required String description,
    required double amount,
    required DateTime date,
    required this.mealTime,
  }) : super(description: description, amount: amount, date: date);

  @override
  void printDetails() {
    super.printDetails();
    print('   Kategori: Makanan 🍔');
    print('   Waktu Makan: $mealTime');
  }
}

class HealthExpense extends Expense {
  final bool insuranceCovered;

  HealthExpense({
    required String description,
    required double amount,
    required DateTime date,
    required this.insuranceCovered,
  }) : super(description: description, amount: amount, date: date);

  @override
  void printDetails() {
    super.printDetails();
    print('   Kategori: Kesehatan 🏥');
    print('   Cover Asuransi: ${insuranceCovered ? "Ya" : "Tidak"}');
  }
}

// LEVEL 3: Sub-kategori
class PublicTransportExpense extends TransportExpense {
  final String vehicleType;

  PublicTransportExpense({
    required String description,
    required double amount,
    required DateTime date,
    required this.vehicleType,
    bool isBusinessTrip = false,
  }) : super(
          description: description,
          amount: amount,
          date: date,
          isBusinessTrip: isBusinessTrip,
        );

  @override
  void printDetails() {
    super.printDetails();
    print('   Tipe Kendaraan: $vehicleType');
    print('   Sub-kategori: Publik');
  }
}

class PrivateTransportExpense extends TransportExpense {
  final String vehiclePlate;
  final double fuelLiters;

  PrivateTransportExpense({
    required String description,
    required double amount,
    required DateTime date,
    required this.vehiclePlate,
    required this.fuelLiters,
    bool isBusinessTrip = false,
  }) : super(
          description: description,
          amount: amount,
          date: date,
          isBusinessTrip: isBusinessTrip,
        );

  double calculateFuelEfficiency(double distanceKm) {
    return distanceKm / fuelLiters;
  }

  @override
  void printDetails() {
    super.printDetails();
    print('   Plat Nomor: $vehiclePlate');
    print('   Bahan Bakar: $fuelLiters Liter');
    print('   Sub-kategori: Pribadi');
  }
}

class RestaurantExpense extends FoodExpense {
  final String restaurantName;
  final int numberOfPeople;

  RestaurantExpense({
    required String description,
    required double amount,
    required DateTime date,
    required String mealTime,
    required this.restaurantName,
    required this.numberOfPeople,
  }) : super(
          description: description,
          amount: amount,
          date: date,
          mealTime: mealTime,
        );

  double calculatePerPerson() {
    return amount / numberOfPeople;
  }

  @override
  void printDetails() {
    super.printDetails();
    print('   Restoran: $restaurantName');
    print('   Jumlah Orang: $numberOfPeople');
    print('   Biaya per Orang: Rp ${calculatePerPerson().toStringAsFixed(2)}');
  }
}

class GroceryExpense extends FoodExpense {
  final List<String> items;

  GroceryExpense({
    required String description,
    required double amount,
    required DateTime date,
    required String mealTime,
    required this.items,
  }) : super(
          description: description,
          amount: amount,
          date: date,
          mealTime: mealTime,
        );

  int getTotalItems() {
    return items.length;
  }

  @override
  void printDetails() {
    super.printDetails();
    print('   Sub-kategori: Belanja Bahan');
    print('   Item (${getTotalItems()}): ${items.join(", ")}');
  }
}

class ExpenseManager {
  final List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  List<T> getByType<T>() {
    return _expenses.whereType<T>().toList();
  }

  void printAll() {
    print('=== SEMUA PENGELUARAN ===');
    for (var expense in _expenses) {
      expense.printDetails();
      print('-------------------------');
    }
  }
}

void main() {
  var manager = ExpenseManager();

  manager.addExpense(PublicTransportExpense(
    description: 'Busway ke Kantor',
    amount: 3500,
    date: DateTime.now(),
    vehicleType: 'Bus Transjakarta',
    isBusinessTrip: true,
  ));

  manager.addExpense(PrivateTransportExpense(
    description: 'Isi Bensin Pertamax',
    amount: 150000,
    date: DateTime.now(),
    vehiclePlate: 'B 1234 XYZ',
    fuelLiters: 10.5,
  ));

  manager.addExpense(RestaurantExpense(
    description: 'Dinner Ultah',
    amount: 750000,
    date: DateTime.now(),
    mealTime: 'Malam',
    restaurantName: 'Sushi Tei',
    numberOfPeople: 4,
  ));

  manager.addExpense(GroceryExpense(
    description: 'Stok Mingguan',
    amount: 300000,
    date: DateTime.now(),
    mealTime: 'Siang',
    items: ['Telur', 'Susu', 'Roti', 'Sayur'],
  ));

  manager.addExpense(HealthExpense(
    description: 'Cek Gigi',
    amount: 500000,
    date: DateTime.now(),
    insuranceCovered: true,
  ));

  print('🔍 FILTER: HANYA TRANSPORTASI (Level 2 & 3)');
  var transportExpenses = manager.getByType<TransportExpense>();
  for (var e in transportExpenses) {
    print('> ${e.description} (Rp ${e.amount})');
  }

  print('\n🔍 FILTER: HANYA RESTORAN (Level 3)');
  var restaurantExpenses = manager.getByType<RestaurantExpense>();
  for (var e in restaurantExpenses) {
    e.printDetails();
  }
}