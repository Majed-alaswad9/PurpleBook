import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';

import 'cubit/purplebook_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()..getNotifications(),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
          listener: ((context, state) {}),
          builder: (context, state) {
            var cubit = PurpleBookCubit.get(context);
            return ConditionalBuilder(
              condition: cubit.notificationsModule != null,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: cubit.notificationsModule!
                              .notifications![0].image!.data!.data!.isNotEmpty
                          ? Image.memory(Uint8List.fromList(cubit
                                  .notificationsModule!
                                  .notifications![0]
                                  .image!
                                  .data!
                                  .data!))
                              .image
                          : const AssetImage('asstes/image/logo_2.jpg'),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              fallback: (context) => Center(
                  child: CircularProgressIndicator(color: HexColor("#6823D0"))),
            );
          }),
    );
  }
}
