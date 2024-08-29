import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../widgets/appColors.dart';

class FullScreenVideo extends StatelessWidget {
  final String videoUrl;

  const FullScreenVideo({required this.videoUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: const Text('Video'),
          backgroundColor: AppColors.defaultColor,
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/mainmenu'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
