import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/provider/provider.dart';
import 'package:studentapp_provider_hive/screens/full_view_screen.dart';
import 'package:studentapp_provider_hive/styles/styles.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<Studentprovider>(context);

    return Scaffold(
      backgroundColor: backgroundtheme,
      appBar: AppBar(
        foregroundColor: iconsColor,
        backgroundColor: themecode,
        title: const Text(
          'Student Details',
          style: TextStyle(fontWeight: studentfont),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.list,
                size: 35,
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: studentProvider.student.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  itemCount: studentProvider.student.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    final StudentModel student = studentProvider.student[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullViewScreen(student: student),
                          ),
                        );
                      },
                      child: Card(
                        color: listTilecolor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: (student.studentPhoto != null &&
                                        student.studentPhoto!.isNotEmpty)
                                    ? Image.file(
                                        File(student.studentPhoto!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/student.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )),
                            const SizedBox(height: 10),
                            Text(
                              student.studentName ?? '',
                              style: const TextStyle(
                                  color: textcolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Reg No: ${student.studentRegNo ?? 'N/A'}",
                              style: const TextStyle(color: textcolor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
