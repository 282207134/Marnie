import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'state/shop_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfff2f2f2),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final preferences = await SharedPreferences.getInstance();
  runApp(MarnieApp(state: ShopState(preferences)));
}
