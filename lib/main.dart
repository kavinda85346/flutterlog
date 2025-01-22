import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Common FFI package
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Web-specific FFI package
import 'screens/login.dart';

void main() {
  // Set the database factory for web
  databaseFactory = databaseFactoryFfiWeb; // Ensure using the web FFI factory

  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
