import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_list.dart';

class FacultyScheduleHistoryView extends StatefulWidget {
  const FacultyScheduleHistoryView({super.key});

  @override
  State<FacultyScheduleHistoryView> createState() => _FacultyScheduleHistoryViewState();
}

class _FacultyScheduleHistoryViewState extends State<FacultyScheduleHistoryView> {
  List<Schedule> _schedules = [];
  String selectedAcademicYearID = '';
  List<DropdownMenuItem<String>> items = [];

  Future<void> fetchSchedules() async{
    _schedules.clear();
    _schedules = await Schedule(
        academicYearID: selectedAcademicYearID
    ).getSchedulesByAY();
  }

  void _refreshList(){
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('faculty', context);
    items.clear();
    AcademicYear().getAcademicYears().then((value){
      setState(() {
        selectedAcademicYearID = value[0].id!;
      });
      fetchSchedules();
      items = value.map((academicYear) {
        return DropdownMenuItem(
          value: academicYear.id,
          child: Text('${academicYear.yearStart} - ${academicYear.yearEnd} (${academicYear.semester})'),
        );
      }).toList();
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  void _removeSchedule(String id) async {
    await Schedule(id: id).deleteSchedule();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Schedule Deleted!"),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchSchedules(),
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
                      'There are no schedules added.'
                  )
                ],
              ),
            );

            if (_schedules.isNotEmpty) {
              mainContent = ScheduleList(
                  isCurrent: false,
                  onRefresh: _refreshList,
                  role: Role.faculty,
                  schedules: _schedules,
                  onRemoveSchedule: _removeSchedule
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
                      const Text('Academic Year: '),
                      DropdownButton<String>(
                        value: selectedAcademicYearID,
                        items: items,
                        onChanged: (value) async {
                          setState(() {
                            selectedAcademicYearID = value!;
                          });
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _schedules.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Schedules',
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
            title: 'Schedule History',
            index: 3,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchSchedules();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Schedules List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                  )
              ),
            ),
          );

        }
    );
  }
}
