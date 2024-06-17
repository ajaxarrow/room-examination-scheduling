import 'package:flutter/material.dart';
import '../../layout/main_layout.dart';
import '../../model/app_user.dart';
import '../../route_guards.dart';
import '../../widgets/users/user_dialog_form.dart';
import '../../widgets/users/user_list.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<AppUser> _users = [];
  final user = AppUser();

  Future<void> fetchUsers() async{
    _users.clear();
    _users = await user.getUsers();

  }

  void _refreshList(){
    setState(() {

    });
  }

  void _openUserDialogForm(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (ctx) => UserDialogForm(
          mode: Mode.create,
          onAddUser: _refreshList,
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUsers(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = Container(
              width: double.infinity,
              child: const Column(
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
                      'There are no available users found. Try adding some!'
                  )
                ],
              ),
            );

            if (_users.isNotEmpty) {
              mainContent = UserList(
                  onRemoveUser: _refreshList,
                  users: _users,
                  onUpdateUserList: _refreshList
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _users.isNotEmpty ?  const Padding(
                    padding: EdgeInsets.only(left:  15, top:  5, bottom:  5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Users',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize:  23
                          ),
                        ),
                      ],
                    )
                ) : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return MainLayout(
            role: Role.admin,
            title: 'Users',
            index: 1,
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: RefreshIndicator(
                  onRefresh: () async{
                    await fetchUsers();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("User List Updated"),
                    ));
                  },
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: body,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: _openUserDialogForm,
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
