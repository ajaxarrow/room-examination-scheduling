import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/model/mixins/app_user.dart';
import 'package:roomexaminationschedulingsystem/widgets/users/user_dialog_form.dart';

class UserItem extends StatefulWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.onUpdateUserList
  });

  final AppUser user;
  final Function() onUpdateUserList;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool isActive = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isActive = widget.user.isActive!;
  }

  @override
  Widget build(BuildContext context) {

    void openUpdateUserDialog(){
      showDialog(
          context: context,
          builder: (ctx) => SimpleDialog(
        children: [
            UserDialogForm(
            onUpdateUser: widget.onUpdateUserList,
            mode: Mode.update,
            user: widget.user,
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
                      widget.user.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  Text(
                    widget.user.role!
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(widget.user.email!),
                  const Spacer(),
                  Switch(
                      value: isActive!,
                      onChanged: (value) async {
                        await AppUser(
                            uid: widget.user!.uid!,
                            isActive: value,
                            role: widget.user!.role!,
                            name: widget.user!.name!,
                            context: context
                        ).updateUser();
                        setState(() {
                          isActive = value;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("User Updated!"),
                        ));
                      }

                  ),
                  Text(isActive! ? 'Active' : 'Inactive'),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              TextButton.icon(
                  onPressed: openUpdateUserDialog,
                  label: const Text('Edit'),
                  icon: const Icon(Icons.edit_rounded,
                      size: 16)
              )
            ],
          ),
        ),
    );
  }
}
