import 'dart:io';
import 'package:flutter/material.dart' show Size;
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../app_settings.dart';

class TrayService with TrayListener, WindowListener {
  static final TrayService instance = TrayService._();
  TrayService._();

  bool _trayActive = false;

  Future<void> initialize() async {
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) return;

    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(1350, 820));
    await windowManager.setPreventClose(true);
    windowManager.addListener(this);
    appSettings.addListener(_onSettingChanged);

    // Ne pas toucher à trayManager ici — il exige setIcon avant addListener
    if (appSettings.minimizeToTray) await _setupTray();
  }

  void _onSettingChanged() async {
    if (appSettings.minimizeToTray) {
      await _setupTray();
    } else if (_trayActive) {
      trayManager.removeListener(this);
      await trayManager.destroy();
      _trayActive = false;
    }
  }

  Future<void> _setupTray() async {
    if (_trayActive) return;
    // setIcon DOIT être appelé avant addListener sur Windows
    await trayManager.setIcon('windows/runner/resources/concertotheque.ico');
    await trayManager.setToolTip('Concertothèque');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'show', label: 'Ouvrir Concertothèque'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: 'Quitter'),
    ]));
    trayManager.addListener(this);
    _trayActive = true;
  }

  @override
  void onTrayIconMouseDown() => _bringToFront();

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show') _bringToFront();
    if (menuItem.key == 'quit') _quit();
  }

  @override
  void onWindowClose() async {
    if (appSettings.minimizeToTray) {
      await windowManager.hide();
    } else {
      await _quit();
    }
  }

  Future<void> _quit() async {
    await windowManager.destroy();
    exit(0);
  }

  void _bringToFront() async {
    await windowManager.show();
    await windowManager.focus();
  }
}
