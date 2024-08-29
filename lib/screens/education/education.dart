import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/extensions/media_query.dart';
import 'package:my_app/screens/education/articledetail.dart';
import 'package:my_app/screens/education/fullscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  final CollectionReference eduCollection =
      FirebaseFirestore.instance.collection('edu');

  final CollectionReference articleCollection =
      FirebaseFirestore.instance.collection('eduArticles');

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
          title: Text(
            'Education',
            style: GoogleFonts.adamina(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Videos',
                style: GoogleFonts.adamina(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: eduCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> videos = snapshot.data!.docs;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      var videoData =
                          videos[index].data() as Map<String, dynamic>;
                      var videoUrl = videoData['url'];
                      var videoTitle = videoData['title'];
                      var videoDescription = videoData['description'];

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => FullScreenVideo(videoUrl: videoUrl));
                        },
                        child: Container(
                          width: deviceWidth * 0.7,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            color: Colors.black87,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: YoutubePlayer(
                                      controller: YoutubePlayerController(
                                        initialVideoId:
                                            YoutubePlayer.convertUrlToId(
                                                videoUrl)!,
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: false,
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      videoTitle,
                                      style: GoogleFonts.adamina(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      videoDescription,
                                      style: GoogleFonts.adamina(
                                        fontSize: 14,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
            // Articles Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Articles',
                style: GoogleFonts.adamina(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: articleCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> articles = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    var articleData =
                        articles[index].data() as Map<String, dynamic>;
                    var articleTitle = articleData['title'];
                    var articleAuthor = articleData['author'];
                    var articleDescription = articleData['description'];
                    var articleContent = articleData['content'];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ArticleDetailPage(
                            title: articleTitle,
                            content: articleContent,
                            author: articleAuthor));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            articleTitle,
                            style: GoogleFonts.adamina(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            'By $articleAuthor',
                            style: GoogleFonts.adamina(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            articleDescription,
                            style: GoogleFonts.adamina(
                              fontSize: 12,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
