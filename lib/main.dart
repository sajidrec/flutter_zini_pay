import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:zini_app/app.dart';
import 'package:zini_app/presentation/state_holders/home_page_controller.dart';

const String isolateName = 'background_isolate';
// Port for communication
final ReceivePort port = ReceivePort();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register port
  IsolateNameServer.registerPortWithName(port.sendPort, isolateName);

  DartPluginRegistrant.ensureInitialized();

  port.listen((dynamic message) async {
    if (message is Map) {
      final phoneNumber = message['phoneNumber'];
      final textMessage = message['message'];

      const platform = MethodChannel('com.example.zini_app/sms');
      try {
        await platform.invokeMethod('sendSms', {
          'phoneNumber': phoneNumber,
          'message': textMessage,
        });
      } catch (e) {
        print('Failed to send SMS: $e');
      }
    }
  });

  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: startServe, // This is the background service entry point
      isForegroundMode: true,
      autoStart: true,
    ),
  );
  await service.startService();

  runApp(const ZiniApp());
}
