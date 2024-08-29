import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:my_app/extensions/media_query.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final CollectionReference eduCollection =
      FirebaseFirestore.instance.collection('edu');

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    double appBarHeight = deviceWidth * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/mainmenu'),
            icon: const Icon(Icons.arrow_back_ios_new_sharp),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Education',
            style: GoogleFonts.adamina(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 9, 99),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eduCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> videos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var videoData = videos[index].data() as Map<String, dynamic>;
              var videoUrl = videoData['url'];
              var videoTitle = videoData['title'];
              var videoDescription = videoData['description'];

              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.black87,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.red,
                            handleColor: Colors.redAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            videoTitle,
                            style: GoogleFonts.adamina(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            videoDescription,
                            style: GoogleFonts.adamina(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
