// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudentYearWorkPage extends StatefulWidget {
  final String studentCode;

  const StudentYearWorkPage({super.key, required this.studentCode});

  @override
  State<StudentYearWorkPage> createState() => _StudentYearWorkPageState();
}

class _StudentYearWorkPageState extends State<StudentYearWorkPage> {
  double subject1 = 0;
  double subject2 = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchYearWork();
  }

  Future<void> fetchYearWork() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.studentCode)
          .get();

      print("👨‍🎓 الكود: \${widget.studentCode}");
      print("📦 هل موجود؟ \${doc.exists}");

      if (doc.exists) {
        final data = doc.data()!;
        print("📄 البيانات: \$data");
        setState(() {
          subject1 = (data['Material_1'] ?? 0).toDouble();
          subject2 = (data['Material_2'] ?? 0).toDouble();
          isLoading = false;
        });
      } else {
        print("❌ الكود غير موجود في Firestore");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('💥 Error fetching data: \$e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sum = subject1 + subject2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Works of year'),
        backgroundColor: const Color(0xFF05B8FB),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (subject1 == 0 && subject2 == 0)
              ? Center(child: Text('لا توجد بيانات لأعمال السنة'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Percentage of years work',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: subject1,
                              title: 'Material 1',
                              color: Colors.blue,
                              radius: 60,
                              titleStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            PieChartSectionData(
                              value: subject2,
                              title: 'Material 2',
                              color: Colors.orange,
                              radius: 60,
                              titleStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            PieChartSectionData(
                              value: sum,
                              title: 'Total',
                              color: Colors.green,
                              radius: 60,
                              titleStyle:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: const [
                          LegendItem(color: Colors.blue, label: 'Material 1'),
                          LegendItem(color: Colors.orange, label: 'Material 2'),
                          LegendItem(color: Colors.green, label: 'Total'),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 16, height: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
