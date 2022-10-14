import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';

void showMsg({required String? msg, required ColorMsg? color}) =>
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chose(color!),
        textColor: Colors.white,
        fontSize: 16.0);

enum ColorMsg { error, success, inCorrect }

Color chose(ColorMsg msg) {
  Color color = Colors.green;
  switch (msg) {
    case ColorMsg.error:
      color = Colors.red;
      break;
    case ColorMsg.success:
      color = Colors.green;
      break;
    case ColorMsg.inCorrect:
      color = HexColor("#6823D0");
      break;
  }
  return color;
}

class Constants {
  static const String edit = 'edit';
  static const String delete = 'delete';

  static const List<String> chose = [edit, delete];
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(
      {Key? key, this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const ShimmerWidget.circular(
      {Key? key,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        decoration:
            ShapeDecoration(color: Colors.grey.shade400, shape: shapeBorder),
      ),
    );
  }
}

Widget buildFoodShimmer() => SingleChildScrollView(
  child:   ListView.builder(
  
        physics: const NeverScrollableScrollPhysics(),
  
        shrinkWrap: true,
  
        itemBuilder: (context, index) => ListTile(
  
          leading: ShimmerWidget.circular(
  
            width: 64,
  
            height: 64,
  
            shapeBorder:
  
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  
          ),
  
          title: const ShimmerWidget.rectangular(height: 16),
  
          subtitle: const ShimmerWidget.rectangular(height: 14),
  
        ),
  
        itemCount: 10,
  
      ),
);
