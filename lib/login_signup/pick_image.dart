import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/network/local/cach_helper.dart';

import '../components/end_points.dart';
import '../purple_book/purple_book_screen.dart';
import 'cubit/bloc_cubit.dart';
import 'cubit/bloc_state.dart';

// ignore: must_be_immutable
class PickImage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  PickImage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginSignUpCubit(),
      child: BlocConsumer<LoginSignUpCubit, LoginSignupState>(
        listener: (context, state) {
          //* login success
          if (state is LoginSuccessState) {
            CachHelper.saveData(key: 'token', value: state.logInModel.token)
                .then((value) {
              isAdmin = state.logInModel.isAdmin;
              token = state.logInModel.token;
              userId = state.logInModel.userId;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Signup Successfully')));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const PurpleBookScreen()),
                (route) => false);
          } else if (state is SignupErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                content: Text(state.error.errors![0].msg!)));
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
                          'Pick image',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MsMadi',
                              color: HexColor("#6823D0")),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: cubit.profileImage != null
                                      ? Image(
                                              image: FileImage(
                                                  cubit.profileImage!))
                                          .image
                                      : const AssetImage(
                                          'assets/image/user.jpg'))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: (context_1) =>
                                          buildImagePicker(context));
                                },
                                color: HexColor("#6823D0"),
                                child: const Text(
                                  'Pick Image',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            if (cubit.profileImage != null)
                              const SizedBox(
                                width: 10,
                              ),
                            if (cubit.profileImage != null)
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    cubit.deletePhoto();
                                  },
                                  color: HexColor("#6823D0"),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        ConditionalBuilder(
                          condition: state is! SignupLoadState,
                          builder: (context) => Container(
                            width: double.infinity,
                            color: HexColor("#6823D0"),
                            child: TextButton(
                              onPressed: () {
                                cubit.userSignup(
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    password: password);
                              },
                              child: const Text(
                                'SIGNUP',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          fallback: (context) => Center(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: HexColor("#6823D0"),
                              ),
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

  Widget buildImagePicker(context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                LoginSignUpCubit.get(context)
                    .imageProfile(ImageSource.gallery)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              color: Colors.grey.shade300,
              child: const Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            child: MaterialButton(
              onPressed: () {
                LoginSignUpCubit.get(context)
                    .imageProfile(ImageSource.camera)
                    .then((value) => Navigator.pop(context));
              },
              color: Colors.grey.shade300,
              child: const Text(
                'Camera',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
