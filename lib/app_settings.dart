import 'package:flutter/material.dart';

final AppSettings appSettings = AppSettings();

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _pushNotificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setPushNotificationsEnabled(bool enabled) {
    if (_pushNotificationsEnabled == enabled) return;
    _pushNotificationsEnabled = enabled;
    notifyListeners();
  }
}
