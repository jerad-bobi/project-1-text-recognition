import 'package:flutter/material.dart';
import 'login_page_employee.dart'; // Import the EmployeeLoginPage
import 'login_page_manager.dart'; // Import the ManagerLoginPage

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the content horizontally
            children: [
              Image.asset(
                'assets/logo.png', // Replace with your logo asset
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you a Manager or Employee?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the login page for Manager
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPageManager()),
                  );
                },
                child: const Text('Manager'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Employee login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPageEmployee()),
                  );
                },
                child: const Text('Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
