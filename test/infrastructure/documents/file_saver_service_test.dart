import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';

import '../../setup/platform.dart';

class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {
  @override
  Future<void> show(
    int? id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {
    return super.noSuchMethod(
      Invocation.method(#show, [id, title, body, notificationDetails, payload]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockDirectory extends Mock implements Directory {
  @override
  bool existsSync() {
    return super.noSuchMethod(
      Invocation.method(#existsSync, []),
      returnValue: true,
      returnValueForMissingStub: true,
    );
  }

  @override
  String get path {
    return super.noSuchMethod(
      Invocation.getter(#path),
      returnValue: '',
      returnValueForMissingStub: '',
    );
  }
}

class MockFile extends Mock implements File {
  @override
  Future<File> writeAsBytes(List<int>? bytes, {FileMode? mode = FileMode.write, bool? flush = false}) {
    return super.noSuchMethod(
      Invocation.method(#writeAsBytes, [bytes], {#mode: mode, #flush: flush}),
      returnValue: Future<File>.value(File('')),
      returnValueForMissingStub: Future<File>.value(File('')),
    );
  }

  @override
  Future<bool> exists() {
    return super.noSuchMethod(
      Invocation.method(#exists, []),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
  });

  group('saveFile', () {
    test('should write local file and show notification on Android', () async {
      // given
      setPlatformOverride(TargetPlatform.android);

      final fileSaverService = FileSaverService();
      fileSaverService.flutterLocalNotificationsPlugin = mockFlutterLocalNotificationsPlugin;

      final mockDirectory = MockDirectory();
      final mockFile = MockFile();

      when(mockDirectory.path).thenReturn('/storage/emulated/0/Download');
      when(mockDirectory.existsSync()).thenReturn(true);
      when(mockFile.exists()).thenAnswer((_) async => true);
      when(mockFile.writeAsBytes(any)).thenAnswer((_) async => mockFile);

      const name = 'document';
      const ext = 'pdf';
      final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);

      String? usedFilePath;

      IOOverrides.runZoned(
        () async {
          // when
          await fileSaverService.saveFile(name: name, ext: ext, bytes: bytes);

          // then
          verify(mockFlutterLocalNotificationsPlugin.show(
            name.hashCode,
            'File downloaded',
            'File is in your Downloads folder',
            any,
          ));
        },
        createDirectory: (String path) => mockDirectory,
        createFile: (String path) {
          usedFilePath = path;
          return mockFile;
        },
      );
    });
  });
}
