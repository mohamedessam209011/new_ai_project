// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class Manual_Attendance_Registration extends StatelessWidget {
  const Manual_Attendance_Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Works of Year'),
        backgroundColor: Color(0xFF05B8FB),
      ),
      body: Center(
        child: Text(
          'Welcome to Works of Year Page!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
