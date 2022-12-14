import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:purplebook/components/const.dart';

class ViewListImage extends StatelessWidget {
  final List<int> image;
  const ViewListImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6823D0),
        actions: [
          TextButton(
            child: const Text('Save',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            onPressed: () async {
              final res =
                  await ImageGallerySaver.saveImage(Uint8List.fromList(image));
              // ignore: use_build_context_synchronously
              showSnackBar('$res', context, const Color(0xFF6823D0));
            },
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
