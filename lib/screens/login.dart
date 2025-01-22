import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/db_helper.dart';
import '../screens/user_data_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await _apiService.login(username, password);
      if (response["Status_Code"] == 200) {
        final userData = response["Response_Body"][0];

        // Save the response to SQLite
        await _dbHelper.insertUser({
          "user_code": userData["User_Code"],
          "user_display_name": userData["User_Display_Name"],
          "email": userData["Email"],
          "user_employee_code": userData["User_Employee_Code"],
          "company_code": userData["Company_Code"],
        });

        // Navigate to the UserDataScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDataScreen()),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login Failed.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
