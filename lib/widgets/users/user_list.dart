import 'package:flutter/material.dart';
import 'package:roomexaminationschedulingsystem/widgets/users/user_item.dart';
import '../../model/mixins/app_user.dart';


class UserList extends StatelessWidget {
  const UserList({
    super.key,
    required this.onRemoveUser,
    required this.users,
    required this.onUpdateUserList
  });

  final Function() onRemoveUser;
  final List<AppUser> users;
  final Function() onUpdateUserList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) =>
            UserItem(
                  user: users[index],
                  onUpdateUserList: onUpdateUserList,
                )
            );
  }
}
