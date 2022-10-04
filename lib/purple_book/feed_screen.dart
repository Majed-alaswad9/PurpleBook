

import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/modules/feed_moduel.dart';
import 'package:purplebook/modules/likes_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';

import '../components/const.dart';
import '../components/end_points.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);
  var keyScaffold = GlobalKey<ScaffoldState>();
  var contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      PurpleBookCubit()
        ..getFeed(),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          if(state is PostDeleteSuccessState){
            showMsg(msg: 'Deleted Successfully', color: ColorMsg.inCorrect);
          }
        },
        builder: (context, state) {
          var cubit = PurpleBookCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.feedModule!=null,
              builder: (context) => RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(
                        milliseconds: 10,
                      )).then((value) {
                        PurpleBookCubit.get(context).getFeed();
                      });
                    },
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConditionalBuilder(
                          builder:(context)=> Column(
                            children: [
                              if(state is PostDeleteLoadingState)
                                LinearProgressIndicator(color: HexColor("#6823D0"),),
                               ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        buildPost(context, cubit.feedModule!, index),
                                    separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: cubit.feedModule!.posts!.length),
                            ],
                          ),
                          condition: cubit.feedModule!.posts!.isNotEmpty,
                          fallback: (context)=> Container(
                            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
                            child: const Text('No Posts Yet (¬_¬ )', style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600
                                )),
                          ),
                        )),
                  ),
              fallback: (context) => buildFoodShimmer());
        },
      ),
    );
  }

  Widget buildPost(conteext, FeedModule feed, index) =>  Card(
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
                           CircleAvatar(
                            radius: 25,
                            backgroundImage: feed.posts![index].author!.imageMini!.data!.isNotEmpty? Image.memory(base64Decode(feed.posts![index].author!.imageMini!.data!)).image
                                :  const AssetImage('assets/image/user.jpg')
                           ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${feed.posts![index].author!.firstName} ${feed
                                      .posts![index].author!.lastName}',
                                  style: const TextStyle(
                                      height: 1.3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text('${feed.posts![index].createdAt}',
                                    style:
                                    const TextStyle(height: 1.3, color: Colors.grey))
                              ],
                            ),
                          ),
                          if (userId == feed.posts![index].author!.sId || isAdmin==true)
                            PopupMenuButton(onSelected: (value) {
                              if (value == Constants.edit) {
                                contentController.text = parseFragment(feed.posts![index].content!).text!;
                                showDialog<String>(
                                    context: conteext,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text('Edit'),
                                            content: TextFormField(
                                              controller: contentController,
                                              maxLines: 100,
                                              minLines: 1,
                                              keyboardType: TextInputType.multiline,
                                              decoration: InputDecoration(
                                                  label: const Text('Edit post'),
                                                  labelStyle: TextStyle(
                                                      color: HexColor("#6823D0")),
                                                  hintStyle: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .subtitle2,
                                                  border: const OutlineInputBorder(),
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: HexColor("#6823D0")),
                                                    borderRadius: const BorderRadius
                                                        .all(Radius.circular(
                                                        10.0)),
                                                  ),
                                                  contentPadding: const EdgeInsets
                                                      .all(10)),
                                            ),
                                            elevation: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Cancel');
                                                },
                                                child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: HexColor("#6823D0")),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  PurpleBookCubit.get(conteext).editPosts(
                                                      edit: contentController.text,
                                                      id: feed.posts![index].sId!);
                                                  Navigator.pop(context,'OK');
                                                },
                                                child: Text('OK', style: TextStyle(
                                                    color: HexColor("#6823D0"))),
                                              ),
                                            ]));
                              } else if (Constants.delete == value) {
                                showDialog<String>(
                                    context: conteext,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text('Delete'),
                                            elevation: 10,
                                            content: const Text('Are you sure you want to delete this post?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Cancel');
                                                },
                                                child: const Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  PurpleBookCubit.get(conteext)
                                                      .deletePost(id: feed.posts![index].sId!);
                                                    Navigator.pop(context,'OK');
                                                },
                                                child: const Text('OK', style: TextStyle(
                                                    color: Colors.red)),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(conteext, MaterialPageRoute(
                              builder: (context) => ViewPostScreen(
                                id: feed.posts![index].sId!, count: index,isFocus: false,)));
                        },
                        child: Text(
                          '${parseFragment(feed.posts![index].content).text}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      if (feed.posts![index].image!.data!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            Navigator.push(conteext, MaterialPageRoute(
                                builder: (context) => ViewPostScreen(
                                  id: feed.posts![index].sId!, count: index,isFocus: false,)));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image:  DecorationImage(
                                  fit: BoxFit.fill,
                                  image: Image.memory(base64Decode(feed.posts![index].image!.data!)).image
                                )),
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
                                    showMsg(msg: 'Just a second', color: ColorMsg.inCorrect);
                                    PurpleBookCubit.get(conteext).getLikesPost(id: feed.posts![index].sId!).then((value) {
                                      showModalBottomSheet(context: conteext,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))
                                        ),
                                        builder: (context) =>
                                            ConditionalBuilder(
                                              condition: PurpleBookCubit.get(conteext).likeModule!.users!.isNotEmpty,
                                              builder: (context) => ListView.separated(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, index) =>
                                                          buildBottomSheet(
                                                              PurpleBookCubit
                                                                  .get(conteext)
                                                                  .likeModule!, index),
                                                      separatorBuilder: (context,
                                                          index) =>
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      itemCount: PurpleBookCubit
                                                          .get(conteext)
                                                          .likeModule!
                                                          .users!
                                                          .length),
                                              fallback: (context) => const Center(child: Text('Not Likes Yet',
                                                style: TextStyle(fontSize: 25),)),
                                            ),);
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
                                        '${PurpleBookCubit
                                            .get(conteext)
                                            .likesCount![index]}',
                                        style: Theme
                                            .of(conteext)
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
                                      Navigator.push(conteext, MaterialPageRoute(
                                          builder: (conteext) => ViewPostScreen(
                                              id: feed.posts![index].sId!,
                                              count: index,isFocus: false,)));
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
                                          '${feed.posts![index]
                                              .commentsCount} comment',
                                          style: Theme
                                              .of(conteext)
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
                                padding: const EdgeInsets.only(top: 10,left: 10),
                                height: 40,
                                decoration:  BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:const BorderRadius.all(Radius.circular(15))
                                ),
                                child: const Text(
                                  'Write Comment...',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(conteext, MaterialPageRoute(
                                    builder: (conteext) => ViewPostScreen(id: feed.posts![index].sId!, count: index,isFocus: true,)));
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  size: 20,
                                  color: PurpleBookCubit
                                      .get(conteext)
                                      .isLikePost![index]
                                      ? HexColor("#6823D0")
                                      : Colors.grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('like',
                                    style: TextStyle(
                                      fontSize: 15, color: PurpleBookCubit
                                        .get(conteext)
                                        .isLikePost![index]
                                        ? HexColor("#6823D0")
                                        : Colors.grey,))
                              ],
                            ),
                            onTap: () {
                              PurpleBookCubit.get(conteext).likePost(
                                  id: feed.posts![index].sId!, index: index);
                              PurpleBookCubit.get(conteext).changeColorIcon(index);
                              PurpleBookCubit.get(conteext).getFeed();
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
                  backgroundImage: user.users![index].imageMini!.data!.data!.isNotEmpty? Image.memory(Uint8List.fromList(user.users![index].imageMini!.data!.data!)).image
                      : const AssetImage('assets/image/user.jpg')
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.users![index].firstName} ${user.users![index]
                            .lastName}',
                        style: const TextStyle(
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
                if(user.users![index].sId != userId)
                  if(user.users![index].friendState == 'NOT_FRIEND')
                    Expanded(
                      child: MaterialButton(onPressed: () {},
                        color: Colors.blue,
                        child: const Text(
                          'Add Friend', style: TextStyle(color: Colors.white),),),
                    )
                  else
                    MaterialButton(onPressed: () {},
                      color: Colors.blueGrey,
                      child: const Text('Cancel Friend',
                        style: TextStyle(color: Colors.white),),)
              ],
            ),
          ],
        ),
      );



}
