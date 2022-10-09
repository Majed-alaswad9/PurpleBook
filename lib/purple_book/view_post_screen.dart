import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/modules/comment_likes_module.dart';
import 'package:purplebook/modules/comments_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import '../components/const.dart';
import '../components/end_points.dart';
import '../modules/likes_module.dart';
import 'cubit/purplebook_state.dart';

class ViewPostScreen extends StatelessWidget {
  final String id;
  final dynamic idComment;
  final bool addComent;
  final bool isFocus;

  ViewPostScreen(
      {Key? key,
      required this.id,
      required this.addComent,
      required this.isFocus})
      : idComment = null,
        super(key: key);

  ViewPostScreen.focusComment(
      {Key? key, required this.id,
      required this.idComment,
      required this.addComent,
      required this.isFocus}) : super(key: key);
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
          //delete comments
          if (state is DeleteCommentPostSuccessState) {
            showMsg(msg: 'deleted Successfully', color: ColorMsg.success);
          } else if (state is DeleteCommentPostErrorState) {
            showMsg(msg: 'Failed delete', color: ColorMsg.error);
          }

          //delete post
          if (state is PostDeleteSuccessState) {
            showMsg(msg: 'deleted Successfully', color: ColorMsg.success);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const PurpleBookScreen()),
                (route) => false);
          } else if (state is PostDeleteErrorState) {
            showMsg(msg: 'Failed delete', color: ColorMsg.error);
          }

          //Edit post
          if (state is EditPostSuccessState) {
            showMsg(msg: 'Edited Successfully', color: ColorMsg.success);
            PurpleBookCubit.get(context).viewPosts(id: id);
          } else if (state is EditPostErrorState) {
            showMsg(msg: 'Failed Edited', color: ColorMsg.error);
          }

          //send friend request
          if (state is SendRequestSuccessState) {
            showMsg(msg: 'Sent Successfully', color: ColorMsg.inCorrect);
          } else if (state is SendRequestErrorState) {
            showMsg(msg: 'Sent Failed', color: ColorMsg.error);
          }

          //cancel friend
          if (state is CancelFriendSuccessState) {
            showMsg(
                msg: 'Cancel friend Successfully', color: ColorMsg.inCorrect);
          } else if (state is CancelFriendErrorState) {
            showMsg(msg: 'Cancel friend Failed', color: ColorMsg.error);
          }

          //cancel friend request
          if (state is CancelSendRequestSuccessState) {
            showMsg(
                msg: 'Cancel request Successfully', color: ColorMsg.inCorrect);
          } else if (state is CancelSendRequestErrorState) {
            showMsg(msg: 'Cancel request Failed', color: ColorMsg.error);
          }
          //cancel friend request
          if (state is CancelSendRequestSuccessState) {
            showMsg(
                msg: 'Cancel request Successfully', color: ColorMsg.inCorrect);
          } else if (state is CancelSendRequestErrorState) {
            showMsg(msg: 'Cancel request Failed', color: ColorMsg.error);
          }

          //accept friend request
          if (state is AcceptFriendRequestSuccessState) {
            showMsg(
                msg: 'Accept request Successfully', color: ColorMsg.inCorrect);
          } else if (state is AcceptFriendRequestErrorState) {
            showMsg(msg: 'Accept request Failed', color: ColorMsg.error);
          }

          //add comment
          if (state is AddCommentPostSuccessState) {
            showMsg(msg: 'Added Successfully', color: ColorMsg.inCorrect);
            contentController.text = '';
          } else if (state is AddCommentPostErrorState) {
            showMsg(msg: 'Added Failed', color: ColorMsg.error);
          }
        },
        builder: (context_1, state) {
          var cubit = PurpleBookCubit.get(context_1);
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Post'),
              backgroundColor: HexColor("#6823D0"),
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
                                                style: const TextStyle(
                                                    height: 1.3,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                  '${cubit.postView!.post!.createdAt!.year.toString()}-'
                                                  '${cubit.postView!.post!.createdAt!.month.toString()}-'
                                                  '${cubit.postView!.post!.createdAt!.day.toString()}',
                                                  style: const TextStyle(
                                                      height: 1.3,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (userId ==
                                              cubit.postView!.post!.author!
                                                  .sId ||
                                          isAdmin == true)
                                        PopupMenuButton(onSelected: (value) {
                                          if (value == Constants.edit) {
                                            editPostController.text =
                                                parseFragment(cubit.postView!
                                                        .post!.content!)
                                                    .text!;
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                            title: const Text(
                                                                'Edit'),
                                                            content:
                                                                TextFormField(
                                                              controller:
                                                                  editPostController,
                                                              maxLines: 100,
                                                              minLines: 1,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              decoration:
                                                                  InputDecoration(
                                                                      label: const Text(
                                                                          'Edit post'),
                                                                      labelStyle: TextStyle(
                                                                          color: HexColor(
                                                                              "#6823D0")),
                                                                      border:
                                                                          const OutlineInputBorder(),
                                                                      enabledBorder:
                                                                          const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.grey),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: HexColor("#6823D0")),
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(10.0)),
                                                                      ),
                                                                      contentPadding:
                                                                          const EdgeInsets.all(
                                                                              10)),
                                                            ),
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
                                                                  cubit.editPosts(
                                                                      edit: editPostController
                                                                          .text,
                                                                      id: cubit
                                                                          .postView!
                                                                          .post!
                                                                          .sId!);
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK');
                                                                },
                                                                child: Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: HexColor(
                                                                            "#6823D0"))),
                                                              ),
                                                            ]));
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
                                                            child: const Text(
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
                                        }, itemBuilder: (BuildContext context) {
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
                                  Text(
                                    ' ${parseFragment(cubit.postView!.post!.content!).text!}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (cubit
                                      .postView!.post!.image!.data!.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      height: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: Image.memory(base64Decode(
                                                      cubit.postView!.post!
                                                          .image!.data!))
                                                  .image)),
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
                                              cubit.likePostFromViewPost(
                                                  id: cubit
                                                      .postView!.post!.sId!);
                                              cubit.viewPosts(id: id);
                                            },
                                            icon: const Icon(
                                                Icons.thumb_up_alt_outlined),
                                            color: cubit.postView!.post!
                                                    .likedByUser!
                                                ? HexColor("#6823D0")
                                                : Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (cubit
                                                  .postView!.post!.likesCount !=
                                              0)
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
                                                                  buildBottomSheet(
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
                        fallback: (context) => ListTile(
                          leading: ShimmerWidget.circular(
                            width: 64,
                            height: 64,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          title: const ShimmerWidget.rectangular(height: 16),
                          subtitle: const ShimmerWidget.rectangular(height: 16),
                        ),
                      ),
                      if (state is AddCommentPostLoadingState)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            color: HexColor("#6823D0"),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: contentController,
                          maxLines: 100,
                          minLines: 1,
                          autofocus: addComent,
                          keyboardType: TextInputType.multiline,
                          validator: validateContent,
                          decoration: InputDecoration(
                              suffix: IconButton(
                                color: HexColor("#6823D0"),
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
                              labelStyle: TextStyle(color: HexColor("#6823D0")),
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#6823D0")),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.all(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is DeleteCommentPostLoadingState)
                        LinearProgressIndicator(
                          color: HexColor("#6823D0"),
                          backgroundColor: Colors.white,
                        ),
                      ConditionalBuilder(
                          condition: cubit.comment != null,
                          builder: (context) => buildComments(
                              PurpleBookCubit.get(context).comment!,
                              context,
                              id),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()))
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
                            radius: 25,
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
                                style: const TextStyle(
                                    height: 1.3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                  '${user.comments![index].createdAt!.year.toString()}-'
                                  '${user.comments![index].createdAt!.month.toString()}-'
                                  '${user.comments![index].createdAt!.day.toString()}  ',
                                  style: const TextStyle(
                                      height: 1.3, color: Colors.grey))
                            ],
                          ),
                        ),
                        if (userId == user.comments![index].author!.sId)
                          PopupMenuButton(onSelected: (value) {
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
                                                labelStyle: TextStyle(
                                                    color: HexColor(
                                                        "#6823D0")),
                                                hintStyle:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .subtitle2,
                                                border:
                                                    const OutlineInputBorder(),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: HexColor(
                                                          "#6823D0")),
                                                  borderRadius:
                                                      const BorderRadius
                                                              .all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(
                                                        10)),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
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
                                                  showMsg(
                                                      msg:
                                                          'editing successfully',
                                                      color: ColorMsg
                                                          .inCorrect);
                                                  Navigator.pop(
                                                      context, 'OK');
                                                });
                                              },
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      color: HexColor(
                                                          "#6823D0"))),
                                            ),
                                          ]));
                            } else if (Constants.delete == value) {
                              PurpleBookCubit.get(context_1)
                                  .deleteComment(
                                      postId: id,
                                      commentId:
                                          user.comments![index].sId!);
                            }
                          }, itemBuilder: (BuildContext context) {
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
                    Text(
                      parseFragment(user.comments![index].content).text!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            PurpleBookCubit.get(context_1)
                                .likeComment(
                                    idPost: id,
                                    idComment:
                                        PurpleBookCubit.get(context_1)
                                            .comment!
                                            .comments![index]
                                            .sId!,
                                    index: index)
                                .then((value) {
                              PurpleBookCubit.get(context_1)
                                  .getComments(id: id);
                            });
                            PurpleBookCubit.get(context_1)
                                .changeLikeComment(index);
                          },
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          color: PurpleBookCubit.get(context_1)
                                  .comment!
                                  .comments![index]
                                  .likedByUser!
                              ? HexColor("#6823D0")
                              : Colors.grey,
                        ),
                        if (user.comments![index].likesCount != 0)
                          Expanded(
                            child: InkWell(
                              splashColor: HexColor("#6823D0"),
                              onTap: () {
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
                                '${PurpleBookCubit.get(context_1).comment!.comments![index].likesCount} like',
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
        fallback: (context_1) => const Center(
          child: Text(
            'No Comments Yet (•_•)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  CircleAvatar(
                      radius: 25,
                      backgroundImage: likeComment
                              .users![index].imageMini!.data!.data!.isNotEmpty
                          ? Image.memory(Uint8List.fromList(likeComment
                                  .users![index].imageMini!.data!.data!))
                              .image
                          : const AssetImage('assets/image/user.jpg')),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${likeComment.users![index].firstName} ${likeComment.users![index].lastName}',
                          style: const TextStyle(
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
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
                                                      id: likeComment
                                                          .users![index].sId!)
                                                  .then((value) {
                                                Navigator.pop(context, 'OK');
                                              });
                                            },
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color:
                                                        HexColor("#6823D0"))),
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
                                                      receiveId: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color:
                                                        HexColor("#6823D0"))),
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
                                                      receiveId: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color:
                                                        HexColor("#6823D0"))),
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
                                                      id: likeComment
                                                          .users![index].sId!)
                                                  .then((value) =>
                                                      Navigator.pop(context_1));
                                            },
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color:
                                                        HexColor("#6823D0"))),
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
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: likeComment.users!.length,
      );

  Widget buildBottomSheet(LikesModule user, int index, context_1) => Padding(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.users![index].firstName} ${user.users![index].lastName}',
                        style: const TextStyle(
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
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
                                                    id: user.users![index].sId!)
                                                .then((value) {
                                              Navigator.pop(context, 'OK');
                                            });
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

  String? validateContent(String? value) {
    if (value != null) {
      return null;
    }
    return 'Write a Comment';
  }
}
