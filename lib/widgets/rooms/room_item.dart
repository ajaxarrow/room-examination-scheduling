import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/widgets/rooms/room_dialog_form.dart';


class RoomItem extends StatefulWidget {
  const RoomItem({
    super.key,
    required this.room,
    required this.onRefresh
  });

  final void Function()? onRefresh;
  final Room room;

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  @override
  Widget build(BuildContext context) {

    void showRoomFormDialog() {
      showDialog(
          context: context,
          builder: (ctx) =>
              SimpleDialog(
                children: [
                  RoomDialogForm(
                      mode: Mode.update,
                      room: widget.room,
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
                      widget.room.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: showRoomFormDialog,
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
                  Text(widget.room.type!),
                ],
              )
            ],
          )
      ),
    );
  }
}
