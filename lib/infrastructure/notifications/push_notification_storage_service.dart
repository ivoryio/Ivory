import 'package:shared_preferences/shared_preferences.dart';

abstract class PushNotificationStorageService {
  Future<void> add(String jsonMessageData);

  Future<void> delete();

  Future<String?> find();
}

class PushNotificationSharedPreferencesStorageService extends PushNotificationStorageService {
  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();
  final String _key = "notificationMessage";

  @override
  Future<void> add(String jsonMessageData) async {
    final sharedPreferences = await _sharedPreferences;
    await sharedPreferences.setString(_key, jsonMessageData);
  }

  @override
  Future<void> delete() async {
    (await _sharedPreferences).remove(_key);
  }

  @override
  Future<String?> find() async {
    final sharedPreferences = await _sharedPreferences;
    sharedPreferences.reload();

    return (sharedPreferences).getString(_key);
  }
}
