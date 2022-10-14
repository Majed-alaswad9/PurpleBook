import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';
import 'package:purplebook/purple_book/user_profile.dart';

// ignore: must_be_immutable
class EditPostScreen extends StatelessWidget {
  final String id;
  final String content;
  EditPostScreen(
      {Key? key, required this.id, required this.content})
      : super(key: key);
  var editPostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()..viewPosts(id: id),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
          listener: (context, state) {
        if (state is EditPostSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Editing Successfully')));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PurpleBookScreen()),
              (route) => false);
        } else if (state is EditPostErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('❌ Editing Failed')));
        }
      }, builder: (context, state) {
        var cubit = PurpleBookCubit.get(context);
        editPostController.text = parseFragment(content).text!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('edit Post'),
            backgroundColor: HexColor("#6823D0"),
            actions: [
              TextButton(
                onPressed: () {
                  PurpleBookCubit.get(context)
                      .editPosts(edit: editPostController.text, id: id);
                },
                child: const Text('edit',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              )
            ],
          ),
          body: ConditionalBuilder(
            condition: cubit.postView != null,
            builder: (context) => SingleChildScrollView(
                child: Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state is EditPostLoadingState)
                            LinearProgressIndicator(
                              color: HexColor("#6823D0"),
                            ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                          id: cubit
                                              .postView!.post!.author!.sId!)));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 25,
                                    backgroundImage: cubit.postView!.post!
                                            .author!.imageMini!.data!.isNotEmpty
                                        ? Image.memory(base64Decode(cubit
                                                .postView!
                                                .post!
                                                .author!
                                                .imageMini!
                                                .data!))
                                            .image
                                        : const AssetImage(
                                            'assets/image/user.jpg')),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${cubit.postView!.post!.author!.firstName} ${cubit.postView!.post!.author!.lastName}',
                                        style: const TextStyle(
                                            height: 1.3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(
                                          '${cubit.postView!.post!.createdAt!.year}-'
                                          '${cubit.postView!.post!.createdAt!.month}-'
                                          '${cubit.postView!.post!.createdAt!.day}',
                                          style: const TextStyle(
                                              height: 1.3, color: Colors.grey))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                          TextFormField(
                            autofocus: true,
                            controller: editPostController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: null,
                          ),
                          if (cubit.postView!.post!.image!.data!.isNotEmpty)
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: Image.memory(base64Decode(cubit
                                              .postView!.post!.image!.data!))
                                          .image)),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                                      '${cubit.postView!.post!.likesCount}',
                                      style: Theme.of(context)
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ))),
            fallback: (context) => Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: HexColor("#6823D0"),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
