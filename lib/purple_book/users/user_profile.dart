// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/users/view_post_user_screen.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';

import '../../components/const.dart';
import '../../components/end_points.dart';
import '../../modules/likes_module.dart';

class UserProfileScreen extends StatelessWidget {
  final String id;

  UserProfileScreen({Key? key, required this.id}) : super(key: key);

  var contentController = TextEditingController();
  final pageController = PageController(initialPage: 0);
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getUserProfile(id: id)
        ..getUserPosts(userId: id),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          if (state is SendRequestSuccessState) {
            showMsg(msg: 'request sent', color: ColorMsg.inCorrect);
          }
        },
        builder: (context, state) {
          var cubit = PurpleBookCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: HexColor("#6823D0"),
            ),
            body: ConditionalBuilder(
              condition: cubit.userProfile != null,
              builder: (context) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(10)),
                    Container(
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const Center(
                            child: CircleAvatar(
                              radius: 85,
                              backgroundImage: NetworkImage(
                                  'https://img.freepik.com/free-photo/woman-using-smartphone-social-media-conecpt_53876-40967.jpg?t=st=1647704509~exp=1647705109~hmac=f1ae56f2218ca7938f19ae0fbd675b8c6b2e21d3d25548429a500e43f89ce211&w=740'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (cubit.userProfile!.user!.friendState! == 'FRIEND')
                            MaterialButton(
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text(
                                                'unfriend with ${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}'),
                                            content: Text(
                                                'Are you sure you want to remove ${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName} from friends list?'),
                                            elevation: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#6823D0")),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit
                                                      .cancelFriend(
                                                          receiveId: id)
                                                      .then((value) {
                                                    cubit.getUserProfile(
                                                        id: id);
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
                              },
                              color: HexColor("#6823D0"),
                              child: const Text(
                                'Friend',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          else if (cubit.userProfile!.user!.friendState! ==
                              'NOT_FRIEND')
                            MaterialButton(
                              onPressed: () {
                                cubit.sendRequestFriend(id: id).then((value) {
                                  cubit.getUserProfile(id: id);
                                });
                              },
                              color: HexColor("#6823D0"),
                              child: const Text(
                                'Not Friend',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )
                          else if (cubit.userProfile!.user!.friendState! ==
                              'FRIEND_REQUEST_SENT')
                            MaterialButton(
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text(
                                                'cancel request ${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}'),
                                            content: Text(
                                                'Are you sure you want to cancel sent request to ${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName} ?'),
                                            elevation: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#6823D0")),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit
                                                      .cancelSendRequestFriend(
                                                          receiveId: id)
                                                      .then((value) {
                                                    cubit.getUserProfile(
                                                        id: id);
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
                              },
                              color: HexColor("#6823D0"),
                              child: const Text(
                                'request sent',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    elevation: indexWidget == 0 ? 10 : 0,
                                    color: indexWidget == 0
                                        ? HexColor("#6823D0")
                                        : Colors.white,
                                    child: MaterialButton(
                                      onPressed: () {
                                        cubit.getUserPosts(userId: id);
                                        indexWidget = 0;
                                      },
                                      child: Text(
                                        'Posts',
                                        style: TextStyle(
                                          color: indexWidget == 0
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    elevation: indexWidget == 1 ? 10 : 0,
                                    color: indexWidget == 1
                                        ? HexColor("#6823D0")
                                        : Colors.white,
                                    child: MaterialButton(
                                      onPressed: () {
                                        cubit.getUserComments(id: id);
                                        indexWidget = 1;
                                      },
                                      child: Text(
                                        'Comments',
                                        style: TextStyle(
                                          color: indexWidget == 1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    elevation: indexWidget == 2 ? 10 : 0,
                                    color: indexWidget == 2
                                        ? HexColor("#6823D0")
                                        : Colors.white,
                                    child: MaterialButton(
                                      onPressed: () {
                                        cubit.getUSerFriends(id: id);
                                        indexWidget = 2;
                                      },
                                      child: Text(
                                        'Friends',
                                        style: TextStyle(
                                          color: indexWidget == 2
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
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
                    if (indexWidget == 0)
                      userPosts(context)
                    else if (indexWidget == 1)
                      userComments(context, PurpleBookCubit.get(context))
                    else
                      userFriend(context, PurpleBookCubit.get(context))
                  ],
                ),
              ),
              fallback: (context) => Center(
                  child: CircularProgressIndicator(
                color: HexColor("#6823D0"),
              )),
            ),
          );
        },
      ),
    );
  }

  // build Widget user comments
  Widget userComments(context, cubit) => ConditionalBuilder(
      condition: cubit.userComments != null && cubit.isLikeComment!.isNotEmpty,
      builder: (context) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Card(
              elevation: 10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                builder: (context) => ViewPostScreen(
                                      id: cubit.userComments!.comments![index]
                                          .post!.sId!,
                                      addComent: false,isFocus: false,
                                    )));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'on ${cubit.userComments!.comments![index].post!.postAuthorFirstName!}\'s',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            '"',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            parseFragment(cubit.userComments!.comments![index]
                                    .post!.contentPreview)
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
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            parseFragment(cubit
                                    .userComments!.comments![index].content)
                                .text!,
                            maxLines: 3,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
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
                            cubit.likeComment(
                                idPost: cubit
                                    .userComments!.comments![index].post!.sId!,
                                idComment:
                                    cubit.userComments!.comments![index].sId!,
                                index: index);
                            cubit.changeLikeComment(index);
                          },
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          color:
                              PurpleBookCubit.get(context).isLikeComment![index]
                                  ? HexColor("#6823D0")
                                  : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${cubit.likeCommentCount![index]} like',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey, fontSize: 15),
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
            itemCount: cubit.userComments!.comments!.length,
          ),
      fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: HexColor("#6823D0"),
          )));

  //build Widget user posts
  Widget userPosts(context) => ConditionalBuilder(
        condition: PurpleBookCubit.get(context).userPost != null,
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
            child: CircularProgressIndicator(
          color: HexColor("#6823D0"),
        )),
      );

  //build Widget user friends
  Widget userFriend(context, cubit) => ConditionalBuilder(
      condition: cubit.userFriends != null,
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
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/woman-using-smartphone-social-media-conecpt_53876-40967.jpg?t=st=1647704509~exp=1647705109~hmac=f1ae56f2218ca7938f19ae0fbd675b8c6b2e21d3d25548429a500e43f89ce211&w=740'),
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
                                    builder: (context) => UserProfileScreen(
                                        id: cubit.userFriends!.friends![index]
                                            .sId!)));
                          },
                          child: Text(
                            '${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (cubit.userFriends!.friends![index].sId! != userId)
                        if (cubit.userFriends!.friends![index].friendState ==
                            'FRIEND')
                          MaterialButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title: Text(
                                              'unfriend with ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}'),
                                          content: Text(
                                              'Are you sure you want to remove ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName} from friends list?'),
                                          elevation: 10,
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: HexColor("#6823D0")),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cubit
                                                    .cancelFriend(receiveId: id)
                                                    .then((value) {
                                                  cubit.getUSerFriends(
                                                      id: cubit.userFriends!
                                                          .friends![index].sId);
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
                            color: Colors.grey.shade300,
                            child: const Text(
                              'Cancel Friend',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        else if (cubit
                                .userFriends!.friends![index].friendState ==
                            'NOT_FRIEND')
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                cubit
                                    .sendRequestFriend(
                                        id: cubit
                                            .userFriends!.friends![index].sId!)
                                    .then((value) {
                                  cubit.getUSerFriends(id: id);
                                });
                              },
                              color: HexColor("#6823D0"),
                              child: const Text(
                                'Add Friend',
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
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text(
                                                'cancel request ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}'),
                                            content: Text(
                                                'Are you sure you want to cancel sent request to ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName} ?'),
                                            elevation: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Cancel');
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#6823D0")),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit
                                                      .cancelSendRequestFriend(
                                                          receiveId: cubit
                                                              .userFriends!
                                                              .friends![index]
                                                              .sId)
                                                      .then((value) {
                                                    cubit.getUSerFriends(
                                                        id: id);
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
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                'request sent',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    ],
                  )),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: cubit.userFriends!.friends!.length,
          ),
      fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: HexColor("#6823D0"),
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
                    Expanded(
                      child: Text(
                          '${user!.posts![index].createdAt!.year.toString()}-'
                          '${user.posts![index].createdAt!.month.toString()}-'
                          '${user.posts![index].createdAt!.day.toString()}  '
                          '${user.posts![index].createdAt!.hour.toString()}:'
                          '${user.posts![index].createdAt!.minute.toString()}',
                          style:
                              const TextStyle(height: 1.3, color: Colors.grey)),
                    ),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => ViewPostUserScreen(
                                  id: user.posts![index].sId!,
                                  count: index,
                                )));
                  },
                  child: Text(
                    '${parseFragment(user.posts![index].content).text}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
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
                              builder: (context) => ViewPostUserScreen(
                                    id: user.posts![index].sId!,
                                    count: index,
                                  )));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: Image.memory(base64Decode(
                                      user.posts![index].image!.data!))
                                  .image)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
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
                                            buildBottomSheet(
                                                PurpleBookCubit.get(context_1)
                                                    .likeModule!,
                                                index),
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
                                  '${PurpleBookCubit.get(context_1).likesUserCount![index]}',
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
                                            ViewPostUserScreen(
                                                id: user.posts![index].sId!,
                                                count: index)));
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
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Write Comment...',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context_1,
                              MaterialPageRoute(
                                  builder: (context_1) => ViewPostUserScreen(
                                      id: user.posts![index].sId!,
                                      count: index)));
                        },
                      ),
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
                            id: user.posts![index].sId!, index: index);
                        PurpleBookCubit.get(context_1)
                            .changeLikePostUser(index);
                      },
                    )
                  ],
                )
              ],
            ),
          ));

  Widget buildBottomSheet(LikesModule user, int index) => Padding(
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
                            : null),
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
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.blue,
                      child: const Text(
                        'Add Friend',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.blueGrey,
                      child: const Text(
                        'Cancel Friend',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
              ],
            ),
          ],
        ),
      );
}
