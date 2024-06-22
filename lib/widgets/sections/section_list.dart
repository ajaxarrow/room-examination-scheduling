import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/section.dart';
import 'package:roomexaminationschedulingsystem/widgets/sections/section_item.dart';

class SectionList extends StatelessWidget {
  const SectionList({
    super.key,
    required this.onRefresh,
    required this.sections,
    required this.onRemoveSection
  });

  final void Function(String id) onRemoveSection;
  final List<Section> sections;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sections.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
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
                key: ValueKey(sections[index]),
                onDismissed: (direction){
                  onRemoveSection(sections[index].id!);
                },
                child: SectionItem(
                  onRefresh: onRefresh,
                  section: sections[index],
                )
            )
    );
  }
}
