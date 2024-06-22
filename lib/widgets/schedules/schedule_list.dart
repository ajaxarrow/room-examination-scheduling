import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
import 'package:roomexaminationschedulingsystem/main.dart';
import 'package:roomexaminationschedulingsystem/model/app_user.dart';
import 'package:roomexaminationschedulingsystem/model/schedule.dart';
import 'package:roomexaminationschedulingsystem/widgets/schedules/schedule_item.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required this.onRefresh,
    required this.role,
    required this.schedules,
    required this.onRemoveSchedule,
  });

  final void Function(String id) onRemoveSchedule;
  final List<Schedule> schedules;
  final Role role;
  final Function() onRefresh;



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                confirmDismiss: (direction) async {
                  final id = FirebaseAuth.instance.currentUser?.uid!;
                  final user = await AppUser().getUserById(id!);
                  if(user.role == 'faculty'){
                    if (id != schedules[index].facultyID){
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text("Deletion Prohibited! You cannot delete someone's schedule"),
                          ));
                      return false;
                    }
                    else{
                      return true;
                    }
                  } else {
                    return true;
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.error.withOpacity(0.85),
                  ),

                  margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16
                  ),

                ),
                key: ValueKey(schedules[index]),
                onDismissed: (direction){
                  onRemoveSchedule(schedules[index].id!);
                },
                child: ScheduleItem(
                  schedule: schedules[index],
                  onRefresh: onRefresh,
                  role: role
                )
            )
    );
  }
}
