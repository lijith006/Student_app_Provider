import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/provider/provider.dart';
import 'package:studentapp_provider_hive/screens/add_student.dart';
import 'package:studentapp_provider_hive/screens/full_view_screen.dart';
import 'package:studentapp_provider_hive/screens/gridview_screen.dart';
import 'package:studentapp_provider_hive/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<Studentprovider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: backgroundtheme,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          foregroundColor: iconsColor,
          backgroundColor: themecode,
          title: const Text(
            'Home',
            style: TextStyle(color: iconsColor, fontWeight: studentfont),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GridViewScreen()));
                },
                icon: const Icon(
                  Icons.grid_view,
                  size: 30,
                ))
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    style: const TextStyle(color: iconsColor),
                    onChanged: (query) {
                      searchProvider.updateSearchQuery(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: iconsColor),
                      contentPadding:
                          const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: iconsColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: searchProvider.filteredStudents.isEmpty &&
                searchProvider._searchQuery.isNotEmpty
            ? const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 18, color: iconsColor),
                ),
              )
            : ListView.builder(
                itemCount: searchProvider.filteredStudents.isNotEmpty
                    ? searchProvider.filteredStudents.length
                    : studentProvider.student.length,
                itemBuilder: (context, index) {
                  final student = searchProvider.filteredStudents.isNotEmpty
                      ? searchProvider.filteredStudents[index]
                      : studentProvider.student[index];
                  return Card(
                    color: listTilecolor,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullViewScreen(
                              student: student,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          student.studentName!,
                          style: const TextStyle(
                            color: textcolor,
                            //color: Color.fromARGB(255, 248, 193, 193),
                            fontWeight: studentfont,
                          ),
                        ),
                        subtitle: Text(
                          student.studentRegNo!,
                          style: const TextStyle(
                            color: textcolor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 205, 240, 162),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
        child: const Icon(
          Icons.add,
          color: themecode,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class SearchProvider extends ChangeNotifier {
  final List<StudentModel> _students;
  String _searchQuery = '';

  SearchProvider(this._students);

  String get searchQuery => _searchQuery;

  List<StudentModel> get filteredStudents {
    if (_searchQuery.isEmpty) {
      return [];
    }
    return _students.where((student) {
      return student.studentName!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.studentRegNo!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
