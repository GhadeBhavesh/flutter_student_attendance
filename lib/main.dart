import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // For formatting date and time

void main() {
  runApp(MyApp());
}

// State Management (using Provider)
class AttendanceProvider with ChangeNotifier {
  String _selectedClass = '';
  String _selectedSection = '';
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

  void _updateStudents() {
    // Mock data with initial status as "None"
    _students = List.generate(
        10,
        (index) => Student(
            id: (5476 + index).toString(),
            name: 'Student ${index + 1}',
            status: 'None',
            entryTime: null));
  }
}

class Student {
  String id;
  String name;
  String status;
  DateTime? entryTime;

  Student({
    required this.id,
    required this.name,
    required this.status,
    required this.entryTime,
  });
}

// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceProvider(),
      child: MaterialApp(
        home: AttendancePage(),
      ),
    );
  }
}

// Attendance Page
class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Student Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Class and Section Dropdowns
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Class Dropdown
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standard',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedClass.isEmpty
                              ? null
                              : provider.selectedClass,
                          hint: Text('L.K.G'),
                          items: ['L.K.G', 'U.K.G', 'Class 1']
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            provider.setClass(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Section Dropdown
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Division',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedSection.isEmpty
                              ? null
                              : provider.selectedSection,
                          hint: Text('A'),
                          items: ['A', 'B', 'C']
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            provider.setSection(value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            SizedBox(height: 16),
            // Student List
            Expanded(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  final student = provider.students[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.black54),
                      ),
                      title: Text(
                        '${student.id} ${student.name}',
                        style: TextStyle(
                          color: student.status == 'None'
                              ? Colors.black
                              : (student.status == 'Present'
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ),
                      subtitle: Text(
                        student.entryTime != null
                            ? 'Today, ${DateFormat('h a').format(student.entryTime!)}'
                            : 'No entry time recorded',
                      ),
                      onTap: () {
                        _showAttendanceDialog(context, provider, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDialog(
      BuildContext context, AttendanceProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark Attendance'),
        content: Text('Mark attendance for ${provider.students[index].name}'),
        actions: [
          TextButton(
            onPressed: () {
              provider.markAttendance(index, 'Present');
              Navigator.of(context).pop();
            },
            child: Text('Present'),
          ),
          TextButton(
            onPressed: () {
              provider.markAttendance(index, 'Absent');
              Navigator.of(context).pop();
            },
            child: Text('Absent'),
          ),
        ],
      ),
    );
  }
}
