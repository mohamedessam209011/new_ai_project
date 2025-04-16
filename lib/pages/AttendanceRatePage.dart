// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AttendanceRatePage extends StatefulWidget {
  final String studentId;
  const AttendanceRatePage({required this.studentId});

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
      num1 = random.nextInt(10) + 1;
      num2 = random.nextInt(10) + 1;
      answerController.clear();
      errorText = null;
    });
  }

  void _checkAnswer() {
    final String userAnswer = answerController.text.trim();
    final int? parsedAnswer = int.tryParse(userAnswer);

    if (parsedAnswer == (num1 + num2)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            onReturn: generateNewQuestion,
            studentId: widget.studentId,
          ),
        ),
      );
    } else {
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Attendance_Rate.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
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

class SuccessPage extends StatefulWidget {
  final VoidCallback onReturn;
  final String studentId;

  const SuccessPage({required this.onReturn, required this.studentId});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  Map<String, Map<String, int>> attendanceData = {};

  String normalizePresence(String value) {
    final cleaned = value
        .replaceAll('ـ', '')
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(String.fromCharCode(8203), '') // zero width space
        .trim()
        .toLowerCase();

    print('RAW: "$value", CLEANED: "$cleaned"');

    if (cleaned == 'present') {
      return 'present';
    } else if (cleaned == 'absent') {
      return 'absent';
    } else {
      return cleaned;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('attendance_data')
        .doc(widget.studentId)
        .collection('records')
        .get();

    final Map<String, Map<String, int>> subjectMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final rawSubject = data['Material_number'] ?? 'Unknown';
      final rawStatus = data['Presence'] ?? 'absent';

      final subject = rawSubject.toString().trim();
      final status = rawStatus.toString().trim();
      final normalizedStatus = normalizePresence(status);

      print(
          'subject: "$subject", status: "$status", normalized: "$normalizedStatus"');

      subjectMap.putIfAbsent(subject, () => {'present': 0, 'absent': 0});

      if (normalizedStatus == 'present') {
        subjectMap[subject]!['present'] = subjectMap[subject]!['present']! + 1;
      } else {
        subjectMap[subject]!['absent'] = subjectMap[subject]!['absent']! + 1;
      }

      print('Updated Map: ${subjectMap[subject]}');
    }

    print('subjectMap debug: $subjectMap');

    setState(() {
      attendanceData = subjectMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Attendance_Rate.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () {
                widget.onReturn();
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(height: 120),
                Expanded(
                  child: ListView(
                    children: attendanceData.entries.map((entry) {
                      final subject = entry.key;
                      final present = entry.value['present'] ?? 0;
                      final absent = entry.value['absent'] ?? 0;
                      final total = present + absent;
                      final rate = total == 0
                          ? '0.0'
                          : (present / total * 100).toStringAsFixed(1);
                      final presentRatio = total == 0 ? 0.0 : present / total;
                      final absentRatio = total == 0 ? 0.0 : absent / total;

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
                                title: Text('Subject $subject'),
                                trailing: Text('$rate %',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
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
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
