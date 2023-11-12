import 'package:dio/dio.dart';

import '../Models/AuthResponse.dart';
import '../Models/LoginStructure.dart';
import '../Models/User.dart';
import './DataService.dart';

const String BaseUrl = "https://cmsc2204-mobile-api.onrender.com/Auth";

class UserClient {
  final _dio = Dio(BaseOptions(baseUrl: BaseUrl));
  final DataService _dataService = DataService();

  Future<AuthResponse?> Login(LoginStructure user) async {
    try {
      var response = await _dio.post("/Login",
          data: {"username": user.username, "password": user.password});

      var data = response.data['data'];
      var authResponse = new AuthResponse(data['userId'], data['token']);

      await _dataService.AddItem("token", authResponse.token);

      return authResponse;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<User>?> GetUsersAsync() async {
    try {
      var token = await _dataService.TryGetItem("token");

      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.get("/GetUsers",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }));
        List<User> users = List.empty(growable: true);

        for (var user in response.data) {
          users.add(User(user["_id"], user["Username"], user["Password"],
              user["Email"], user["AuthLevel"]));
        }

        return users;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String> GetApiVersion() async {
    var response = await _dio.get("/ApiVersion");
    return response.data;
  }

  Future<User?> CreateUser(User user) async {
    try {
      var token = await _dataService.TryGetItem("token");

      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.post("/AddUser",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }),
            data: {
              "username": user.username,
              "password": user.password,
              "email": user.email,
              "authLevel": user.AuthLevel
            });

        if (response.statusCode == 200) {
          var userData = response.data;
          return User(userData["_id"], userData["username"],
              userData["password"], userData["email"], userData["authLevel"]);
        } else {
          print(
              "User creation failed with status code: ${response.statusCode}");
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String?> DeleteUser(User user) async {
    try {
      var token = await _dataService.TryGetItem("token");

      if (await _dataService.TryGetItem("token") != null) {
        var response = await _dio.post("/DeleteUserById",
            options: Options(headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            }),
            data: {"id": user.id});

        if (response.statusCode == 200) {
          return "User deleted successfully";
        } else {
          print("Cannot delete user: ${response.statusCode}");
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }
}
