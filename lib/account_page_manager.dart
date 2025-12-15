import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPageManager extends StatefulWidget {
  const AccountPageManager({Key? key}) : super(key: key);

  @override
  State<AccountPageManager> createState() => _ManagerAccountPageState();
}

class _ManagerAccountPageState extends State<AccountPageManager> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false; // To toggle password visibility

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from SharedPreferences using correct keys
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usernameController.text =
        prefs.getString('manager_username') ?? "admin"; // Load manager username
    passwordController.text = prefs.getString('manager_password') ??
        "password123"; // Load manager password
  }

  // Save updated credentials using correct keys
  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'manager_username', usernameController.text); // Save manager username
    await prefs.setString(
        'manager_password', passwordController.text); // Save manager password

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Credentials updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off), // Eye icon
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible; // Toggle state
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
