import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  final Map _gitData;

  GifPage(this._gitData);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_gitData['title']),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: (){
                Share.share(_gitData['images']['fixed_height']?['url']);
              },
              icon: Icon(Icons.share)
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Image.network(_gitData['images']['fixed_height']?['url'])
      ),
    );
  }
}