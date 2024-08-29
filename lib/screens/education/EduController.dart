import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart'; // Import RxDart
import 'package:my_app/screens/education/sortEducationMaterials.dart';

class EduController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SortDatas sortDatas = SortDatas();

  // Belirli bir video dokümanını almak için
  Future<Map<String, dynamic>?> getVideoById(String docId) async {
    DocumentSnapshot doc = await _firestore.collection('edu').doc(docId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getArticleById(String docId) async {
    DocumentSnapshot doc =
        await _firestore.collection('eduArticles').doc(docId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> getSortedVideos() {
    return getVideos().map((videos) => sortDatas.sortVideosByDate(videos));
  }

  Stream<List<Map<String, dynamic>>> getSortedArticles() {
    return getArticles()
        .map((articles) => sortDatas.sortArticlesByDate(articles));
  }

  Stream<List<Map<String, dynamic>>> getSortedArticlesAndVideos() {
    return Rx.combineLatest2(
      getArticles(),
      getVideos(),
      (List<Map<String, dynamic>> articles, List<Map<String, dynamic>> videos) {
        return sortDatas.sortArticlesAndVideosByDate(articles, videos);
      },
    );
  }

  Stream<List<Map<String, dynamic>>> getVideos() {
    return _firestore.collection('edu').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }

  Stream<List<Map<String, dynamic>>> getArticles() {
    return _firestore.collection('eduArticles').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }
}
