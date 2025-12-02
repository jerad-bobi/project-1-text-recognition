import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'dart:io';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Load products from database
  Future<void> _loadProducts() async {
    final data = await DBHelper.fetchProducts();
    setState(() {
      products = List.from(data);
      filteredProducts = List.from(data);
    });
  }

  // Filter products based on search query and category
  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        bool matchesSearch = product['name'].toLowerCase().contains(query);
        bool matchesCategory = selectedCategory == 'All' ||
            product['category'] == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
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
              onChanged: (value) => _filterProducts(),
            ),
          ),

          // Category Filter Dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Food', 'Drinks', 'Snacks', 'Others']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  _filterProducts();
                });
              },
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
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
                      'Quantity: ${product['quantity']}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
