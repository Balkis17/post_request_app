import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyPostWidget());
}
class MyPostWidget extends StatefulWidget {
 @override
 _MyPostWidget createState() => _MyPostWidget();
}

class _MyPostWidget extends State<MyPostWidget>{
  Future<String>? _album;
  
  final TextEditingController _controller=TextEditingController() ;
  @override
  Widget build(BuildContext context){
    return (
      MaterialApp(
        home: Scaffold(
          appBar:AppBar(title: Text("PostApi"),),
          body: Center(
            child: Column(children: [
              TextField(controller: _controller,
              decoration: const InputDecoration(hintText: "Enter title"),
              ),
              ElevatedButton(onPressed: (){
              setState(() {
                _album = createAlbum(_controller.text);
              });
              },
              child: Text("add album")),
             (_album==null)? Text("vide"):builderfuture()
          ]),
        ),
      )
    ));
  }


    FutureBuilder<String> builderfuture() {
      return(
        FutureBuilder(
          future: _album,
          builder: (context, snapshot) {
         if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();

        })
      );
    }


 Future<String> createAlbum(String title) async{
    var response =await  http.post(Uri.parse("https://jsonplaceholder.typicode.com/albums"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body:jsonEncode(<String, String>{"title":title}));

    if (response.statusCode == 201) {
     var res=jsonDecode(response.body) as Map<String, dynamic>;
     return res["title"];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to post album');
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
