// ignore_for_file: avoid_print, unused_field

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/cubit/state.dart';
import 'package:purplebook/network/remote/dio_helper.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';
import 'cubit/bloc_provider.dart';
import 'components/end_points.dart';
import 'login_signup/login_screen.dart';
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
  bool isDark = CachHelper.getData(key: 'isDark') ?? false;
  if (token != null) {
    widget = const PurpleBookScreen();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(
    widget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget widget;
  const MyApp({Key? key, required this.isDark, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..changeThemeMode(fromShared: isDark),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textTheme: TextTheme(
                    bodyText1: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    bodyText2: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    headline5: const TextStyle(color: Colors.black),
                    caption: const TextStyle(
                        color: Colors.grey, height: 1.5, fontSize: 14),
                    headline4: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                    subtitle1: const TextStyle(color: Colors.black),
                    subtitle2: TextStyle(color: Colors.grey.shade300),
                    headline6: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Color(0xFF6823D0),
                        statusBarIconBrightness: Brightness.light)),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Color(0xFF6823D0),
                    elevation: 10)),
            darkTheme: ThemeData(
                bottomSheetTheme: const BottomSheetThemeData(
                    backgroundColor: Color(0xFF242F3D)),
                dialogTheme:
                    const DialogTheme(backgroundColor: Color(0xFF242F3D)),
                drawerTheme:
                    const DrawerThemeData(backgroundColor: Color(0xFF17212B)),
                popupMenuTheme: const PopupMenuThemeData(
                    color: Color(0xFF242F3D),
                    textStyle: TextStyle(color: Colors.white)),
                scaffoldBackgroundColor: const Color(0xFF0E1621),
                cardColor: const Color(0xFF242F3D),
                listTileTheme: const ListTileThemeData(
                    iconColor: Colors.white, textColor: Colors.white),
                textTheme: TextTheme(
                    caption: const TextStyle(
                        color: Colors.grey, height: 1.5, fontSize: 14),
                    bodyText1: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    bodyText2: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    headline5: const TextStyle(color: Colors.white),
                    headline4: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                    subtitle1: const TextStyle(color: Colors.white),
                    subtitle2: TextStyle(color: Colors.grey.shade300),
                    headline6: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Color(0xFF6823D0),
                        statusBarIconBrightness: Brightness.light)),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Color(0xFF6823D0),
                    backgroundColor: Color(0xFF242F3D),
                    elevation: 10)),
            themeMode: MainCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: Tab(icon: Image.asset("assets/image/logo_2.jpg")),
              duration: 3000,
              backgroundColor: const Color(0xFF6823D0),
              nextScreen: widget,
            ),
          );
        },
      ),
    );
  }
}
