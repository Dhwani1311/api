import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
      home: new HomePage()
  ));
}
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}
class HomePageState extends State<HomePage> {
  List data;

  Future<String> getData() async {
  var response = await http.get(Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
  headers: {
  "Accept": "application/json"
  }
  );
  this.setState(() {
  data = json.decode(response.body);
  });
  print(data[1]["title"]);
  return "Success!";
  }

  Future<http.Response> createAlbum(String title,String body) {
    return http.post('https://jsonplaceholder.typicode.com/posts',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );
  }

  @override
  void initState(){
    super.initState();
   // this.getData();
   // this.createAlbum('title');
  }
  @override
  Widget build(BuildContext context){
  return  Scaffold(
  appBar: AppBar(
      title: Center(
          child:  Text("Rest Api")), backgroundColor: Colors.blue),
    //   body:  ListView.builder(
    //   itemCount: data == null ? 0 : data.length,
    //     itemBuilder: (BuildContext context, int index){
    // return new Card(
    //   child: new Text(data[index]["title"]),
    //   );
    //   },
    //   ),
    body: Center(
    child: FutureBuilder<http.Response>(
        future: createAlbum('Title','Body'),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return CircularProgressIndicator();
    } if (snapshot.hasError) {
    return Text("${snapshot.error}");
    }
    final Map<String,dynamic> data = jsonDecode(snapshot.data.body);
    return Column(
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child:Text('${data['title']}'),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
    child:Text('${data['body']}'),
    ),
    ),
    ],
    );
    },
    ),
    ),);
      }
}
