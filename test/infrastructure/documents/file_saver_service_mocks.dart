import 'dart:io';
import 'dart:ui';

import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

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

class FakeFile extends Fake implements File {
  @override
  Future<File> writeAsBytes(List<int>? bytes, {FileMode? mode = FileMode.write, bool? flush = false}) async {
    return this;
  }

  @override
  Future<bool> exists() async {
    return true;
  }
}

class FakeInexistentFile extends Fake implements File {
  @override
  Future<File> writeAsBytes(List<int>? bytes, {FileMode? mode = FileMode.write, bool? flush = false}) async {
    return this;
  }

  @override
  Future<bool> exists() async {
    return false;
  }
}

class FakeDownloadDirectory extends Fake implements Directory {
  @override
  bool existsSync() {
    return true;
  }

  @override
  String get path {
    return '/storage/emulated/0/Download';
  }
}

class MockSharePlatform extends Mock with MockPlatformInterfaceMixin implements SharePlatform {
  @override
  Future<ShareResult> shareXFiles(
    List<XFile?>? files, {
    List<String>? fileNameOverrides,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #shareXFiles,
        [files],
        {#subject: subject, #text: text, #sharePositionOrigin: sharePositionOrigin},
      ),
      returnValue: Future.value(const ShareResult("", ShareResultStatus.success)),
      returnValueForMissingStub: Future.value(const ShareResult("", ShareResultStatus.success)),
    );
  }
}
