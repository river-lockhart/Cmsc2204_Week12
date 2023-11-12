import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataService {
  FlutterSecureStorage SecureStorage = const FlutterSecureStorage();

  ///Stores a string in secure storage
  Future<bool> AddItem(String key, String value) async {
    try {
      await SecureStorage.write(key: key, value: value);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  ///Returns the requested value by key from secure storage
  Future<String?> TryGetItem(String key) async {
    try {
      return await SecureStorage.read(key: key);
    } catch (error) {
      print(error);
      return null;
    }
  }
}
