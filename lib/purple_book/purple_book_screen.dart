import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:purplebook/cubit/cubit.dart';
import 'package:purplebook/login_signup/login_screen.dart';
import 'package:purplebook/network/local/cach_helper.dart';
import 'package:purplebook/purple_book/app_info.dart';
import 'package:purplebook/purple_book/new_post_screen.dart';
import '../components/end_points.dart';
import 'cubit/purplebook_cubit.dart';
import 'cubit/purplebook_state.dart';

class PurpleBookScreen extends StatelessWidget {
  const PurpleBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getFriendRequestFromAnyScreen()
        ..getNotificationsFromAnyScreen()
        ..getUserProfile(id: userId!),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {},
        builder: (context, state) {
          bool isVisible =
              PurpleBookCubit.get(context).indexBottom == 0 ? true : false;
          return WillPopScope(
            onWillPop: () async {
              if (PurpleBookCubit.get(context).indexBottom == 0) {
                return true;
              } else {
                PurpleBookCubit.get(context).changeBottom(0);
                return false;
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: HexColor("#6823D0"),
                  title: Text(PurpleBookCubit.get(context)
                      .bar[PurpleBookCubit.get(context).indexBottom]),
                  actions: [
                    IconButton(
                        onPressed: () {
                          MainCubit.get(context).changeThemeMode();
                        },
                        icon: const Icon(Icons.brightness_medium))
                  ],
                ),
                body: PurpleBookCubit.get(context)
                    .bottomNavItem[PurpleBookCubit.get(context).indexBottom],
                drawer: const NavigationDrawer(),
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
                    PurpleBookCubit.get(context)
                        .getNotificationsFromAnyScreen();
                    PurpleBookCubit.get(context)
                        .getFriendRequestFromAnyScreen();
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
                          if (PurpleBookCubit.get(context)
                                  .friendsRequestCount !=
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
                                  '${PurpleBookCubit.get(context).friendsRequestCount}',
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
                      label: 'Notification',
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
                        icon: Icon(Icons.account_circle_rounded),
                        label: 'Account'),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildHeader(context), buildMenuItem(context)],
        ),
      ),
    );
  }

  Widget buildHeader(context_1) {
    return ConditionalBuilder(
      condition: PurpleBookCubit.get(context_1).userProfile != null,
      builder: (context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HexColor("#6823D0"), Colors.blueAccent])),
        padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context_1).padding.top, bottom: 50),
        child: Column(children: [
          CircleAvatar(
            radius: 65,
            backgroundImage: PurpleBookCubit.get(context_1)
                    .userProfile!
                    .user!
                    .imageFull!
                    .data!
                    .data!
                    .isNotEmpty
                ? Image.memory(Uint8List.fromList(PurpleBookCubit.get(context_1)
                        .userProfile!
                        .user!
                        .imageFull!
                        .data!
                        .data!))
                    .image
                : const AssetImage('assets/image/user.jpg'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${PurpleBookCubit.get(context_1).userProfile!.user!.firstName!} ${PurpleBookCubit.get(context_1).userProfile!.user!.lastName!}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ]),
      ),
      fallback: (context) => Container(
          padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context_1).padding.top, bottom: 50),
          child: LinearProgressIndicator(color: HexColor("#6823D0"))),
    );
  }

  Widget buildMenuItem(context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Feed'),
            onTap: () {
              PurpleBookCubit.get(context).changeBottom(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Row(
              children: [
                const Text('Friends'),
                const Spacer(),
                if (PurpleBookCubit.get(context).friendsRequestCount != 0)
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ignore: prefer_const_constructors
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '${PurpleBookCubit.get(context).friendsRequestCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              PurpleBookCubit.get(context).changeBottom(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Row(
              children: [
                const Text('notifications'),
                const Spacer(),
                if (PurpleBookCubit.get(context).notificationsCount != 0)
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ignore: prefer_const_constructors
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '${PurpleBookCubit.get(context).notificationsCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              PurpleBookCubit.get(context).changeBottom(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text('Account'),
            onTap: () {
              PurpleBookCubit.get(context).changeBottom(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text('Logout'),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete friend request'),
                          content: const Text(
                              'Are you sure you want to Delete this request?'),
                          elevation: 10,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'No');
                              },
                              child: Text(
                                'No',
                                style: TextStyle(color: HexColor("#6823D0")),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                CachHelper.removeUser(key: 'token')
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Logout Successfully')));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      (route) => false);
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Logout Successfully')));
                                });
                                Navigator.pop(context, 'Yes');
                              },
                              child: Text('Yes',
                                  style: TextStyle(color: HexColor("#6823D0"))),
                            ),
                          ]));
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App info'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AppInfo()));
            },
          ),
        ],
      ),
    );
  }
}
