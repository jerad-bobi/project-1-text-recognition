import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> expiringProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchExpiringProducts();
  }

  // Fetch products expiring within the next 30 days
  Future<void> _fetchExpiringProducts() async {
    final currentDate = DateTime.now();
    final nextMonth = currentDate.add(Duration(days: 30));

    // Format the dates to match the database format (e.g., YYYY-MM-DD or DDMMYYYY)
    final currentDateString = DateFormat('yyyy-MM-dd').format(currentDate);
    final nextMonthString = DateFormat('yyyy-MM-dd').format(nextMonth);

    print('Current Date: $currentDateString');
    print('Next Month: $nextMonthString');

    // Fetch products from the database
    final products = await DBHelper.fetchProducts();

    // Filter products that expire within the next 30 days
    final expiringProductsList = products.where((product) {
      final expiryDate = product['expiryDate'] as String;

      // Debugging expiry date comparison
      print('Checking Product: ${product['name']} Expiry Date: $expiryDate');

      return expiryDate.compareTo(nextMonthString) <= 0 &&
          expiryDate.compareTo(currentDateString) >= 0;
    }).toList();

    print('Expiring Products: $expiringProductsList');

    setState(() {
      expiringProducts = expiringProductsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expiring Products Notifications'),
      ),
      body: expiringProducts.isEmpty
          ? Center(
              child: Text('No products are expiring within the next month.'))
          : ListView.builder(
              itemCount: expiringProducts.length,
              itemBuilder: (context, index) {
                final product = expiringProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Expiry Date: ${product['expiryDate']}'),
                  trailing: Icon(Icons.warning, color: Colors.red),
                );
              },
            ),
    );
  }
}
