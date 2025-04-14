// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class Attendance_Monitoring extends StatelessWidget {
  const Attendance_Monitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/Attendance monitoring.png'), // عدل مسار الصورة حسب مشروعك
                fit: BoxFit.cover,
              ),
            ),
          ),

          // زر الرجوع
          Positioned(
            top: 30, // المسافة من أعلى الشاشة
            left: 10, // المسافة من اليسار
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // الرجوع للشاشة السابقة
              },
            ),
          ),

          // اسم الصفحة
          Positioned(
            top: 90,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                'Attendance Monitoring',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // المحتوى فوق الخلفية
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OneStudentPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF05B8FB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'One Student',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const PageTemplate(
                //           pageTitle: 'Full Band Attendance',
                //         ),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF05B8FB),
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 40, vertical: 16),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20)),
                //   ),
                //   child: const Text(
                //     'Full Band',
                //     style: TextStyle(fontSize: 18, color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// صفحة عامة لعرض اسم الصفحة
class OneStudentPage extends StatelessWidget {
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _studentCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  OneStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Attendance_Rate.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // زر الرجوع
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // الرجوع للشاشة السابقة
              },
            ),
          ),
          // المحتوى
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // عنوان الصفحة
                      const Text(
                        'One Student Attendance',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // TextBox لإدخال اسم المادة
                      TextFormField(
                        controller: _materialController,
                        decoration: InputDecoration(
                          labelText: 'Name of the Material',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the material name';
                          }
                          if (!RegExp(r'^[\u0621-\u064A ]+$').hasMatch(value)) {
                            return 'Please enter a valid material name in Arabic';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // TextBox لإدخال كود الطالب
                      TextFormField(
                        controller: _studentCodeController,
                        decoration: InputDecoration(
                          labelText: 'Student Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the student code';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Please enter a valid numeric student code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // زرار التحقق
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceRateScreen(
                                  materialName: _materialController.text,
                                  studentCode: _studentCodeController.text,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF33BEF1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Check Attendance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceRateScreen extends StatelessWidget {
  final String materialName;
  final String studentCode;

  const AttendanceRateScreen({
    super.key,
    required this.materialName,
    required this.studentCode,
  });

  @override
  Widget build(BuildContext context) {
    // نسبة الحضور (مثال ثابت، يمكنك تعديله ليكون ديناميكيًا بناءً على قاعدة بيانات أو API)
    final double attendanceRate = 85.0; // النسبة المئوية للحضور

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Rate'),
        backgroundColor: const Color(0xFF33BEF1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض كود الطالب
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Student Code: $studentCode',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // عنوان المادة
            Text(
              'Material: $materialName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            // نسبة الحضور
            Center(
              child: Column(
                children: [
                  const Text(
                    'Attendance Rate:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // عرض النسبة بشكل مرئي
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // الدائرة الخارجية
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: attendanceRate / 100,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[300],
                          color: const Color(0xFF33BEF1),
                        ),
                      ),
                      // النسبة المئوية داخل الدائرة
                      Text(
                        '${attendanceRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
