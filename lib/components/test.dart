import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Scroll extends StatefulWidget {
  const Scroll({super.key});

  @override
  State<Scroll> createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  final ScrollController _scrollController = ScrollController();
  mockFetch() async {
    await Future.delayed(Duration(milliseconds: 300));
  }

  @override
  void initState() {
    super.initState();
    // mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        print('end scroll');
        // mockFetch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const Text('data'),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 20)
    );
  }
}
