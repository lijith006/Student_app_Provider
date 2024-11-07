import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/provider/provider.dart';
import 'package:studentapp_provider_hive/screens/add_student.dart';
import 'package:studentapp_provider_hive/screens/edit_student.dart';
import 'package:studentapp_provider_hive/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(StudentModelAdapter());
  await Hive.openBox<StudentModel>('students');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Studentprovider()),
        ChangeNotifierProxyProvider<Studentprovider, SearchProvider>(
          create: (context) =>
              SearchProvider(context.read<Studentprovider>().student),
          update: (context, studentProvider, previous) =>
              SearchProvider(studentProvider.student),
        ),
        ChangeNotifierProvider(create: (context) => ImageProviderImg()),
        ChangeNotifierProvider(create: (context) => EditingImageprovider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.amber),
        home: const HomeScreen(),
      ),
    );
  }
}
