// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableDoctor extends StatelessWidget {
  final String doctorId;

  const TableDoctor({super.key, required this.doctorId});

  Future<List<Map<String, dynamic>>> fetchSchedule(String doctorId) async {
    final scheduleSnapshot = await FirebaseFirestore.instance
        .collection('studyschedule')
        .where('doctor_id', isEqualTo: doctorId)
        .get();
    print('📥 جاري تحميل جدول الدكتور: $doctorId');

    if (scheduleSnapshot.docs.isEmpty) {
      print('❌ لا يوجد جدول لهذا الدكتور في studyschedule');
    }

    List<Map<String, dynamic>> scheduleList = [];

    for (var doc in scheduleSnapshot.docs) {
      final data = doc.data();

      // اسم المادة
      String subjectName = 'Unknown';
      final subjectSnapshot = await FirebaseFirestore.instance
          .collection('academic_subject')
          .doc(data['Subject_number'])
          .get();
      if (subjectSnapshot.exists) {
        subjectName = subjectSnapshot.data()?['Material_name'] ?? 'Unknown';
      }

      // اسم القاعة (اختياري)
      String roomName = data['Place'] ?? '';
      final placeSnapshot = await FirebaseFirestore.instance
          .collection('place')
          .doc(data['Place'])
          .get();
      if (placeSnapshot.exists) {
        roomName = placeSnapshot.data()?['site'] ?? roomName;
      }

      scheduleList.add({
        'subject': subjectName,
        'day': data['Day'] ?? '',
        'start_time': data['start_time'] ?? '',
        'end_time': data['end_time'] ?? '',
        'room': roomName,
      });
    }

    return scheduleList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Table_doctor.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // زر الرجوع
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // جدول البيانات
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSchedule(doctorId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('حدث خطأ في تحميل الجدول'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('لا يوجد جدول لهذا الدكتور'));
              }

              final schedule = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final item = schedule[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(item['subject']),
                        subtitle: Text(
                          'Day: ${item['day']} - From ${item['start_time']} To ${item['end_time']} - Room: ${item['room']}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
