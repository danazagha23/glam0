import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glam0/auth/auth.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:glam0/cart.dart';
import 'package:glam0/categorise.dart';
import 'package:glam0/home/home.dart';
import 'package:glam0/localizations.dart';
import 'package:glam0/product_detail.dart';
import 'package:glam0/settings.dart';
import 'package:glam0/shop/shop.dart';
import 'package:glam0/wishlist.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Locale locale = Locale('en');
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
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/auth': (BuildContext context) => Auth(),
        '/shop': (BuildContext context) => Shop(),
        '/categorise': (BuildContext context) => Categorise(),
        '/wishlist': (BuildContext context) => WishList(),
        '/cart': (BuildContext context) => CartList(),
        '/settings': (BuildContext context) => Settings(),
        '/products': (BuildContext context) => Products()
      },
    ),
  ));
}
