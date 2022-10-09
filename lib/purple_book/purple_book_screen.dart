import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purplebook/purple_book/new_post_screen.dart';
import 'cubit/purplebook_cubit.dart';
import 'cubit/purplebook_state.dart';

class PurpleBookScreen extends StatelessWidget {
  const PurpleBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getFriendRequestFromAnyScreen()
        ..getNotificationsFromAnyScreen(),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isVisible =
              PurpleBookCubit.get(context).indexBottom == 0 ? true : false;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: HexColor("#6823D0"),
                title: Text(PurpleBookCubit.get(context)
                    .bar[PurpleBookCubit.get(context).indexBottom]),
              ),
              body: PurpleBookCubit.get(context)
                  .bottomNavItem[PurpleBookCubit.get(context).indexBottom],
              floatingActionButton: isVisible
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewPostScreen()));
                      },
                      backgroundColor: HexColor("#6823D0"),
                      child: const Icon(Icons.add),
                    )
                  : null,
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  PurpleBookCubit.get(context).changeBottom(index);
                  PurpleBookCubit.get(context).getNotificationsFromAnyScreen();
                  PurpleBookCubit.get(context).getFriendRequestFromAnyScreen();
                },
                currentIndex: PurpleBookCubit.get(context)
                    .indexBottom, // cubit.indexBottom,
                selectedItemColor: HexColor("#6823D0"),
                unselectedItemColor: Colors.grey,

                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Feed'),
                  BottomNavigationBarItem(
                    label: 'Friends',
                    icon: Stack(
                      children: <Widget>[
                        const Icon(Icons.people),
                        if (PurpleBookCubit.get(context).friendeRequestCount !=
                            0)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              // ignore: prefer_const_constructors
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${PurpleBookCubit.get(context).friendeRequestCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Notificatio',
                    icon: Stack(
                      children: <Widget>[
                        const Icon(Icons.notifications),
                        if (PurpleBookCubit.get(context).notificationsCount !=
                            0)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // ignore: prefer_const_constructors
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${PurpleBookCubit.get(context).notificationsCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.info_outline), label: 'Account'),
                ],
              ));
        },
      ),
    );
  }
}
