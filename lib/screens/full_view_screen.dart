import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/provider/provider.dart';
import 'package:studentapp_provider_hive/screens/edit_student.dart';
import 'package:studentapp_provider_hive/styles/styles.dart';

class FullViewScreen extends StatelessWidget {
  final StudentModel student;

  const FullViewScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = const AssetImage('assets/student.png');

    if (student.studentPhoto != null && student.studentPhoto!.isNotEmpty) {
      final file = File(student.studentPhoto!);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
        print('OK');
      } else {
        print('File does not exist: ${student.studentPhoto}');
      }
    }

    final studentProvider = Provider.of<Studentprovider>(context);

    return Scaffold(
      backgroundColor: backgroundtheme,
      appBar: AppBar(
        backgroundColor: themecode,
        foregroundColor: iconsColor,
        title: const Center(
          child: Text(
            "Student Details",
            style: TextStyle(fontWeight: studentfont),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: listTilecolor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Student Name : ${student.studentName!}',
                      style: const TextStyle(
                        color: textcolor,
                        fontWeight: studentfont,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Age : ${student.studentAge}',
                      style: const TextStyle(
                        color: textcolor,
                        fontWeight: studentfont,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Register Number : ${student.studentRegNo!}',
                      style: const TextStyle(
                        color: textcolor,
                        fontWeight: studentfont,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Contact Number : ${student.studentContact!}',
                      style: const TextStyle(
                        color: textcolor,
                        fontWeight: studentfont,
                      ),
                    ),
                    const SizedBox(height: 90),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditScreen(studentt: student),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: iconsColor,
                                ),
                                child: const Text(
                                  "EDIT",
                                  style: TextStyle(color: themecode),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDeleteDialog(
                                      context, studentProvider, student);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: iconsColor,
                                ),
                                child: const Text(
                                  "DELETE",
                                  style: TextStyle(color: themecode),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, Studentprovider studentProvider,
      StudentModel student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  studentProvider.deleteDetails(student);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student deleted successfully!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Delete')),
          ],
        );
      },
    );
  }
}
