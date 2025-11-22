import 'dart:io';

class InputHelper {
  static String readString(String prompt) {
    stdout.write('$prompt: ');
    return stdin.readLineSync() ?? '';
  }

  static int readInt(String prompt, {int? min, int? max}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync();

      if (input == null || input.isEmpty) {
        print('❌ Mohon masukkan angka');
        continue;
      }

      final number = int.tryParse(input);

      if (number == null) {
        print('❌ Angka tidak valid');
        continue;
      }

      if (min != null && number < min) {
        print('❌ Angka minimal $min');
        continue;
      }

      if (max != null && number > max) {
        print('❌ Angka maksimal $max');
        continue;
      }

      return number;
    }
  }

  static double readDouble(String prompt, {double? min}) {
    while (true) {
      stdout.write('$prompt: ');
      final input = stdin.readLineSync();

      if (input == null || input.isEmpty) {
        print('❌ Mohon masukkan angka');
        continue;
      }

      final number = double.tryParse(input);

      if (number == null) {
        print('❌ Angka tidak valid');
        continue;
      }

      if (min != null && number < min) {
        print('❌ Angka minimal $min');
        continue;
      }

      return number;
    }
  }

  static bool readYesNo(String prompt) {
    while (true) {
      stdout.write('$prompt (y/t): ');
      final input = stdin.readLineSync()?.toLowerCase();

      if (input == 'y' || input == 'ya') return true;
      if (input == 't' || input == 'tidak') return false;

      print('❌ Mohon masukkan y atau t');
    }
  }

  static String readChoice(String prompt, List<String> options) {
    print('$prompt:');
    for (int i = 0; i < options.length; i++) {
      print('  ${i + 1}. ${options[i]}');
    }

    final choice = readInt('Pilih (1-${options.length})',
                         min: 1, max: options.length);
    return options[choice - 1];
  }

  static void pause() {
    print('\\nTekan Enter untuk melanjutkan...');
    stdin.readLineSync();
  }
}
