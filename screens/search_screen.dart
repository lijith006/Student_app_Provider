import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentapp_provider_hive/model/student_model.dart';
import 'package:studentapp_provider_hive/screens/full_view_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (query) {
                searchProvider.updateSearchQuery(query);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchProvider.filteredStudents.isEmpty &&
                      searchProvider._searchQuery.isNotEmpty
                  ? const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchProvider.filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = searchProvider.filteredStudents[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullViewScreen(student: student)));
                            },
                            title: Text(student.studentName!),
                            subtitle: Text(student.studentRegNo!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchProvider extends ChangeNotifier {
  final List<StudentModel> _students;
  String _searchQuery = '';

  SearchProvider(this._students);

  List<StudentModel> get filteredStudents {
    if (_searchQuery.isEmpty) {
      return [];
    }
    return _students.where((student) {
      return student.studentName!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
