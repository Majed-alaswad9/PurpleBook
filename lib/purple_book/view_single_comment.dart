import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:purplebook/modules/view_single_comment_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/user_profile.dart';

import '../components/const.dart';
import '../components/end_points.dart';
import '../cubit/cubit.dart';
import '../modules/comment_likes_module.dart';

// ignore: must_be_immutable
class ViewSingleCommentScreen extends StatelessWidget {
  ViewSingleCommentScreen(
      {Key? key, required this.idPost, required this.idComment})
      : super(key: key);
  final String idPost;
  final String idComment;

  var editCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..viewSingleComment(idPost: idPost, idComment: idComment),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PurpleBookCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Comment'),
              backgroundColor: const Color(0xFF6823D0),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ConditionalBuilder(
                  condition: state is! ViewSingleCommentLoadingState,
                  fallback: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6823D0),
                        ),
                      ),
                  builder: (context) =>
                      buildComments(cubit.viewComment!, context, idPost)),
            ),
          );
        },
      ),
    );
  }

  Widget buildComments(
          ViewSingleCommentModule? user, context_1, String postId) =>
      ConditionalBuilder(
        condition: user!.comment != null,
        builder: (context_1) => Card(
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
                        backgroundImage:
                            user.comment!.author!.imageMini!.data!.isNotEmpty
                                ? Image.memory(base64Decode(
                                        user.comment!.author!.imageMini!.data!))
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
                              '${user.comment!.author!.firstName} ${user.comment!.author!.lastName}',
                              style: Theme.of(context_1).textTheme.headline6),
                          if (DateTime.now()
                                  .difference(user.comment!.createdAt!)
                                  .inMinutes <
                              60)
                            Text(
                                '${DateTime.now().difference(user.comment!.createdAt!).inMinutes} Minutes ago',
                                style: Theme.of(context_1).textTheme.caption)
                          else if (DateTime.now()
                                  .difference(user.comment!.createdAt!)
                                  .inHours <
                              24)
                            Text(
                                '${DateTime.now().difference(user.comment!.createdAt!).inHours} hours ago',
                                style: Theme.of(context_1).textTheme.caption)
                          else if (DateTime.now()
                                  .difference(user.comment!.createdAt!)
                                  .inDays <
                              7)
                            Text(
                                '${DateTime.now().difference(user.comment!.createdAt!).inDays} days ago',
                                style: Theme.of(context_1).textTheme.caption)
                          else
                            Text(
                                '${user.comment!.createdAt!.year}-'
                                '${user.comment!.createdAt!.month}-'
                                '${user.comment!.createdAt!.day}',
                                style: Theme.of(context_1).textTheme.caption)
                        ],
                      ),
                    ),
                    if (userId == user.comment!.author!.sId || isAdmin!)
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
                                  user.comment!.content!;
                              showDialog<String>(
                                  context: context_1,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title: const Text('Edit'),
                                          content: TextFormField(
                                            controller: editCommentController,
                                            maxLines: 100,
                                            minLines: 1,
                                            keyboardType:
                                                TextInputType.multiline,
                                            decoration: InputDecoration(
                                                label:
                                                    const Text('Write comment'),
                                                labelStyle: const TextStyle(
                                                    color: Color(0xFF6823D0)),
                                                hintStyle: Theme.of(context)
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
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF6823D0)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(10)),
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
                                                    color: Color(0xFF6823D0)),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                PurpleBookCubit.get(context_1)
                                                    .editComment(
                                                        postId: postId,
                                                        commentId:
                                                            user.comment!.sId!,
                                                        text:
                                                            editCommentController
                                                                .text)
                                                    .then((value) {
                                                  Navigator.pop(context, 'OK');
                                                });
                                              },
                                              child: const Text('OK',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF6823D0))),
                                            ),
                                          ]));
                            } else if (Constants.delete == value) {
                              PurpleBookCubit.get(context_1).deleteComment(
                                  postId: idPost, commentId: idComment);
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
                if (user.comment!.content!.contains('<'))
                  Html(
                    data: "${user.comment!.content}",
                    style: {
                      "body": Style(
                          color: MainCubit.get(context_1).isDark
                              ? Colors.white
                              : Colors.black),
                    },
                  )
                else
                  Text(
                    user.comment!.content!,
                    style: Theme.of(context_1).textTheme.headline5,
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        PurpleBookCubit.get(context_1).likeSingleComment(
                            postId: idPost, commentId: idPost);
                        PurpleBookCubit.get(context_1)
                            .changeLikeSingleComment();
                      },
                      icon: const Icon(Icons.thumb_up_alt_rounded),
                      color: PurpleBookCubit.get(context_1).isLike!
                          ? const Color(0xFF6823D0)
                          : Colors.grey,
                    ),
                    if (PurpleBookCubit.get(context_1).countLike != 0)
                      Expanded(
                        child: InkWell(
                          splashColor: const Color(0xFF6823D0),
                          onTap: () {
                            showMsg(
                                msg: 'Just a second',
                                color: ColorMsg.inCorrect);
                            PurpleBookCubit.get(context_1)
                                .getLikeComments(
                                    commentId: idComment, postId: idPost)
                                .then((value) => showModalBottomSheet(
                                      context: context_1,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: (context) => buildLikesComment(
                                          PurpleBookCubit.get(context_1)
                                              .commentLikes!,
                                          context_1),
                                    ));
                          },
                          child: Text(
                            '${PurpleBookCubit.get(context_1).countLike} like',
                            style: Theme.of(context_1)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
        fallback: (context_1) => Center(
          child: Text(
            'No Comments Yet (•_•)',
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
}
