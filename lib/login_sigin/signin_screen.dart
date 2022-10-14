import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/components/end_points.dart';
import 'package:purplebook/login_sigin/cubit/bloc_cubit.dart';
import 'package:purplebook/login_sigin/pick_image.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';

import 'cubit/bloc_state.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        return BlocProvider(
          create: (context) => LoginSignUpCubit(),
          child: BlocConsumer<LoginSignUpCubit, LoginSignupState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                isAdmin = state.logInModel.isAdmin;
                token = state.logInModel.token;
                userId = state.logInModel.userId;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Signup Successfully')));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurpleBookScreen()),
                    (route) => false);
              } else if (state is SignupErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('❌ Signup Failed')));
              }
            },
            builder: (context, state) {
              var cubit = LoginSignUpCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: HexColor("#6823D0"),
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
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'MsMadi',
                                  color: HexColor("#6823D0")),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: firstNameController,
                              keyboardType: TextInputType.name,
                              validator: validateFirstName,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: HexColor("#6823D0"),
                                  ),
                                  hintText: 'First Name',
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle2,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#6823D0")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  contentPadding: const EdgeInsets.all(10)),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: lastNameController,
                              keyboardType: TextInputType.name,
                              validator: validateLastName,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: HexColor("#6823D0"),
                                  ),
                                  hintText: 'Last Name',
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle2,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#6823D0")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  contentPadding: const EdgeInsets.all(10)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.alternate_email,
                                    color: HexColor("#6823D0"),
                                  ),
                                  hintText: 'Email',
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle2,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#6823D0")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
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
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: HexColor("#6823D0"),
                                  ),
                                  hintText: 'Password',
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle2,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor("#6823D0")),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0)),
                                  ),
                                  contentPadding: const EdgeInsets.all(10)),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: HexColor("#6823D0"),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: TextButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PickImage(
                                                firstName:
                                                    firstNameController.text,
                                                lastName:
                                                    lastNameController.text,
                                                email: emailController.text,
                                                password:
                                                    passController.text)));
                                  }
                                },
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'There are no bottons to push :)',
            ),
            Text(
              'Just turn off your internet.',
            )
          ]),
    );
  }

  String? validateEmail(String? value) {
    if (value!.isNotEmpty) {
      return null;
    }
    return 'should be a valid email format and not used before';
  }

  String? validatePassword(String? value) {
    if (value != null) {
      if (value.length >= 8) {
        return null;
      }
      return 'between 8 and 32 characters';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value!.length > 20 || value.isNotEmpty) {
      return null;
    }
    return 'should be in english and not more than 20 characters ';
  }

  String? validateLastName(String? value) {
    if (value!.length > 20 || value.isNotEmpty) {
      return null;
    }
    return 'should be in english and not more than 20 characters ';
  }
}
