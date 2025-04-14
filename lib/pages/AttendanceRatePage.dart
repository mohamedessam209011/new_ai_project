// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math';

class AttendanceRatePage extends StatefulWidget {
  @override
  State<AttendanceRatePage> createState() => _AttendanceRatePageState();
}

class _AttendanceRatePageState extends State<AttendanceRatePage> {
  final TextEditingController answerController = TextEditingController();
  int num1 = 0;
  int num2 = 0;
  String? errorText;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();
    setState(() {
      num1 = random.nextInt(10) + 1; // من 1 لـ 10
      num2 = random.nextInt(10) + 1;
      answerController.clear();
      errorText = null;
    });
  }

  void _checkAnswer() {
    final String userAnswer = answerController.text.trim();
    final int? parsedAnswer = int.tryParse(userAnswer);

    if (parsedAnswer == (num1 + num2)) {
      // صح
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessPage(onReturn: generateNewQuestion)),
      );
    } else {
      // غلط
      setState(() {
        errorText = 'Wrong answer, please try again!';
      });
    }
  }

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
            top: 30, // المسافة من أعلى الشاشة
            left: 10, // المسافة من اليسار
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // الرجوع للشاشة السابقة
              },
            ),
          ),

          // المحتوى
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Solve this: $num1 + $num2 = ?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: answerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorText: errorText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _checkAnswer,
                    child: Container(
                      width: 143,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF05B8FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//صفحه نسبه حضور و غياب الطالب
class SuccessPage extends StatelessWidget {
  final VoidCallback onReturn;

  const SuccessPage({super.key, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> attendanceData = [
      {
        'subject': 'Math',
        'present': 10,
        'absent': 2,
      },
      {
        'subject': 'Science',
        'present': 15,
        'absent': 0,
      },
      {
        'subject': 'History',
        'present': 8,
        'absent': 1,
      },
    ];

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
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () {
                onReturn();
                Navigator.pop(context);
              },
            ),
          ),

          // المحتوى
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: attendanceData.length,
                    itemBuilder: (context, index) {
                      final item = attendanceData[index];
                      final total = item['present'] + item['absent'];
                      final rate = total == 0
                          ? 0.0
                          : (item['present'] / total * 100).toStringAsFixed(1);
                      final presentRatio =
                          total == 0 ? 0.0 : item['present'] / total;
                      final absentRatio =
                          total == 0 ? 0.0 : item['absent'] / total;

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.check_circle,
                                    color: Colors.green),
                                title: Text(item['subject']),
                                trailing: Text(
                                  '$rate %',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Text('تفاصيل ${item['subject']}'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              '✅ الحضور: ${item['present']} مرات'),
                                          Text(
                                              '❌ الغياب: ${item['absent']} مرات'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('إغلاق'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: (presentRatio * 100).round(),
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: (absentRatio * 100).round(),
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
