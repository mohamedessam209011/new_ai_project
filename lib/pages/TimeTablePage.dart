// ignore_for_file: file_names

import 'package:flutter/material.dart';

//صفحه اظهار الجدول

class StudentTimeTablePage extends StatelessWidget {
  final String studentCode;

  const StudentTimeTablePage({super.key, required this.studentCode});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> dummyTimeTable = {
      '1234': ['Math - 8AM', 'Science - 10AM', 'History - 12PM'],
    };

    final List<String>? schedule = dummyTimeTable[studentCode];

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Table_student2.png'),
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

          // المحتوى فوق الخلفية
          Center(
            child: schedule == null
                ? const Text(
                    'No schedule found for this student code.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300, // ارتفاع مناسب عشان الجدول يظهر في النص
                        child: ListView.builder(
                          itemCount: schedule.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white.withOpacity(0.85),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              child: ListTile(
                                leading: const Icon(Icons.schedule),
                                title: Text(
                                  schedule[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
