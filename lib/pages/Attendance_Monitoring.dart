import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
        const SnackBar(
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

      // تصفية السجلات لاستبعاد الـ IDs العشوائية (تحتوي على أحرف)
      final filteredDocs = snapshot.docs
          .where((doc) => RegExp(r'^[0-9]+$')
                  .hasMatch(doc.id) // يأخذ فقط الـ IDs الرقمية
              )
          .toList();

      if (filteredDocs.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // استرجاع جميع الـ student_ids مرة واحدة
      final studentIds =
          filteredDocs.map((doc) => doc['student_id'].toString()).toList();

      // جلب بيانات الطلاب باستخدام whereIn
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where(FieldPath.documentId, whereIn: studentIds)
          .get();

      final studentMap = {
        for (var doc in studentsSnapshot.docs) doc.id: doc.data()
      };

      for (var doc in filteredDocs) {
        final data = doc.data();

        String status = 'Unknown';
        if (data['presence'] != null) {
          final presenceValue =
              data['presence'].toString().toLowerCase().trim();
          if (presenceValue == 'true' || presenceValue == 'حاضر') {
            status = 'حاضر';
          } else if (presenceValue == 'false' || presenceValue == 'غائب') {
            status = 'غائب';
          }
        }

        String time = 'Unknown';
        if (data['date'] != null) {
          final dateString = data['date'].toString();
          try {
            final parsedDate = DateTime.parse(dateString);
            time = DateFormat('yyyy-MM-dd – HH:mm').format(parsedDate);
          } catch (e) {
            time = dateString;
          }
        }

        final studentData = studentMap[data['student_id'].toString()];
        String studentName = 'Unknown';
        if (studentData != null) {
          studentName = '${studentData['First_name']} '
                  '${studentData['secound_Name']} '
                  '${studentData['Third_Name']}'
              .trim();
        }

        attendanceList.add({
          'doc_id': doc.id, // إضافة ID المستند للفحص
          'student_id': data['student_id'].toString(),
          'student_name': studentName,
          'status': status,
          'time': time,
        });
      }

      attendanceList.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['time']);
          final dateB = DateTime.parse(b['time']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
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
        title: const Text('Attendance Monitoring'),
        backgroundColor: const Color(0xFF33BEF1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _materialController,
              decoration: const InputDecoration(
                labelText: 'Material Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33BEF1),
              ),
              child: const Text('Show Attendance'),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: attendanceList.isEmpty
                        ? const Center(
                            child: Text('No attendance records found.'))
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: attendanceList.length,
                            itemBuilder: (context, index) {
                              final item = attendanceList[index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  leading: Icon(
                                    item['status'] == 'حاضر'
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: item['status'] == 'حاضر'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    'ID: ${item['student_id']} | Name: ${item['student_name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status: ${item['status']}',
                                        style: TextStyle(
                                          color: item['status'] == 'حاضر'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      Text('Time: ${item['time']}'),
                                      Text('DocID: ${item['doc_id']}',
                                          style: TextStyle(fontSize: 10)),
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
    );
  }
}
