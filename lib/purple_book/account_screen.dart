import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/login_sigin/login_screen.dart';
import 'package:purplebook/modules/comment_likes_module.dart';
import 'package:purplebook/modules/user_comments_module.dart';
import 'package:purplebook/modules/user_friends_module.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import 'package:purplebook/purple_book/view_list_image.dart';
import 'package:purplebook/purple_book/view_string_image.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';

import '../components/const.dart';
import '../components/end_points.dart';
import '../modules/likes_module.dart';

// ignore: must_be_immutable
class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var editPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        return Stack(
          fit: StackFit.expand,
          children: [
            if (!connected)
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: const Color(0xFFEE4400),
                  child: const Center(
                    child: Text('OFFLINE'),
                  ),
                ),
              ),
            BlocProvider(
              create: (context) => PurpleBookCubit()
                ..getUserProfile(id: userId!)
                ..getUserPosts(userId: userId!),
              child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
                listener: (context, state) {
                  if (state is UpdateUserProfileSuccessState) {
                    showMsg(
                        msg: '✅ Update Successfully',
                        color: ColorMsg.inCorrect);
                  } else if (state is UpdateUserProfileErrorState) {
                    showMsg(msg: '❌ Update Failed', color: ColorMsg.error);
                  }

                  if (state is DeleteUserSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('✅ Delete Account Successfully')));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  } else if (state is DeleteUserErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('❌ Delete Account Failed')));
                  }

                  if (state is PostDeleteSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Deleted Successfully'),
                    ));
                  } else if (state is PostDeleteErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('❌ Deleted Failed'),
                    ));
                  }

                  if (state is EditUserPostSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Editing Successfully'),
                    ));
                  } else if (state is EditUserPostErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('❌ Editing Failed'),
                    ));
                  }
                  if (state is UpdateUserProfileSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Editing Successfully'),
                    ));
                  } else if (state is UpdateUserProfileErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('❌ Editing Failed'),
                    ));
                  }

                  if (state is CancelFriendSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Cancel Successfully'),
                    ));
                  } else if (state is CancelFriendErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('❌ Cancel Failed'),
                    ));
                  }
                },
                builder: (context, state) {
                  var cubit = PurpleBookCubit.get(context);
                  return ConditionalBuilder(
                    condition: cubit.userProfile != null,
                    builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.all(10)),
                          if (state is UpdateUserProfileLoadingState)
                            LinearProgressIndicator(
                              color: HexColor("#6823D0"),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: MainCubit.get(context).isDark
                                ? HexColor("#242F3D")
                                : Colors.grey.shade300,
                            child: Column(
                              children: [
                                Center(
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: HexColor("#6823D0"),
                                        radius: 90,
                                        child: InkWell(
                                          onTap: () {
                                            if (cubit
                                                .userProfile!
                                                .user!
                                                .imageFull!
                                                .data!
                                                .data!
                                                .isNotEmpty) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewListImage(
                                                              image: cubit
                                                                  .userProfile!
                                                                  .user!
                                                                  .imageFull!
                                                                  .data!
                                                                  .data!)));
                                            }
                                          },
                                          child: CircleAvatar(
                                            radius: 85,
                                            backgroundImage: cubit
                                                        .profileImage ==
                                                    null
                                                ? Image.memory(
                                                        Uint8List.fromList(cubit
                                                            .userProfile!
                                                            .user!
                                                            .imageFull!
                                                            .data!
                                                            .data!))
                                                    .image
                                                : Image(
                                                        image: FileImage(cubit
                                                            .profileImage!))
                                                    .image,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: HexColor("#6823D0"),
                                        radius: 25,
                                        child: IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                                  builder: (context_1) =>
                                                      buildImagePicker(
                                                          context));
                                            },
                                            icon: const Icon(
                                                Icons.camera_alt_outlined)),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if (cubit.profileImage != null)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 7,
                                          color: HexColor("#6823D0"),
                                          child: MaterialButton(
                                            onPressed: () {
                                              firstNameController.text = cubit
                                                  .userProfile!
                                                  .user!
                                                  .firstName!;
                                              lastNameController.text = cubit
                                                  .userProfile!.user!.lastName!;
                                              cubit.editUserProfile(
                                                  id: userId!,
                                                  firstName:
                                                      firstNameController.text,
                                                  lastName:
                                                      lastNameController.text);
                                            },
                                            child: const Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 7,
                                          color: HexColor("#6823D0"),
                                          child: MaterialButton(
                                            onPressed: () {
                                              cubit.deletePhotoProfile();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundColor: HexColor("#6823D0"),
                                        child: IconButton(
                                          onPressed: () {
                                            firstNameController.text = cubit
                                                .userProfile!.user!.firstName!;
                                            lastNameController.text = cubit
                                                .userProfile!.user!.lastName!;
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context_2) =>
                                                        AlertDialog(
                                                            title: const Text(
                                                                'Edit Name'),
                                                            elevation: 10,
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                TextFormField(
                                                                  controller:
                                                                      firstNameController,
                                                                  maxLines: 2,
                                                                  minLines: 1,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  decoration: InputDecoration(
                                                                      label: const Text('First Name'),
                                                                      labelStyle: TextStyle(color: HexColor("#6823D0")),
                                                                      hintStyle: Theme.of(context).textTheme.subtitle2,
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: HexColor("#6823D0")),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      contentPadding: const EdgeInsets.all(10)),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      lastNameController,
                                                                  maxLines: 2,
                                                                  minLines: 1,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  decoration: InputDecoration(
                                                                      label: const Text('Last Name'),
                                                                      labelStyle: TextStyle(color: HexColor("#6823D0")),
                                                                      hintStyle: Theme.of(context).textTheme.subtitle2,
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: HexColor("#6823D0")),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      contentPadding: const EdgeInsets.all(10)),
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context_2,
                                                                      'Cancel');
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  cubit.editUserProfile(
                                                                      id:
                                                                          userId!,
                                                                      firstName:
                                                                          firstNameController
                                                                              .text,
                                                                      lastName:
                                                                          lastNameController
                                                                              .text);
                                                                  Navigator.pop(
                                                                      context_2,
                                                                      'Update');
                                                                },
                                                                child: Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                      color: HexColor(
                                                                          "#6823D0")),
                                                                ),
                                                              )
                                                            ]));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 14,
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 1.5,
                                    color: HexColor("#6823D0"),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          color: Colors.red,
                                          width: double.infinity,
                                          child: MaterialButton(
                                            onPressed: () {
                                              showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      AlertDialog(
                                                          title: const Text(
                                                              'Delete account'),
                                                          content: const Text(
                                                              'Are you sure yoo delete your account'),
                                                          elevation: 10,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: HexColor(
                                                                        "#6823D0")),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                cubit
                                                                    .deleteUser();
                                                                Navigator.pop(
                                                                    context,
                                                                    'Yes');
                                                              },
                                                              child: const Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                            ),
                                                          ]));
                                            },
                                            child: const Text(
                                              'Delete Account',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              elevation: cubit.indexWidget == 0
                                                  ? 10
                                                  : 0,
                                              color: cubit.indexWidget == 0
                                                  ? HexColor("#6823D0")
                                                  : Colors.white,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  cubit.getUserPosts(
                                                      userId: userId!);
                                                  cubit.indexWidget = 0;
                                                },
                                                child: Text(
                                                  'Posts',
                                                  style: TextStyle(
                                                    color:
                                                        cubit.indexWidget == 0
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              elevation: cubit.indexWidget == 1
                                                  ? 10
                                                  : 0,
                                              color: cubit.indexWidget == 1
                                                  ? HexColor("#6823D0")
                                                  : Colors.white,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  cubit.getUserComments(
                                                      id: userId!);
                                                  cubit.indexWidget = 1;
                                                },
                                                child: Text(
                                                  'Comments',
                                                  style: TextStyle(
                                                    color:
                                                        cubit.indexWidget == 1
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              elevation: cubit.indexWidget == 2
                                                  ? 10
                                                  : 0,
                                              color: cubit.indexWidget == 2
                                                  ? HexColor("#6823D0")
                                                  : Colors.white,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  cubit.getUSerFriends(
                                                      id: userId!);
                                                  cubit.indexWidget = 2;
                                                },
                                                child: Text(
                                                  'Friends',
                                                  style: TextStyle(
                                                    color:
                                                        cubit.indexWidget == 2
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (cubit.indexWidget == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButton(
                                      style: TextStyle(
                                          color: MainCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black),
                                      items: [
                                        DropdownMenuItem(
                                          value: "date",
                                          child: Text(
                                            'date',
                                            style: TextStyle(
                                                color: MainCubit.get(context)
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Most liked",
                                          child: Text(
                                            'Most Liked',
                                            style: TextStyle(
                                                color: MainCubit.get(context)
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ],
                                      dropdownColor:
                                          MainCubit.get(context).isDark
                                              ? HexColor("#242F3D")
                                              : Colors.white,
                                      value: cubit.dropDownValue,
                                      onChanged: (value) {
                                        cubit.dropDownValue = value!;
                                        if (value == 'date') {
                                          cubit.getUserPosts(
                                              userId: userId!, sort: 'date');
                                        } else {
                                          cubit.getUserPosts(
                                              userId: userId!, sort: 'likes');
                                        }
                                      }),
                                ),

                                ConditionalBuilder(
                                  builder: (context) => userPosts(context),
                                  condition: cubit.userPost != null && cubit.likesUserCount!.isNotEmpty,
                                  fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                        color: HexColor("#6823D0")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (!cubit.isEndUserPost)
                                  ConditionalBuilder(
                                    condition:
                                        state is! GetMoreUserPostLoadingState,
                                    fallback: (context) =>
                                        CircularProgressIndicator(
                                      color: HexColor("#6823D0"),
                                    ),
                                    builder: (context) => Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: HexColor("#6823D0"),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: TextButton(
                                        onPressed: () {
                                          cubit.getMoreUserPosts(
                                              userId: userId!);
                                        },
                                        child: const Text(
                                          'Show More',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          else if (cubit.indexWidget == 1)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: DropdownButton(
                                      style: TextStyle(
                                          color: MainCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black),
                                      items: [
                                        DropdownMenuItem(
                                          value: "date",
                                          child: Text(
                                            'date',
                                            style: TextStyle(
                                                color: MainCubit.get(context)
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Most liked",
                                          child: Text(
                                            'Most Liked',
                                            style: TextStyle(
                                                color: MainCubit.get(context)
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ],
                                      dropdownColor:
                                          MainCubit.get(context).isDark
                                              ? HexColor("#242F3D")
                                              : Colors.white,
                                      value: cubit.dropDownValue,
                                      onChanged: (value) {
                                        cubit.dropDownValue = value!;
                                        if (value == 'date') {
                                          cubit.getUserComments(
                                              id: userId!, sort: 'date');
                                        } else {
                                          cubit.getUserComments(
                                              id: userId!, sort: 'likes');
                                        }
                                      }),
                                ),

                                ConditionalBuilder(
                                  builder: (context) => userComments(
                                      context,
                                      PurpleBookCubit.get(context)
                                          .userComments),
                                  condition: cubit.userComments != null && cubit.likeCommentCount!.isNotEmpty,
                                  fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                        color: HexColor("#6823D0")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (!cubit.isEndUserComments)
                                  ConditionalBuilder(
                                    condition: state
                                        is! GetMoreUserCommentsLoadingState,
                                    fallback: (context) => Center(
                                      child: CircularProgressIndicator(
                                        color: HexColor("#6823D0"),
                                      ),
                                    ),
                                    builder: (context) => Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: HexColor("#6823D0"),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: TextButton(
                                        onPressed: () {
                                          cubit.getMoreUserComments(
                                              id: userId!);
                                        },
                                        child: const Text(
                                          'Show More',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          else
                            ConditionalBuilder(
                              condition: cubit.userFriends != null,
                              builder: (context) => userFriend(context,
                                  PurpleBookCubit.get(context).userFriends),
                              fallback: (context) => buildFoodShimmer(),
                            )
                        ],
                      ),
                    ),
                    fallback: (context) => Center(
                        child: CircularProgressIndicator(
                      color: HexColor("#6823D0"),
                    )),
                  );
                },
              ),
            ),
          ],
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

  //* build Widget user comments
  Widget userComments(context_1, UserCommentsModule? comment) =>
      ConditionalBuilder(
          condition: comment!.comments != null &&
              PurpleBookCubit.get(context_1).isLikeComment!.isNotEmpty,
          builder: (context) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                  elevation: 10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPostScreen.focusComment(
                                          id: comment
                                              .comments![index].post!.sId!,
                                          addComent: false,
                                          isFocus: true,
                                          idComment:
                                              comment.comments![index].sId,
                                        )));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'on ${comment.comments![index].post!.postAuthorFirstName!}\'s',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '"',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                parseFragment(comment
                                        .comments![index].post!.contentPreview)
                                    .text!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.grey, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '"',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                parseFragment(comment.comments![index].content)
                                    .text!,
                                maxLines: 3,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                PurpleBookCubit.get(context).likeComment(
                                    postId: comment.comments![index].post!.sId!,
                                    commentId: comment.comments![index].sId!,
                                    index: index);
                                PurpleBookCubit.get(context)
                                    .changeLikeComment(index);
                              },
                              icon: const Icon(Icons.thumb_up_alt_outlined),
                              color: PurpleBookCubit.get(context)
                                      .isLikeComment![index]
                                  ? HexColor("#6823D0")
                                  : Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (PurpleBookCubit.get(context)
                                    .likeCommentCount![index] !=
                                0)
                              InkWell(
                                onTap: () {
                                  showMsg(
                                      msg: 'Just a second',
                                      color: ColorMsg.inCorrect);
                                  PurpleBookCubit.get(context)
                                      .getLikeComments(
                                          commentId:
                                              comment.comments![index].sId!,
                                          postId: comment
                                              .comments![index].post!.sId!)
                                      .then((value) {
                                    showModalBottomSheet(
                                        context: context_1,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: (context) =>
                                            ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) =>
                                                    buildLikesComment(
                                                        PurpleBookCubit.get(
                                                                context_1)
                                                            .commentLikes!,
                                                        index,
                                                        context_1),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                itemCount: PurpleBookCubit.get(
                                                        context_1)
                                                    .commentLikes!
                                                    .users!
                                                    .length));
                                  });
                                },
                                child: Text(
                                  '${PurpleBookCubit.get(context).likeCommentCount![index]} like',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Colors.grey, fontSize: 15),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: comment.comments!.length,
              ),
          fallback: (context) => Center(
                child: Text('No Comments Yet (•_•)',
                    style: Theme.of(context).textTheme.headline4),
              ));

  //* build Widget user posts
  Widget userPosts(context) => ConditionalBuilder(
        condition: PurpleBookCubit.get(context).userPost!.posts!.isNotEmpty,
        builder: (context) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => buildUserPost(
                PurpleBookCubit.get(context).userPost, index, context),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: PurpleBookCubit.get(context).userPost!.posts!.length),
        fallback: (context) => Center(
            child: Text(
          'No Posts Yet (•_•)',
          style: Theme.of(context).textTheme.headline5,
        )),
      );

  //* build Widget user friends
  Widget userFriend(context, UserFriendsModule? friend) => ConditionalBuilder(
      condition: friend!.friends!.isNotEmpty,
      builder: (context) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Card(
              elevation: 5,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileScreen(
                                      id: friend.friends![index].sId!))),
                          child: CircleAvatar(
                              radius: 35,
                              backgroundImage: friend.friends![index].imageMini!
                                      .data!.isNotEmpty
                                  ? Image.memory(base64Decode(friend
                                          .friends![index].imageMini!.data!))
                                      .image
                                  : const AssetImage('assets/image/user.jpg')),
                        );
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfileScreen(
                                        id: friend.friends![index].sId!)));
                          },
                          child: Text(
                            '${friend.friends![index].firstName} ${friend.friends![index].lastName}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'unfriend ${friend.friends![index].firstName} ${friend.friends![index].lastName}'),
                                      content: Text(
                                          'Are you sure you want to remove ${friend.friends![index].firstName} ${friend.friends![index].lastName} from friends list?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context)
                                                .cancelFriend(
                                                    receiveId: friend
                                                        .friends![index].sId!)
                                                .then((value) {
                                              PurpleBookCubit.get(context)
                                                  .getUSerFriends(id: userId!);
                                              Navigator.pop(context, 'OK');
                                            });
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: Colors.grey.shade300,
                        child: const Text(
                          'Cancel Friend',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  )),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: friend.friends!.length,
          ),
      fallback: (context) => const Center(
              child: Text(
            'No Friends Yet (•_•)',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          )));

  Widget buildUserPost(
          UserPostsModule? user, int index, BuildContext context_1) =>
      Card(
          elevation: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (DateTime.now()
                            .difference(user!.posts![index].createdAt!)
                            .inMinutes <
                        60)
                      Expanded(
                        child: Text(
                            '${DateTime.now().difference(user.posts![index].createdAt!).inMinutes} minutes ago',
                            style: Theme.of(context_1).textTheme.caption),
                      )
                    else if (DateTime.now()
                            .difference(user.posts![index].createdAt!)
                            .inHours <
                        24)
                      Expanded(
                          child: Text(
                              '${DateTime.now().difference(user.posts![index].createdAt!).inHours} hours ago',
                              style: Theme.of(context_1).textTheme.caption))
                    else if (DateTime.now()
                            .difference(user.posts![index].createdAt!)
                            .inDays <
                        7)
                      Expanded(
                          child: Text(
                              '${DateTime.now().difference(user.posts![index].createdAt!).inDays} days ago',
                              style: Theme.of(context_1).textTheme.caption))
                    else
                      Expanded(
                          child: Text(
                              '${user.posts![index].createdAt!.year}-'
                              '${user.posts![index].createdAt!.month}-'
                              '${user.posts![index].createdAt!.day}',
                              style: Theme.of(context_1).textTheme.caption)),
                    PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: MainCubit.get(context_1).isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSelected: (value) {
                          if (value == Constants.edit) {
                            editPostController.text =
                                parseFragment(user.posts![index].content!)
                                    .text!;
                            showDialog<String>(
                                context: context_1,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Edit'),
                                        content: TextFormField(
                                          controller: editPostController,
                                          maxLines: 100,
                                          minLines: 1,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                              label: const Text('Edit post'),
                                              labelStyle: TextStyle(
                                                  color: HexColor("#6823D0")),
                                              border:
                                                  const OutlineInputBorder(),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: HexColor("#6823D0")),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10)),
                                        ),
                                        elevation: 10,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0")),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .editUserPosts(
                                                edit: editPostController.text,
                                                id: user.posts![index].sId!,
                                                userId: PurpleBookCubit.get(
                                                        context_1)
                                                    .userProfile!
                                                    .user!
                                                    .sId!,
                                              );
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color:
                                                        HexColor("#6823D0"))),
                                          ),
                                        ]));
                          } else if (Constants.delete == value) {
                            showDialog<String>(
                                context: context_1,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Delete'),
                                        elevation: 10,
                                        content: const Text(
                                            'Are you sure you want to delete this post?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .deletePost(
                                                      id: user
                                                          .posts![index].sId!)
                                                  .then((value) {
                                                PurpleBookCubit.get(context_1)
                                                    .getUserPosts(
                                                        userId: userId!);
                                              });
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ]));
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return Constants.chose.map((e) {
                            return PopupMenuItem<String>(
                              value: e,
                              child: Text(e),
                            );
                          }).toList();
                        })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                if(user.posts![index].content!.contains('<'))
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => ViewPostScreen(
                                  id: user.posts![index].sId!,
                                  addComent: false,
                                  isFocus: false,
                                )));
                  },
                  child: Html(
                    data: user.posts![index].content!,
                    style: {
                      "body": Style(
                          fontSize: const FontSize(20.0),
                          color: MainCubit.get(context_1).isDark
                              ? Colors.white
                              : Colors.black),
                    },
                  ),
                )
                else
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => ViewPostScreen(
                                id: user.posts![index].sId!,
                                addComent: false,
                                isFocus: false,
                              )));
                    },
                    child: Text(
                       user.posts![index].content!,
                      style: Theme.of(context_1).textTheme.headline5,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (user.posts![index].image!.data!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => ViewStringImage(
                                    image: user.posts![index].image!.data!,
                                  )));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: Image.memory(base64Decode(
                                      user.posts![index].image!.data!))
                                  .image)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      if (PurpleBookCubit.get(context_1)
                          .likesUserCount![index] != 0)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              highlightColor: HexColor("#6823D0"),
                              onTap: () {
                                showMsg(
                                    msg: 'Just a second',
                                    color: ColorMsg.inCorrect);
                                PurpleBookCubit.get(context_1)
                                    .getLikesPost(id: user.posts![index].sId!)
                                    .then((value) {
                                  showModalBottomSheet(
                                    context: context_1,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: (context) => ConditionalBuilder(
                                      condition: PurpleBookCubit.get(context_1)
                                          .likeModule!
                                          .users!
                                          .isNotEmpty,
                                      builder: (context) => ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              buildLikesPost(
                                                  PurpleBookCubit.get(context_1)
                                                      .likeModule!,
                                                  index,
                                                  context_1),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 10,
                                              ),
                                          itemCount:
                                              PurpleBookCubit.get(context_1)
                                                  .likeModule!
                                                  .users!
                                                  .length),
                                      fallback: (context) => const Center(
                                          child: Text(
                                        'Not Likes Yet',
                                        style: TextStyle(fontSize: 25),
                                      )),
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${PurpleBookCubit.get(context_1).likesUserCount![index]} like',
                                    style: Theme.of(context_1)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.grey, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (user.posts![index].commentsCount != 0)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SizedBox(
                              height: 30,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context_1,
                                      MaterialPageRoute(
                                          builder: (context_1) =>
                                              ViewPostScreen(
                                                id: user.posts![index].sId!,
                                                isFocus: false,
                                                addComent: false,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.chat_rounded,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${user.posts![index].commentsCount} comment',
                                      style: Theme.of(context_1)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color: Colors.grey, fontSize: 17),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              color: MainCubit.get(context_1).isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade200,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Text(
                            'Write Comment...',
                            style: Theme.of(context_1).textTheme.subtitle1,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context_1,
                              MaterialPageRoute(
                                  builder: (context_1) => ViewPostScreen(
                                        id: user.posts![index].sId!,
                                        addComent: true,
                                        isFocus: false,
                                      )));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            size: 20,
                            color: PurpleBookCubit.get(context_1)
                                    .isLikeUserPost![index]
                                ? HexColor("#6823D0")
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('like',
                              style: TextStyle(
                                fontSize: 15,
                                color: PurpleBookCubit.get(context_1)
                                        .isLikeUserPost![index]
                                    ? HexColor("#6823D0")
                                    : Colors.grey,
                              ))
                        ],
                      ),
                      onTap: () {
                        PurpleBookCubit.get(context_1).likeUserPost(
                            id: user.posts![index].sId!, index: index,userId: userId!);
                        PurpleBookCubit.get(context_1)
                            .changeLikePostUser(index);
                      },
                    )
                  ],
                )
              ],
            ),
          ));

  Widget buildLikesPost(LikesModule user, int index, context_1) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        user.users![index].imageMini!.data!.data!.isNotEmpty
                            ? Image.memory(Uint8List.fromList(
                                    user.users![index].imageMini!.data!.data!))
                                .image
                            : const AssetImage('assets/image/user.jpg')),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                  id: user.users![index].sId!)));
                    },
                    child: Text(
                        '${user.users![index].firstName} ${user.users![index].lastName}',
                        style: Theme.of(context_1).textTheme.headline6),
                  ),
                ),
                if (user.users![index].sId != userId)
                  if (user.users![index].friendState == 'NOT_FRIEND')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Add Friend'),
                                      content: Text(
                                          'Are you sure you want to sent request to ${user.users![index].firstName} ${user.users![index].lastName} ?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .sendRequestFriend(
                                                    id: user
                                                        .users![index].sId!);
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Add Friend',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else if (user.users![index].friendState == 'FRIEND')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Cancel Friend'),
                                      content: Text(
                                          'Are you sure you want to remove ${user.users![index].firstName} ${user.users![index].lastName} from your list friends?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .cancelFriend(
                                                    receiveId:
                                                        user.users![index].sId!)
                                                .then((value) => Navigator.pop(
                                                    context, 'OK'));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: Colors.grey.shade300,
                        child: const Text(
                          'Cancel Friend',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  else if (user.users![index].friendState ==
                      'FRIEND_REQUEST_SENT')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'Friend request ${user.users![index].firstName} ${user.users![index].lastName}'),
                                      content: const Text(
                                          'Are you sure you want to cancel request sent?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .cancelSendRequestFriend(
                                                    receiveId:
                                                        user.users![index].sId!)
                                                .then((value) =>
                                                    Navigator.pop(context_1));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Cancel request',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'Accept request ${user.users![index].firstName} ${user.users![index].lastName} '),
                                      content: const Text(
                                          'Are you sure you want to Accept request?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .acceptFriendRequest(
                                                    id: user.users![index].sId!)
                                                .then((value) =>
                                                    Navigator.pop(context_1));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Accept request',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
              ],
            ),
          ],
        ),
      );

  //* show likes comment
  Widget buildLikesComment(
          CommentLikesModule commentLike, int index, context_1) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    backgroundImage: commentLike
                            .users![index].imageMini!.data!.data!.isNotEmpty
                        ? Image.memory(Uint8List.fromList(commentLike
                                .users![index].imageMini!.data!.data!))
                            .image
                        : const AssetImage('assets/image/user.jpg')),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                  id: commentLike.users![index].sId!)));
                    },
                    child: Text(
                        '${commentLike.users![index].firstName} ${commentLike.users![index].lastName}',
                        style: Theme.of(context_1).textTheme.subtitle1),
                  ),
                ),
                if (commentLike.users![index].sId != userId)
                  if (commentLike.users![index].friendState == 'NOT_FRIEND')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Add Friend'),
                                      content: Text(
                                          'Are you sure you want to sent request to ${commentLike.users![index].firstName} ${commentLike.users![index].lastName} ?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .sendRequestFriend(
                                                    id: commentLike
                                                        .users![index].sId!);
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Add Friend',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else if (commentLike.users![index].friendState == 'FRIEND')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Cancel Friend'),
                                      content: Text(
                                          'Are you sure you want to remove ${commentLike.users![index].firstName} ${commentLike.users![index].lastName} from your list friends?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .cancelFriend(
                                                    receiveId: commentLike
                                                        .users![index].sId!)
                                                .then((value) => Navigator.pop(
                                                    context, 'OK'));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: Colors.grey.shade300,
                        child: const Text(
                          'Cancel Friend',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  else if (commentLike.users![index].friendState ==
                      'FRIEND_REQUEST_SENT')
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'Friend request ${commentLike.users![index].firstName} ${commentLike.users![index].lastName}'),
                                      content: const Text(
                                          'Are you sure you want to cancel request sent?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .cancelSendRequestFriend(
                                                    receiveId: commentLike
                                                        .users![index].sId!)
                                                .then((value) =>
                                                    Navigator.pop(context_1));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Cancel request',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context_1,
                              builder: (BuildContext context) => AlertDialog(
                                      title: Text(
                                          'Accept request ${commentLike.users![index].firstName} ${commentLike.users![index].lastName} '),
                                      content: const Text(
                                          'Are you sure you want to Accept request?'),
                                      elevation: 10,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: HexColor("#6823D0")),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .acceptFriendRequest(
                                                    id: commentLike
                                                        .users![index].sId!)
                                                .then((value) =>
                                                    Navigator.pop(context_1));
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
                                        ),
                                      ]));
                        },
                        color: HexColor("#6823D0"),
                        child: const Text(
                          'Accept request',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
              ],
            ),
          ],
        ),
      );

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
                PurpleBookCubit.get(context)
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
                PurpleBookCubit.get(context)
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
