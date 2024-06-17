import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/widgets/rooms/room_item.dart';

class RoomList extends StatelessWidget {
  const RoomList({
    super.key,
    required this.onRefresh,
    required this.rooms,
    required this.onRemoveRoom
  });

  final void Function(String id) onRemoveRoom;
  final List<Room> rooms;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: rooms.length,
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
                key: ValueKey(rooms[index]),
                onDismissed: (direction){
                  onRemoveRoom(rooms[index].id!);
                },
                child: RoomItem(
                  onRefresh: onRefresh,
                  room: rooms[index],
                )
            )
    );
  }
}
