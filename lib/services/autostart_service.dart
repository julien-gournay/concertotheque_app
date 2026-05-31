import 'dart:io';

class AutostartService {
  static const _appName = 'Concertothèque';
  static const _regPath =
      r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run';

  static Future<bool> isEnabled() async {
    if (!Platform.isWindows) return false;
    final result = await Process.run(
      'reg',
      ['query', _regPath, '/v', _appName],
    );
    return result.exitCode == 0;
  }

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isWindows) return;
    if (enabled) {
      final exe = Platform.resolvedExecutable;
      await Process.run('reg', [
        'add', _regPath, '/v', _appName,
        '/t', 'REG_SZ', '/d', exe, '/f',
      ]);
    } else {
      await Process.run('reg', [
        'delete', _regPath, '/v', _appName, '/f',
      ]);
    }
  }
}
