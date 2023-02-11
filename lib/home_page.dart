import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:stream_sample/constants/app_colors.dart';
import 'package:stream_sample/constants/app_strings.dart';
import 'package:stream_sample/constants/network_constants.dart';
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _controller != null && !_showInput
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
                _controller!.value.isPlaying ? Icons.play_arrow : Icons.pause,
              ),
            )
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
