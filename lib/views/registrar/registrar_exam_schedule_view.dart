import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_dialog_form.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_list.dart';
import '../../layout/main_layout.dart';
import '../../route_guards.dart';

class RegistrarExamScheduleView extends StatefulWidget {
  const RegistrarExamScheduleView({super.key});

  @override
  State<RegistrarExamScheduleView> createState() => _RegistrarExamScheduleViewState();
}

class _RegistrarExamScheduleViewState extends State<RegistrarExamScheduleView> {

  List<Schedule> _schedules = [];

  Future<void> fetchSchedules() async{
    _schedules.clear();
    _schedules = await Schedule().getSchedules();
  }

  void _refreshList(){
    setState(() {

    });
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


  void showScheduleFormDialog() {
    showDialog(
        context: context,
        builder: (ctx) =>
            SimpleDialog(
              children: [
                ScheduleDialogForm(
                    mode: Mode.create,
                    onRefresh: _refreshList,
                    role: Role.registrar
                )
              ],
            )
    );
  }

  @override
  void dispose() {
    super.dispose();
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
                  isCurrent: true,
                  onRefresh: _refreshList,
                  role: Role.registrar,
                  schedules: _schedules,
                  onRemoveSchedule: _removeSchedule
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
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
            role: Role.registrar,
            title: 'Exam Schedules',
            index: 1,
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
                    floatingActionButton: FloatingActionButton(
                      onPressed: showScheduleFormDialog,
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
