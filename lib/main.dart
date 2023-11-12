import 'package:flutter/material.dart';
import 'package:lockhart_api_integration/Models/AuthResponse.dart';

import 'Models/LoginStructure.dart';
import 'Models/User.dart';
import 'Repositories/UserClient.dart';
import 'Views/usersView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Lockhart Week 12'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final UserClient userClient = UserClient();

  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool _loading = false;

class _MyHomePageState extends State<MyHomePage> {
  String apiVersion = "";

  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loading = true;

    widget.userClient
        .GetApiVersion()
        .then((response) => {setApiVersion(response)});
  }

  void onLoginButtonPress() {
    setState(() {
      _loading = true;

      LoginStructure user =
          LoginStructure(usernameController.text, passwordController.text);

      widget.userClient
          .Login(user)
          .then((response) => {onLoginCallCompleted(response)});
    });
  }

  void onLoginCallCompleted(var response) {
    if (response == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Failed")));
    } else {
      getUsers();
    }

    setState(() {
      _loading = false;
    });
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

  void setApiVersion(String version) {
    setState(() {
      _loading = false;
      apiVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Enter Credentials"),
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: onLoginButtonPress, child: const Text("Login"))
                ]),
              ],
            ),
            _loading
                ? const Column(
                    children: [CircularProgressIndicator(), Text("Loading...")])
                : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Api Version: $apiVersion"),
                  ])
          ],
        ),
      ),
    );
  }
}
