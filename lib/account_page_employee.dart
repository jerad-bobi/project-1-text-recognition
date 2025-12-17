import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPageEmployee extends StatefulWidget {
  const AccountPageEmployee({Key? key}) : super(key: key);

  @override
  State<AccountPageEmployee> createState() => _EmployeeAccountPageState();
}

class _EmployeeAccountPageState extends State<AccountPageEmployee> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false; // To toggle password visibility

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from SharedPreferences
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usernameController.text =
        prefs.getString('employee_username') ?? "employee";
    passwordController.text =
        prefs.getString('employee_password') ?? "employee123";
  }

  // Save updated credentials
  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('employee_username', usernameController.text);
    await prefs.setString('employee_password', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Employee credentials updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Account Settings'),
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
