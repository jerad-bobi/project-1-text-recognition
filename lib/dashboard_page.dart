import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'db_helper.dart';
import 'db_helper_2.dart'; // Your DBHelper import

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalProducts = 0;
  int expiringProducts = 0;
  int totalContacts = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch the total number of products
    List<Map<String, dynamic>> products = await DBHelper.fetchProducts();
    setState(() {
      totalProducts = products.length;
    });

    // Fetch the number of products expiring under 1 month
    DateTime now = DateTime.now();
    DateTime oneMonthFromNow = now.add(Duration(days: 30));
    int countExpiring = 0;

    for (var product in products) {
      if (product['expiryDate'] != null) {
        try {
          DateTime expiryDate = DateTime.parse(product['expiryDate']);
          if (expiryDate.isBefore(oneMonthFromNow)) {
            countExpiring++;
          }
        } catch (e) {
          print('Error parsing expiry date for product ${product['name']}: $e');
        }
      }
    }

    setState(() {
      expiringProducts = countExpiring;
    });

    // Fetch the total number of contacts
    List<Map<String, dynamic>> contacts = await DBHelper2.instance.queryAll();
    setState(() {
      totalContacts = contacts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        // To prevent overflow at the bottom
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Total Products Line Chart
              const Text('Total Products'),
              _buildLineChart(totalProducts, 'Total Products'),
              const SizedBox(height: 20),
              // Expiring Products Line Chart
              const Text('Expiring Products (Under 1 Month)'),
              _buildLineChart(expiringProducts, 'Expiring Products'),
              const SizedBox(height: 20),
              // Total Contacts Line Chart
              const Text('Total Contacts'),
              _buildLineChart(totalContacts, 'Total Contacts'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // A method to build the line chart for each data category
  Widget _buildLineChart(int data, String label) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, data.toDouble()), // Only one point for now
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData:
                  BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
