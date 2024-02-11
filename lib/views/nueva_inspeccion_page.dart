import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_textfield.dart';
import 'package:modernlogintute/theme/dimensions.dart';
import 'package:modernlogintute/views/checklist_page.dart';

import '../components/my_button.dart';
import '../components/my_navigation_drawer.dart';
import 'my_home_page.dart';

class NuevaInspeccionPage extends StatelessWidget {
  NuevaInspeccionPage({Key? key}) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(),
      drawer: const MyNavigationDrawer(),
      body: Column(
        children: [
          const Text("Datos de la inspeccion"),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.marginMedium),
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).drawerTheme.backgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
              ),
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.marginSmall),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return MyTextField(
                          controller: controller,
                          hintText: "hint",
                        );
                      },
                    ),
                  ),
                  //const SizedBox(height: Dimensions.marginSmall),
                ],
              )
            )
          ),
          MyButton(
            adaptableWidth: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckListPage()),
              );
            },
            text: "ir a checklist",
          ),
        ],
      ),
    );
  }
}
