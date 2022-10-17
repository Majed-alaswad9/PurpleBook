import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/modules/feed_moduel.dart';
import 'package:purplebook/modules/likes_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/edit_post_screen.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';
import 'package:purplebook/purple_book/view_string_iamge.dart';

import '../components/const.dart';
import '../components/end_points.dart';

// ignore: must_be_immutable
class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);
  var keyScaffold = GlobalKey<ScaffoldState>();
  var contentController = TextEditingController();

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
              if (connected)
                BlocProvider(
                  create: (context) => PurpleBookCubit()
                    ..getFeed()
                    ..getUserProfile(id: userId!)
                    ..getNotificationsFromAnyScreen()
                    ..getFriendRequestFromAnyScreen(),
                  child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
                    listener: (context, state) {
                      if (state is PostDeleteSuccessState) {
                        showMsg(
                            msg: 'Deleted Successfully',
                            color: ColorMsg.inCorrect);
                      } else if (state is PostDeleteErrorState) {
                        showMsg(msg: 'Deleted Failed', color: ColorMsg.error);
                      }

                      if (state is SendRequestSuccessState) {
                        showMsg(
                            msg: 'Sent Successfully',
                            color: ColorMsg.inCorrect);
                      } else if (state is SendRequestErrorState) {
                        showMsg(msg: 'Sent Failed', color: ColorMsg.error);
                      }

                      if (state is CancelSendRequestSuccessState) {
                        showMsg(
                            msg: 'Cancel Successfully',
                            color: ColorMsg.inCorrect);
                      } else if (state is CancelSendRequestErrorState) {
                        showMsg(msg: 'Cancel Failed', color: ColorMsg.error);
                      }

                      if (state is AcceptFriendRequestSuccessState) {
                        showMsg(
                            msg: 'Accept request Successfully',
                            color: ColorMsg.inCorrect);
                      } else if (state is AcceptFriendRequestErrorState) {
                        showMsg(
                            msg: 'Accept request Failed',
                            color: ColorMsg.error);
                      }
                    },
                    builder: (context, state) {
                      var cubit = PurpleBookCubit.get(context);
                      return ConditionalBuilder(
                          condition: cubit.feedModule != null,
                          builder: (context) => SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConditionalBuilder(
                                builder: (context) => Column(
                                  children: [
                                    if (state is PostDeleteLoadingState)
                                      LinearProgressIndicator(
                                        color: HexColor("#6823D0"),
                                      ),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            buildPost(context,
                                                cubit.feedModule!, index),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        itemCount:
                                            cubit.feedModule!.posts!.length),
                                    if (!cubit.isEndFeed)
                                      ConditionalBuilder(
                                        condition:
                                            state is! GetMoreFeedLoadingState &&
                                                cubit.isLikePost != null,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: HexColor("#6823D0"),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: MaterialButton(
                                              onPressed: () {
                                                cubit.getMoreFeed();
                                              },
                                              child: const Text(
                                                'show more',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        fallback: (context) => Center(
                                            child: CircularProgressIndicator(
                                          color: HexColor("#6823D0"),
                                        )),
                                      )
                                  ],
                                ),
                                condition: cubit.feedModule!.posts!.isNotEmpty,
                                fallback: (context) => Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              3),
                                  child: const Center(
                                    child: Text('No Posts Yet (¬_¬ )',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              )),
                          fallback: (context) => buildFoodShimmer());
                    },
                  ),
                )
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
              ),
            ]));
  }

  Widget buildPost(conteext, FeedModule feed, index) => Card(
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
                        conteext,
                        MaterialPageRoute(
                            builder: (conteext) => UserProfileScreen(
                                id: feed.posts![index].author!.sId!)));
                  },
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage: feed
                              .posts![index].author!.imageMini!.data!.isNotEmpty
                          ? Image.memory(base64Decode(
                                  feed.posts![index].author!.imageMini!.data!))
                              .image
                          : const AssetImage('assets/image/user.jpg')),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                        conteext,
                        MaterialPageRoute(
                            builder: (conteext) => UserProfileScreen(
                                id: feed.posts![index].author!.sId!))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${feed.posts![index].author!.firstName} ${feed.posts![index].author!.lastName}',
                            style: Theme.of(conteext).textTheme.headline6),
                        const SizedBox(
                          height: 10,
                        ),
                        if (DateTime.now()
                                .difference(feed.posts![index].createdAt!)
                                .inMinutes <
                            60)
                          Text(
                              '${DateTime.now().difference(feed.posts![index].createdAt!).inMinutes} minutes ago',
                              style: Theme.of(conteext).textTheme.caption)
                        else if (DateTime.now()
                                .difference(feed.posts![index].createdAt!)
                                .inHours <
                            24)
                          Text(
                              '${DateTime.now().difference(feed.posts![index].createdAt!).inHours} hours ago',
                              style: Theme.of(conteext).textTheme.caption)
                        else if (DateTime.now()
                                .difference(feed.posts![index].createdAt!)
                                .inDays <
                            7)
                          Text(
                              '${DateTime.now().difference(feed.posts![index].createdAt!).inDays} days ago',
                              style: Theme.of(conteext).textTheme.caption)
                        else
                          Text(
                              '${feed.posts![index].createdAt!.year}-'
                              '${feed.posts![index].createdAt!.month}-'
                              '${feed.posts![index].createdAt!.day}',
                              style: Theme.of(conteext).textTheme.caption)
                      ],
                    ),
                  ),
                ),
                if (userId == feed.posts![index].author!.sId || isAdmin == true)
                  PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: MainCubit.get(conteext).isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (value) {
                        if (value == Constants.edit) {
                          Navigator.push(
                              conteext,
                              MaterialPageRoute(
                                  builder: (conteext) => EditPostScreen(
                                        id: feed.posts![index].sId!,
                                        content: feed.posts![index].content!,
                                      )));
                        } else if (Constants.delete == value) {
                          showDialog<String>(
                              context: conteext,
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(conteext)
                                                .deletePost(
                                                    id: feed
                                                        .posts![index].sId!);
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK',
                                              style:
                                                  TextStyle(color: Colors.red)),
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
            InkWell(
              onTap: () {
                Navigator.push(
                    conteext,
                    MaterialPageRoute(
                        builder: (context) => ViewPostScreen(
                              id: feed.posts![index].sId!,
                              addComent: false,
                              isFocus: false,
                            )));
              },
              child: Html(
                data: feed.posts![index].content!,
                style: {
                  "body": Style(
                      fontSize: const FontSize(20.0),
                      color: MainCubit.get(conteext).isDark
                          ? Colors.white
                          : Colors.black),
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (feed.posts![index].image!.data!.isNotEmpty)
              InkWell(
                onTap: () {
                  Navigator.push(
                      conteext,
                      MaterialPageRoute(
                          builder: (context) => ViewStringImage(
                              image: feed.posts![index].image!.data!)));
                },
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.memory(
                                  base64Decode(feed.posts![index].image!.data!))
                              .image)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  if (PurpleBookCubit.get(conteext).likesCount![index] != 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: InkWell(
                          highlightColor: HexColor("#6823D0"),
                          onTap: () {
                            showMsg(
                                msg: 'Just a second',
                                color: ColorMsg.inCorrect);
                            PurpleBookCubit.get(conteext)
                                .getLikesPost(id: feed.posts![index].sId!)
                                .then((value) {
                              showModalBottomSheet(
                                context: conteext,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: (context) => ConditionalBuilder(
                                  condition: PurpleBookCubit.get(conteext)
                                      .likeModule!
                                      .users!
                                      .isNotEmpty,
                                  builder: (context) => ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          buildBottomSheet(
                                              PurpleBookCubit.get(conteext)
                                                  .likeModule!,
                                              index,
                                              conteext),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 10,
                                          ),
                                      itemCount: PurpleBookCubit.get(conteext)
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
                                '${PurpleBookCubit.get(conteext).likesCount![index]} like',
                                style: Theme.of(conteext)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.grey, fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (feed.posts![index].commentsCount != 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          height: 30,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  conteext,
                                  MaterialPageRoute(
                                      builder: (conteext) => ViewPostScreen(
                                            id: feed.posts![index].sId!,
                                            addComent: false,
                                            isFocus: false,
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
                                  '${feed.posts![index].commentsCount} comment',
                                  style: Theme.of(conteext)
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                          color: MainCubit.get(conteext).isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        'Write Comment...',
                        style: Theme.of(conteext).textTheme.subtitle1,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          conteext,
                          MaterialPageRoute(
                              builder: (conteext) => ViewPostScreen(
                                    id: feed.posts![index].sId!,
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
                        color: PurpleBookCubit.get(conteext).isLikePost![index]
                            ? HexColor("#6823D0")
                            : Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('like',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                PurpleBookCubit.get(conteext).isLikePost![index]
                                    ? HexColor("#6823D0")
                                    : Colors.grey,
                          ))
                    ],
                  ),
                  onTap: () {
                    PurpleBookCubit.get(conteext)
                        .likePost(id: feed.posts![index].sId!, index: index);
                    PurpleBookCubit.get(conteext).changeColorIcon(index);
                    // PurpleBookCubit.get(conteext).getFeed();
                  },
                )
              ],
            )
          ],
        ),
      ));

  Widget buildBottomSheet(LikesModule user, int index, context_1) => Padding(
        padding: const EdgeInsets.all(10.0),
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
                          style: Theme.of(context_1).textTheme.headline6,
                        ),
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
}
