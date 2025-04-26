// ignore_for_file: prefer_const_constructors, file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentTimeTablePage extends StatefulWidget {
  final String studentCode;

  const StudentTimeTablePage({super.key, required this.studentCode});

  @override
  State<StudentTimeTablePage> createState() => _StudentTimeTablePageState();
}

class _StudentTimeTablePageState extends State<StudentTimeTablePage> {
  List<Map<String, dynamic>> scheduleList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudentBandCodeAndSchedule();
  }

  Future<void> fetchStudentBandCodeAndSchedule() async {
    try {
      final studentDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentCode)
          .get();

      if (studentDoc.exists) {
        final data = studentDoc.data()!;

        if (!data.containsKey('Band_Code')) {
          setState(() {
            errorMessage = 'لا يوجد Band_Code مرتبط بحسابك';
            isLoading = false;
          });
          return;
        }

        final bandCode = data['Band_Code'] is int
            ? data['Band_Code']
            : int.tryParse(data['Band_Code'].toString()) ?? 0;

        final querySnapshot = await FirebaseFirestore.instance
            .collection('studyschedule')
            .where('Band_Code', isEqualTo: bandCode)
            .get();

        final List<Map<String, dynamic>> enrichedSchedule = [];

        for (var doc in querySnapshot.docs) {
          final item = doc.data();

          // Get doctor name
          String doctorName = '';
          final doctorDoc = await FirebaseFirestore.instance
              .collection('doctor')
              .doc(item['doctor_id'].toString())
              .get();
          if (doctorDoc.exists) {
            final doctorData = doctorDoc.data()!;
            doctorName =
                '${doctorData['first_name'] ?? ''} ${doctorData['third_Name'] ?? ''} ${doctorData['LAST_name'] ?? ''}';
          }

          // Get subject name from academic_subject
          String subjectName = '';
          final subjectDoc = await FirebaseFirestore.instance
              .collection('academic_subject')
              .doc(item['Subject_number'].toString())
              .get();
          if (subjectDoc.exists) {
            subjectName = subjectDoc.data()!['Material_name'] ?? '';
          }

          // Get place site
          String placeName = '';
          final placeDoc = await FirebaseFirestore.instance
              .collection('place')
              .doc(item['Place'].toString())
              .get();
          if (placeDoc.exists) {
            placeName = placeDoc.data()!['site'] ?? '';
          }

          enrichedSchedule.add({
            ...item,
            'doctor_name': doctorName,
            'subject_name': subjectName,
            'place_name': placeName,
          });
        }

        setState(() {
          scheduleList = enrichedSchedule;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'الطالب غير موجود في قاعدة البيانات';
          isLoading = false;
        });
      }
    } catch (e) {
      print('💥 Error: \$e');
      setState(() {
        errorMessage = 'حدث خطأ أثناء تحميل البيانات';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Table'),
        backgroundColor: Color(0xFF05B8FB),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : scheduleList.isEmpty
                  ? Center(child: Text('لا توجد بيانات جدول'))
                  : ListView.builder(
                      itemCount: scheduleList.length,
                      itemBuilder: (context, index) {
                        final item = scheduleList[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                                '${item['Day']} | ${item['start_time']} - ${item['end_time']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Subject: ${item['subject_name']}'),
                                Text('Doctor: ${item['doctor_name']}'),
                                Text('Place: ${item['place_name']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
