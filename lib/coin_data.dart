import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '1DB0B423-AE11-4A8A-AEDB-F6BD455AE982';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'THB',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String cashCurrency) async {
    Map<String, String> cryptoToCash = {};

    for (String crypto in cryptoList) {
      var url = Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$cashCurrency?apikey=$apiKey');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        cryptoToCash[crypto] = decodedData['rate'].toStringAsFixed(0);
      } else {
        throw (response.statusCode);
      }
    }
    return cryptoToCash;
  }
}
