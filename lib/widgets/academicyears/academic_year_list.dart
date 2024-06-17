import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/academic_year.dart';
import 'academic_year_item.dart';

class AcademicYearList extends StatelessWidget {
  const AcademicYearList({
    super.key,
    required this.onRemoveAcademicYear,
    required this.academicYears,
    required this.onUpdateList
  });

  final void Function(String id) onRemoveAcademicYear;
  final List<AcademicYear> academicYears;
  final Function() onUpdateList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: academicYears.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                confirmDismiss: (direction) async {
                  if (FirebaseAuth.instance.currentUser?.email != 'admin@gmail.com'){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Deletion Prohibited! Only Super Admin have the Deletion Capabilities"),
                        ));
                    return false;
                  }
                  else{
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
                key: ValueKey(academicYears[index]),
                onDismissed: (direction){
                  onRemoveAcademicYear(academicYears[index].id!);
                },
                child: AcademicYearItem(
                  academicYear: academicYears[index],
                  onUpdateList: onUpdateList,
                )
            )
    );
  }
}
