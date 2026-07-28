import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logger/logger_service.dart';

// shared preferences non sensitive data ke lie like in our case onboarding status
class LocalStorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  LocalStorageService({
    required SharedPreferences prefs,
    FlutterSecureStorage? secureStorage,
  })  : _prefs = prefs,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      AppLogger.error('Failed to set bool for key: $key', 'LocalStorage', e);
      return false;
    }
  }
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      AppLogger.error('Failed to get bool for key: $key', 'LocalStorage', e);
      return defaultValue;
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      AppLogger.error('Failed to set string for key: $key', 'LocalStorage', e);
      return false;
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      AppLogger.error('Failed to get string for key: $key', 'LocalStorage', e);
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      AppLogger.error('Failed to remove key: $key', 'LocalStorage', e);
      return false;
    }
  }

// flutter secure storage
  Future<void> setSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error('Failed to write secure key: $key', 'SecureStorage', e);
    }
  }

  Future<String?> getSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      AppLogger.error('Failed to read secure key: $key', 'SecureStorage', e);
      return null;
    }
  }

  Future<void> deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      AppLogger.error('Failed to delete secure key: $key', 'SecureStorage', e);
    }
  }

  Future<void> clearAllSecure() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', 'SecureStorage', e);
    }
  }
}