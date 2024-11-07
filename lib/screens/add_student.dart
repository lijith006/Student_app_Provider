import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/provider/provider.dart';
import 'package:studentapp_provider_hive/screens/home_screen.dart';
import 'package:studentapp_provider_hive/styles/styles.dart';
import 'package:studentapp_provider_hive/widgets/custom_Text_formfield.dart';

class AddScreen extends StatelessWidget {
  AddScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final registerNoController = TextEditingController();
  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundtheme,
      appBar: AppBar(
        backgroundColor: themecode,
        foregroundColor: iconsColor,
        title: const Text(
          "Add Student",
          style: TextStyle(fontWeight: fontStyles),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Consumer<ImageProviderImg>(
                  builder: (context, imageProvider, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: imageProvider.selectedImage != null
                              ? FileImage(imageProvider.selectedImage!)
                              : const AssetImage('assets/student.png')
                                  as ImageProvider,
                          radius: 60,
                          child: imageProvider.selectedImage == null
                              ? const SizedBox()
                              : null,
                        ),
                        Positioned(
                          bottom: -5,
                          right: -4,
                          child: IconButton(
                            onPressed: () {
                              pickImage(context);
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormfield(
                  controller: nameController,
                  hintText: "Enter Your name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name can only contain letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormfield(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  hintText: "Enter Your age",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age is required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 1 || age > 99) {
                      return 'Age must be between 1 and 99';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormfield(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  keyboardType: TextInputType.number,
                  controller: registerNoController,
                  hintText: "Enter Your Register Number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Register Number is required';
                    } else if (value.length != 6) {
                      return 'Register Number must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormfield(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  keyboardType: TextInputType.phone,
                  controller: contactController,
                  hintText: "Enter Your Contact Number",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contact number is required';
                    } else if (value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Consumer<ImageProviderImg>(
                  builder: (context, imageProvider, _) {
                    return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(iconsColor)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          addStudentDetails(context);
                        }
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(color: themecode),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        Provider.of<ImageProviderImg>(context, listen: false)
            .setImage(File(pickedFile.path));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void addStudentDetails(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final imageProvider =
          Provider.of<ImageProviderImg>(context, listen: false);
      final student = StudentModel(
        studentName: nameController.text,
        studentAge: ageController.text,
        studentRegNo: registerNoController.text,
        studentContact: contactController.text,
        studentPhoto: imageProvider.selectedImage?.path ?? '',
      );
      Provider.of<Studentprovider>(context, listen: false).addStudent(student);
      Provider.of<ImageProviderImg>(context, listen: false).setImage(null);
      //Snackbar

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student added successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}

class ImageProviderImg extends ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }
}
