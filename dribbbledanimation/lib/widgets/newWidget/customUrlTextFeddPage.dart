import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../helper/utility.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UrlTextFeedPage extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle urlStyle;
  final Function(String) onHashTagPressed;

  UrlTextFeedPage(
      {this.text, this.style, this.urlStyle, this.onHashTagPressed});

  List<InlineSpan> getTextSpans() {
    List<InlineSpan> widgets = List<InlineSpan>();
    RegExp reg = RegExp(
        r"([#])\w+| [@]\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<_ResultMatch> resultMatches = List<_ResultMatch>();
    int start = 0;
    for (Match match in _matches) {
      if (match.group(0).isNotEmpty) {
        if (start != match.start) {
          _ResultMatch result1 = _ResultMatch();
          result1.isUrl = false;
          result1.text = text.substring(start, match.start);
          resultMatches.add(result1);
        }

        _ResultMatch result2 = _ResultMatch();
        result2.isUrl = true;
        result2.text = match.group(0);
        resultMatches.add(result2);
        start = match.end;
      }
    }
    if (start < text.length) {
      _ResultMatch result1 = _ResultMatch();
      result1.isUrl = false;
      result1.text = text.substring(start);
      resultMatches.add(result1);
    }
    for (var result in resultMatches) {
      if (result.isUrl) {
        widgets.add(_LinkTextSpan(
            onHashTagPressed: onHashTagPressed,
            text: result.text,
            style:
                urlStyle != null ? urlStyle : TextStyle(color: Colors.blue)));
      } else {
        widgets.add(TextSpan(
            text: result.text,
            style: style != null ? style : TextStyle(color: Colors.black)));
      }
    }
    return widgets;
  }

  List<Widget> getRichLinks(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    RegExp reg = RegExp(
        r"([#])\w+| [@]\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<_ResultMatch> resultMatches = List<_ResultMatch>();
    int start = 0;
    for (Match match in _matches) {
      if (match.group(0).isNotEmpty) {
        if (start != match.start) {
          _ResultMatch result1 = _ResultMatch();
          result1.isUrl = false;
          result1.text = text.substring(start, match.start);
          resultMatches.add(result1);
        }

        _ResultMatch result2 = _ResultMatch();
        result2.isUrl = true;
        result2.text = match.group(0);
        resultMatches.add(result2);
        start = match.end;
      }
    }
    if (start < text.length) {
      _ResultMatch result1 = _ResultMatch();
      result1.isUrl = false;
      result1.text = text.substring(start);
      resultMatches.add(result1);
    }
    for (var result in resultMatches) {
      if (result.isUrl) {
        widgets.add(_buildCustomLinkPreview(context, result.text));
      }
    }
    if (widgets.length == 0) {
      widgets.add(new Container());
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(1),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, offset: Offset(3, 3), color: Colors.white)
            ],
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        padding: EdgeInsets.all(10),

        // constraints: BoxConstraints(maxHeight: 133),
        child: Column(
          children: [
            getRichLinks(context)[0],
            Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(children: getTextSpans()),
                  textAlign: TextAlign.left,
                ))
          ],
        ));
  }

  Widget _buildCustomLinkPreview(BuildContext context, String url) {
    return FlutterLinkPreview(
      key: ValueKey(url),
      url: url,
      builder: (info) {
        if (info == null) return const SizedBox();
        if (info is WebImageInfo) {
          return CachedNetworkImage(
            imageUrl: info.image,
            fit: BoxFit.contain,
          );
        }

        final WebInfo webInfo = info;
        if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF0F1F2),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: webInfo.icon ?? "",
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          fit: BoxFit.contain,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.link);
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        webInfo.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                WebAnalyzer.isNotEmpty(webInfo.description)
                    ? const SizedBox(height: 8)
                    : Container(),
                WebAnalyzer.isNotEmpty(webInfo.description)
                    ? Text(
                        webInfo.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Container(),
                WebAnalyzer.isNotEmpty(webInfo.image)
                    ? const SizedBox(height: 8)
                    : Container(),
                WebAnalyzer.isNotEmpty(webInfo.image)
                    ? CachedNetworkImage(
                        imageUrl: webInfo.image,
                        fit: BoxFit.contain,
                      )
                    : Container(),
              ]),
        );
      },
    );
  }
}

class _LinkTextSpan extends TextSpan {
  final Function(String) onHashTagPressed;
  _LinkTextSpan({TextStyle style, String text, this.onHashTagPressed})
      : super(
            style: style,
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (onHashTagPressed != null &&
                    (text.substring(0, 1).contains("#") ||
                        text.substring(0, 1).contains("#"))) {
                  onHashTagPressed(text);
                } else {
                  launchURL(text);
                }
              });
}

class _ResultMatch {
  bool isUrl;
  String text;
}
