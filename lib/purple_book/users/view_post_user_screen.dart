import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/modules/comments_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';

import '../../components/const.dart';
import '../../components/end_points.dart';
import '../../modules/likes_module.dart';
import '../cubit/purplebook_state.dart';


class ViewPostUserScreen extends StatelessWidget {
  final String id;
  final int count;

  ViewPostUserScreen({Key? key, required this.id, required this.count}) : super(key: key);
  var contentController = TextEditingController();
  var editController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..viewPosts(id: id)..getComments(id: id)..getUserPosts(userId: userId!),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          if (state is DeleteCommentPostSuccessState) {
            showMsg(msg: 'deleted Successfully', color: ColorMsg.success);
          } else if (state is DeleteCommentPostErrorState) {
            showMsg(msg: 'Failed delete', color: ColorMsg.error);
          }

          if (state is AddCommentPostSuccessState) {
            showMsg(msg: 'Added Successfully', color: ColorMsg.inCorrect);
            contentController.text = '';
          } else if (state is AddCommentPostErrorState) {
            showMsg(msg: 'Added Failed', color: ColorMsg.error);
          }
        },
        builder: (context, state) {
          var cubit = PurpleBookCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('View Post'),
              backgroundColor: HexColor("#6823D0"),
            ),
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state is AddCommentPostLoadingState)
                        LinearProgressIndicator(
                          color: HexColor("#6823D0"),
                        ),
                      ConditionalBuilder(
                        condition:cubit.postView!=null &&cubit.isLikeUserPost!.isNotEmpty ,
                        builder: (context) => Card(
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
                                      const CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-photo/woman-using-smartphone-social-media-conecpt_53876-40967.jpg?t=st=1647704509~exp=1647705109~hmac=f1ae56f2218ca7938f19ae0fbd675b8c6b2e21d3d25548429a500e43f89ce211&w=740'),
                                      ),
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
                                                '${cubit.postView!.post!.createdAt}',
                                                style: const TextStyle(
                                                    height: 1.3,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ),
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
                                  Text(
                                    ' ${parseFragment(cubit.postView!.post!.content!).text!}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  if (cubit.postView!.post!.image!.data!.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                                          )),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              cubit.likeUserPost(id: id, index: count);
                                              cubit.changeLikePostUser(count);
                                            },
                                            icon: const Icon(Icons.thumb_up_alt_outlined),
                                            color: PurpleBookCubit.get(context).isLikeUserPost![count]
                                                ? HexColor("#6823D0")
                                                : Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: (){
                                              PurpleBookCubit.get(context).getLikesPost(id: id).then((value) {
                                                showModalBottomSheet(context: context,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(20))
                                                  ),
                                                  builder: (context) =>
                                                      ConditionalBuilder(
                                                        condition: PurpleBookCubit.get(context).likeModule!.users!.isNotEmpty,
                                                        builder: (context) => ListView.separated(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemBuilder: (context, index) => buildBottomSheet(PurpleBookCubit.get(context).likeModule!, index),
                                                            separatorBuilder: (context, index) => const SizedBox(height: 10,),
                                                            itemCount: PurpleBookCubit.get(context).likeModule!.users!.length),
                                                        fallback: (context) => const Center(child: Text('Not Likes Yet',
                                                          style: TextStyle(fontSize: 25),)),
                                                      ),);
                                              });

                                            },
                                            child: Text(
                                              '${cubit.likesUserCount![count]} like',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
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
                            )),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(
                            color: HexColor("#6823D0"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: contentController,
                          maxLines: 100,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          validator: validateContent,
                          decoration: InputDecoration(
                              suffix: IconButton(
                                color: HexColor("#6823D0"),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.addComment(
                                        postId: id,
                                        text: contentController.text);
                                  }
                                },
                                icon: const Icon(Icons.send),
                              ),
                              label: const Text('Write comment'),
                              labelStyle: TextStyle(color: HexColor("#6823D0")),
                              hintStyle: Theme.of(context).textTheme.subtitle2,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: HexColor("#6823D0")),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.all(10)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is DeleteCommentPostLoadingState)
                        LinearProgressIndicator(
                          color: HexColor("#6823D0"),
                          backgroundColor: Colors.white,
                        ),
                      ConditionalBuilder(
                          condition: cubit.comment != null,
                          builder: (context) => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => buildComments(
                                  cubit.comment!, index,
                                  context,
                                  id),
                              separatorBuilder: (context, index) =>
                              const SizedBox(
                                height: 10,
                              ),
                              itemCount: cubit.comment!.comments!.length),
                          fallback: (context) => const Center(
                            child: Text(
                              'NO Comments Yet',
                              style: TextStyle(fontSize: 25),
                            ),
                          ))
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget buildComments(
      CommentsModule user, int index, context_1, String postId) =>
      Card(
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-photo/woman-using-smartphone-social-media-conecpt_53876-40967.jpg?t=st=1647704509~exp=1647705109~hmac=f1ae56f2218ca7938f19ae0fbd675b8c6b2e21d3d25548429a500e43f89ce211&w=740'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.comments![index].author!.firstName} ${user.comments![index].author!.lastName}',
                          style: const TextStyle(
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text('${user.comments![index].createdAt}',
                            style: const TextStyle(
                                height: 1.3, color: Colors.grey))
                      ],
                    ),
                  ),
                  if (userId == user.comments![index].author!.sId)
                    PopupMenuButton(onSelected: (value) {
                      if (value == Constants.edit) {
                        contentController.text=user.comments![index].content!;
                        showDialog<String>(
                            context: context_1,
                            builder: (BuildContext context) => AlertDialog(
                                title: const Text('Edit'),
                                content: TextFormField(
                                  controller: contentController,
                                  maxLines: 100,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      label: const Text('Write comment'),
                                      labelStyle: TextStyle(color: HexColor("#6823D0")),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .subtitle2,
                                      border: const OutlineInputBorder(),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: HexColor("#6823D0")),
                                        borderRadius: const BorderRadius.all(Radius.circular(
                                            10.0)),
                                      ),
                                      contentPadding: const EdgeInsets.all(10)),
                                ),
                                actions:[
                                  TextButton(
                                    onPressed: ()
                                    {
                                      Navigator.pop(context, 'Cancel');
                                    } ,
                                    child: Text('Cancel',style: TextStyle(color: HexColor("#6823D0")),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      PurpleBookCubit.get(context_1).editComment(postId: postId,
                                          commentId: user.comments![index].sId!,
                                          text: contentController.text).then((value) {
                                        showMsg(msg: 'editing successfully',
                                            color: ColorMsg.inCorrect);
                                        Navigator.pop(context, 'OK');
                                      });
                                    },
                                    child: Text('OK',style: TextStyle(color: HexColor("#6823D0"))),
                                  ),
                                ]));
                      } else if (Constants.delete == value) {
                        PurpleBookCubit.get(context_1).deleteComment(
                            postId: id, commentId: user.comments![index].sId!);
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
              Text(
                parseFragment(user.comments![index].content).text!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      PurpleBookCubit.get(context_1).likeComment(
                          idPost: id,
                          idComment: PurpleBookCubit.get(context_1)
                              .comment!
                              .comments![index]
                              .sId!,
                          index: index);
                      PurpleBookCubit.get(context_1).changeLikeComment(index);
                    },
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    color: PurpleBookCubit.get(context_1).isLikeComment![index]
                        ? HexColor("#6823D0")
                        : Colors.grey,
                  ),
                  Text(
                    '${PurpleBookCubit.get(context_1).likeCommentCount![index]} like',
                    style: Theme.of(context_1)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.grey, fontSize: 15),
                  )
                ],
              ),
            ],
          ),
        ),
      );

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

  String? validateContent(String? value) {
    if (value != null) {
      return null;
    }
    return 'Write a Comment';
  }
}
