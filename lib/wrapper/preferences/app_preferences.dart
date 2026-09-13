
import 'package:hive/hive.dart';

class AppPreferences{
  late final Box box;
  AppPreferences._privateConstructor() {
    box = Hive.box('rider_tracker');
  }
  static final AppPreferences instance = AppPreferences._privateConstructor();

  Future putValue(String key, dynamic value) {
    return box.put(key, value);
  }

  Future putMultiple(Map<String, dynamic> value) {
    return box.putAll(value);
  }

  Future putAt(int index, dynamic value) {
    return box.putAt(index, value);
  }

  Future remove(String key) {
    return box.delete(key);
  }

  dynamic getValue(String key, {dynamic defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }
  Future<int> clear() {
    return box.clear();
  }

}