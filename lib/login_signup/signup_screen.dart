import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purplebook/components/const.dart';
import 'package:purplebook/login_signup/cubit/bloc_cubit.dart';
import 'package:purplebook/login_signup/pick_image.dart';

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
    return BlocProvider(
      create: (context) => LoginSignUpCubit(),
      child: BlocConsumer<LoginSignUpCubit, LoginSignupState>(
        listener: (context, state) {},
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
                          'Sign Up',
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
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          validator: validateFirstName,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFF6823D0),
                              ),
                              hintText: 'First Name',
                              hintStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle2,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6823D0)),
                                borderRadius: BorderRadius.all(
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
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFF6823D0),
                              ),
                              hintText: 'Last Name',
                              hintStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle2,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6823D0)),
                                borderRadius: BorderRadius.all(
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
                              prefixIcon: const Icon(
                                Icons.alternate_email,
                                color: Color(0xFF6823D0),
                              ),
                              hintText: 'Email',
                              hintStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle2,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6823D0)),
                                borderRadius: BorderRadius.all(
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
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF6823D0),
                              ),
                              hintText: 'Password',
                              hintStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle2,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6823D0)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              contentPadding: const EdgeInsets.all(10)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xFF6823D0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))),
                          child: TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                navigatorPush(context: context,
                                    widget: PickImage(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: passController.text));
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
