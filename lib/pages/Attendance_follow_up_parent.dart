// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AttendanceRatePage_stu.dart'; // الصفحة اللي فيها النسبة الفعلية

class Attendance_follow_up extends StatelessWidget {
  final String parentId;

  const Attendance_follow_up({super.key, required this.parentId});

  Future<List<Map<String, dynamic>>> getStudentsForParent() async {
    // تحويل parentId من String إلى int
    int? parentIdInt = int.tryParse(parentId);

    if (parentIdInt == null) {
      print('Invalid parent ID');
      return [];
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('student')
        .where('parent_id', isEqualTo: parentIdInt) // استخدام القيمة الرقمية
        .get();

    return querySnapshot.docs
        .map((doc) => {'id': doc.id, 'data': doc.data()})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow attendance'),
        backgroundColor: const Color(0xFF05B8FB),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getStudentsForParent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('There are no children associated with you.'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final data = student['data'];
              final id = student['id'];
              final name = "${data['First_name']} ${data['secound_Name']}";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('images/$id.jpg'),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("code: $id",
                      style: const TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceRatePage(studentId: id),
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
