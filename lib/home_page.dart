import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:stream_sample/constants/app_colors.dart';
import 'package:stream_sample/constants/app_strings.dart';
import 'package:stream_sample/constants/network_constants.dart';
import 'package:stream_sample/widgets/curve.dart';
import 'package:stream_sample/widgets/rtsp_entry_field.dart';
import 'package:stream_sample/widgets/vlc_media.dart';

///Author-Pushkar Srivastava
///Date-10/02/23

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VlcPlayerController? _controller;
  late TextEditingController _textEditingController;
  var _showInput = false;
  String? _errorText;
  bool isPoly = false;
  double? xV;
  double? yV;

  int i = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _textEditingController = TextEditingController(
      text: NetworkConstants.rtspURL2,
    );
    vlcDataInitialize();
  }

  vlcDataInitialize() {
    _controller = VlcPlayerController.network(
      _textEditingController.text,
      hwAcc: HwAcc.full,
      autoInitialize: true,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(
              AppColors.colorVlcSubtitleColorYellow),
          VlcSubtitleOptions.outlineThickness(
              AppColors.colorVlcSubtitleColorNormal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(AppColors.colorVlcSubtitleColor),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    _controller?.addOnInitListener(() async {
      await _controller?.startRendererScanning();
    });
    _controller?.addOnRendererEventListener((type, id, name) {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var height = media.size.height;
    var width = media.size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.colorBlack,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: _controller != null
                    ? VlcMediaPlayer(
                        height: height,
                        width: width,
                        controller: _controller,
                      )
                    : Container(
                        color: AppColors.colorBlue.withOpacity(0.8),
                      ),
              ),
              if (_showInput)
                Positioned.fill(
                  child: SizedBox(
                    height: height * 0.1,
                    width: width * 0.2,
                    child: RtspEntryFieldWidget(
                      text: _textEditingController,
                      errorText: _errorText,
                      showInput: _showInput,
                      onClickClose: () {
                        setState(() {
                          _showInput = !_showInput;
                        });
                      },
                      onClickStart: () {
                        var url = _textEditingController.text;

                        if (url.isEmpty) {
                          _errorText = AppStrings.errorText;
                        } else {
                          _controller?.setMediaFromNetwork(url);
                          setState(() {
                            _showInput = !_showInput;
                          });
                        }
                      },
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 10,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showInput = !_showInput;
                          });
                        },
                        child: Icon(
                          Icons.videocam,
                          color: AppColors.colorWhite,
                          size: height * 0.2,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isPoly = !isPoly;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 20, 10),
                            child: Icon(
                              Icons.polyline,
                              color: AppColors.colorWhite,
                              size: height * 0.1,
                            )),
                      ),
                      Expanded(child: Container()),
                      isPoly
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPoly = false;
                                    });
                                    Future.delayed(Duration.zero, () {
                                      setState(() {
                                        isPoly = true;
                                      });
                                    });
                                  },
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 15, 5, 10),
                                      child: Icon(
                                        Icons.refresh,
                                        color: Colors.yellow,
                                        size: height * 0.1,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPoly = false;
                                    });
                                  },
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(5, 15, 10, 10),
                                      child: Icon(
                                        Icons.clear_rounded,
                                        color: Colors.red,
                                        size: height * 0.1,
                                      )),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPoly = false;
                                    });
                                  },
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 10, 10),
                                      child: Icon(
                                        Icons.done_rounded,
                                        color: Colors.green,
                                        size: height * 0.1,
                                      )),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              isPoly
                  ? Positioned(
                      top: 0,
                      bottom: 70,
                      left: 0,
                      right: 0,
                      child: InfiniteCanvasPage(i))
                  : Container()
            ],
          ),
        ),
      ),
      floatingActionButton: !isPoly
          ? _controller != null && !_showInput
              ? FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    if (_controller != null) {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    }
                  },
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.play_arrow
                        : Icons.pause,
                  ),
                )
              : null
          : null,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller?.stopRendererScanning();
    await _controller?.dispose();
  }
}

// class ResizebleWidget extends StatefulWidget {
//   ResizebleWidget({this.child});

//   final Widget? child;
//   @override
//   _ResizebleWidgetState createState() => _ResizebleWidgetState();
// }

// const ballDiameter = 20.0;

// class _ResizebleWidgetState extends State<ResizebleWidget> {
//   double height = 100;
//   double width = 200;

//   double top = 100;
//   double left = 200;

//   void onDrag(double dx, double dy) {
//     var newHeight = height + dy;
//     var newWidth = width + dx;

//     setState(() {
//       height = newHeight > 0 ? newHeight : 0;
//       width = newWidth > 0 ? newWidth : 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           top: top,
//           left: left,
//           child: Container(
//             height: height,
//             width: width,
//             child: widget.child,
//           ),
//         ),
//         // top left
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var mid = (dx + dy) / 2;
//               var newHeight = height - 2 * mid;
//               var newWidth = width - 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top + mid;
//                 left = left + mid;
//               });
//             },
//           ),
//         ),
//         // top middle
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var newHeight = height - dy;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 top = top + dy;
//               });
//             },
//           ),
//         ),
//         // top right
//         Positioned(
//           top: top - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var mid = (dx + (dy * -1)) / 2;

//               var newHeight = height + 2 * mid;
//               var newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         // center right
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var newWidth = width + dx;

//               setState(() {
//                 width = newWidth > 0 ? newWidth : 0;
//               });
//             },
//           ),
//         ),
//         // bottom right
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left + width - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var mid = (dx + dy) / 2;

//               var newHeight = height + 2 * mid;
//               var newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         // bottom center
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var newHeight = height + dy;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//               });
//             },
//           ),
//         ),
//         // bottom left
//         Positioned(
//           top: top + height - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var mid = ((dx * -1) + dy) / 2;

//               var newHeight = height + 2 * mid;
//               var newWidth = width + 2 * mid;

//               setState(() {
//                 height = newHeight > 0 ? newHeight : 0;
//                 width = newWidth > 0 ? newWidth : 0;
//                 top = top - mid;
//                 left = left - mid;
//               });
//             },
//           ),
//         ),
//         //left center
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               var newWidth = width - dx;

//               setState(() {
//                 width = newWidth > 0 ? newWidth : 0;
//                 left = left + dx;
//               });
//             },
//           ),
//         ),
//         // center center
//         Positioned(
//           top: top + height / 2 - ballDiameter / 2,
//           left: left + width / 2 - ballDiameter / 2,
//           child: ManipulatingBall(
//             onDrag: (dx, dy) {
//               setState(() {
//                 top = top + dy;
//                 left = left + dx;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ManipulatingBall extends StatefulWidget {
//   ManipulatingBall({this.onDrag});

//   Function? onDrag;

//   @override
//   _ManipulatingBallState createState() => _ManipulatingBallState();
// }

// class _ManipulatingBallState extends State<ManipulatingBall> {
//   double? initX;
//   double? initY;

//   _handleDrag(details) {
//     setState(() {
//       initX = details.globalPosition.dx;
//       initY = details.globalPosition.dy;
//     });
//   }

//   _handleUpdate(details) {
//     var dx = details.globalPosition.dx - initX;
//     var dy = details.globalPosition.dy - initY;
//     initX = details.globalPosition.dx;
//     initY = details.globalPosition.dy;
//     widget.onDrag!(dx, dy);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanStart: _handleDrag,
//       onPanUpdate: _handleUpdate,
//       child: Container(
//         width: ballDiameter,
//         height: ballDiameter,
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.5),
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }

// class ExampleLine extends CustomPainter {
//   double xaxis, yaxis;
//   ExampleLine({required this.xaxis, required this.yaxis});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint line = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//     Path pline = Path();
//     pline.moveTo(xaxis / 2, yaxis / 2);
//     pline.relativeLineTo(-xaxis / 2, -yaxis / 2);
//     pline.close();

//     canvas.drawPath(pline, line);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
