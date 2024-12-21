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
