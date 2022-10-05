import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purplebook/network/remote/dio_helper.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';

import 'bloc_provider.dart';
import 'components/end_points.dart';
import 'login_sigin/login_screen.dart';
import 'network/local/cach_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CachHelper.init();
  DioHelper.init();
  Widget widget;
  token = CachHelper.getData(key: 'token');
  userId = CachHelper.getData(key: 'userId');
  isAdmin = CachHelper.getData(key: 'isAdmin');
  bool? isDark = CachHelper.getData(key: 'isDark') ?? false;
  if (token != null) {
    widget = const PurpleBookScreen();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    widget: widget,
    isDark: isDark!,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget widget;
  const MyApp({Key? key, required this.isDark, required this.widget})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Tab(icon: Image.asset("assets/image/logo_2.jpg")),
        duration: 3000,
        backgroundColor: HexColor("#6823D0"),
        nextScreen: widget,
      ),
    );
  }
}
