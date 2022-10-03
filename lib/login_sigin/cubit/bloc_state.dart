import 'package:purplebook/modules/login_module.dart';

abstract class LogInSIgnUpState{}

class InitialLogInState extends LogInSIgnUpState{}

class LogInSuccessState extends LogInSIgnUpState{
  final LogInModule logInModel;

  LogInSuccessState(this.logInModel);
}
class LogInLoadState extends LogInSIgnUpState{}
class LogInErrorState extends LogInSIgnUpState{
  final String error;

  LogInErrorState(this.error);
}

class ChangeVisibilityState extends LogInSIgnUpState{}