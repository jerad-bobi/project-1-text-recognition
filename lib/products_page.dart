import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'product_details_page.dart';
import 'dart:io';
import 'scan_expiry_page.dart'; // Import ScanExpiryPage

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load products from database
  }

  // Load products from database
  Future<void> _loadProducts() async {
    final data = await DBHelper.fetchProducts();
    setState(() {
      products = List.from(data); // Ensure a mutable list
    });
  }

  // Calculate remaining days until expiry
  String getRemainingDays(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now).inDays;

      if (difference < 0) {
        return 'Expired';
      } else if (difference == 0) {
        return 'Expires Today';
      } else {
        return '$difference days left';
      }
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  products = products
                      .where((product) => product['name']
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: product['image'] != null
                        ? Image.file(File(product['image']),
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image),
                    title: Text(product['name']),
                    subtitle: Text(
                      'Expiry Date: ${product['expiryDate']}\n'
                      'Category: ${product['category']}\n'
                      'Quantity: ${product['quantity']}\n'
                      'Remaining: ${getRemainingDays(product['expiryDate'])}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DBHelper.deleteProduct(product['id']);
                        _loadProducts(); // Refresh product list
                      },
                    ),
                    onTap: () async {
                      // Navigate to details page
                      final updatedProduct = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                      if (updatedProduct != null) {
                        _loadProducts(); // Refresh after edit
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to ScanExpiryPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanExpiryPage()),
          );

          if (result != null) {
            await DBHelper.insertProduct(result); // Save product to database
            _loadProducts(); // Reload products dynamically
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
