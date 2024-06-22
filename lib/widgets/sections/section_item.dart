import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/widgets/sections/section_dialog_form.dart';


class SectionItem extends StatefulWidget {
  const SectionItem({
    super.key,
    required this.section,
    required this.onRefresh
  });

  final void Function()? onRefresh;
  final Section section;

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem> {
  @override
  Widget build(BuildContext context) {

    void showSectionFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  SectionDialogForm(
                      mode: Mode.update,
                      section: widget.section,
                      onRefresh: widget.onRefresh!
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
                      widget.section.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: showSectionFormDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit,
                          size: 16)
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(widget.section.program!),
                ],
              )
            ],
          )
      ),
    );
  }
}
