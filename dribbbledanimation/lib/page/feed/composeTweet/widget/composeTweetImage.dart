import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../widgets/customWidgets.dart';
import 'package:video_player/video_player.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class ComposeTweetImage extends StatefulWidget {
  final File image;

  final Function onCrossIconPressed;

  const ComposeTweetImage({Key key, this.image, this.onCrossIconPressed})
      : super(key: key);

  @override
  _ComposeTweetImageState createState() => _ComposeTweetImageState();
}

class _ComposeTweetImageState extends State<ComposeTweetImage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image.path.indexOf(".mp4") >= 0) {
      print("widget.image.path");
      print(widget.image.path);
      _controller = VideoPlayerController.file(widget.image);
      _controller.addListener(() {
        setState(() {});
      });
      //  _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    } else {
      print("widget.image.pdf");
      print(widget.image.path);
    }
    return Container(
      child: widget.image.path == null
          ? Container()
          : widget.image.path.indexOf(".mp4") < 0
              ? Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      child: widget.image != null &&
                              !(widget.image.path.indexOf(".jpg") >= 0 ||
                                  widget.image.path.indexOf(".png") >= 0)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          PDF.file(
                                            widget.image,
                                            height: 200,
                                            width: 150,
                                            placeHolder: Image.asset(
                                                "assets/images/pdf.png",
                                                height: 200,
                                                width: 100),
                                          ),
                                          widget.image != null &&
                                                  widget.image.path
                                                          .indexOf(".pdf") >=
                                                      0
                                              ? IconButton(
                                                  icon: Image.asset(
                                                    "assets/images/pdf.png",
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                  onPressed: () => {})
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.insert_drive_file,
                                                    color: Colors.amber,
                                                  ),
                                                  onPressed: () => {}),
                                          Text(
                                              widget.image.path.split('/').last,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  /* Container(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.file_download,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () => {}))*/
                                ],
                              ),
                            )

                          /*PDF.file(
                              widget.image,
                              height: 300,
                              width: 150,
                              placeHolder: Image.asset("assets/images/pdf.png",
                                  height: 200, width: 100),
                            )*/
                          : Container(
                              height: 220,
                              width: fullWidth(context) * .8,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: FileImage(widget.image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black54),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: widget.onCrossIconPressed,
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : widget.image.path.indexOf(".mp4") >= 0 &&
                      _controller.value.initialized
                  ? SingleChildScrollView(
                      child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        const Text('With assets mp4'),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                VideoPlayer(_controller),
                                _PlayPauseOverlay(controller: _controller),
                                VideoProgressIndicator(_controller,
                                    allowScrubbing: true),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                  : Container(),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
