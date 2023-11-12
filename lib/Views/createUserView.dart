import 'package:flutter/material.dart';

import '../Models/User.dart';
import '../Repositories/UserClient.dart';
import 'usersView.dart';

class CreateUser extends StatefulWidget {
  final UserClient userClient = UserClient();
  CreateUser({super.key});

  @override
  State<CreateUser> createState() => _createUserState();
}

bool _loading = false;

class _createUserState extends State<CreateUser> {
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var emailController = new TextEditingController();
  var authLevelController = new TextEditingController();

  void createUser() {
    setState(() {
      User user = User(null, usernameController.text, passwordController.text,
          emailController.text, authLevelController.text);

      widget.userClient
          .CreateUser(user)
          .then((response) => {onUserCreated(response)});
    });
  }

  void onUserCreated(var response) {
    getUsers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create User"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Enter New User Info"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                            controller: usernameController,
                            decoration:
                                const InputDecoration(hintText: "Username")))
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(hintText: "Password")))
                ]),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: "Email")))
                ]),
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: authLevelController,
                          decoration: const InputDecoration(
                              hintText: "AuthLevel(Instructor or Student)")))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: createUser, child: const Text("Create"))
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
