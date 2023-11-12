import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Repositories/UserClient.dart';
import 'createUserView.dart';

class UsersView extends StatefulWidget {
  final UserClient userClient = UserClient();
  final List<User> inUsers;
  UsersView({Key? key, required this.inUsers}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState(inUsers);
}

bool _loading = false;

class _UsersViewState extends State<UsersView> {
  _UsersViewState(users);

  late List<User> users = widget.inUsers;

  void createUser() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateUser()));
    });
  }

  void deleteUser(User user) {
    widget.userClient.DeleteUser(user).then((response) => {getUsers()});
  }

  void getUsers() {
    setState(() {
      _loading = true;
      widget.userClient
          .GetUsersAsync()
          .then((response) => onGetUserSuccess(response));
    });
  }

  void onGetUserSuccess(List<User>? users) {
    setState(() {
      if (users != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UsersView(inUsers: users)));
      }
    });
  }

  showAlertDialog(User user) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: getUsers,
    );
    Widget continueButton = TextButton(
        child: const Text("Continue"), onPressed: () => deleteUser(user));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Are you sure you want to delete user?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("View Users"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((user) {
            return Padding(
              padding: EdgeInsets.all(3),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Username: ${user.username}"),
                      subtitle: Text("Auth Level: ${user.AuthLevel}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text("Update"),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () => showAlertDialog(user),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
