// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WorksOfYearPage.dart'; // تأكد أن المسار صحيح

class year_work extends StatelessWidget {
  final String parentId;

  const year_work({super.key, required this.parentId});

  Future<List<Map<String, dynamic>>> getStudentsForParent() async {
    print('Starting getStudentsForParent for parentId: $parentId');

    int? parentIdInt = int.tryParse(parentId);

    if (parentIdInt == null) {
      print(
          '❌ Error: Invalid parent ID format. Cannot convert "$parentId" to an integer.');
      return []; // إذا فشل التحويل، لا توجد حاجة للاستعلام
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('parent_id',
              isEqualTo: parentIdInt) // استخدام القيمة الرقمية هنا
          .get();

      print('✅ Firestore query for parent_id: $parentIdInt completed.');
      print('Found ${querySnapshot.docs.length} students.');

      if (querySnapshot.docs.isEmpty) {
        print('No student documents found for this parent ID.');
      }

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
    } catch (e) {
      print('❌ Error fetching students for parent: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Year Work'),
        backgroundColor: const Color(0xFF05B8FB), // لون موحد
        iconTheme:
            const IconThemeData(color: Colors.white), // لون أيقونة الرجوع
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getStudentsForParent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('❌ FutureBuilder Error: ${snapshot.error}');
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('There are no children associated with you.'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final data = student['data'];
              final id = student['id'];

              final firstName = data['First_name'] ?? '';
              final secondName = data['secound_Name'] ?? '';
              final thirdName = data['Third_Name'] ?? '';
              final name = '$firstName $secondName $thirdName'.trim();

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('images/$id.jpg'),
                    onBackgroundImageError: (exception, stackTrace) {
                      print(
                          '⚠️ Error loading image for student ID $id: $exception');
                    },
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Code: $id", // عرض معرف الطالب
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // الانتقال لصفحة أعمال السنة للطالب
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentYearWorkPage(studentCode: id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
