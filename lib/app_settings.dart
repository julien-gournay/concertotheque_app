import 'package:flutter/material.dart';

final AppSettings appSettings = AppSettings();

class AppSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _pushNotificationsEnabled = true;
  bool _minimizeToTray = false;

  ThemeMode get themeMode => _themeMode;
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get minimizeToTray => _minimizeToTray;

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

  void setMinimizeToTray(bool enabled) {
    if (_minimizeToTray == enabled) return;
    _minimizeToTray = enabled;
    notifyListeners();
  }
}
