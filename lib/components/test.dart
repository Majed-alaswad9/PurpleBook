import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}



class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar:  AppBar(
        title:  const Text("Offline Demo"),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          connected? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Online Now'))):null;
          return  Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected ? const Color(0xFF00EE44) : const Color(0xFFEE4400),
                  child: Center(
                    child: Text(connected ? 'ONLINE' : 'OFFLINE'),
                  ),
                ),
              ),
              const Center(
                child:  Text(
                  'Yay!',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
