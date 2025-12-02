import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'db_helper_2.dart'; // Database helper import

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Future<List<Map<String, dynamic>>> contacts;

  @override
  void initState() {
    super.initState();
    contacts =
        DBHelper2.instance.queryAll(); // Fetch contacts from the database
  }

  // Add contact function
  void _addContact() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              keyboardType:
                  TextInputType.phone, // Numeric keyboard for phone input
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                Map<String, dynamic> contact = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                };
                await DBHelper2.instance.insert(contact); // Insert contact
                setState(() {
                  contacts =
                      DBHelper2.instance.queryAll(); // Refresh contact list
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete contact function
  void _deleteContact(int id) async {
    await DBHelper2.instance.delete(id); // Delete the contact
    setState(() {
      contacts = DBHelper2.instance.queryAll(); // Refresh the contact list
    });
  }

  // Call contact function with phone number sanitization
  void _callContact(String phoneNumber) async {
    // Sanitize phone number to remove non-numeric characters
    String sanitizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri url = Uri(scheme: 'tel', path: sanitizedPhoneNumber);

    try {
      // Attempt to launch the call app
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Handle error if call app can't be opened
      print('Error launching call app: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open the call app!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: contacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var contact = snapshot.data![index];
              return ListTile(
                title: Text(contact['name']),
                subtitle: Text(contact['phone']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Call button
                    IconButton(
                      icon: const Icon(Icons.call,
                          color: Colors.green), // Call icon
                      onPressed: () {
                        _callContact(contact['phone']); // Call contact
                      },
                    ),
                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red), // Delete icon
                      onPressed: () {
                        _deleteContact(contact['_id']); // Delete contact
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact, // Add contact
        child: const Icon(Icons.add),
      ),
    );
  }
}
