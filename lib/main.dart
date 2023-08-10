

import 'dart:io';

import 'package:Radiance/common/routes/pages.dart';
import 'package:Radiance/common/style/style.dart';
import 'package:Radiance/common/utils/FirebaseMassagingHandler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart'
    '';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'global.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new PostHttpOverrides();
  await Global.init();
  runApp(const MyApp());
  firebaseChatInit().whenComplete(() => FirebaseMessagingHandler.config());

}

Future firebaseChatInit() async{
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMessagingHandler.firebaseMessagingBackground
  );
  if(GetPlatform.isAndroid){
    FirebaseMessagingHandler.flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(FirebaseMessagingHandler.channel_call);
    FirebaseMessagingHandler.flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(FirebaseMessagingHandler.channel_message);

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,780),
        builder: (context,child)=>GetMaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Radiance',
          theme: AppTheme.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          localizationsDelegates: const[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
    ));
  }
}

