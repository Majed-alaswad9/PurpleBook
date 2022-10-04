import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purplebook/modules/login_module.dart';
import 'package:purplebook/network/dio_helper.dart';

import '../../components/end_points.dart';
import 'bloc_state.dart';

class LoginSignUpCubit extends Cubit<LogInSIgnUpState> {
  LoginSignUpCubit() : super(InitialLogInState());

  static LoginSignUpCubit get(context) => BlocProvider.of(context);


  IconData iconPassword=Icons.visibility;
  bool isVisible=true;
  void changeVisibility(){
    if(isVisible){
      iconPassword=Icons.visibility_off;
      isVisible=!isVisible;
    }
    else{
      iconPassword=Icons.visibility;
      isVisible=!isVisible;
    }
    emit(ChangeVisibilityState());
  }

  LogInModule? loginModul;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LogInLoadState());
    DioHelper.postData(url: login,  data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModul = LogInModule.fromJson(value.data);
      emit(LogInSuccessState(loginModul!));
    }).catchError((error) {
      emit(LogInErrorState(error.toString()));
    });
  }
}