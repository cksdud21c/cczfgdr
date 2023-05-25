import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? old;
  String? sex;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      var response = await http.get(Uri.parse('http://your-api-url/user-data'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          old = data['old'];
          sex = data['sex'];
        });
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  void saveUserData() async {
    try {
      var url = Uri.parse('http://your-api-url/save-user-data');
      var data = {'old': old, 'sex': sex};
      var body = json.encode(data);
      var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장!'),
          ),
        );
        Navigator.pop(context);
      } else {
        print('Failed to save user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to save user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('회원 정보 수정'),
      ),
      body: Container(
        child: ListView(
          children: [
            OldInput(
              initialValue: old,
              onChanged: (value) {
                setState(() {
                  old = value;
                });
              },
            ),
            SexInput(
              initialValue: sex,
              onChanged: (value) {
                setState(() {
                  sex = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: saveUserData,
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

class SexInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const SexInput({Key? key, this.initialValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sex = ['남성', '여성'];
    return Container(
      padding: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: initialValue,
        items: _sex.map(
              (e) => DropdownMenuItem(value: e, child: Text(e)),
        ).toList(),
        onChanged: onChanged != null ? (String? value) => onChanged!(value!) : null,
        decoration: InputDecoration(
          labelText: "성별",
        ),
      ),
    );
  }
}


class OldInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const OldInput({Key? key, this.initialValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: initialValue),
        decoration: InputDecoration(
          labelText: "나이",
        ),
      ),
    );
  }
}
