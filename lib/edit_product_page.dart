import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController expiryDateController;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    categoryController =
        TextEditingController(text: widget.product['category']);
    descriptionController =
        TextEditingController(text: widget.product['description']);
    quantityController =
        TextEditingController(text: widget.product['quantity'].toString());
    expiryDateController =
        TextEditingController(text: widget.product['expiryDate']);
    if (widget.product['image'] != null) {
      _image = File(widget.product['image']);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Picker
              _image != null
                  ? Image.file(_image!,
                      height: 200, width: 200, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 200),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),

              // Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10),

              // Expiry Date
              TextField(
                controller: expiryDateController,
                decoration: const InputDecoration(labelText: 'Expiry Date'),
              ),
              const SizedBox(height: 10),

              // Category
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),

              // Description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),

              // Quantity
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Collect updated product data
                  final updatedProduct = {
                    'id': widget.product['id'],
                    'name': nameController.text,
                    'expiryDate': expiryDateController.text,
                    'category': categoryController.text,
                    'description': descriptionController.text,
                    'quantity': int.parse(quantityController.text),
                    'image': _image?.path, // Save image path
                  };

                  // Update the product in your database
                  // For example: DBHelper.updateProduct(updatedProduct);

                  Navigator.pop(
                      context, updatedProduct); // Return the updated product
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
