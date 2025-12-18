import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  final String? expiryDate; // This can be null if not detected

  const AddProductPage({Key? key, this.expiryDate}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  File? _image;
  String? selectedCategory = 'Food'; // Default selected category

  @override
  void initState() {
    super.initState();
    if (widget.expiryDate != null) {
      // Pre-fill expiry date if it was detected
      expiryDateController.text = widget.expiryDate!;
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
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Picker
            _image != null
                ? Image.file(_image!,
                    height: 150, width: 150, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 150),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 10),

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

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              // NEW FEATURE: Added TextField for supplier contact information //
              items: ['Food', 'Drinks', 'Snacks', 'Others']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
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
                Navigator.pop(context, {
                  'name': nameController.text,
                  'expiryDate': expiryDateController.text,
                  'category': selectedCategory,
                  'description': descriptionController.text,
                  'quantity': quantityController.text,
                  'image': _image?.path, // Save image path
                });
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
