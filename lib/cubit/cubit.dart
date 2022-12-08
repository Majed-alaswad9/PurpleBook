import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purplebook/cubit/state.dart';

import '../network/local/cach_helper.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(InitialCubitState());

  static MainCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeThemeModeState());
    } else {
      isDark = !isDark;
      CachHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ChangeThemeModeState());
      });
    }
  }
}
