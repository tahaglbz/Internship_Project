import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinMarketCapService {
  final String apiKey = 'e75f4491-9466-4dfc-b173-a3f5bb0dcbd1';

  Future<Map<String, dynamic>> fetchCoinData(String symbol) async {
    final url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$symbol';
    final response = await http.get(Uri.parse(url), headers: {
      'X-CMC_PRO_API_KEY': apiKey,
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load coin data');
    }
  }
}
