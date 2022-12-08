import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:purplebook/components/const.dart';

class ViewStringImage extends StatelessWidget {
  final String image;
  const ViewStringImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6823D0),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: () async {
              await ImageGallerySaver.saveImage(
                  base64Decode(image).buffer.asUint8List());
              // ignore: use_build_context_synchronously
              showSnackBar('Saved Successfully', context, const Color(0xFF6823D0));
            },
          )
        ],
      ),
      body: Center(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Image.memory(base64Decode(image)).image)))),
    );
  }
}
