import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../Models/ProductModel.dart';
import '../api-interface/articles.dart';

class PopularArticlesProvider with ChangeNotifier {
  List<Results> popularArticles = [];

  int _page = 1;
  void incrementPage() {
    _page += 1;
  }

  resetPage() {
    _page = 1;
  }

  Future<List<Results>> fetchArticles({
    bool reload = false,
    String? category,
    String? query,
  }) async {
    if (reload) {
      resetPage();
    }
    final data = await ArticleInterface.fetchArticle(
        query: query, category: category, page: _page, limit: 10);
    popularArticles.addAll(data);
    notifyListeners();
    incrementPage();
    return data;
  }
}
