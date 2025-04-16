// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_ai_project/pages/AttendanceRatePage.dart';
import 'package:new_ai_project/pages/Attendance_Monitoring.dart';
import 'package:new_ai_project/pages/Attendance_follow_up.dart';
import 'package:new_ai_project/pages/Manual_Attendance_Registration.dart';
import 'package:new_ai_project/pages/Table_doctor.dart';
import 'package:new_ai_project/pages/TimeTablePage.dart';
import 'package:new_ai_project/pages/WorksOfYearPage.dart';
import 'package:new_ai_project/pages/year_work.dart';

class HomePage extends StatefulWidget {
  final String userType;
  final String? studentCode;

  const HomePage({super.key, required this.userType, this.studentCode});

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
      fetchStudentName(widget.studentCode!);
    }
  }

  Future<void> fetchStudentName(String code) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('student')
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
          if (widget.userType == 'Student' && fullName.isNotEmpty) ...[
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

          //زراير الطالب
          if (widget.userType == 'Student') ...[
            // زر "Works of Year"
            Positioned(
              top: 350, // المسافة من الأعلى
              left: 210,

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
                  width: 170,
                  height: 50,
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
              top: 540,
              right: 230,
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
                  width: 150,
                  height: 50,
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
              bottom: 50,
              left: 190,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceRatePage(studentId: widget.studentCode ?? '')),
                  );
                },
                child: Container(
                  width: 183,
                  height: 50,
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
            // زر "table"
            Positioned(
              top: 330, // المسافة من الأعلى
              left: 135,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Table_doctor()),
                  );
                },
                child: Container(
                  width: 120,
                  height: 50,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // زر " Attendance Monitoring"
            Positioned(
              top: 520,
              right: 125,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Attendance_Monitoring()),
                  );
                },
                child: Container(
                  width: 130,
                  height: 75,
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
            // زر "  Manual_Attendance_Registration "
            Positioned(
              bottom: 30,
              left: 110,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Manual_Attendance_Registration()),
                  );
                },
                child: Container(
                  width: 200,
                  height: 70,
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
          //زراير ولي الامر
          if (widget.userType == 'Guardian') ...[
            // زر "year_work"
            Positioned(
              top: 420, // المسافة من الأعلى
              left: 135,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => year_work()),
                  );
                },
                child: Container(
                  width: 115,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'year work',
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

            // زر "  Attendance_follow_up "
            Positioned(
              bottom: 80,
              left: 90,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Attendance_follow_up()),
                  );
                },
                child: Container(
                  width: 225,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF05B8FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Attendance follow up',
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
        ],
      ),
    );
  }
}
