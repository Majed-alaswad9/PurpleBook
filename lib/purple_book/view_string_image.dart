import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ViewStringImage extends StatelessWidget {
  final String image;
  const ViewStringImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#6823D0"),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: () async {
              await ImageGallerySaver.saveImage(
                  base64Decode(image).buffer.asUint8List());
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Saved Successfully')));
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
