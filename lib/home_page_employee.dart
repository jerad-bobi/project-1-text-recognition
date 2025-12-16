import 'package:flutter/material.dart';
import 'account_page_manager.dart';
import 'calendar_page.dart';
import 'notification_page.dart';
import 'products_page.dart';
import 'search_page.dart';
import 'welcome_page.dart';
import 'dart:math';
import 'db_helper.dart'; // Import your DBHelper class

class HomePageEmployee extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomePageEmployee({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomePageEmployeeState createState() => _HomePageEmployeeState();
}

class _HomePageEmployeeState extends State<HomePageEmployee> {
  final List<String> quotes = [
    "The best way to predict the future is to create it.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "It always seems impossible until it's done.",
    "You miss 100% of the shots you don't take.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "Do not wait to strike till the iron is hot, but make it hot by striking.",
    "Success usually comes to those who are too busy to be looking for it."
  ];

  List<Map<String, dynamic>> recentReminders = [];
  Map<String, dynamic>? recentProduct;

  @override
  void initState() {
    super.initState();
    fetchRecentReminders();
    fetchRecentProduct();
  }

  Future<void> fetchRecentReminders() async {
    final reminders = await DBHelper.fetchReminders();
    setState(() {
      recentReminders = reminders.reversed.take(2).toList();
    });
  }

  Future<void> fetchRecentProduct() async {
    final products = await DBHelper.fetchProducts();
    setState(() {
      if (products.isNotEmpty) {
        recentProduct = products.last;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String randomQuote = quotes[Random().nextInt(quotes.length)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildDrawerItem(Icons.home, 'Home', () {}),
            _buildDrawerItem(Icons.search, 'Search', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            }),
            _buildDrawerItem(Icons.shopping_bag, 'Products', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductsPage()),
              );
            }),
            _buildDrawerItem(Icons.calendar_today, 'Calendar', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            }),
            _buildDrawerItem(Icons.notifications, 'Notification', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            }),
            _buildDrawerItem(Icons.account_circle, 'Account', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountPageManager()),
              );
            }),
            _buildDrawerItem(Icons.book, 'Tutorial', () {}),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Dark Theme'),
              onTap: widget.toggleTheme,
            ),
            const Divider(),
            // Log Out Button
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Random Quote
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue[100],
              child: Text(
                randomQuote,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
            // Recently Added Tasks Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'RECENTLY ADDED TASKS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Recently Added Tasks Section
            recentReminders.isEmpty
                ? const Center(child: Text('No recent reminders available.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = recentReminders[index];
                      return _buildRecentItem(
                        title: reminder['title'] ?? 'No Title',
                        subtitle:
                            'Date: ${reminder['date'] ?? 'N/A'}\nTime: ${reminder['time'] ?? 'N/A'}',
                      );
                    },
                  ),
            // Recently Added Products Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'RECENTLY ADDED PRODUCTS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Recently Added Products Section
            recentProduct == null
                ? const Center(child: Text('No recent products available.'))
                : _buildRecentItem(
                    title: recentProduct!['name'] ?? 'No Name',
                    subtitle:
                        'Category: ${recentProduct!['category'] ?? 'N/A'}\nExpiry: ${recentProduct!['expiryDate'] ?? 'N/A'}',
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildRecentItem({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
