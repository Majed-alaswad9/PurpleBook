import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App info'),
        backgroundColor: HexColor("#6823D0"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/image/background.png'))),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('PurpleBook',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade300),
            ),
            const SizedBox(
              height: 10,
            ),
            Tab(
              height: 100,
              icon: Image.asset(
                'assets/image/logo_2.jpg',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('2022',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade300)),
            const SizedBox(
              height: 10,
            ),
            Text('Developed By:',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade300)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      const toEmail = 'alaswadmajed389@gmail.com';
                      final url = Uri.parse('mailto:$toEmail?subject=tell us how we can help');

                      await launchUrl(url);
                    },
                    child: const Text('Majed Alaswad',
                        style: TextStyle(color: Colors.blue))),
                TextButton(
                    onPressed: () async {
                      const toEmail = 'islamnaasani@gmail.com';
                      final url = Uri.parse('mailto:$toEmail?subject=tell us how we can help');
                      await launchUrl(url);
                    },
                    child: const Text('Islam Nassani',
                        style: TextStyle(color: Colors.blue))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Source code: ',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () async {
                      const http =
                          'https://github.com/Majed-alaswad9/PurpleBook';
                      final url = Uri.parse(http);
                      if (await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {}
                    },
                    child: const Text('GitHub',
                        style: TextStyle(color: Colors.blue))),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
