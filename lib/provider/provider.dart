import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';

class Studentprovider extends ChangeNotifier {
  final Box<StudentModel> studentbox = Hive.box<StudentModel>('students');
  List<StudentModel> get student => studentbox.values.toList();

  void addStudent(StudentModel student) {
    studentbox.add(student);
    print('student data added:${student.studentName}');
    notifyListeners();
  }

  void updateDetails(StudentModel student) {
    int index = studentbox.values.toList().indexOf(student);
    studentbox.putAt(index, student);
    notifyListeners();
  }

  void deleteDetails(StudentModel student) {
    int index = studentbox.values.toList().indexOf(student);
    studentbox.deleteAt(index);
    notifyListeners();
  }
}
