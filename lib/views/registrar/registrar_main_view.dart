import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../model/mixins/academic_year.dart';
import '../../route_guards.dart';
import '../../widgets/academicyears/academic_year_dialog_form.dart';
import '../../widgets/academicyears/academic_year_list.dart';


class RegistrarMainView extends StatefulWidget {
  const RegistrarMainView({super.key});

  @override
  State<RegistrarMainView> createState() => _RegistrarMainViewState();
}

class _RegistrarMainViewState extends State<RegistrarMainView> {
  List<AcademicYear> _academicYears = [];

  Future<void> fetchAcademicYears() async {
    _academicYears.clear();
    _academicYears = await AcademicYear().getAcademicYears();
  }

  void _refreshList(){
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('registrar', context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeAcademicYear(String id) async {
    await AcademicYear(id: id).deleteAcademicYear();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Academic Year Deleted!"),
        )
    );
  }

  void showAcademicYearFormDialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
        SimpleDialog(
          children: [
            AcademicYearDialogForm(
              mode: Mode.create,
              onAddAcademicYear: _refreshList,
            )
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAcademicYears(),
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
                      'There are no academic years added.'
                  )
                ],
              ),
            );

            if (_academicYears.isNotEmpty) {
              mainContent = AcademicYearList(
                academicYears: _academicYears,
                onUpdateList: _refreshList,
                onRemoveAcademicYear: _removeAcademicYear,
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _academicYears.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Academic Years',
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
            role: Role.registrar,
            title: 'Academic Year',
            index: 0,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchAcademicYears();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Academic Years List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: showAcademicYearFormDialog,
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
