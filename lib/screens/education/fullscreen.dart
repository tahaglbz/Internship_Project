import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideo extends StatelessWidget {
  final String videoUrl;

  const FullScreenVideo({required this.videoUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: const Text(
            'Video',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/education'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
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
