import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class UserDataScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _getUserData() async {
    final db = await _dbHelper.database;
    return db.query('user_data'); // Query all data from the user_data table
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved User Data'),
        backgroundColor: Color(0xFF9932CC),
      ),
      backgroundColor:
          Color(0xFFD3D3D3), // Set the background color to light grey
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(user['user_display_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Code: ${user['user_code']}'),
                        Text('Email: ${user['email']}'),
                        Text(
                            'User Employee Code: ${user['user_employee_code']}'),
                        Text('Company Code: ${user['company_code']}'),
                        Text('User Locations: ${user['user_locations']}'),
                        Text('User Permissions: ${user['user_permissions']}')
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No saved user data found.'));
          }
        },
      ),
    );
  }
}
