import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glam0/auth/auth.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:glam0/cart.dart';
import 'package:glam0/edit_profile_page.dart';
import 'package:glam0/checkout.dart';
import 'package:glam0/categories.dart';
import 'package:glam0/home/home.dart';
import 'package:glam0/localizations.dart';
import 'package:glam0/product_detail.dart';
import 'package:glam0/settings.dart';
import 'package:glam0/shop/Clothes.dart';
import 'package:glam0/shop/FilterShop.dart';
import 'package:glam0/shop/StoreItems.dart';
import 'package:glam0/shop/shop.dart';
import 'package:glam0/stores.dart';
import 'package:glam0/wishlist.dart';
import 'package:glam0/splash.dart';
import 'package:provider/provider.dart';

import 'checkout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Locale locale = Locale('en');
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // await Categories.init();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider<AuthBlock>.value(value: AuthBlock())],
    child: MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.deepOrange.shade500,
          accentColor: Colors.lightBlue.shade900,
          fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Lato'),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => Splash(),
        '/': (BuildContext context) => Home(),
        '/auth': (BuildContext context) => Auth(),
        '/shop': (BuildContext context) => Shop(),
        '/categorise': (BuildContext context) => Categories(),
        '/wishlist': (BuildContext context) => WishList(),
        '/cart': (BuildContext context) => CartList(),
        '/settings': (BuildContext context) => Settings(),
        '/products': (BuildContext context) => Product(),
        '/Clothes': (BuildContext context) => Clothes(),
        '/checkout': (BuildContext context) => Checkout(),
        '/profile': (BuildContext context) => profile(),
        '/filter': (BuildContext context) => Filter(),
        '/stores': (BuildContext context) => Stores(),
        '/storeItems': (BuildContext context) => StoreItems(),
      },
    ),
  ));
}
