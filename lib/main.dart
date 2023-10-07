import 'dart:io';
import 'dart:typed_data';

import 'package:calendar_view/calendar_view.dart';
import 'package:edt/src/constants/urls.dart';
import 'package:edt/src/models/event.dart';
import 'package:edt/src/screens/calendar_view.dart';
import 'package:edt/src/services/calendar_sync.dart';
import 'package:edt/src/services/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EdtNotifier(),
      child: MaterialApp(
        title: 'Mon EDT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CalendarView(),
        debugShowCheckedModeBanner: false,
      ),
    );
    //);
  }
}
