import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/modules/comment_likes_module.dart';
import 'package:purplebook/modules/comments_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/edit_post_screen.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import 'package:purplebook/purple_book/view_single_comment.dart';
import 'package:purplebook/purple_book/view_string_image.dart';
import '../components/const.dart';
import '../components/end_points.dart';
import '../modules/likes_module.dart';
import 'cubit/purplebook_state.dart';

// ignore: must_be_immutable
class ViewPostScreen extends StatelessWidget {
  final String id;
  final dynamic idComment;
  final bool addComment;
  final bool isFocus;

  ViewPostScreen(
      {Key? key,
      required this.id,
      required this.addComment,
      required this.isFocus})
      : idComment = null,
        super(key: key);

  ViewPostScreen.focusComment(
      {Key? key,
      required this.id,
      required this.idComment,
      required this.addComment,
      required this.isFocus})
      : super(key: key);
  var contentController = TextEditingController();
  var editCommentController = TextEditingController();
  var editPostController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..viewPosts(id: id)
        ..getFeed()
        ..getComments(id: id),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          //* delete comments
          if (state is DeleteCommentPostSuccessState) {
            showSnackBar(
                'deleted Successfully', context, const Color(0xFF6823D0));
          } else if (state is DeleteCommentPostErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* delete post
          if (state is PostDeleteSuccessState) {
            showSnackBar(
                'Delete successfully', context, const Color(0xFF6823D0));
            navigatorAndRemove(
                context: context, widget: const PurpleBookScreen());
          } else if (state is PostDeleteErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* Edit post
          if (state is EditPostSuccessState) {
            showSnackBar(
                'Editing successfully', context, const Color(0xFF6823D0));
            PurpleBookCubit.get(context).viewPosts(id: id);
          } else if (state is EditPostErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* send friend request
          if (state is SendFriendRequestSuccessState) {
            showSnackBar('Sent successfully', context, const Color(0xFF6823D0));
          } else if (state is SendFriendRequestErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* cancel friend
          if (state is CancelFriendSuccessState) {
            showSnackBar(
                'unFriend successfully', context, const Color(0xFF6823D0));
          } else if (state is CancelFriendErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* cancel friend request
          if (state is CancelSendFriendRequestSuccessState) {
            showSnackBar(
                'Cancel sent successfully', context, const Color(0xFF6823D0));
          } else if (state is CancelSendFriendRequestErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* accept friend request
          if (state is AcceptFriendRequestSuccessState) {
            showSnackBar(
                'Confirm successfully', context, const Color(0xFF6823D0));
          } else if (state is AcceptFriendRequestErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          //* add comment
          if (state is AddCommentPostSuccessState) {
            showSnackBar(
                '??? Add comment successfully', context, const Color(0xFF6823D0));
            contentController.text = '';
          } else if (state is AddCommentPostErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }

          if (state is AddLikeCommentPostErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }
          if (state is DeleteLikeCommentPostErrorState) {
            showSnackBar('Error ${state.error.response!.statusCode}', context,
                Colors.red);
          }
        },
        builder: (context_1, state) {
          var cubit = PurpleBookCubit.get(context_1);
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Post'),
              backgroundColor: const Color(0xFF6823D0),
            ),
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConditionalBuilder(
                        condition: cubit.postView != null,
                        builder: (context) => Card(
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
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                          id: cubit
                                                              .postView!
                                                              .post!
                                                              .author!
                                                              .sId!)));
                                        },
                                        child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: cubit
                                                    .postView!
                                                    .post!
                                                    .author!
                                                    .imageMini!
                                                    .data!
                                                    .isNotEmpty
                                                ? Image.memory(base64Decode(
                                                        cubit
                                                            .postView!
                                                            .post!
                                                            .author!
                                                            .imageMini!
                                                            .data!))
                                                    .image
                                                : const AssetImage(
                                                    'assets/image/user.jpg')),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserProfileScreen(
                                                            id: cubit
                                                                .postView!
                                                                .post!
                                                                .author!
                                                                .sId!)));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${cubit.postView!.post!.author!.firstName} ${cubit.postView!.post!.author!.lastName}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                              if (DateTime.now()
                                                  .difference(
                                                  cubit.postView!.post!.createdAt!)
                                                  .inMinutes <
                                                  60)
                                                Text(
                                                    '${DateTime.now().difference(cubit.postView!.post!.createdAt!).inMinutes} Minutes ago',
                                                    style: Theme.of(context_1)
                                                        .textTheme
                                                        .caption)
                                              else if (DateTime.now()
                                                      .difference(cubit
                                                          .postView!
                                                          .post!
                                                          .createdAt!)
                                                      .inHours <
                                                  24)
                                                Text(
                                                    '${DateTime.now().difference(cubit.postView!.post!.createdAt!).inHours} hours ago',
                                                    style: Theme.of(context_1)
                                                        .textTheme
                                                        .caption)
                                              else if (DateTime.now()
                                                      .difference(cubit
                                                          .postView!
                                                          .post!
                                                          .createdAt!)
                                                      .inDays <
                                                  7)
                                                Text(
                                                    '${DateTime.now().difference(cubit.postView!.post!.createdAt!).inDays} days ago',
                                                    style: Theme.of(context_1)
                                                        .textTheme
                                                        .caption)
                                              else
                                                Text(
                                                    '${cubit.postView!.post!.createdAt!.year}-'
                                                    '${cubit.postView!.post!.createdAt!.month}-'
                                                    '${cubit.postView!.post!.createdAt!.day}',
                                                    style: Theme.of(context_1)
                                                        .textTheme
                                                        .caption)
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (userId ==
                                              cubit.postView!.post!.author!
                                                  .sId ||
                                          isAdmin == true)
                                        PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color:
                                                  MainCubit.get(context).isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                            onSelected: (value) {
                                              if (value == Constants.edit) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPostScreen(
                                                                id: cubit
                                                                    .postView!
                                                                    .post!
                                                                    .sId!,
                                                                content: cubit
                                                                    .postView!
                                                                    .post!
                                                                    .content!)));
                                              } else if (Constants.delete ==
                                                  value) {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                            title: const Text(
                                                                'Delete'),
                                                            elevation: 10,
                                                            content: const Text(
                                                                'Are you sure you want to delete this post?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
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
                                                                  cubit.deletePost(
                                                                      id: cubit
                                                                          .postView!
                                                                          .post!
                                                                          .sId!);
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK');
                                                                },
                                                                child: const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                              ),
                                                            ]));
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
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
                                  if (cubit.postView!.post!.content!
                                      .contains('<'))
                                    Html(
                                      data: "${cubit.postView!.post!.content}",
                                      style: {
                                        "body": Style(
                                            // fontSize: const FontSize(22.0),
                                            color: MainCubit.get(context).isDark
                                                ? Colors.white
                                                : Colors.black),
                                      },
                                    )
                                  else
                                    Text(
                                      "${cubit.postView!.post!.content}",
                                      style: Theme.of(context_1)
                                          .textTheme
                                          .headline5,
                                    ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (cubit
                                      .postView!.post!.image!.data!.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewStringImage(
                                                        image: cubit
                                                            .postView!
                                                            .post!
                                                            .image!
                                                            .data!)));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 350,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: Image.memory(
                                                        base64Decode(cubit
                                                            .postView!
                                                            .post!
                                                            .image!
                                                            .data!))
                                                    .image)),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              cubit.likeSinglePost();
                                              cubit.changeLikeSinglePost();
                                            },
                                            icon: const Icon(
                                                Icons.thumb_up_alt_rounded),
                                            color: cubit.isLikeSinglePost!
                                                ? const Color(0xFF6823D0)
                                                : Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (cubit.likePostCount != 0)
                                            InkWell(
                                              onTap: () {
                                                showMsg(
                                                    msg: 'Just a second',
                                                    color: ColorMsg.inCorrect);
                                                cubit
                                                    .getLikesPost(id: id)
                                                    .then((value) {
                                                  showModalBottomSheet(
                                                      context: context_1,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top:
                                                                      Radius.circular(
                                                                          20))),
                                                      builder: (context) =>
                                                          ListView.separated(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  buildLikesPost(
                                                                      cubit
                                                                          .likeModule!,
                                                                      index,
                                                                      context_1),
                                                              separatorBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                              itemCount: cubit
                                                                  .likeModule!
                                                                  .users!
                                                                  .length));
                                                });
                                              },
                                              child: Text(
                                                '${cubit.postView!.post!.likesCount} like',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                              ),
                                            ),
                                        ],
                                      ),
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
                                ],
                              ),
                            )),
                        fallback: (context) => Column(
                          children: [
                            ListTile(
                              leading: ShimmerWidget.circular(
                                width: 64,
                                height: 64,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              title:
                                  const ShimmerWidget.rectangular(height: 16),
                              subtitle:
                                  const ShimmerWidget.rectangular(height: 16),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ShimmerWidget.circular(
                                height: 200,
                                width: double.infinity,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (state is AddCommentPostLoadingState)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            color: Color(0xFF6823D0),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              color: MainCubit.get(context).isDark
                                  ? const Color(0xFF242F3D)
                                  : Colors.white),
                          child: TextFormField(
                            controller: contentController,
                            maxLines: 100,
                            minLines: 1,
                            cursorColor: MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            autofocus: addComment,
                            keyboardType: TextInputType.multiline,
                            validator: validateContent,
                            decoration: InputDecoration(
                                suffix: IconButton(
                                  color: const Color(0xFF6823D0),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.addComment(
                                          postId: id,
                                          text: contentController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.send),
                                ),
                                label: const Text('Write comment'),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF6823D0)),
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
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is DeleteCommentPostLoadingState)
                        const LinearProgressIndicator(
                          color: Color(0xFF6823D0),
                          backgroundColor: Colors.white,
                        ),
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
                                          color: MainCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "Most liked",
                                    child: Text(
                                      'Most Liked',
                                      style: TextStyle(
                                          color: MainCubit.get(context).isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                                dropdownColor: MainCubit.get(context).isDark
                                    ? const Color(0xFF242F3D)
                                    : Colors.white,
                                value: cubit.dropDownValue,
                                onChanged: (value) {
                                  cubit.dropDownValue = value!;
                                  if (value == 'date') {
                                    cubit.getComments(id: id);
                                  } else {
                                    cubit.getComments(id: id);
                                  }
                                }),
                          ),
                          ConditionalBuilder(
                              condition: cubit.comment != null &&
                                  cubit.isLikeComment != null,
                              builder: (context) => buildComments(
                                  PurpleBookCubit.get(context).comment!,
                                  context,
                                  id),
                              fallback: (context) => buildFoodShimmer()),
                          if (!cubit.isEndComments)
                            ConditionalBuilder(
                              condition:
                                  state is! GetMoreCommentPostLoadingState,
                              fallback: (context) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6823D0),
                                  ),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF6823D0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextButton(
                                    onPressed: () {
                                      cubit.getMoreComments(id: id);
                                    },
                                    child: const Text(
                                      'Show More',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget buildComments(CommentsModule user, context_1, String postId) =>
      ConditionalBuilder(
        condition: user.comments!.isNotEmpty,
        builder: (context_1) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context_1, index) => Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundImage: user.comments![index].author!
                                        .imageMini!.data!.isNotEmpty
                                    ? Image.memory(base64Decode(user
                                            .comments![index]
                                            .author!
                                            .imageMini!
                                            .data!))
                                        .image
                                    : const AssetImage(
                                        'assets/image/user.jpg')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${user.comments![index].author!.firstName} ${user.comments![index].author!.lastName}',
                                      style: Theme.of(context_1)
                                          .textTheme
                                          .headline6),
                                  if (DateTime.now()
                                      .difference(
                                      user.comments![index].createdAt!)
                                      .inMinutes <
                                      60)
                                    Text(
                                        '${DateTime.now().difference(user.comments![index].createdAt!).inMinutes} Minutes ago',
                                        style: Theme.of(context_1)
                                            .textTheme
                                            .caption)
                                  else if (DateTime.now()
                                          .difference(
                                              user.comments![index].createdAt!)
                                          .inHours <
                                      24)
                                    Text(
                                        '${DateTime.now().difference(user.comments![index].createdAt!).inHours} hours ago',
                                        style: Theme.of(context_1)
                                            .textTheme
                                            .caption)
                                  else if (DateTime.now()
                                          .difference(
                                              user.comments![index].createdAt!)
                                          .inDays <
                                      7)
                                    Text(
                                        '${DateTime.now().difference(user.comments![index].createdAt!).inDays} days ago',
                                        style: Theme.of(context_1)
                                            .textTheme
                                            .caption)
                                  else
                                    Text(
                                        '${user.comments![index].createdAt!.year}-'
                                        '${user.comments![index].createdAt!.month}-'
                                        '${user.comments![index].createdAt!.day}',
                                        style: Theme.of(context_1)
                                            .textTheme
                                            .caption)
                                ],
                              ),
                            ),
                            if (userId == user.comments![index].author!.sId ||
                                isAdmin!)
                              PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: MainCubit.get(context_1).isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onSelected: (value) {
                                    if (value == Constants.edit) {
                                      editCommentController.text =
                                          user.comments![index].content!;
                                      showDialog<String>(
                                          context: context_1,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: const Text('Edit'),
                                                  content: TextFormField(
                                                    controller:
                                                        editCommentController,
                                                    maxLines: 100,
                                                    minLines: 1,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    decoration: InputDecoration(
                                                        label: const Text(
                                                            'Write comment'),
                                                        labelStyle:
                                                            const TextStyle(
                                                                color: Color(
                                                                    0xFF6823D0)),
                                                        hintStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .subtitle2,
                                                        border:
                                                            const OutlineInputBorder(),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF6823D0)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(10)),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF6823D0)),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        PurpleBookCubit.get(
                                                                context_1)
                                                            .editComment(
                                                                postId: postId,
                                                                commentId: user
                                                                    .comments![
                                                                        index]
                                                                    .sId!,
                                                                text:
                                                                    editCommentController
                                                                        .text)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context, 'OK');
                                                        });
                                                      },
                                                      child: const Text('OK',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF6823D0))),
                                                    ),
                                                  ]));
                                    } else if (Constants.delete == value) {
                                      PurpleBookCubit.get(context_1)
                                          .deleteComment(
                                              postId: id,
                                              commentId:
                                                  user.comments![index].sId!);
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        if (user.comments![index].content!.contains('<'))
                          InkWell(
                            onTap: () => navigatorPush(
                                context: context_1,
                                widget: ViewSingleCommentScreen(
                                    idPost: id,
                                    idComment: user.comments![index].sId!)),
                            child: Html(
                              data: "${user.comments![index].content}",
                              style: {
                                "body": Style(
                                    color: MainCubit.get(context_1).isDark
                                        ? Colors.white
                                        : Colors.black),
                              },
                            ),
                          )
                        else
                          InkWell(
                            onTap: () => navigatorPush(
                                context: context_1,
                                widget: ViewSingleCommentScreen(
                                    idPost: id,
                                    idComment: user.comments![index].sId!)),
                            child: Text(
                              user.comments![index].content!,
                              style: Theme.of(context_1).textTheme.headline5,
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                PurpleBookCubit.get(context_1).likeComment(
                                    postId: id,
                                    commentId: PurpleBookCubit.get(context_1)
                                        .comment!
                                        .comments![index]
                                        .sId!,
                                    index: index);
                                PurpleBookCubit.get(context_1)
                                    .changeLikeComment(index);
                              },
                              icon: const Icon(Icons.thumb_up_alt_rounded),
                              color: PurpleBookCubit.get(context_1)
                                      .isLikeComment![index]
                                  ? const Color(0xFF6823D0)
                                  : Colors.grey,
                            ),
                            if (PurpleBookCubit.get(context_1).likeCommentCount![index] != 0)
                              Expanded(
                                child: InkWell(
                                  splashColor: const Color(0xFF6823D0),
                                  onTap: () {
                                    showMsg(
                                        msg: 'Just a second',
                                        color: ColorMsg.inCorrect);
                                    PurpleBookCubit.get(context_1)
                                        .getLikeComments(
                                            commentId:
                                                user.comments![index].sId!,
                                            postId: id)
                                        .then((value) => showModalBottomSheet(
                                              context: context_1,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              builder: (context) =>
                                                  buildLikesComment(
                                                      PurpleBookCubit.get(
                                                              context_1)
                                                          .commentLikes!,
                                                      context_1),
                                            ));
                                  },
                                  child: Text(
                                    '${PurpleBookCubit.get(context_1).likeCommentCount![index]} like',
                                    style: Theme.of(context_1)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            separatorBuilder: (context_1, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: user.comments!.length),
        fallback: (context_1) => Center(
          child: Text(
            'No Comments Yet (???_???)',
            style: Theme.of(context_1).textTheme.headline6,
          ),
        ),
      );

  Widget buildLikesComment(CommentLikesModule likeComment, context_1) =>
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context_1) => UserProfileScreen(
                                id: likeComment.users![index].sId!))),
                    child: CircleAvatar(
                        radius: 25,
                        backgroundImage: likeComment
                                .users![index].imageMini!.data!.data!.isNotEmpty
                            ? Image.memory(Uint8List.fromList(likeComment
                                    .users![index].imageMini!.data!.data!))
                                .image
                            : const AssetImage('assets/image/user.jpg')),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context_1) => UserProfileScreen(
                                  id: likeComment.users![index].sId!))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${likeComment.users![index].firstName} ${likeComment.users![index].lastName}',
                              style: Theme.of(context_1).textTheme.subtitle1),
                        ],
                      ),
                    ),
                  ),
                  if (likeComment.users![index].sId != userId)
                    if (likeComment.users![index].friendState == 'NOT_FRIEND')
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Add Friend'),
                                        content: Text(
                                            'Are you sure you want to sent request to ${likeComment.users![index].firstName} ${likeComment.users![index].lastName} ?'),
                                        elevation: 10,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .sendRequestFriend(
                                                      id: likeComment
                                                          .users![index].sId!)
                                                  .then((value) {
                                                Navigator.pop(context, 'OK');
                                              });
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(0xFF6823D0))),
                                          ),
                                        ]));
                          },
                          color: const Color(0xFF6823D0),
                          child: const Text(
                            'Add Friend',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    else if (likeComment.users![index].friendState == 'FRIEND')
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Cancel Friend'),
                                        content: Text(
                                            'Are you sure you want to remove ${likeComment.users![index].firstName} ${likeComment.users![index].lastName} from your list friends?'),
                                        elevation: 10,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .cancelFriend(
                                                      receiveId: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(0xFF6823D0))),
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
                    else if (likeComment.users![index].friendState ==
                        'FRIEND_REQUEST_SENT')
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: Text(
                                            'Friend request ${likeComment.users![index].firstName} ${likeComment.users![index].lastName}'),
                                        content: const Text(
                                            'Are you sure you want to cancel request sent?'),
                                        elevation: 10,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .cancelSendRequestFriend(
                                                      receiveId: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(0xFF6823D0))),
                                          ),
                                        ]));
                          },
                          color: const Color(0xFF6823D0),
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
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: Text(
                                            'Accept request ${likeComment.users![index].firstName} ${likeComment.users![index].lastName} '),
                                        content: const Text(
                                            'Are you sure you want to Accept request?'),
                                        elevation: 10,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              PurpleBookCubit.get(context_1)
                                                  .acceptFriendRequest(
                                                      id: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(0xFF6823D0))),
                                          ),
                                        ]));
                          },
                          color: const Color(0xFF6823D0),
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
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: likeComment.users!.length,
      );

  Widget buildLikesPost(LikesModule user, int index, context_1) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context_1,
                      MaterialPageRoute(
                          builder: (context_1) =>
                              UserProfileScreen(id: user.users![index].sId!))),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage: user
                              .users![index].imageMini!.data!.data!.isNotEmpty
                          ? Image.memory(Uint8List.fromList(
                                  user.users![index].imageMini!.data!.data!))
                              .image
                          : const AssetImage('assets/image/user.jpg')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context_1) => UserProfileScreen(
                                id: user.users![index].sId!))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${user.users![index].firstName} ${user.users![index].lastName}',
                            style: Theme.of(context_1).textTheme.subtitle1),
                      ],
                    ),
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
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Color(0xFF6823D0)),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .sendRequestFriend(
                                                    id: user.users![index].sId!)
                                                .then((value) {
                                              Navigator.pop(context, 'OK');
                                            });
                                          },
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0))),
                                        ),
                                      ]));
                        },
                        color: const Color(0xFF6823D0),
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
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Color(0xFF6823D0)),
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
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0))),
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
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Color(0xFF6823D0)),
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
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0))),
                                        ),
                                      ]));
                        },
                        color: const Color(0xFF6823D0),
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
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Color(0xFF6823D0)),
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
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Color(0xFF6823D0))),
                                        ),
                                      ]));
                        },
                        color: const Color(0xFF6823D0),
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

  String? validateContent(String? value) {
    if (value != null) {
      return null;
    }
    return 'Write a Comment';
  }
}
