import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableDoctor extends StatelessWidget {
  final String doctorId;

  const TableDoctor({Key? key, required this.doctorId}) : super(key: key);

  // دالة fetchSchedule لتحميل جدول الدكتور
  Future<List<Map<String, dynamic>>> fetchSchedule(String doctorId) async {
    // doctor_id مخزن كـ Number في Firestore، نحول النص إلى عدد
    final int doctorIdNum = int.tryParse(doctorId) ?? 0;

    // جلب الجدول
    final scheduleSnapshot = await FirebaseFirestore.instance
        .collection('studyschedule')
        .where('doctor_id', isEqualTo: doctorIdNum)
        .get();

    print('📥 جاري تحميل جدول الدكتور: $doctorIdNum');

    if (scheduleSnapshot.docs.isEmpty) {
      print('❌ لا يوجد جدول لهذا الدكتور في studyschedule');
      return [];
    }

    List<Map<String, dynamic>> scheduleList = [];

    for (var doc in scheduleSnapshot.docs) {
      final data = doc.data();

      print('Subject_number: ${data['Subject_number']}');
      print('Place: ${data['Place']}');

      // جلب اسم المادة من academic_subject
      String subjectName = 'Unknown';
      final subjectSnapshot = await FirebaseFirestore.instance
          .collection('academic_subject')
          .doc(data['Subject_number'].toString())
          .get();
      if (subjectSnapshot.exists) {
        subjectName = subjectSnapshot.data()?['Material_name'] ?? 'Unknown';
        print('Fetched subject: $subjectName');
      } else {
        print('❌ لم يتم العثور على المادة ${data['Subject_number']}');
      }

      // جلب اسم القاعة من place
      String roomName = data['Place'].toString();
      final placeSnapshot = await FirebaseFirestore.instance
          .collection('place')
          .doc(roomName)
          .get();
      if (placeSnapshot.exists) {
        roomName = placeSnapshot.data()?['site'] ?? roomName;
        print('Fetched room: $roomName');
      } else {
        print('❌ لم يتم العثور على القاعة $roomName');
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // المحتوى الرئيسي
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
              print('Schedule data: $schedule');
              return Padding(
                padding: const EdgeInsets.only(top: 150),
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final item = schedule[index];
                    print('Displaying subject: ${item['subject']}');
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
