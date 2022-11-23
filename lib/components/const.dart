import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/cubit.dart';

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
      child: ListView.builder(
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

Widget textForm(
        {TextEditingController? controller,
        String? label,
        String? hint,
        int? maxLines,
        int? minLines,
        TextInputType? keyboardType}) =>
    TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          label: Text(label!),
          labelStyle: TextStyle(color: HexColor("#6823D0")),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#6823D0")),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          contentPadding: const EdgeInsets.all(10)),
    );

Widget textButton(
        {BuildContext? context,
        required String label,
        required VoidCallback onPressed}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: HexColor("#6823D0")),
      ),
    );

Widget dropDown(
        {required BuildContext context,
        String? value1,
        String? value2,
        String? text1,
        String? text2,
        required Object dropDownValue,
        ValueChanged? change}) =>
    DropdownButton(
        style: TextStyle(
            color: MainCubit.get(context).isDark ? Colors.white : Colors.black),
        items: [
          DropdownMenuItem(
            value: value1,
            child: Text(
              text1!,
              style: TextStyle(
                  color: MainCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: value2,
            child: Text(
              text2!,
              style: TextStyle(
                  color: MainCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
        dropdownColor:
            MainCubit.get(context).isDark ? HexColor("#242F3D") : Colors.white,
        value: dropDownValue,
        onChanged: change);
