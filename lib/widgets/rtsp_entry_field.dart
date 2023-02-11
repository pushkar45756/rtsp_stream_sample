// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:stream_sample/constants/app_colors.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';

///Author-Pushkar Srivastava
///Date-10/02/23

class RtspEntryFieldWidget extends StatefulWidget {
  RtspEntryFieldWidget(
      {Key? key,
      required this.text,
      required this.errorText,
      required this.showInput,
      required this.onClickStart,
      required this.onClickClose})
      : super(key: key);
  TextEditingController text;

  var errorText;
  VlcPlayerController? controller;
  var showInput = false;
  VoidCallback onClickStart;
  VoidCallback onClickClose;

  @override
  State<RtspEntryFieldWidget> createState() => _RtspEntryFieldWidgetState();
}

class _RtspEntryFieldWidgetState extends State<RtspEntryFieldWidget> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var height = media.size.height;
    var width = media.size.width;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            top: height * 0.02, left: height * 0.02, right: height * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorTransparent,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffcccccc),
                  ),
                  height: MediaQuery.of(context).size.width * 0.34,
                  padding: EdgeInsets.only(
                      top: height * 0.04,
                      left: height * 0.04,
                      right: height * 0.04),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        const Text(
                          AppStrings.rtspLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorBlack,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: height * 0.08),
                            child: TextField(
                              controller: widget.text,
                              onChanged: (value) {
                                setState(() {
                                  widget.errorText = null;
                                });
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.colorWhite,
                                  hintText: AppStrings.inputTitle,
                                  errorText: widget.errorText,
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: height * 0.2,
                      onPressed: widget.onClickClose,
                      icon: Image.asset(
                        AppAssets.close,
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        onPressed: widget.onClickStart,
                        iconSize: height * 0.1,
                        icon: Image.asset(
                          AppAssets.right,
                          color: AppColors.colorGreen,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
