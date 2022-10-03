import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';

import '../modules/feed_moduel.dart';

class EditPostScreen extends StatelessWidget {
  final String id;
  final Posts post;
  final int index;
   EditPostScreen( {Key? key, required this.id, required this.post, required this.index}): super(key: key);
  var editPostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(context)=> PurpleBookCubit()..getFeed(),
    child: BlocConsumer<PurpleBookCubit,PurpleBookState>(
        listener: (context,state){
          if(state is GetFeedSuccessState){
            editPostController.text=parseFragment(state.feed.posts![index].content!).text!;
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: const Text('edit Post'),
              backgroundColor: HexColor("#6823D0") ,
              actions: [
                TextButton(onPressed: (){
                  PurpleBookCubit.get(context).editPosts(edit: editPostController.text,id: post.sId!,index: index);
                }, child: const Text('edit',style: TextStyle(color: Colors.white,fontSize: 20)),)
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! EditPostLoadingState,
              builder: (context)=>SingleChildScrollView(
                child: Card(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Text(
                                      '${post.author!.firstName} ${post.author!.lastName}',
                                      style: const TextStyle(
                                          height: 1.3,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text('${post.createdAt}',
                                        style: const TextStyle(
                                            height: 1.3, color: Colors.grey))
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
                          TextFormField(
                            controller: editPostController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: null,

                          ),
                          if(post.image!=null)
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                                  )),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                          '${post.likesCount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.grey, fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                          'comment',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.grey, fontSize: 17),
                                        )
                                      ],
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
                            children:  [
                              Expanded(
                                child: InkWell(
                                  child: Row(
                                    children: const [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Write Comment...',style: TextStyle(fontSize: 15,color: Colors.grey),),
                                    ],
                                  ),
                                  onTap: (){
                                  },
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(Icons.thumb_up,size: 20,color: Colors.grey,),
                                    SizedBox(width: 5,),
                                    Text('like',style: TextStyle(fontSize: 15,color: Colors.grey))
                                  ],
                                ),
                                onTap: (){

                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ))
              ),
              fallback: (context)=> Center(child: CircularProgressIndicator(color: HexColor("#6823D0"),),),
            ),
          );
        }
    ),
    );
  }
}
