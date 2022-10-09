import 'dart:async';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
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
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getNotifications(),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
          listener: ((context, state) {
        if (state is GetNotificationsSuccessState) {
          Future.delayed(const Duration(seconds: 5)).then((value) {
            PurpleBookCubit.get(context).viewedAllNotifications();
          });
        }
      }), builder: (context, state) {
        var cubit = PurpleBookCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConditionalBuilder(
            condition: cubit.notificationsModule != null,
            builder: (context) => ConditionalBuilder(
              condition: cubit.notificationsModule!.notifications!.isNotEmpty,
              builder: (context) => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    buildNotification(index, context),
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: cubit.notificationsModule!.notifications!.length,
              ),
              fallback: (context) => const Center(
                child: Text('No Notification for now (•_•)'),
              ),
            ),
            fallback: (context) => Center(child: buildFoodShimmer()),
          ),
        );
      }),
    );
  }

  Widget buildNotification(index, context_1) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: !PurpleBookCubit.get(context_1)
                .notificationsModule!
                .notifications![index]
                .viewed!
            ? HexColor("#6823D0").withOpacity(0.6)
            : null,
        elevation: 5,
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
                          .data!
                          .isNotEmpty
                      ? Image.memory(Uint8List.fromList(
                              PurpleBookCubit.get(context_1)
                                  .notificationsModule!
                                  .notifications![index]
                                  .image!
                                  .data!
                                  .data!))
                          .image
                      : const AssetImage('assets/image/user.jpg'),
                ),
              ),
              const SizedBox(
                width: 10,
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
                                    addComent: false,
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
                                        .links![2]
                                        .linkId!,
                                    addComent: false,
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (DateTime.now()
                              .difference(PurpleBookCubit.get(context_1)
                                  .notificationsModule!
                                  .notifications![index]
                                  .createdAt!)
                              .inHours <
                          24)
                        Text(
                          '${DateTime.now().difference(PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!).inHours} hours ago',
                          style:
                              const TextStyle(color: Colors.grey, height: 1.5),
                        )
                      else if (DateTime.now()
                              .difference(PurpleBookCubit.get(context_1)
                                  .notificationsModule!
                                  .notifications![index]
                                  .createdAt!)
                              .inDays <
                          7)
                        Text(
                            '${DateTime.now().difference(PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!).inDays} days ago',
                            style: const TextStyle(
                                color: Colors.grey, height: 1.5))
                      else
                        Text(
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.year}-'
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.month}-'
                            '${PurpleBookCubit.get(context_1).notificationsModule!.notifications![index].createdAt!.day}',
                            style: const TextStyle(
                                color: Colors.grey, height: 1.5))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
