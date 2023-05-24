import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/models/model_clothing_item.dart';
import 'package:http/http.dart' as http;

class ClothingGrid extends StatefulWidget {
  final List<ClothingItem> clothingItems;

  ClothingGrid({required this.clothingItems});

  @override
  State<ClothingGrid> createState() => _ClothingGridState();
}

class _ClothingGridState extends State<ClothingGrid> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), // GridView의 스크롤 비활성화
        children: List.generate(widget.clothingItems.length, (index) {
          return GestureDetector(
            onTap: () {
              _showDetailDialog(context, widget.clothingItems[index]);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0), // 각 이미지에 간격 추가
              child: Image.network(
                widget.clothingItems[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              Image.network(item.imageUrl),
              // Add more details or customize the layout as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _showDeleteConfirmationDialog(context, item);
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ClothingItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                sendDeleteImageToServer(item.imageUrl);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close both dialog windows
              },
            ),
          ],
        );
      },
    );
  }
  Future<String> sendDeleteImageToServer(String url) async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    var url = Uri.parse('http://34.66.37.198/deleteimg');
    var data = {'url': url, 'ID': id};
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json"},
        body: body);
    if(response.statusCode == 200) {
      return response.body;
    }else{
      throw Exception('Failed to send hope emotion value to server');
    }
  }
}


