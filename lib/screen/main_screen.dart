import 'package:admin_panel/utils/app-constant.dart';
import 'package:admin_panel/widgets/custom-drawer-widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text('Admin Panel'),
      ),
      drawer:const DrawerWidget() ,
      body: Center(
        child: Text('Throw test Exception'),
        ),

    );

  }
}
