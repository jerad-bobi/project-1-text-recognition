import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'add_product_page.dart';

class ScanExpiryPage extends StatefulWidget {
  const ScanExpiryPage({Key? key}) : super(key: key);

  @override
  State<ScanExpiryPage> createState() => _ScanExpiryPageState();
}

class _ScanExpiryPageState extends State<ScanExpiryPage> {
  File? _image;
  String? _scannedText;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _scanText();
    }
  }

  Future<void> _scanText() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      String? extractedText;

      // Look for numbers (could be expiry dates or other values)
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          final numberRegex =
              RegExp(r'\b\d+\b'); // Regex for any number sequence
          final match = numberRegex.firstMatch(line.text);
          if (match != null) {
            extractedText = match.group(0); // Get the first detected number
            break;
          }
        }
        if (extractedText != null) break;
      }

      setState(() {
        _scannedText = extractedText ?? 'No numbers detected';
      });
    } catch (e) {
      setState(() {
        _scannedText = 'Error: Failed to recognize text';
      });
    }

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Expiry Date')),
      body: Center(
        // Wrap the Column with Center
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Ensure horizontal centering
          children: [
            if (_image != null) Image.file(_image!),
            const SizedBox(height: 20),
            Text(
              _scannedText ?? 'No text scanned',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureImage,
              child: const Text('Open Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddProductPage(expiryDate: _scannedText ?? ''),
                  ),
                );

                Navigator.pop(context, result); // Pass product back
              },
              child: const Text('Proceed to Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
