// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:stream_sample/constants/app_colors.dart';

class VlcMediaPlayer extends StatelessWidget {
  VlcMediaPlayer(
      {Key? key,
      required this.controller,
      required this.height,
      required this.width})
      : super(key: key);
  VlcPlayerController? controller;
  var height = 0.0;
  var width = 0.0;

  @override
  Widget build(BuildContext context) {
    // return OrientationBuilder(builder: (context,orientation){
    //   final isPortrait = orientation==Orientation.portrait;
    //
    //   return Stack(
    //
    //     fit: ,
    //     children: [
    //
    //     ],
    //   )
    // });
    return Column(
      children: [
        SizedBox(
          height: height * 0.7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: VlcPlayer(
                  controller: controller!,
                  aspectRatio: 4 / 3,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            height: height,
            color: AppColors.colorBlue.withOpacity(0.8),
          ),
        )
      ],
    );
  }
}
