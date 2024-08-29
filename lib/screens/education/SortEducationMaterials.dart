class SortDatas {
  List<Map<String, dynamic>> sortArticlesByDate(
      List<Map<String, dynamic>> articles) {
    articles.sort((a, b) => DateTime.parse(b['createdAt'])
        .compareTo(DateTime.parse(a['createdAt'])));
    return articles;
  }

  List<Map<String, dynamic>> sortVideosByDate(
      List<Map<String, dynamic>> videos) {
    videos.sort((a, b) => DateTime.parse(b['createdAt'])
        .compareTo(DateTime.parse(a['createdAt'])));
    return videos;
  }

  List<Map<String, dynamic>> sortArticlesAndVideosByDate(
      List<Map<String, dynamic>> articles, List<Map<String, dynamic>> videos) {
    List<Map<String, dynamic>> allItems = [...articles, ...videos];
    allItems.sort((a, b) => DateTime.parse(b['createdAt'])
        .compareTo(DateTime.parse(a['createdAt'])));
    return allItems;
  }
}
