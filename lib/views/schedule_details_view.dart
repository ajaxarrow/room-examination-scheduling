import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/layout/main_layout.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/utils/format_date.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_dialog_form.dart';


class ScheduleDetailsView extends StatefulWidget {
  const ScheduleDetailsView({
    super.key,
    required this.proctor,
    required this.role,
    required this.course,
    required this.room,
    required this.faculty,
    required this.section,
    required this.schedule,
    required this.currentUser,
    required this.isCurrent
  });

  final Role role;
  final String proctor;
  final String room;
  final String course;
  final String faculty;
  final String section;
  final Schedule schedule;
  final AppUser currentUser;
  final bool isCurrent;

  @override
  State<ScheduleDetailsView> createState() => _ScheduleDetailsViewState();
}

class _ScheduleDetailsViewState extends State<ScheduleDetailsView> {
  String role = 'faculty';
  Role get userRole {
    if(role == 'faculty'){
      return Role.faculty;
    } else if(role == 'registrar'){
      return Role.registrar;
    } else {
      return Role.admin;
    }
  }

  int get index {
    if(role == 'faculty'){
      return 0;
    } else if(role == 'registrar'){
      return 1;
    } else {
      return 2;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppUser().getUserRoleById(FirebaseAuth.instance.currentUser!.uid!).then((value) =>
        setState(() {
          role = value;
        })
    );
  }

  @override
  Widget build(BuildContext context) {

    void showScheduleDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  ScheduleDialogForm(
                    schedule: widget.schedule,
                    mode: Mode.update,
                    onRefresh: (){
                      Navigator.of(context).pop();
                    },
                    role: userRole
                  )
                ],
              )
      );
    }

    return MainLayout(
      role: userRole,
      title: 'Exam Schedule',
      index: index,
      content: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height:  10),
              TextButton.icon(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft),
                  label: const Text('Back to Exam Schedules')
              ),
              const SizedBox(height:  20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.course} - ${widget.section}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                          ),
                        ),
                        Text('Proposed Time: ${formatTimestamp(widget.schedule.timeStart!)} - ${formatTimestamp(widget.schedule.timeEnd!)}')
                      ],
                    ),
                  ),
                  widget.isCurrent && (widget.currentUser.role != 'faculty' || FirebaseAuth.instance.currentUser!.uid! == widget.schedule.facultyID!) ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                      ),
                      icon: const PhosphorIcon(PhosphorIconsRegular.pencil),
                      onPressed: showScheduleDialog,
                      label: const Text('Edit'),
                    ),
                  ) : const SizedBox.shrink()
                ],
              ),
              const SizedBox(height:  5),
              const Divider(),
              const SizedBox(height:  10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Section'),
                        Text(widget.section)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Course'),
                        Text(widget.course),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height:  10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Faculty Name'),
                        Text(widget.faculty)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Room'),
                        Text(widget.room),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TimeStart'),
                        Text(formatTimestamp(widget.schedule.timeStart!))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TimeEnd'),
                        Text(formatTimestamp(widget.schedule.timeEnd!))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Proctor'),
                        Text(widget.proctor)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
