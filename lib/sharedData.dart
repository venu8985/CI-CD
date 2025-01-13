import 'package:get_storage/get_storage.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage _instance = LocalStorage._privateConstructor();
  factory LocalStorage() => _instance;
  final GetStorage _storage = GetStorage('local_storage');
  GetStorage get storage => _storage;
  Future<void> setData(key, value) async {
    await _storage.write(key, value);
  }

  Future<dynamic> getData(key) async {
    return await _storage.read(key);
  }

  Future<void> remove(String key) async {
    await _storage.remove(key);
  }
}
