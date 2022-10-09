import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ViewListImage extends StatelessWidget {
  final List<int> image;
  const ViewListImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#6823D0"),
        actions: [
          TextButton(
            child: const Text('Save',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            onPressed: () async {},
          )
        ],
      ),
      body: Center(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Image.memory(Uint8List.fromList(image)).image)))),
    );
  }
}
