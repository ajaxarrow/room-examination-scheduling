import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';
import 'package:roomexaminationschedulingsystem/widgets/sections/section_dialog_form.dart';
import 'package:roomexaminationschedulingsystem/widgets/sections/section_list.dart';

class FacultySectionsView extends StatefulWidget {
  const FacultySectionsView({super.key});

  @override
  State<FacultySectionsView> createState() => _FacultySectionsViewState();
}

class _FacultySectionsViewState extends State<FacultySectionsView> {
  List<Section> _sections = [];
  String selectedCollege = 'All';

  Future<void> fetchSections() async {
    _sections.clear();
    _sections = await Section().getSectionsByCollege(selectedCollege);
  }

  void _refreshList(){
    setState(() {

    });
  }

  void _removeSection(String id) async {
    await Section(id: id).deleteSection();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Section Deleted!"),
        )
    );
  }

  void showSectionFormDialog() {
    showDialog(
        context: context,
        builder: (ctx) =>
            SimpleDialog(
              children: [
                SectionDialogForm(
                    mode: Mode.create,
                    onRefresh: _refreshList
                )
              ],
            )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchSections(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OOPS!',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no sections added.'
                  )
                ],
              ),
            );

            if (_sections.isNotEmpty) {
              mainContent = SectionList(
                  onRefresh: _refreshList,
                  sections: _sections,
                  onRemoveSection: _removeSection
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Text('College: '),
                      DropdownButton<String>(
                        value: selectedCollege,
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Agriculture',
                            child: Text('College of Agriculture'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Arts and Sciences',
                            child: Text('College of Arts and Sciences'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Business and Management',
                            child: Text('College of Business and Management'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Education',
                            child: Text('College of Education'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Engineering',
                            child: Text('College of Engineering'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Forestry & Environmental Science',
                            child: Text('College of Forestry & Environmental Science'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Human Ecology',
                            child: Text('College of Human Ecology'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Information Sciences and Computing',
                            child: Text('College of Information Sciences and Computing'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Nursing',
                            child: Text('College of Nursing'),
                          ),
                          DropdownMenuItem(
                            value: 'College of Veterinary Medicine',
                            child: Text('College of Veterinary Medicine'),
                          )
                        ],
                        onChanged: (value) async {
                          setState(() {
                            selectedCollege = value!;
                          });
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _sections.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Sections',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  18
                    ),
                  ),
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return MainLayout(
            role: Role.faculty,
            title: 'Sections',
            index: 2,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchSections();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Section List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: showSectionFormDialog,
                      child: const Icon(Icons.add),
                    ),
                  )
              ),
            ),
          );

        }
    );
  }
}
