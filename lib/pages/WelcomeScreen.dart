// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:new_ai_project/pages/LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // الصورة الخلفية
          Image.asset(
            'images/page_two_bg.png', // مسار الصورة
            fit: BoxFit.cover, // تغطية الشاشة بالكامل
            width: double.infinity,
            height: double.infinity,
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
          // العناصر فوق الصورة
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40), // مسافة بين النص والأزرار
              ],
            ),
          ),
          // زر Student
          Positioned(
            top: screenHeight * 0.4, // نسبة من ارتفاع الشاشة
            left: screenWidth * 0.5, // نسبة من عرض الشاشة
            child: GestureDetector(
              onTap: () {
                // الانتقال لصفحة تسجيل الطالب
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(userType: 'Student')),
                );
              },
              child: Container(
                width: screenWidth * 0.4, // 50% من عرض الشاشة
                height: screenHeight * 0.06, // 7% من ارتفاع الشاشة
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFF05B8FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Student',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // زر Doctor
          Positioned(
            top: screenHeight * 0.64, // نسبة من ارتفاع الشاشة
            right: screenWidth * 0.53, // نسبة من عرض الشاشة
            child: GestureDetector(
              onTap: () {
                // الانتقال لصفحة تسجيل الدكتور
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(userType: 'Doctor')),
                );
              },
              child: Container(
                width: screenWidth * 0.4, // 50% من عرض الشاشة
                height: screenHeight * 0.06, // 7% من ارتفاع الشاشة
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFF05B8FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Doctor',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // زر Guardian
          Positioned(
            top: screenHeight * 0.89, // نسبة من ارتفاع الشاشة
            left: screenWidth * 0.5, // نسبة من عرض الشاشة
            child: GestureDetector(
              onTap: () {
                // الانتقال لصفحة تسجيل ولي الأمر
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(userType: 'Guardian')),
                );
              },
              child: Container(
                width: screenWidth * 0.4, // 50% من عرض الشاشة
                height: screenHeight * 0.06, // 7% من ارتفاع الشاشة
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFF05B8FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Guardian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
