// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_ai_project/pages/AttendanceRatePage_stu.dart';
import 'package:new_ai_project/pages/Attendance_Monitoring.dart';
import 'package:new_ai_project/pages/Attendance_follow_up_parent.dart';
import 'package:new_ai_project/pages/Manual_Attendance_Registration.dart';
import 'package:new_ai_project/pages/Table_doctor.dart';
import 'package:new_ai_project/pages/TimeTablePage.dart';
import 'package:new_ai_project/pages/WorksOfYearPage.dart';
import 'package:new_ai_project/pages/year_work.dart';

class HomePage extends StatefulWidget {
  final String userType;
  final String? studentCode;
  final String? doctorId;

  const HomePage({
    super.key,
    required this.userType,
    this.studentCode,
    this.doctorId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = '';

  @override
  void initState() {
    super.initState();
    if (widget.userType.toLowerCase() == 'student' &&
        widget.studentCode != null) {
      fetchName('student', widget.studentCode!);
    } else if (widget.userType.toLowerCase() == 'doctor' &&
        widget.doctorId != null) {
      fetchName('doctor', widget.doctorId!);
    } else if (widget.userType.toLowerCase() == 'guardian' &&
        widget.studentCode != null) {
      fetchName('parent', widget.studentCode!);
    }
  }

  Future<void> fetchName(String collection, String code) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(code)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        String fName = data['First_name'] ?? '';
        String sName = data['secound_Name'] ?? '';
        String tName = data['Third_Name'] ?? '';
        setState(() {
          fullName = '$fName $sName $tName';
        });
      }
    } catch (e) {
      print('Error fetching name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // تحديد الخلفية
    String backgroundImage;
    if (widget.userType == 'Student') {
      backgroundImage = 'images/HOME_student.png'; // خلفية الطلاب
    } else if (widget.userType == 'Doctor') {
      backgroundImage = 'images/Home_doctor.png'; // خلفية الأطباء
    } else if (widget.userType == 'Guardian') {
      backgroundImage = 'images/Home_guardian.png'; // خلفية أولياء الأمور
    } else {
      backgroundImage = 'images/default_background.png'; // خلفية افتراضية
    }

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 👇 هنا تحط الاسم
          if (fullName.isNotEmpty) ...[
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                            color: Colors.black45,
                            offset: Offset(1, 1),
                            blurRadius: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          // الأزرار بناءً على نوع المستخدم

          // زراير الطالب
          if (widget.userType == 'Student') ...[
            // زر "Works of Year"
            Positioned(
              top: screenHeight * 0.42, // نسبة من ارتفاع الشاشة
              left: screenWidth * 0.54, // نسبة من عرض الشاشة
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentYearWorkPage(
                              studentCode: widget.studentCode ?? '',
                            )),
                  );
                },
                child: Container(
                  width: screenWidth * 0.4, // نسبة من عرض الشاشة
                  height: screenHeight * 0.06, // نسبة من ارتفاع الشاشة
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Works of Year',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // زر "Time Table"
            Positioned(
              top: screenHeight * 0.64, // نسبة من ارتفاع الشاشة
              left: screenWidth * 0.05, // نسبة من عرض الشاشة
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentTimeTablePage(
                              studentCode: widget.studentCode ?? '',
                            )),
                  );
                },
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Time Table',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // زر "Attendance Rate"
            Positioned(
              bottom: 70,
              left: screenWidth * 0.53,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceRatePage(
                            studentId: widget.studentCode ?? '')),
                  );
                },
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Attendance Rate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // زراير الدكتور
          if (widget.userType == 'Doctor') ...[
            // زر "Table"
            Positioned(
              top: screenHeight * 0.40,
              left: screenWidth * 0.33,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TableDoctor(doctorId: widget.doctorId ?? ''),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Table',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // زر "Attendance Monitoring"
            Positioned(
              top: screenHeight * 0.63,
              left: screenWidth * 0.2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceMonitoring()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.07,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Attendance Monitoring',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // زر "Manual Attendance Registration"
            Positioned(
              bottom: 50,
              left: screenWidth * 0.15,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Manual_Attendance_Registration()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Manual Attendance Registration',
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
            ),
          ],
          // زرائر ولي الأمر
          if (widget.userType == 'Guardian') ...[
            // زر "Year Work"
            Positioned(
              top: screenHeight * 0.52, // نسبة من ارتفاع الشاشة
              left: screenWidth * 0.33, // نسبة من عرض الشاشة
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            year_work(parentId: widget.studentCode ?? '')),
                  );
                },
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Year Work',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // زر "Attendance Follow Up"
            Positioned(
              bottom: screenHeight * 0.1, // 10% من ارتفاع الشاشة
              left: screenWidth * 0.2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Attendance_follow_up(
                          parentId: widget.studentCode ?? ''),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.06,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Attendance Follow Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
