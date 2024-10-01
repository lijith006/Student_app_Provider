import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel extends HiveObject {
  @HiveField(0)
  String? studentName;
  @HiveField(1)
  String? studentAge;
  @HiveField(2)
  String? studentRegNo;
  @HiveField(3)
  String? studentContact;
  @HiveField(4)
  String? studentPhoto;

  StudentModel(
      {required this.studentName,
      required this.studentAge,
      required this.studentRegNo,
      required this.studentContact,
      required this.studentPhoto});
}
