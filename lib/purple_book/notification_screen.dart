import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:html/parser.dart';
import 'package:purplebook/components/const.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/user_profile.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';

import 'cubit/purplebook_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
            showMsg(msg: 'You\'re offline', color: ColorMsg.error);
          }
          return BlocProvider(
            create: (context) => PurpleBookCubit()
              ..getNotifications()
              ..viewedAllNotifications(),
            child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
                listener: ((context, state) {}),
                builder: (context, state) {
                  var cubit = PurpleBookCubit.get(context);
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ConditionalBuilder(
                          condition: cubit.notificationsModule != null,
                          builder: (context) => ConditionalBuilder(
                            condition: cubit
                                .notificationsModule!.notifications!.isNotEmpty,
                            builder: (context) => ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  buildNotification(index, context),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 1),
                              itemCount: cubit
                                  .notificationsModule!.notifications!.length,
                            ),
                            fallback: (context) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 2.5),
                              child: Center(
                                child: Text(
                                  'No Notification for now (???_???)',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ),
                          ),
                          fallback: (context) =>
                              Center(child: buildFoodShimmer()),
                        ),
                        // if (!cubit.isEndNotification)
                        //   ConditionalBuilder(
                        //     condition:
                        //         state is! GetMoreNotificationsLoadingState,
                        //     fallback: (context) => Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Center(
                        //         child: CircularProgressIndicator(
                        //           color: Color(0xFF6823D0),
                        //         ),
                        //       ),
                        //     ),
                        //     builder: (context) => Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //         width: double.infinity,
                        //         decoration: BoxDecoration(
                        //             color: Color(0xFF6823D0),
                        //             borderRadius: const BorderRadius.all(
                        //                 Radius.circular(20))),
                        //         child: TextButton(
                        //           onPressed: () {
                        //             cubit.getMoreNotifications();
                        //           },
                        //           child: const Text(
                        //             'Show More',
                        //             style: TextStyle(
                        //                 color: Colors.white, fontSize: 20),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   )
                      ],
                    ),
                  );
                }),
          );
        },
        child: const Text('offline'));
  }

  Widget buildNotification(index, context_1) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (PurpleBookCubit.get(context_1)
                          .notificationsModule!
                          .notifications![index]
                          .links!
                          .length ==
                      1) {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                                id: PurpleBookCubit.get(context_1)
                                    .notificationsModule!
                                    .notifications![index]
                                    .links![0]
                                    .linkId!)));
                  } else if (PurpleBookCubit.get(context_1)
                          .notificationsModule!
                          .notifications![index]
                          .links!
                          .length ==
                      2) {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                                id: PurpleBookCubit.get(context_1)
                                    .notificationsModule!
                                    .notifications![index]
                                    .links![1]
                                    .linkId!)));
                  } else if (PurpleBookCubit.get(context_1)
                          .notificationsModule!
                          .notifications![index]
                          .links!
                          .length ==
                      3) {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                                id: PurpleBookCubit.get(context_1)
                                    .notificationsModule!
                                    .notifications![index]
                                    .links![2]
                                    .linkId!)));
                  }
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: PurpleBookCubit.get(context_1)
                          .notificationsModule!
                          .notifications![index]
                          .image!
                          .data!
                          .isNotEmpty
                      ? Image.memory(base64Decode(PurpleBookCubit.get(context_1)
                              .notificationsModule!
                              .notifications![index]
                              .image!
                              .data!))
                          .image
                      : const AssetImage('assets/image/user.jpg'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (PurpleBookCubit.get(context_1)
                            .notificationsModule!
                            .notifications![index]
                            .links!
                            .length ==
                        1) {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                  id: PurpleBookCubit.get(context_1)
                                      .notificationsModule!
                                      .notifications![index]
                                      .links![0]
                                      .linkId!)));
                    } else if (PurpleBookCubit.get(context_1)
                            .notificationsModule!
                            .notifications![index]
                            .links!
                            .length ==
                        2) {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => ViewPostScreen(
                                    id: PurpleBookCubit.get(context_1)
                                        .notificationsModule!
                                        .notifications![index]
                                        .links![0]
                                        .linkId!,
                                    addComment: false,
                                    isFocus: false,
                                  )));
                    } else if (PurpleBookCubit.get(context_1)
                            .notificationsModule!
                            .notifications![index]
                            .links!
                            .length ==
                        3) {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => ViewPostScreen.focusComment(
                                    id: PurpleBookCubit.get(context_1)
                                        .notificationsModule!
                                        .notifications![index]
                                        .links![1]
                                        .linkId!,
                                    addComment: false,
                                    isFocus: true,
                                    idComment: PurpleBookCubit.get(context_1)
                                        .notificationsModule!
                                        .notifications![index]
                                        .links![0]
                                        .linkId!,
                                  )));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parseFragment(PurpleBookCubit.get(context_1)
                                .notificationsModule!
                                .notifications![index]
                                .content!)
                            .text!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context_1).textTheme.subtitle1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (DateTime.now()
                              .difference(PurpleBookCubit.get(context)
                                  .notificationsModule!
                                  .notifications![index]
                                  .createdAt!)
                              .inMinutes <
                          60)
                        Text(
                            '${DateTime.now().difference(PurpleBookCubit.get(context).notificationsModule!.notifications![index].createdAt!).inMinutes} minutes ago',
                            style: Theme.of(context).textTheme.caption)
                      else if (DateTime.now()
                              .difference(PurpleBookCubit.get(context_1)
                                  .notificationsModule!
                                  .notifications![index]
                                  .createdAt!)
                              .inHours <
                          24)
                        Text(
                            '${DateTime.now().difference(PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!).inHours} hours ago',
                            style: Theme.of(context_1).textTheme.caption)
                      else if (DateTime.now()
                              .difference(PurpleBookCubit.get(context_1)
                                  .notificationsModule!
                                  .notifications![index]
                                  .createdAt!)
                              .inDays <
                          7)
                        Text(
                            '${DateTime.now().difference(PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!).inDays} days ago',
                            style: Theme.of(context_1).textTheme.caption)
                      else
                        Text(
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.year}-'
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.month}-'
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.day}',
                            style: Theme.of(context_1).textTheme.caption)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
