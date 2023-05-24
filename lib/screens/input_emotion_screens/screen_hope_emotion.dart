import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_input_emotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/model_place_clothes_recommend.dart';
import 'package:untitled/screens/shared_screens/bottombar.dart';
import 'package:untitled/screens/shared_screens/menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Hope_emotion_Page extends StatelessWidget {
  const Hope_emotion_Page({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => InputEmotionModel(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 6, 67, 117),
            title: Text(title + ': 희망 감정'),
          ),
          endDrawer : SafeArea(
            child:
              Menu(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                hope_emotion_Input(),
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

class hope_emotion_Input extends StatelessWidget {
  final _controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var hemotion = Provider.of<InputEmotionModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          _controller.text = ''; // clear prefixText
        },
        child: TextFormField(
          onChanged: (emotion) {
            hemotion.setEmotion(emotion); // update variable with user input
          },
          keyboardType: TextInputType.text,
          controller: _controller,
          decoration: InputDecoration(
            labelText: '희망하는 감정을 입력해주세요',
            hintText: '평온한 분위기를 느끼고 싶어.',
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
      ),
    );
  }
}

class Next_Button extends StatelessWidget {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final hemotion = Provider.of<InputEmotionModel>(context, listen: false);
    final placeClothesRecommendModel = Provider.of<PlaceClothesRecommendModel>(context, listen: false);
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    return TextButton(
      onPressed: () async {
        if (hemotion.emotion.isNotEmpty) {
          await fetchRecommendations(hemotion.emotion, id!,placeClothesRecommendModel);
        }
        Navigator.of(context).pushNamed("/screen_recommend_place");
      },
      child: Text('NEXT'),
    );
  }

  // Future<void> fetchRecommendations(String emotion, String id, PlaceClothesRecommendModel placeClothesRecommendModel) async {
  //   try {
  //     final response = await sendHopeEmotionToServer(emotion, id);
  //     final List<Map<String, dynamic>> recommendationSets = [];
  //
  //     for (var i = 0; i < 3; i++) {
  //       final placeName = response['placeName$i'];
  //       final placeLocation = response['placeLocation$i'];
  //       final placeDescription = response['placeDescription$i'];
  //       final List<String> outfitUrls = [];
  //
  //       for (var j = 0; j < 5; j++) {
  //         final outfitUrl = response['outfitUrls$i$j'];
  //         outfitUrls.add(outfitUrl);
  //       }
  //
  //       final recommendationSet = {
  //         'placeName': placeName,
  //         'placeLocation': placeLocation,
  //         'placeDescription': placeDescription,
  //         'outfitUrls': outfitUrls,
  //       };
  //
  //       recommendationSets.add(recommendationSet);
  //     }
  //
  //     placeClothesRecommendModel.setRecommendationSets(recommendationSets);
  //   } catch (error) {
  //     // Handle error here
  //     print('Failed to fetch recommendations: $error');
  //   }
  // }

  Future<void> fetchRecommendations(String emotion, String id, PlaceClothesRecommendModel placeClothesRecommendModel) async {
    //테스트용 코드임. 실제로는 위에 주석친거로 받아와야함.
    try {
      // final response = await sendHopeEmotionToServer(emotion, id);
      List<Map<String, dynamic>> recommendationSets = [];

      for (var i = 0; i < 3; i++) {
        var placeName = '세종대학교'; // Set constant place name "A"
        var placeLocation = '서울특별시 광진구 능동로'; // Set constant place location "B"
        var placeDescription = '서울시 광진구의 세종대학교이다.'; // Set constant place description "C"
        List<String> outfitUrls = List.generate(5, (j) => 'https://i.ytimg.com/vi/905ABIKU6Hs/maxresdefault.jpg');

        var recommendationSet = {
          'placeName': placeName,
          'placeLocation': placeLocation,
          'placeDescription': placeDescription,
          'outfitUrls': outfitUrls,
        };

        recommendationSets.add(recommendationSet);
      }

      placeClothesRecommendModel.setRecommendationSets(recommendationSets);
    } catch (error) {
      // Handle error here
      print('Failed to fetch recommendations: $error');
    }
  }

}

Future <Map<String, dynamic>> sendHopeEmotionToServer(String he, String id) async {
  var url = Uri.parse('http://34.66.37.198/emotext');
  var data = {'text': he, 'ID': id};
  var body = json.encode(data);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body, //이 body에 placename,location,discription,clotheslist가 다 담겨져 있어야함.
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to send hope emotion value to the server');
  }
}
