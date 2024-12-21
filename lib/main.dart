import 'dart:convert'; // For JSON decoding
import 'package:flutter/services.dart'; // For loading assets
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

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

    _updateStudents(); // Initial filter
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

class Student {
  String name;
  String classLevel;
  String section;
  String status;
  DateTime? entryTime;

  Student({
    required this.name,
    required this.classLevel,
    required this.section,
    required this.status,
    this.entryTime,
  });
}

class MyApp extends StatelessWidget {
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

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      body: provider.students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: DiagonalBackgroundPainter(),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Student Attendance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Class Dropdown
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Standard',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Division',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                    child: Icon(Icons.person,
                                        color: Colors.black54),
                                  ),
                                  title: Text(
                                    student.name,
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
                                    _showAttendanceDialog(
                                        context, provider, index);
                                  },
                                ),
                              );
                            },
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

class DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color.fromARGB(255, 237, 96, 53),
          const Color.fromARGB(255, 224, 99, 37),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();
    path.lineTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
