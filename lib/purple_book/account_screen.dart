import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/login_sigin/login_screen.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/users/user_profile.dart';
import 'package:purplebook/purple_book/users/view_post_user_screen.dart';
import 'package:purplebook/purple_book/view_post_screen.dart';

import '../component/components.dart';
import '../component/end_points.dart';
import '../modules/likes_module.dart';

// ignore: must_be_immutable
class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurpleBookCubit()
        ..getUserProfile(id: userId!)
        ..getUserPosts(userId: userId!),
      child: BlocConsumer<PurpleBookCubit, PurpleBookState>(
        listener: (context, state) {
          if(state is UpdateUserProfileSuccessState){
            showMsg(msg: 'Update Successfully', color: ColorMsg.inCorrect);
          }
          else if(state is UpdateUserProfileErrorState){
            showMsg(msg: 'Update Failed', color: ColorMsg.error);
          }

          if(state is DeleteUserSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
          }
        },
        builder: (context, state) {
          var cubit = PurpleBookCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.userProfile != null,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  if(state is UpdateUserProfileLoadingState)
                    LinearProgressIndicator(color: HexColor("#6823D0"),),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                backgroundColor: HexColor("#6823D0"),
                                radius: 90,
                                child: CircleAvatar(
                                  radius: 85,
                                  backgroundImage:cubit.profileImage ==null ? Image.memory(Uint8List.fromList(cubit.userProfile!.user!.imageFull!.data!.data!)).image:Image(image: FileImage(cubit.profileImage!)).image ,
                                ),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.all(10),
                              //   width: double.infinity,
                              //   height: 300,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //       image:  DecorationImage(
                              //           fit: BoxFit.fill,
                              //           image: Image.memory(Uint8List.fromList(cubit.userProfile!.user!.imageFull!.data!.data!)).image
                              //       )),
                              // ),
                              CircleAvatar(
                                backgroundColor: HexColor("#6823D0"),
                                radius: 25,
                                child: IconButton(
                                    onPressed: () {
                                      cubit.imageProfile(ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.camera_alt_outlined)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if(cubit.profileImage!=null)
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  elevation: 7,
                                  color: HexColor("#6823D0"),
                                  child: MaterialButton(
                                    onPressed: () {
                                      firstNameController.text=cubit.userProfile!.user!.firstName!;
                                      lastNameController.text=cubit.userProfile!.user!.lastName!;
                                      cubit.editUserProfile(id: userId!, firstName: firstNameController.text, lastName: lastNameController.text);
                                    },
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(
                                        color:  Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  elevation: 7,
                                  color: HexColor("#6823D0"),
                                  child: MaterialButton(
                                    onPressed: () {
                                      cubit.deletePhotoProfile();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${cubit.userProfile!.user!.firstName} ${cubit.userProfile!.user!.lastName}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10,),
                            CircleAvatar(
                              radius: 15,
                                backgroundColor: HexColor("#6823D0"),
                                child: IconButton(
                                    onPressed: (){
                                      firstNameController.text=cubit.userProfile!.user!.firstName!;
                                      lastNameController.text=cubit.userProfile!.user!.lastName!;
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context_2) =>
                                              AlertDialog(
                                                  title: const Text('Edit Name'),
                                                  elevation: 10,
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      TextFormField(
                                                        controller: firstNameController,
                                                        maxLines: 2,
                                                        minLines: 1,
                                                        keyboardType: TextInputType.multiline,
                                                        decoration: InputDecoration(
                                                            label: const Text('First Name'),
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
                                                      const SizedBox(height: 15,),
                                                      TextFormField(
                                                        controller: lastNameController,
                                                        maxLines: 2,
                                                        minLines: 1,
                                                        keyboardType: TextInputType.multiline,
                                                        decoration: InputDecoration(
                                                            label: const Text('Last Name'),
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
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context_2, 'Cancel');
                                                      },
                                                      child: const Text('Cancel',
                                                        style: TextStyle(
                                                            color: Colors.black),),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        cubit.editUserProfile(id: userId!, firstName: firstNameController.text, lastName: lastNameController.text);
                                                        Navigator.pop(context_2,'Update');
                                                      },
                                                      child: Text('OK', style: TextStyle(
                                                          color: HexColor("#6823D0")),
                                                    ),)
                                                  ]));
                                    },
                                    icon: const Icon(Icons.edit,size: 14,),))
                          ],
                        ),
                       const SizedBox(height: 25,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            height: 1.5,
                            color: HexColor("#6823D0"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  color: Colors.red,
                                  width: double.infinity,
                                  child:  MaterialButton(onPressed: (){
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                            title: const Text(
                                                'Delete account'),
                                            content: const Text(
                                                'Are you sure yoo delete your account'),
                                            elevation: 10,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'Cancel');
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
                                                  cubit.deleteUser();
                                                  Navigator.pop(
                                                      context, 'OK');
                                                },
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ]));
                                  },child: const Text('Delete Account',style: TextStyle(fontSize: 20,color: Colors.white),),),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      elevation: cubit.indexWidget == 0 ? 10 : 0,
                                      color: cubit.indexWidget == 0
                                          ? HexColor("#6823D0")
                                          : Colors.white,
                                      child: MaterialButton(
                                        onPressed: () {
                                          cubit.getUserPosts(userId: userId!);
                                          cubit.indexWidget = 0;
                                        },
                                        child: Text(
                                          'Posts',
                                          style: TextStyle(
                                            color: cubit.indexWidget == 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      elevation: cubit.indexWidget == 1 ? 10 : 0,
                                      color: cubit.indexWidget == 1
                                          ? HexColor("#6823D0")
                                          : Colors.white,
                                      child: MaterialButton(
                                        onPressed: () {
                                          cubit.getUserComments(id: userId!);
                                          cubit.indexWidget = 1;
                                        },
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                            color: cubit.indexWidget == 1
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      elevation: cubit.indexWidget == 2 ? 10 : 0,
                                      color: cubit.indexWidget == 2
                                          ? HexColor("#6823D0")
                                          : Colors.white,
                                      child: MaterialButton(
                                        onPressed: () {
                                          cubit.getUSerFriends(id: userId!);
                                          cubit.indexWidget = 2;
                                        },
                                        child: Text(
                                          'Friends',
                                          style: TextStyle(
                                            color: cubit.indexWidget == 2
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                  if (cubit.indexWidget == 0)
                    ConditionalBuilder(
                        condition: cubit.userPost!=null,
                        builder:(context)=> userPosts(context),
                        fallback: (context)=>buildFoodShimmer(),
                    )
                  else if (cubit.indexWidget == 1)
                    ConditionalBuilder(
                      condition: cubit.userComments!=null,
                      builder:(context)=> userComments(context,cubit),
                      fallback: (context)=>buildFoodShimmer(),
                    )
                  else
                    ConditionalBuilder(
                      condition: cubit.userFriends!=null,
                      builder:(context)=> userFriend(context,cubit),
                      fallback: (context)=>buildFoodShimmer(),
                    )
                ],
              ),
            ),
            fallback: (context) => Center(
                child: CircularProgressIndicator(
              color: HexColor("#6823D0"),
            )),
          );
        },
      ),
    );
  }

  // build Widget user comments
  Widget userComments(context, cubit) => ConditionalBuilder(
      condition: cubit.userComments != null && cubit.isLikeComment!.isNotEmpty,
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
                                    count: index)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'on ${cubit.userComments!.comments![index].post!.postAuthorFirstName!}\'s',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            '"',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            parseFragment(cubit.userComments!.comments![index]
                                    .post!.contentPreview)
                                .text!,
                            maxLines: 1,
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
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.black, fontSize: 16),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
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
                            cubit.likeComment(
                                idPost: cubit
                                    .userComments!.comments![index].post!.sId!,
                                idComment:
                                    cubit.userComments!.comments![index].sId!,
                                index: index);
                            cubit.changeLikeComment(index);
                          },
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          color:
                              PurpleBookCubit.get(context).isLikeComment![index]
                                  ? HexColor("#6823D0")
                                  : Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${cubit.likeCommentCount![index]} like',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.grey, fontSize: 15),
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
      fallback: (context) => const Center(child: Text(
        'No Comments Yet (•_•)',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600
        ),
      )));

  //build Widget user posts
  Widget userPosts(context) => ConditionalBuilder(
        condition: PurpleBookCubit.get(context).userPost!.posts!.isNotEmpty ,
        builder: (context) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => buildUserPost(
                PurpleBookCubit.get(context).userPost, index, context),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: PurpleBookCubit.get(context).userPost!.posts!.length),
        fallback: (context) => const Center(child: Text(
          'No Posts Yet (•_•)',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600
          ),
        )),
      );

  //build Widget user friends
  Widget userFriend(context, cubit) => ConditionalBuilder(
      condition: cubit.userFriends.friends.isNotEmpty,
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
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-photo/woman-using-smartphone-social-media-conecpt_53876-40967.jpg?t=st=1647704509~exp=1647705109~hmac=f1ae56f2218ca7938f19ae0fbd675b8c6b2e21d3d25548429a500e43f89ce211&w=740'),
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
                                            .sId)));
                          },
                          child: Text(
                            '${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                        MaterialButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                        'unfriend ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName}'),
                                    content: Text('Are you sure you want to remove ${cubit.userFriends!.friends![index].firstName} ${cubit.userFriends!.friends![index].lastName} from friends list?'),
                                    elevation: 10,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancel');
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
                                          cubit.cancelFriend(receiveId: cubit.userFriends!.friends![index].sId).then((value) {
                                            cubit.getUSerFriends(id: userId);
                                            Navigator.pop(context, 'OK');
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
                        )
                    ],
                  )),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: cubit.userFriends!.friends!.length,
          ),
      fallback: (context) => const Center(child: Text(
        'No Friends Yet (•_•)',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600
        ),
      )));

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
                    Expanded(
                      child: Text(
                          '${user!.posts![index].createdAt!.year.toString()}-'
                              '${user.posts![index].createdAt!.month.toString()}-'
                              '${user.posts![index].createdAt!.day.toString()}  '
                              '${user.posts![index].createdAt!.hour.toString()}:'
                              '${user.posts![index].createdAt!.minute.toString()}',
                          style:
                              const TextStyle(height: 1.3, color: Colors.grey)),
                    ),
                    PopupMenuButton(onSelected: (value) {
                      if (value == Constants.edit) {
                        /* Navigator.push(
                            conteext,
                            MaterialPageRoute(
                                builder: (context) => EditPostScreen(
                                    id: feed.posts![index].sId!,
                                    post: feed.posts![index],
                                    index: index)));*/
                        firstNameController.text =
                            parseFragment(user.posts![index].content!).text!;
                        showDialog<String>(
                            context: context_1,
                            builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Edit'),
                                    content: TextFormField(
                                      controller: firstNameController,
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
                                            borderSide:
                                                BorderSide(color: Colors.grey),
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
                                                  edit: firstNameController.text,
                                                  id: user.posts![index].sId!,
                                                  index: index);
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
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          PurpleBookCubit.get(context_1)
                                              .deletePost(
                                                  id: user.posts![index].sId!);
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK',
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context_1,
                        MaterialPageRoute(
                            builder: (context) => ViewPostUserScreen(
                                  id: user.posts![index].sId!,
                                  count: index,
                                )));
                  },
                  child: Text(
                    '${parseFragment(user.posts![index].content).text}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                if (user.posts![index].image!.data!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context_1,
                          MaterialPageRoute(
                              builder: (context) => ViewPostUserScreen(
                                    id: user.posts![index].sId!,
                                    count: index,
                                  )));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image:  DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.memory(base64Decode(user.posts![index].image!.data!)).image
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
                                        .getLikes!
                                        .users!
                                        .isNotEmpty,
                                    builder: (context) => ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            buildBottomSheet(
                                                PurpleBookCubit.get(context_1)
                                                    .getLikes!,
                                                index),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        itemCount:
                                            PurpleBookCubit.get(context_1)
                                                .getLikes!
                                                .users!
                                                .length),
                                    fallback: (context) => const Center(
                                        child: Text(
                                      'Not Likes Yet',
                                      style: TextStyle(fontSize: 25),
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
                                  '${PurpleBookCubit.get(context_1).likesUserCount![index]}',
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
                                            ViewPostUserScreen(
                                                id: user.posts![index].sId!,
                                                count: index)));
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
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Write Comment...',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context_1,
                              MaterialPageRoute(
                                  builder: (context_1) => ViewPostUserScreen(
                                      id: user.posts![index].sId!,
                                      count: index)));
                        },
                      ),
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
                            id: user.posts![index].sId!, index: index);
                        PurpleBookCubit.get(context_1)
                            .changeLikePostUser(index);
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
                        '${user.users![index].firstName} ${user.users![index].lastName}',
                        style: const TextStyle(
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
                if (user.users![index].sId != userId)
                  if (user.users![index].friendState == 'NOT_FRIEND')
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.blue,
                      child: const Text(
                        'Add Friend',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.blueGrey,
                      child: const Text(
                        'Cancel Friend',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
              ],
            ),
          ],
        ),
      );

  Widget buildFoodShimmer()=>ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder:(context,index)=> ListTile(
      leading: ShimmerWidget.circular(width: 64, height: 64,shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
      title: const ShimmerWidget.rectangular(height: 16),
      subtitle: const ShimmerWidget.rectangular(height: 14),
    ),
    itemCount: 10,
  );
}
