// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/view_list_image.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';
import 'package:purplebook/purple_book/view_string_image.dart';

import '../components/const.dart';
import '../components/end_points.dart';
import '../modules/comment_likes_module.dart';
import '../modules/likes_module.dart';

class UserProfileScreen extends StatefulWidget {
  final String id;

  UserProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var contentController = TextEditingController();

  var editPostController = TextEditingController();

  final pageController = PageController(initialPage: 0);

  int indexWidget = 0;
  var _dropDowmValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getUserProfile(id: widget.id)
        ..getUserPosts(userId: widget.id),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          if (state is SendRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('✅ request Successfully'),
            ));
          } else if (state is SendRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('❌ request Failed'),
            ));
          }

          if (state is CancelSendRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('✅ Cancel request Successfully'),
            ));
          } else if (state is CancelSendRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('❌ Cancel request Failed'),
            ));
          }

          if (state is PostDeleteSuccessState) {
            PurpleBookCubit.get(context).getUserPosts(userId: widget.id);
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
                      color: MainCubit.get(context).isDark
                          ? HexColor("#242F3D")
                          : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (cubit.userProfile!.user!.imageFull!.data!
                                    .data!.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewListImage(
                                              image: cubit.userProfile!.user!
                                                  .imageFull!.data!.data!)));
                                }
                              },
                              child: CircleAvatar(
                                  radius: 85,
                                  backgroundImage: cubit.userProfile!.user!
                                          .imageFull!.data!.data!.isNotEmpty
                                      ? Image.memory(Uint8List.fromList(cubit
                                              .userProfile!
                                              .user!
                                              .imageFull!
                                              .data!
                                              .data!))
                                          .image
                                      : const AssetImage(
                                          'assets/image/user.jpg')),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: MainCubit.get(context).isDark
                                ? HexColor("#242F3E")
                                : Colors.grey.shade300,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}',
                                style: Theme.of(context).textTheme.headline4,
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
                                                'unfriend ${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}'),
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
                                                          receiveId: widget.id)
                                                      .then((value) {
                                                    cubit.getUserProfile(
                                                        id: widget.id);
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
                                cubit
                                    .sendRequestFriend(id: widget.id)
                                    .then((value) {
                                  cubit.getUserProfile(id: widget.id);
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
                                                          receiveId: widget.id)
                                                      .then((value) {
                                                    cubit.getUserProfile(
                                                        id: widget.id);
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
                                        cubit.getUserPosts(userId: widget.id);
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
                                        cubit.getUserComments(id: widget.id);
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
                                        cubit.getUSerFriends(id: widget.id);
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
                                    ? HexColor("#242F3D")
                                    : Colors.white,
                                value: cubit.dropDownValue,
                                onChanged: (value) {
                                  cubit.dropDownValue = value!;
                                  if (value == 'date') {
                                    cubit.getUserPosts(userId: widget.id);
                                  } else {
                                    cubit.getUserPosts(userId: widget.id);
                                  }
                                }),
                          ),
                          if (state is GetUserPostLoadingState)
                            LinearProgressIndicator(color: HexColor("#6823D0")),
                          ConditionalBuilder(
                            builder: (context) => userPosts(context),
                            condition: cubit.userPost != null,
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
                              condition: state is! GetMoreUserPostLoadingState,
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
                                        Radius.circular(15))),
                                child: TextButton(
                                  onPressed: () {
                                    cubit.getMoreUserPosts(userId: widget.id);
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
                    else if (indexWidget == 1)
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
                                    ? HexColor("#242F3D")
                                    : Colors.white,
                                value: cubit.dropDownValue,
                                onChanged: (value) {
                                  cubit.dropDownValue = value!;
                                  if (value == 'date') {
                                    cubit.getUserComments(
                                        id: widget.id, sort: 'date');
                                  } else {
                                    cubit.getUserComments(
                                        id: widget.id, sort: 'likes');
                                  }
                                }),
                          ),
                          ConditionalBuilder(
                            builder: (context) => userComments(
                                context, PurpleBookCubit.get(context)),
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
                              condition:
                                  state is! GetMoreUserCommentsLoadingState,
                              fallback: (context) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: HexColor("#6823D0"),
                                  ),
                                ),
                              ),
                              builder: (context) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                      color: HexColor("#6823D0"),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextButton(
                                    onPressed: () {
                                      cubit.getMoreUserComments(id: widget.id);
                                    },
                                    child: const Text(
                                      'Show More',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      )
                    else
                      ConditionalBuilder(
                        builder: (context) =>
                            userFriend(context, PurpleBookCubit.get(context)),
                        condition: cubit.userFriends != null,
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                              color: HexColor("#6823D0")),
                        ),
                      )
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
  Widget userComments(context_1, cubit) => ConditionalBuilder(
      condition:
          PurpleBookCubit.get(context_1).userComments!.comments!.isNotEmpty,
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
                                      addComent: false,
                                      isFocus: false,
                                    )));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'on ${cubit.userComments!.comments![index].post!.postAuthorFirstName!}\'s',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            '"',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            parseFragment(cubit.userComments!.comments![index]
                                    .post!.contentPreview)
                                .text!,
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
                            style: Theme.of(context).textTheme.headline6,
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
                              style: Theme.of(context).textTheme.headline6),
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
                            PurpleBookCubit.get(context_1)
                                .likeComment(
                                    postId: cubit.userComments!.comments![index]
                                        .post!.sId!,
                                    commentId: cubit
                                        .userComments!.comments![index].sId!,
                                    index: index)
                                .then((value) {
                              PurpleBookCubit.get(context_1)
                                  .getUserComments(id: widget.id);
                            });
                          },
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          color: PurpleBookCubit.get(context)
                                  .userComments!
                                  .comments![index]
                                  .likedByUser!
                              ? HexColor("#6823D0")
                              : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (PurpleBookCubit.get(context)
                                .userComments!
                                .comments![index]
                                .likesCount !=
                            0)
                          InkWell(
                            onTap: () {
                              PurpleBookCubit.get(context)
                                  .getLikeComments(
                                      commentId: PurpleBookCubit.get(context)
                                          .userComments!
                                          .comments![index]
                                          .sId!,
                                      postId: PurpleBookCubit.get(context)
                                          .userComments!
                                          .comments![index]
                                          .post!
                                          .sId!)
                                  .then((value) {
                                showModalBottomSheet(
                                    context: context_1,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: (context) => ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            buildLikesComment(
                                                PurpleBookCubit.get(context_1)
                                                    .commentLikes!,
                                                index,
                                                context_1),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        itemCount:
                                            PurpleBookCubit.get(context_1)
                                                .commentLikes!
                                                .users!
                                                .length));
                              });
                            },
                            child: Text(
                              '${PurpleBookCubit.get(context_1).userComments!.comments![index].likesCount} like',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.grey, fontSize: 15),
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
            itemCount: cubit.userComments!.comments!.length,
          ),
      fallback: (context) => Center(
            child: Text(
              'No Comments Yet (¬_¬ )',
              style: Theme.of(context).textTheme.headline4,
            ),
          ));

  //build Widget user posts
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
          child: Center(
            child: Text(
              'No Posts Yet (¬_¬ )',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      );

  //build Widget user friends
  Widget userFriend(context, cubit) => ConditionalBuilder(
      condition: PurpleBookCubit.get(context).userFriends!.friends!.isNotEmpty,
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileScreen(
                                      id: cubit
                                          .userFriends!.friends![index].sId!)));
                        },
                        child: CircleAvatar(
                            radius: 35,
                            backgroundImage: PurpleBookCubit.get(context)
                                    .userFriends!
                                    .friends![index]
                                    .imageMini!
                                    .data!
                                    .isNotEmpty
                                ? Image.memory(base64Decode(
                                        PurpleBookCubit.get(context)
                                            .userFriends!
                                            .friends![index]
                                            .imageMini!
                                            .data!))
                                    .image
                                : const AssetImage('assets/image/user.jpg')),
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
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      if (cubit.userFriends!.friends![index].sId! != userId)
                        if (cubit.userFriends!.friends![index].friendState ==
                            'FRIEND')
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text(
                                                'unfriend ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}'),
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
                                                      color:
                                                          HexColor("#6823D0")),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit
                                                      .cancelFriend(
                                                          receiveId: widget.id)
                                                      .then((value) {
                                                    cubit.getUSerFriends(
                                                        id: cubit
                                                            .userFriends!
                                                            .friends![index]
                                                            .sId);
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
                              color: Colors.grey.shade300,
                              child: const Text(
                                'Cancel Friend',
                                style: TextStyle(color: Colors.black),
                              ),
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
                                  cubit.getUSerFriends(id: widget.id);
                                });
                              },
                              color: HexColor("#6823D0"),
                              child: const Text(
                                'Add Friend',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        else if (cubit
                                .userFriends!.friends![index].friendState ==
                            'FRIEND_REQUEST_SENT')
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
                                                        id: widget.id);
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
                              color: Colors.white,
                              child: Text(
                                'request sent',
                                style: TextStyle(color: HexColor("#6823D0")),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                cubit.acceptFriendRequest(
                                    id: cubit
                                        .userFriends!.friends![index].sId!);
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                'Confrim',
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
            child: Text(
              'No Friends Yet (¬_¬ )',
              style: Theme.of(context).textTheme.headline4,
            ),
          ));

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
                            .inHours <
                        24)
                      Expanded(
                        child: Text(
                            '${DateTime.now().difference(user.posts![index].createdAt!).inHours} hours ago',
                            style: Theme.of(context_1).textTheme.caption),
                      )
                    else if (DateTime.now()
                            .difference(user.posts![index].createdAt!)
                            .inDays <
                        7)
                      Expanded(
                        child: Text(
                            '${DateTime.now().difference(user.posts![index].createdAt!).inDays} days ago',
                            style: Theme.of(context_1).textTheme.caption),
                      )
                    else
                      Expanded(
                        child: Text(
                            '${user.posts![index].createdAt!.year}-'
                            '${user.posts![index].createdAt!.month}-'
                            '${user.posts![index].createdAt!.day}',
                            style: Theme.of(context_1).textTheme.caption),
                      ),
                    if (isAdmin!)
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
                              parseFragment(user.posts![index].content!).text!;
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
                                            border: const OutlineInputBorder(),
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
                                              userId:
                                                  PurpleBookCubit.get(context_1)
                                                      .userProfile!
                                                      .user!
                                                      .sId!,
                                            );
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color: HexColor("#6823D0"))),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            PurpleBookCubit.get(context_1)
                                                .deletePost(
                                                    id: user.posts![index].sId!)
                                                .then((value) => PurpleBookCubit
                                                        .get(context_1)
                                                    .getUserPosts(
                                                        userId:
                                                            PurpleBookCubit.get(
                                                                    context_1)
                                                                .userProfile!
                                                                .user!
                                                                .sId!));
                                            Navigator.pop(context, 'Yes');
                                          },
                                          child: const Text('Yes',
                                              style:
                                                  TextStyle(color: Colors.red)),
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
                      style: Theme.of(context_1).textTheme.headline5
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
                      height: 350,
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
                              .likesUserCount![index] !=
                          0)
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
                                      fallback: (context) => Center(
                                          child: Text(
                                        'Not Likes Yet',
                                        style: Theme.of(context_1)
                                            .textTheme
                                            .headline6,
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(15)),
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
                                        isFocus: false,
                                        addComent: true,
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
                            id: user.posts![index].sId!,
                            index: index,
                            userId: widget.id);
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
}
