import 'dart:convert';
import 'package:http/http.dart' as http;

class Fixerio {
  Future<Map<String, double>> fetchExchangeRates() async {
    final url =
        'http://data.fixer.io/api/latest?access_key=48f5c6f32ffaabb610b74a5b7d4b0aec';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'goldUsd': (data['rates']['XAU'] ?? 0.0) / 31.1, // Gram başına değer
        'tryUsd': (data['rates']['TRY'] ?? 0.0).toDouble(),
        'eurUsd': (data['rates']['EUR'] ?? 0.0).toDouble(),
        'usd': 1.0, // USD karşılığı kendi kendisi
      };
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  Future<double> calculateAssetValue(String iconPath, double amount) async {
    final exchangeRates = await fetchExchangeRates();

    double rate;

    switch (iconPath) {
      case 'lib/assets/ingots.png': // Altın
        rate = exchangeRates['goldUsd']!;
        break;
      case 'lib/assets/turkish-lira.png': // TL
        rate = exchangeRates['tryUsd']!;
        break;
      case 'lib/assets/euro-currency-symbol.png': // Euro
        rate = exchangeRates['eurUsd']!;
        break;
      case 'lib/assets/dollar-symbol.png': // Dolar
        rate = exchangeRates['usd']!;
        break;
      default:
        throw Exception('Unknown icon');
    }

    return amount * rate;
  }
}
