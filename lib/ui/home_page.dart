import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifs_finder_project/ui/gif_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {

  String? _search;
  int _offset = 0;

  _getShare() async{
    http.Response response;

    if(_search == null || _search!.isEmpty) {
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=TJGJ3gHMz18ji6TJNDS4x71Qo3rfOM1M&limit=20&offset=0&rating=g&bundle=messaging_non_clips'));
    } else {
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=TJGJ3gHMz18ji6TJNDS4x71Qo3rfOM1M&q=$_search&limit=19&offset=$_offset&rating=g&lang=en&bundle=sticker_layering'));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getShare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search here",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
                future: _getShare(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if(snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGifTable(context,snapshot);
                      }
                  }
                },
              )
          )
        ],
      ),
    );
  }

  int _getCount(List data){
    if (_search == null || _search!.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['data'][index]['images']['fixed_height']?['url'],
                  height: 300,
                  fit: BoxFit.cover,
              ),
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context){
                      return GifPage(snapshot.data['data'][index]);
                    }
                  )
                );
              },
              onLongPress: (){
                Share.share(snapshot.data['data'][index]['images']['fixed_height']?['url']);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                key: Key(index.toString()),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70,),
                    Text(
                      "Carregar mais ...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        }
    );
  }
}