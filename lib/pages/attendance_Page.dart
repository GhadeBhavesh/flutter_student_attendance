import 'package:flutter/material.dart';
import 'package:flutter_student_attendance/components/attendance_Provider.dart';
import 'package:flutter_student_attendance/components/dialog_Box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
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
                  painter: DialogBox(),
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
                            // Division Dropdown
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
                                      '${student.name} (${student.status})', // Show name and status
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
                                  ));
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
    final student = provider.students[index];
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 237, 96, 53),
                const Color.fromARGB(255, 224, 99, 37),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mark Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Mark attendance for ${student.name}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      provider.markAttendance(index, 'Present');
                      Navigator.of(context).pop();
                    },
                    child: Text('Present'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      provider.markAttendance(index, 'Absent');
                      Navigator.of(context).pop();
                    },
                    child: Text('Absent'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
