
import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/academic_year.dart';

import 'academic_year_dialog_form.dart';

class AcademicYearItem extends StatefulWidget {
  const AcademicYearItem({
    super.key,
    required this.academicYear,
    required this.onUpdateList
  });

  final AcademicYear academicYear;
  final Function() onUpdateList;

  @override
  State<AcademicYearItem> createState() => _AcademicYearItemState();
}

class _AcademicYearItemState extends State<AcademicYearItem> {
  bool isDefault = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDefault = widget.academicYear.isDefault!;
  }

  @override
  Widget build(BuildContext context) {

    void showAcademicYearFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  AcademicYearDialogForm(
                    mode: Mode.update,
                    academicYear: widget.academicYear,
                    onUpdateAcademicYear: widget.onUpdateList,
                  )
                ],
              )
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      '${widget.academicYear.yearStart} - ${widget.academicYear.yearEnd}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Switch(
                      value: isDefault!,
                      onChanged: (value) async {
                        await AcademicYear(
                          context: context,
                          yearStart: widget.academicYear.yearStart!,
                          yearEnd: widget.academicYear.yearEnd!,
                          isDefault: value,
                          id: widget.academicYear!.id!,
                          semester: widget.academicYear.semester!,
                        ).updateAcademicYear();
                        setState(() {
                          isDefault = value;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Academic Year Updated!"),
                        ));
                      }

                  ),
                  Text(isDefault! ? 'Default' : 'Not Default'),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(widget.academicYear.semester!),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: showAcademicYearFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit,
                          size: 16)
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
