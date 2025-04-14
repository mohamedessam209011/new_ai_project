// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:new_ai_project/pages/LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // زر Student تحت صورة الولد
          Positioned(
            top: 320, // المسافة من الأعلى
            left: 185, // المسافة من اليسار
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
                width: 183,
                height: 50,
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
          // زر Doctor
          Positioned(
            top: 530, // المسافة من الأعلى
            right: 200, // المسافة من اليسار
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
                width: 183, // عرض الزر
                height: 50, // ارتفاع الزر
                padding: const EdgeInsets.all(10), // المسافة الداخلية
                decoration: ShapeDecoration(
                  color: const Color(0xFF05B8FB), // لون الخلفية
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // زوايا مدورة
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Doctor', // نص الزر
                      style: TextStyle(
                        color: Colors.white, // لون النص
                        fontSize: 24, // حجم النص
                        fontFamily: 'Inter', // نوع الخط
                        fontWeight: FontWeight.w700, // سمك الخط
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // زر Guardian
          Positioned(
            top: 740, // المسافة من الأعلى
            left: 185, // المسافة من اليسار
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
                width: 183, // عرض الزر
                height: 50, // ارتفاع الزر
                padding: const EdgeInsets.all(10), // المسافة الداخلية
                decoration: ShapeDecoration(
                  color: const Color(0xFF05B8FB), // لون الخلفية
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // زوايا مدورة
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Guardian', // نص الزر
                      style: TextStyle(
                        color: Colors.white, // لون النص
                        fontSize: 24, // حجم النص
                        fontFamily: 'Inter', // نوع الخط
                        fontWeight: FontWeight.w700, // سمك الخط
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
