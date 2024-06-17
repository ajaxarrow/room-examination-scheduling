import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/room.dart';

enum Mode{update, create}

class RoomDialogForm extends StatefulWidget {
  const RoomDialogForm({
    super.key,
    required this.mode,
    required this.onRefresh,
    this.room,
  });

  final void Function() onRefresh;
  final Mode mode;
  final Room? room;

  @override
  State<RoomDialogForm> createState() => _RoomDialogFormState();
}

class _RoomDialogFormState extends State<RoomDialogForm> {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String selectedType = 'Lecture Room';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.room != null){
      nameController.text = widget.room!.name!;
      setState(() {
        selectedType = widget.room!.type!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    void addRoom(Room room) async{
      await room.addRoom();
      widget.onRefresh();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Room Added!"),
      ));
    }

    void updateRoom(Room room) async{
      await room.updateRoom();
      widget.onRefresh();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Room Updated!"),
      ));
    }

    void submitRoom() async {
      final isValid = _form.currentState!.validate();
      if (!isValid) {
        return;
      }
      _form.currentState!.save();

      if (widget.mode == Mode.create){
        addRoom(Room(
          context: context,
          type: selectedType,
          name: nameController.text
        ));
      } else {
        updateRoom(Room(
          context: context,
          type: selectedType,
          name: nameController.text,
          id: widget.room!.id!
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child:   Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.mode == Mode.create
                        ? 'Add Room'
                        : 'Update Room',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              const SizedBox(height: 25),
              const Text('Room Name:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Room Name start must not be empty';
                  }
                  return null;
                },
                controller: nameController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter Room Name'
                ),
              ),
              const SizedBox(height: 25),
              const Text('Room Type:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButton(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(
                        value: 'Lecture Room',
                        child: Text('Lecture Room')
                    ),
                    DropdownMenuItem(
                        value: 'Laboratory',
                        child: Text('Laboratory')
                    ),
                    DropdownMenuItem(
                        value: 'Office',
                        child: Text('Office')
                    ),
                    DropdownMenuItem(
                        value: 'Others',
                        child: Text('Others')
                    )
                  ],
                  onChanged: (value){
                    setState(() {
                      selectedType = value!;
                    });
                  }
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffdae2f3),
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff3b5ba9)
                            )
                        )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 19)
                        ),
                        onPressed: submitRoom,
                        child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16
                            )
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
