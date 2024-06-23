import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/route_guards.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_dialog_form.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminCalendarView extends StatefulWidget {
  const AdminCalendarView({super.key});

  @override
  State<AdminCalendarView> createState() => _AdminCalendarViewState();
}

class _AdminCalendarViewState extends State<AdminCalendarView> {
  List<Appointment> _appointments = <Appointment>[];


  Future<void> fetchAppointments() async {
    _appointments.clear();
    _appointments = await Schedule().getAppointments();
  }

  void _refreshList(){
    setState(() {

    });
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
                    role: Role.admin
                )
              ],
            )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAuthenticated('admin', context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAppointments(),
      builder: (ctx, snapshot) {
        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = Center(child: Text('Error: ${snapshot.error}'));
        } else {
          body = Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SfCalendar(
                    initialSelectedDate: DateTime.now(),
                    monthViewSettings: const MonthViewSettings(
                      showAgenda: true,
                      agendaViewHeight: 200,
                    ),
                    allowViewNavigation: true,
                    allowedViews: const <CalendarView>[
                      CalendarView.day,
                      CalendarView.schedule,
                      CalendarView.month,
                      CalendarView.week
                    ],
                    showNavigationArrow: true,
                    showCurrentTimeIndicator: true,
                    showTodayButton: true,
                    view: CalendarView.month,
                    dataSource: _getCalendarDataSource(_appointments),
                    timeSlotViewSettings: const TimeSlotViewSettings(
                      timeIntervalHeight: 100,
                    ),
                    showDatePickerButton: true,
                  ),
                ),
              ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: SfCalendar(
              //
              //       // allowViewNavigation: true,
              //       showNavigationArrow: true,
              //       showCurrentTimeIndicator: true,
              //       view: CalendarView.month,
              //       dataSource: _getCalendarDataSource(_appointments),
              //       showDatePickerButton: true,
              //     ),
              //   ),
              // ),
            ],
          );
        }

        return MainLayout(
          role: Role.admin,
          title: 'Calendar of Schedule',
          index: 6,
          content: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              body: body,
              floatingActionButton: FloatingActionButton(
                onPressed: showScheduleFormDialog,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }

  _DataSource _getCalendarDataSource(List<Appointment> appointments) {
    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
