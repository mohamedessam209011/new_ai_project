// ignore_for_file: prefer_const_constructors, sort_child_properties_last, camel_case_types, avoid_unnecessary_containers, file_names, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manual_Attendance_Registration extends StatefulWidget {
  const Manual_Attendance_Registration({super.key});

  @override
  State<Manual_Attendance_Registration> createState() =>
      _Manual_Attendance_RegistrationState();
}

class _Manual_Attendance_RegistrationState
    extends State<Manual_Attendance_Registration> {
  final TextEditingController studentCodeController = TextEditingController();
  final TextEditingController materialCodeController = TextEditingController();

  Color buttonColor = Colors.blue;

  void addManualAttendance() async {
    String studentCode = studentCodeController.text.trim();
    String materialCode = materialCodeController.text.trim();

    print('📥 الطالب: $studentCode / المادة: $materialCode');

    if (studentCode.isEmpty || materialCode.isEmpty) {
      setState(() {
        buttonColor = Colors.red;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('من فضلك اكتب كود الطالب وكود المادة')),
      );

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          buttonColor = Colors.blue;
        });
      });
      return;
    }

    final studentDoc = await FirebaseFirestore.instance
        .collection('student')
        .doc(studentCode)
        .get();

    if (!studentDoc.exists) {
      setState(() {
        buttonColor = Colors.red;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الطالب غير موجود في النظام')),
      );

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          buttonColor = Colors.blue;
        });
      });
      return;
    }

    try {
      final materialDoc = await FirebaseFirestore.instance
          .collection('academic_subject')
          .doc(materialCode)
          .get();

      if (!materialDoc.exists) {
        setState(() {
          buttonColor = Colors.red;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('المادة غير موجودة في النظام')),
        );

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            buttonColor = Colors.blue;
          });
        });
        return;
      }

      DateTime now = DateTime.now();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendance_data')
          .where('student_id', isEqualTo: int.parse(studentCode))
          .where('material_number', isEqualTo: materialCode.trim())
          .get();

      print('🧪 جاري التحقق من التكرار...');
      for (var doc in querySnapshot.docs) {
        final String dateStr = doc['date'] ?? '';
        print('📄 $materialCode - $dateStr');
      }

      bool alreadyMarked = querySnapshot.docs.any((doc) {
        final String dateStr = doc['date'] ?? '';
        if (dateStr.isEmpty) return false;
        final dateParts = dateStr.split('-');
        if (dateParts.length != 3) return false;

        final int year = int.parse(dateParts[0]);
        final int month = int.parse(dateParts[1]);
        final int day = int.parse(dateParts[2]);

        DateTime date = DateTime(year, month, day);
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      });

      if (alreadyMarked) {
        print('❌ تم اكتشاف حضور مكرر لنفس المادة اليوم');

        setState(() {
          buttonColor = Colors.red;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الطالب حضر بالفعل هذه المادة اليوم')),
        );

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            buttonColor = Colors.blue;
          });
        });
        return;
      }

      await FirebaseFirestore.instance.collection('attendance_data').add({
        'student_id': int.parse(studentCode),
        'material_number': materialCode.trim(),
        'presence': "true",
        'absence': null,
        'another': null,
        'date':
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      });

      print('✅ تم تسجيل الحضور الجديد');

      setState(() {
        buttonColor = Colors.green;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تسجيل الحضور بنجاح')),
      );

      studentCodeController.clear();
      materialCodeController.clear();

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          buttonColor = Colors.blue;
        });
      });
    } catch (e) {
      print('❌ حصل استثناء: $e');

      setState(() {
        buttonColor = Colors.red;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حصل خطأ أثناء تسجيل الحضور')),
      );

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          buttonColor = Colors.blue;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Manual_Attendance.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: studentCodeController,
                        decoration: InputDecoration(labelText: 'Student code'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: materialCodeController,
                        decoration: InputDecoration(labelText: 'Material code'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: addManualAttendance,
                        child: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
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
