import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_navigation_drawer.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyNavigationDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pdf")
          ],
        ),
      ),
    );
  }
}