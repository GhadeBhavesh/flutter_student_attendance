import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_student_attendance/components/student_class.dart';

class AttendanceProvider with ChangeNotifier {
  String _selectedClass = '';
  String _selectedSection = '';
  List<Student> _allStudents = [];
  List<Student> _students = [];

  String get selectedClass => _selectedClass;
  String get selectedSection => _selectedSection;
  List<Student> get students => _students;

  void setClass(String value) {
    _selectedClass = value;
    _updateStudents();
    notifyListeners();
  }

  void setSection(String value) {
    _selectedSection = value;
    _updateStudents();
    notifyListeners();
  }

  void markAttendance(int index, String status) {
    _students[index].status = status;
    _students[index].entryTime = DateTime.now();
    notifyListeners();
  }

  // Load students from JSON file
  Future<void> loadStudentsFromJson() async {
    final String jsonString =
        await rootBundle.loadString('assets/students.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    _allStudents = jsonData.map((data) {
      return Student(
        name: data['name'],
        classLevel: data['class'], // Add class and section fields
        section: data['section'],
        status: data['status'],
        entryTime: data['entryTime'] != null
            ? DateTime.parse(data['entryTime'])
            : null,
      );
    }).toList();
    _updateStudents();
    notifyListeners();
  }

  // Update students list based on selected class and section
  void _updateStudents() {
    _students = _allStudents.where((student) {
      final matchesClass =
          _selectedClass.isEmpty || student.classLevel == _selectedClass;
      final matchesSection =
          _selectedSection.isEmpty || student.section == _selectedSection;
      return matchesClass && matchesSection;
    }).toList();
  }
}
