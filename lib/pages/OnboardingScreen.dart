// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_ai_project/pages/WelcomeScreen.dart'; // لإضافة SystemNavigator

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الصورة الخلفية
          Image.asset(
            'images/background.png', // مسار الصورة
            fit: BoxFit.cover, // تغطية الشاشة بالكامل
            width: double.infinity, // عرض الصورة
            height: double.infinity, // ارتفاع الصورة
          ),
          // زر الرجوع
          Positioned(
            top: 30, // المسافة من أعلى الشاشة
            left: 10, // المسافة من اليسار
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                SystemNavigator.pop(); // إغلاق التطبيق
              },
            ),
          ),
          // العناصر فوق الصورة
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 350), // مسافة بين النص والزر
                // Container بدل زر NEXT
                GestureDetector(
                  onTap: () {
                    // الانتقال للشاشة التالية
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                  child: Container(
                    width: 386,
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF33BEF1),
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
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
