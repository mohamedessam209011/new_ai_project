// ignore_for_file: prefer_const_constructors, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceMonitoring extends StatefulWidget {
  const AttendanceMonitoring({super.key});

  @override
  State<AttendanceMonitoring> createState() => _AttendanceMonitoringState();
}

class _AttendanceMonitoringState extends State<AttendanceMonitoring> {
  final TextEditingController _materialController = TextEditingController();
  List<Map<String, dynamic>> attendanceList = [];
  bool isLoading = false;

  Future<void> fetchAttendance() async {
    final materialNumber = _materialController.text.trim();

    if (materialNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Material Number"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      attendanceList.clear();
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('attendance_data')
          .where('material_number', isEqualTo: materialNumber)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // ✅ Get student ID
        final studentId = data['student_id'].toString();

        // ✅ Fetch student name
        String studentName = 'Unknown';
        try {
          final studentSnapshot = await FirebaseFirestore.instance
              .collection('student')
              .doc(studentId)
              .get();
          if (studentSnapshot.exists) {
            final studentData = studentSnapshot.data()!;
            final firstName = studentData['First_name'] ?? '';
            final secondName = studentData['secound_Name'] ?? '';
            final thirdName = studentData['Third_Name'] ?? '';
            studentName = '$firstName $secondName $thirdName'.trim();
          }
        } catch (e) {
          print('❌ Error fetching student name: $e');
        }

        // ✅ Format status
        String status = 'Unknown';
        if (data['presence'] != null) {
          final presenceValue =
              data['presence'].toString().toLowerCase().trim();
          if (presenceValue == 'true') {
            status = 'حاضر';
          } else if (presenceValue == 'false') {
            status = 'Absent';
          }
        }

        // ✅ Format date
        String time = 'Unknown';
        if (data['date'] != null) {
          time = data['date'].toString();
        }

        attendanceList.add({
          'student_id': studentId,
          'student_name': studentName,
          'status': status,
          'time': time,
        });
        // ✅ ترتيب البيانات حسب التاريخ (من الأحدث إلى الأقدم)
        attendanceList.sort((a, b) {
          DateTime dateA = DateTime.parse(a['time']);
          DateTime dateB = DateTime.parse(b['time']);
          return dateB.compareTo(dateA); // لتصنيف البيانات من الأحدث إلى الأقدم
        });
      }
    } catch (e) {
      print("❌ Error fetching attendance: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Monitoring'),
        backgroundColor: Color(0xFF33BEF1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _materialController,
              decoration: InputDecoration(
                labelText: 'Material Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF33BEF1),
              ),
              child: Text('Show Attendance'),
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: attendanceList.isEmpty
                        ? Text('No attendance records found.')
                        : ListView.builder(
                            itemCount: attendanceList.length,
                            itemBuilder: (context, index) {
                              final item = attendanceList[index];
                              return Card(
                                child: ListTile(
                                  title: Text(
                                      'ID: ${item['student_id']} | Name: ${item['student_name']}'),
                                  subtitle: Text(
                                    'Status: ${item['status']}\nTime: ${item['time']}',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
