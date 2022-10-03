// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/component/components.dart';
import 'package:purplebook/purple_book/cubit/purplebook_cubit.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/purple_book_screen.dart';

class NewPostScreen extends StatelessWidget {
   NewPostScreen({Key? key}) : super(key: key);
  var contentController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>PurpleBookCubit(),
        child: BlocConsumer<PurpleBookCubit,PurpleBookState>(
          listener: (context,state){
            if(state is AddNewPostSuccessState){
              showMsg(msg: 'post successfully', color: ColorMsg.success);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const PurpleBookScreen()), (route) => false);
            }
            else{
              if(state is AddNewPostErrorState){
                showMsg(msg: 'Failed Post', color: ColorMsg.error);
              }
            }
          },
          builder: (context,state){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: HexColor("#6823D0"),
                title: const Text('New Post'),
                actions: [
                  TextButton(onPressed: (){
                      PurpleBookCubit.get(context).newPost(content: contentController.text);
                  },
                      child: const Text('Post',style: TextStyle(fontSize: 17,color: Colors.white),))
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is AddNewPostLoadingState)
                      LinearProgressIndicator(color: HexColor("#6823D0"),backgroundColor: Colors.white,),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: contentController,
                        maxLines: 100,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: 'What\'s on your mind? ',
                            border: InputBorder.none,
                        ),
                      ),
                      ),
                      if(PurpleBookCubit.get(context).postImage!=null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                               Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image:  DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(PurpleBookCubit.get(context).postImage!),
                                      )),
                                ),
                              CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black12,
                                  child: IconButton(onPressed: (){
                                    PurpleBookCubit.get(context).deletePhotoPost();
                                  }, icon: const Icon(Icons.close,color: Colors.red,)))
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: MaterialButton(onPressed: (){
                              PurpleBookCubit.get(context).imagePost(ImageSource.camera);
                            },color: HexColor("#6823D0"),child: const Text('Camera',style: TextStyle(color: Colors.white),),),),
                            const SizedBox(width: 10,),
                            Expanded(child: MaterialButton(onPressed: (){
                              PurpleBookCubit.get(context).imagePost(ImageSource.gallery);
                            },color: HexColor("#6823D0"),child: const Text('Gallery',style: TextStyle(color: Colors.white)),)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            );
          },
        ),
    );

  }
   String? validateContent(String? value) {
     if (value != null) {
       return null;
     }
     return 'Write Post';
   }
}
