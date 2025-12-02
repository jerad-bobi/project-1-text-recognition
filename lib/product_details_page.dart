import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'dart:io';
import 'edit_product_page.dart'; // Import the new edit page

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the entire Column widget
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center vertically within the screen
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Product Image
              product['image'] != null
                  ? Image.file(
                      File(product['image']),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image, size: 200),
              const SizedBox(height: 20),

              // Product Name
              Text(
                'Product Name: ${product['name']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 10),

              // Expiry Date
              Text(
                'Expiry Date: ${product['expiryDate']}',
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 10),

              // Category
              Text(
                'Category: ${product['category']}',
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 10),

              // Description
              Text(
                'Description: ${product['description']}',
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 10),

              // Quantity
              Text(
                'Quantity: ${product['quantity']}',
                textAlign: TextAlign.center, // Center the text
              ),

              // Edit Button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(product: product),
                    ),
                  );
                  if (updatedProduct != null) {
                    // Update product in the database
                    await DBHelper.updateProduct(updatedProduct);

                    // Navigate back to the ProductsPage
                    Navigator.pop(context, updatedProduct);
                  }
                },
                child: const Text('Edit Product Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
