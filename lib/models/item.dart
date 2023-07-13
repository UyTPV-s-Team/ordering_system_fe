import 'dart:convert';

import 'package:http/http.dart' as http;

class Item {
  final String id;
  final String timestamp;
  final bool isPreparation;
  final bool isReady;
  final bool isDelivered;
  final List<Map<String, dynamic>> products;

  Item({
    required this.id,
    required this.timestamp,
    required this.isPreparation,
    required this.isReady,
    required this.isDelivered,
    required this.products,
  });

  static Future<List<Item>> fetchItemsFromUrl() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/order'));
    final jsonData = json.decode(response.body);

    final List<Item> items = [];
    if (jsonData.containsKey('orders')) {
      final orders = jsonData['orders'];
      for (var order in orders) {
        final id = order['id'];
        final timestamp = order['timestamp'];
        final status = order['status'][0];
        final isPreparation = status['preparation'] == 'true';
        final isReady = status['ready'] == 'true';
        final isDelivered = status['delivered'] == 'true';
        final products = order['products'];

        List<Map<String, dynamic>> parsedProducts = [];
        for (var product in products) {
          final title = product['title'];
          final amount = product['amount'];

          if (product.containsKey('subProducts')) {
            final subProducts = product['subProducts'];
            parsedProducts.add({
              'title': title,
              'amount': amount,
              'subProducts': List<Map<String, dynamic>>.from(subProducts),
            });
          } else {
            parsedProducts.add({
              'title': title,
              'amount': amount,
            });
          }
        }

        items.add(Item(
          id: id.toString(),
          timestamp: timestamp,
          isPreparation: isPreparation,
          isReady: isReady,
          isDelivered: isDelivered,
          products: parsedProducts,
        ));
      }
    }

    return items;
  }
}
