import 'package:flutter/material.dart';
import 'package:flutter_student_attendance/components/attendance_Provider.dart';
import 'package:flutter_student_attendance/pages/attendance_Page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttendanceProvider()..loadStudentsFromJson(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AttendancePage(),
      ),
    );
  }
}
