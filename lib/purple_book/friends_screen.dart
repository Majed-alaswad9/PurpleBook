import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purplebook/modules/friend_recommendation_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import '../components/const.dart';
import '../modules/friends_request_module.dart';
import 'cubit/purplebook_state.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (!connected) {
            Fluttertoast.showToast(
                msg: 'You\'re offline',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          return BlocProvider(
            create: (context) => PurpleBookCubit()
              ..getFriendRequest()
              ..getFriendRecommendation()
              ..viewedAllFriendRequest(),
            child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
              listener: (context, state) {
                //* remove friend request
                if (state is RemoveFriendRequestSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Delete successfully')));
                } else if (state is RemoveFriendRequestSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ Delete Failed')));
                }

                //* accept friend request
                if (state is AcceptFriendRequestSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Accepted successfully')));
                } else if (state is AcceptFriendRequestErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ Accepted Failed')));
                }

                //* Add friend
                if (state is SendFriendRequestSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Sent successfully')));
                } else if (state is SendFriendRequestErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ Sent Failed')));
                }

                //* cancel request
                if (state is CancelSendFriendRequestSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('✅ Cancel Sent successfully')));
                } else if (state is CancelSendFriendRequestErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ Cancel Sent Failed')));
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Text('Friend requests',
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition:
                                PurpleBookCubit.get(context).friendRequest !=
                                    null,
                            builder: (context) => buildFriendRequests(
                                context,
                                PurpleBookCubit.get(context).friendRequest!,
                                connected),
                            fallback: (context) => buildFoodShimmer()),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          width: double.infinity,
                          child: Text(
                            'friend recommendation',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: PurpleBookCubit.get(context)
                                    .friendsRecommendation !=
                                null,
                            builder: (context) => buildFriendRecommendation(
                                context,
                                PurpleBookCubit.get(context)
                                    .friendsRecommendation!,
                                connected),
                            fallback: (context) => buildFoodShimmer()),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'There are no buttons to push :)',
              ),
              Text(
                'Just turn off your internet.',
              ),
            ]));
  }

  Widget buildFriendRequests(
          context_1, FriendsRequestModule request, bool connected) =>
      ConditionalBuilder(
        condition: request.friendRequests!.isNotEmpty,
        builder: (context_1) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context_1) => UserProfileScreen(
                                        id: request.friendRequests![index].user!
                                            .sId!))),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: request
                                          .friendRequests![index]
                                          .user!
                                          .imageMini!
                                          .data!
                                          .data!
                                          .isNotEmpty
                                      ? Image.memory(Uint8List.fromList(request
                                              .friendRequests![index]
                                              .user!
                                              .imageMini!
                                              .data!
                                              .data!))
                                          .image
                                      : const AssetImage(
                                          'assets/image/user.jpg'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    '${request.friendRequests![index].user!.firstName} ${request.friendRequests![index].user!.lastName}',
                                    style:
                                        Theme.of(context_1).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    if (connected) {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: const Text(
                                                      'Delete friend request'),
                                                  content: const Text(
                                                      'Are you sure you want to Delete this request?'),
                                                  elevation: 10,
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'No');
                                                      },
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: HexColor(
                                                                "#6823D0")),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        PurpleBookCubit.get(
                                                                context_1)
                                                            .removeRequest(
                                                                id: request
                                                                    .friendRequests![
                                                                        index]
                                                                    .user!
                                                                    .sId!);
                                                        Navigator.pop(
                                                            context, 'Yes');
                                                      },
                                                      child: Text('Yes',
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  "#6823D0"))),
                                                    ),
                                                  ]));
                                    } else if (!connected) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('You\'re offline')));
                                    }
                                  },
                                  color: Colors.grey.shade300,
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: MaterialButton(
                                  elevation: 5,
                                  onPressed: () {
                                    if (connected) {
                                      PurpleBookCubit.get(context_1)
                                          .acceptFriendRequest(
                                              id: request.friendRequests![index]
                                                  .user!.sId!);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('You\'re offline')));
                                    }
                                  },
                                  color: HexColor("#6823D0"),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
            itemCount: request.friendRequests!.length),
        fallback: (context_1) => Text(
          'Wow, such empty ⚆_⚆',
          style: Theme.of(context_1).textTheme.headline4,
        ),
      );

  Widget buildFriendRecommendation(
          context_1, FriendRecommendationModule request, bool connected) =>
      ConditionalBuilder(
        condition: request.friendRecommendation!.isNotEmpty,
        builder: (context_1) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: request
                                      .friendRecommendation![index]
                                      .imageMini!
                                      .data!
                                      .isNotEmpty
                                  ? Image.memory(base64Decode(request
                                          .friendRecommendation![index]
                                          .imageMini!
                                          .data!))
                                      .image
                                  : const AssetImage('assets/image/user.jpg')),
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
                                            id: request
                                                .friendRecommendation![index]
                                                .sId!)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${request.friendRecommendation![index].firstName} ${request.friendRecommendation![index].lastName}',
                                    style:
                                        Theme.of(context_1).textTheme.bodyText1,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (request.friendRecommendation![index]
                                          .mutualFriends !=
                                      0)
                                    Text(
                                      '${request.friendRecommendation![index].mutualFriends} mutual friends',
                                      style:
                                          Theme.of(context_1).textTheme.caption,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (request
                                  .friendRecommendation![index].friendState ==
                              'NOT_FRIEND')
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  if (connected) {
                                    PurpleBookCubit.get(context_1)
                                        .sendRequestFriend(
                                            id: request
                                                .friendRecommendation![index]
                                                .sId!)
                                        .then((value) {
                                      PurpleBookCubit.get(context_1)
                                          .getFriendRecommendation();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('You\'re offline')));
                                  }
                                },
                                color: HexColor("#6823D0"),
                                child: const Text(
                                  'Add Friend',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          else if (request
                                  .friendRecommendation![index].friendState ==
                              'FRIEND_REQUEST_SENT')
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  if (connected) {
                                    PurpleBookCubit.get(context_1)
                                        .cancelSendRequestFriend(
                                            receiveId: request
                                                .friendRecommendation![index]
                                                .sId!)
                                        .then((value) {
                                      PurpleBookCubit.get(context_1)
                                          .getFriendRecommendation();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('You\'re offline')));
                                  }
                                },
                                color: Colors.grey.shade400,
                                child: const Text(
                                  'request sent',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  if (connected) {
                                    PurpleBookCubit.get(context_1)
                                        .acceptFriendRequest(
                                            id: request
                                                .friendRecommendation![index]
                                                .sId!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('You\'re offline')));
                                  }
                                },
                                color: Colors.grey.shade300,
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                        ],
                      )),
                ),
            itemCount: request.friendRecommendation!.length),
        fallback: (context_1) => Text('Wow, such empty ⚆_⚆',
            style: Theme.of(context_1).textTheme.headline4),
      );

  Widget buildFoodShimmer() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
          leading: ShimmerWidget.circular(
            width: 64,
            height: 64,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          title: const ShimmerWidget.rectangular(height: 16),
          subtitle: const ShimmerWidget.rectangular(height: 14),
        ),
        itemCount: 5,
      );
}
