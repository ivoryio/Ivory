import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';

class FileSaverService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> saveFile({required String name, String? ext, required Uint8List bytes, String? mimeType}) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Open the share sheet. This has option to save to files
      final xFile = XFile.fromData(bytes, name: name, mimeType: mimeType);
      Share.shareXFiles([xFile]);
    } else {
      try {
        await _writeLocalFile(name: name, extension: ext!, bytes: bytes);

        flutterLocalNotificationsPlugin.show(
          name.hashCode,
          'File downloaded',
          'File is in your Downloads folder',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              highImportanceChannelId,
              highImportanceChannelId,
            ),
          ),
        );
      } catch (error) {
        if (error is FileAlreadyExistsException) {
          log("File already exists");

          flutterLocalNotificationsPlugin.show(
            name.hashCode,
            'File download failed',
            'File already exists',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                highImportanceChannelId,
                highImportanceChannelId,
              ),
            ),
          );
          return;
        }

        flutterLocalNotificationsPlugin.show(
          name.hashCode,
          'File download failed',
          'Please try again',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              highImportanceChannelId,
              highImportanceChannelId,
            ),
          ),
        );
      }
    }
  }
}

Future<void> _writeLocalFile({required String name, required String extension, required Uint8List bytes}) async {
  Directory downloadDirectory = Directory('/storage/emulated/0/Download');
  if (!downloadDirectory.existsSync()) {
    downloadDirectory = Directory('/storage/emulated/0/Downloads');
  }

  final path = downloadDirectory.path;
  final fileObject = File('$path/$name.$extension');

  if (await fileObject.exists()) {
    log("File already exists");
    throw FileAlreadyExistsException();
  }

  final file = await fileObject.writeAsBytes(bytes);

  if (!(await file.exists())) {
    log("File not saved");
    throw FileNotSavedException();
  }
}

class FileAlreadyExistsException implements Exception {}

class FileNotSavedException implements Exception {}
