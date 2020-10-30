import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import './image_model.dart';
import 'package:storage_path/storage_path.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Images extends StatefulWidget {
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> with AutomaticKeepAliveClientMixin {
  String imagePath = "";
  List<dynamic> list = [
    {
      "files": [
        "/storage/emulated/0/WhatsApp/Media/WhatsApp Images/IMG-20200816-WA0064.jpg",
        "/storage/emulated/0/WhatsApp/Media/WhatsApp Images/IMG-20200816-WA0064.jpg",
      ]
    }
  ];

  Future<void> getImagesPath() async {
    String imagespath = "";
    try {
      imagespath = await StoragePath.imagesPath;
      var response = jsonDecode(imagespath);
      print("response");
      print(response);
      var imageList = response as List;
      List<ImageModel> list = imageList
          .map<ImageModel>((json) => ImageModel.fromJson(json))
          .toList();

      setState(() {
        imagePath = list[11].files[0];
      });
    } on PlatformException {
      imagespath = 'Failed to get path';
    }
    return imagespath;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        ImageModel imageModel = ImageModel.fromJson(list[0]);
        return new _Tile(
            'https://cdn.pixabay.com/photo/2013/04/07/21/30/croissant-101636_960_720.jpg',
            1);
      },
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _Tile extends StatelessWidget {
  const _Tile(this.source, this.index);

  final String source;
  final int index;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Image.network(source),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Image number $index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  'Vincent Van Gogh',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
