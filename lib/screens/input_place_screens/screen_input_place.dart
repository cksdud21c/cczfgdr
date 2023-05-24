import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_input_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/model_ClothesRecommend.dart';

class InputPlacePage extends StatelessWidget {
  const InputPlacePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InputPlaceModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 6, 67, 117),
          title: Text(title),
        ),
        endDrawer : SafeArea(
          child:
            Menu(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InputPlace(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Next_Button(),
            ],
          ),
        ),
        bottomNavigationBar: Bottombar(),
      ),
    );
  }
}

class InputPlace extends StatelessWidget {
  final _controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final hplace = Provider.of<InputPlaceModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          _controller.text = ''; // clear prefixText
        },
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: hplace.district,
              onChanged: (value) {
                hplace.setSelectedDistrict(value!); // update selected district
              },
              items: ['성동구', '광진구', '동대문구'].map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select District',
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: hplace.category,
              onChanged: (value) {
                hplace.setSelectedCategory(value!); // update selected category
              },
              items: ['음식점', '카페', '문화시설'].map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Category',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onChanged: (place) {
                hplace.setPlace(place); // update variable with user input
              },
              keyboardType: TextInputType.text,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your destination',
                hintText: '세종대학교.',
                suffixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Next_Button extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final hplace = Provider.of<InputPlaceModel>(context, listen: false);
    final clothesRecommendModel = Provider.of<ClothesRecommendModel>(context, listen: false);
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    return TextButton(
      onPressed: () async {
        if (hplace.place.isNotEmpty) {
          print(hplace.place);
          print(hplace.district);
          print(hplace.category);

          List<List<String>> recommendationSets = await sendPlaceNameValueToServer(
            id!,
            hplace.place,
            hplace.district,
            hplace.category,
          );

          clothesRecommendModel.setRecommendationSets(recommendationSets);

          Navigator.of(context).pushNamed('/screen_recommend_clothes');
        }
      },
      child: Text('NEXT'),
    );
  }
}


// 텍스트 값을 Flask 서버에 보내는 함수(보내지는거 확인완료.근데 애뮬레이터에서 한글이 안쳐짐. 이건 해결해야함.)
// Future<List<List<String>>> sendPlaceNameValueToServer(String id, String pn, String d, String c) async {
//   var url = Uri.parse('http://34.66.37.198/spacename');
//   var data = {'ID' : id, 'place': pn, 'district': d, 'Category': c};
//   var body = json.encode(data);
//   var response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: body,
//   );
//
//   if (response.statusCode == 200) {
//     List<dynamic> responseData = json.decode(response.body);
//
//     List<List<String>> recommendationSets = [];
//     for (dynamic set in responseData) {
//       List<String> urls = List<String>.from(set);
//       recommendationSets.add(urls);
//     }
//
//     return recommendationSets;
//   } else {
//     throw Exception('Failed to send place name to server');
//   }
// }
Future<List<List<String>>> sendPlaceNameValueToServer(String id, String pn, String d, String c) async {
  // Simulating response from the server with hardcoded image URLs
  List<List<String>> recommendationSets = [
    [
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
    ],
    [
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
    ],
    [
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
      'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg',
    ],
  ];

  // Simulating an asynchronous delay to mimic server response time
  await Future.delayed(Duration(seconds: 2));

  return recommendationSets;
}
