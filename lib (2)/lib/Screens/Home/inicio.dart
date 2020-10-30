import 'package:flutter/material.dart';
import 'package:native_share/native_share.dart';
import '../social/user_feed_page.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<News> news = List<News>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/75/17/46/500_F_175174631_fZWpQKTkvuuXxZN6rz7x7mzjwCrhJq0o.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));
    news.add(News(
        'title',
        'content',
        'description',
        'https://stock.adobe.com/ec/search?load_type=search&native_visual_search=&similar_content_id=&is_recent_search=&search_type=usertyped&k=news&asset_id=112102817',
        'https://as1.ftcdn.net/jpg/01/12/10/28/500_F_112102817_IJrMlxKIoS5CptR3kAhRswAD75OYJuaR.jpg',
        null,
        'ashrith',
        '1'));

    news.add(News(
        'title1',
        'conten2t',
        'description',
        'https://blogs.ashrithgn.com/2019/06/20/set-up-app-loading-progress-indicator-dialog/',
        'https://as1.ftcdn.net/jpg/01/97/60/20/500_F_197602041_LT4M49woXxNopBG2V6jiuXRLWKHDayql.jpg',
        null,
        'ashrith',
        '1'));
    return new WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: new Scaffold(
            body: new Container(
                width: screenSize.width,
                height: screenSize.height,
                child: new Column(
                    //alignment: buttonSwingAnimation.value,
                    //alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        //elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Image.asset(
                            'assets/iconos/h1.jpeg',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      /*Expanded(
                          child: ListView.builder(
                        itemBuilder: (BuildContext ctxt, int index) {
                          return _buildListItem(news[index], ctxt);
                        },
                        itemCount: news.length,
                      )),*/
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'COMPARTE TUS IDEAS',
                            contentPadding: const EdgeInsets.all(20.0)),
                      ),
                    ]))));
  }

  _buildListItem(News news, BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 5),
                child: Text(
                    news.title == null || news.title.isEmpty
                        ? "NA"
                        : news.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            Container(
                margin: EdgeInsets.only(bottom: 5, left: 25),
                child: Text(
                  "Source: newsapi.org - ${news.sourceName}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                )),
            Container(
              margin: EdgeInsets.only(bottom: 15, top: 0),
              decoration: BoxDecoration(color: Colors.grey),
              child: news.imagePath == null || news.imagePath.isEmpty
                  ? SizedBox(
                      height: 10,
                    )
                  : new Image.network(
                      news.imagePath,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5, left: 10),
                child: Text(
                    news.description == null || news.description.isEmpty
                        ? "NA"
                        : news.description,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14))),
            Divider(
              height: 20,
              color: Colors.grey,
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  tooltip: "View",
                  onPressed: () async {},
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: "Share",
                  onPressed: () {
                    NativeShare.share({
                      'title': news.title == null || news.title.isEmpty
                          ? "NA"
                          : news.title,
                      'url': news.path == null || news.path.isEmpty
                          ? null
                          : news.path,
                    });
                  },
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
    );
  }
}

class News {
  String title;
  String content;
  String description;
  String path;
  String imagePath;
  DateTime publishedAt;
  String sourceName;
  String sourceId;

  News(this.title, this.content, this.description, this.path, this.imagePath,
      this.publishedAt, this.sourceName, this.sourceId);

  News.empty();
}
