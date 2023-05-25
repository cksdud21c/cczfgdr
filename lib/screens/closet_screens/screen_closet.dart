import 'package:flutter/material.dart';
import 'package:untitled/screens/closet_screens/screen_closetbody.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';

class Closet_Page extends StatelessWidget {
  const Closet_Page({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text(title),
      ),
      endDrawer : SafeArea(
        child:
        Menu(),
      ),
      body: ClosetScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFFFD725A),
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Bottombar(),
    );
  }
}