
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
    return BlocProvider(create: (context)=>PurpleBookCubit()..getFeed(),
    child: BlocConsumer<PurpleBookCubit,PurpleBookState>(
      listener: (context,state){},
      builder: (context,state){
        bool isVisible=PurpleBookCubit.get(context).indexBottom==0?true:false;
        return Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor("#6823D0"),
              title: Text(PurpleBookCubit.get(context).bar[PurpleBookCubit.get(context).indexBottom]),
            ),
            body:PurpleBookCubit.get(context).bottomNavItem[PurpleBookCubit.get(context).indexBottom] ,
            floatingActionButton:isVisible? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPostScreen()));
              },
              backgroundColor: HexColor("#6823D0"),
              child: const Icon(Icons.add),
            ):null,
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                PurpleBookCubit.get(context).changeBottom(index);
              },
              currentIndex:PurpleBookCubit.get(context).indexBottom,// cubit.indexBottom,
              selectedItemColor: HexColor("#6823D0"),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Feed'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: 'Friends'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: 'Notification'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.info_outline), label: 'Account'),
              ],
            )
        );
      },
    ),
    );
  }
}
