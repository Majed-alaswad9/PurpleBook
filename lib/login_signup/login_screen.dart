import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:purplebook/components/const.dart';
import 'package:purplebook/login_signup/cubit/bloc_state.dart';
import 'package:purplebook/login_signup/signup_screen.dart';
import 'package:purplebook/network/local/cach_helper.dart';
import '../components/end_points.dart';
import '../purple_book/purple_book_screen.dart';
import 'cubit/bloc_cubit.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();

  var passController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  Map? userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginSignUpCubit(),
      child: BlocConsumer<LoginSignUpCubit, LoginSignupState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CachHelper.saveData(key: 'token', value: state.logInModel.token)
                .then((value) {
              token = state.logInModel.token;
              userId = state.logInModel.userId;
              isAdmin = state.logInModel.isAdmin;
              CachHelper.saveData(
                  key: 'userId', value: state.logInModel.userId);
              CachHelper.saveData(
                  key: 'isAdmin', value: state.logInModel.isAdmin);
              navigatorAndRemove(
                  widget: const PurpleBookScreen(), context: context);
              showSnackBar(
                  'Login Successfully', context, const Color(0xFF6823D0));
            });
          } else if (state is LoginErrorState) {
            showSnackBar(state.error.errors![0].msg!, context, Colors.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF6823D0),
                title: const Text('purplebook'),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MsMadi',
                                color: Color(0xFF6823D0)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            decoration: InputDecoration(
                                // icon: Icons(Icons.alternate_email),
                                prefixIcon: const Icon(
                                  Icons.alternate_email,
                                  color: Color(0xFF6823D0),
                                ),
                                hintText: 'Email',
                                hintStyle:
                                    Theme.of(context).textTheme.subtitle2,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6823D0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                contentPadding: const EdgeInsets.all(10)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF6823D0),
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    Theme.of(context).textTheme.subtitle2,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF6823D0)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                contentPadding: const EdgeInsets.all(10)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadState,
                            builder: (context) => Container(
                              width: double.infinity,
                              color: const Color(0xFF6823D0),
                              child: TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginSignUpCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passController.text);
                                  }
                                },
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                            fallback: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6823D0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()),
                                  );
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () async {
                                final result = await FacebookAuth.i.login(
                                    permissions: ["public_profile", "email"]);
                                if (result.status == LoginStatus.success) {
                                  print(result.accessToken);
                                } else {
                                  print(result.status.toString());
                                }
                              },
                              child: Text('FaceBook'))
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value!.isNotEmpty) {
      return null;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < 8) {
        return 'Password must be between 8 and 32 characters';
      }
      return null;
    }
    return null;
  }
}
