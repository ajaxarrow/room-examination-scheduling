import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';
import 'package:roomexaminationschedulingsystem/widgets/rooms/room_dialog_form.dart';
import 'package:roomexaminationschedulingsystem/widgets/rooms/room_list.dart';
import '../../layout/main_layout.dart';
import '../../route_guards.dart';
import 'package:roomexaminationschedulingsystem/enums/roles.enum.dart';
class AdminRoomsView extends StatefulWidget {
  const AdminRoomsView({super.key});

  @override
  State<AdminRoomsView> createState() => _AdminRoomsViewState();
}

class _AdminRoomsViewState extends State<AdminRoomsView> {
  List<Room> _rooms = [];

  Future<void> fetchRooms() async {
    _rooms.clear();
    _rooms = await Room().getRooms();
  }

  void _refreshList(){
    print('called');
    setState(() {

    });
  }

  void _removeRoom(String id) async {
    await Room(id: id).deleteRoom();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Room Deleted!"),
        )
    );
  }

  void showRoomFormDialog() {
    showDialog(
      context: context,
      builder: (ctx) =>
        SimpleDialog(
          children: [
            RoomDialogForm(
              mode: Mode.create,
              onRefresh: _refreshList
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchRooms(),
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
                      'There are no rooms added.'
                  )
                ],
              ),
            );

            if (_rooms.isNotEmpty) {
              mainContent = RoomList(
                onRefresh: _refreshList,
                rooms: _rooms,
                onRemoveRoom: _removeRoom
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _rooms.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15,  bottom:  5),
                  child: Text(
                    'Rooms',
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
            role: Role.admin,
            title: 'Rooms',
            index: 3,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchRooms();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Room List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: showRoomFormDialog,
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
