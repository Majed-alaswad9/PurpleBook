import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purplebook/cubit/state.dart';

import '../network/local/cach_helper.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(InitialCubitState());

  static MainCubit get(context) => BlocProvider.of(context);

  IconData darkMode = Icons.light_mode;
  bool isDark = false;
  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      darkMode = fromShared ? Icons.dark_mode : Icons.light_mode;
      print('from sharde $fromShared');
      emit(ChangeThemeModeState());
    } else {
      print(isDark);
      isDark = !isDark;
      darkMode = isDark ? Icons.dark_mode : Icons.light_mode;
      print('else $isDark');
      CachHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ChangeThemeModeState());
      });
    }
  }
}
