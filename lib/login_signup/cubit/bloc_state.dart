import 'package:purplebook/modules/error_module.dart';
import 'package:purplebook/modules/login_module.dart';

abstract class LoginSignupState {}

class InitialLogInState extends LoginSignupState {}

class LoginSuccessState extends LoginSignupState {
  final LogInModule logInModel;

  LoginSuccessState(this.logInModel);
}

class LoginLoadState extends LoginSignupState {}

class LoginErrorState extends LoginSignupState {
  final ErrorModule error;

  LoginErrorState(this.error);
}

class SignupSuccessState extends LoginSignupState {}

class SignupLoadState extends LoginSignupState {}

class SignupErrorState extends LoginSignupState {
  final ErrorModule error;
  SignupErrorState(this.error);
}

class ChangeVisibilityState extends LoginSignupState {}

class GetImageProfileSuccessState extends LoginSignupState {}

class GetImageProfileErrorState extends LoginSignupState {}

class DeletePhotoSuccessState extends LoginSignupState {}
