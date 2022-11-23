import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/modules/error_module.dart';
import 'package:purplebook/modules/login_module.dart';
import 'package:purplebook/modules/signup_module.dart';
import 'package:purplebook/network/remote/dio_helper.dart';

import '../../components/end_points.dart';
import 'bloc_state.dart';

class LoginSignUpCubit extends Cubit<LoginSignupState> {
  LoginSignUpCubit() : super(InitialLogInState());

  static LoginSignUpCubit get(context) => BlocProvider.of(context);

  IconData iconPassword = Icons.visibility;
  bool isVisible = true;
  void changeVisibility() {
    if (isVisible) {
      iconPassword = Icons.visibility_off;
      isVisible = !isVisible;
    } else {
      iconPassword = Icons.visibility;
      isVisible = !isVisible;
    }
    emit(ChangeVisibilityState());
  }

  LogInModule? loginModule;
  ErrorModule? loginError;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadState());
    DioHelper.postData(url: login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModule = LogInModule.fromJson(value.data);
      emit(LoginSuccessState(loginModule!));
    }).catchError((error) {
      loginError = ErrorModule.fromJson(error.response!.data);
      emit(LoginErrorState(loginError!));
    });
  }

  SignupModule? signupModule;
  void userSignup(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) {
    emit(SignupLoadState());
    FormData formData = FormData.fromMap({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "profilePicture": profileImage != null
          ? MultipartFile.fromFileSync(profileImage!.path)
          : null
    });
    DioHelper.postFormData(url: signup, data: formData).then((value) {
      signupModule = SignupModule.fromJson(value.data);
      userLogin(email: email, password: password);
      emit(SignupSuccessState());
    }).catchError((error) {
      loginError = ErrorModule.fromJson(error.response!.data);
      emit(SignupErrorState(loginError!));
    });
  }

  File? profileImage;
  final ImagePicker _imagePicker = ImagePicker();
  Future imageProfile(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      profileImage = File(image.path);
      emit(GetImageProfileSuccessState());
    } else {
      emit(GetImageProfileErrorState());
    }
  }

  void deletePhoto() {
    profileImage = null;
    emit(DeletePhotoSuccessState());
  }
}
