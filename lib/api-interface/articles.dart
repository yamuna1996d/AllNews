import 'dart:convert';
import '../Models/ProductModel.dart';
import '../constraints/api/api_methods.dart';
import '../constraints/api/api_request.dart';
import '../constraints/constraints.dart';

class ArticleInterface{
  static Future<List<Results>> fetchArticle({String? category,query,int? page,limit}) async {
    try {
      final response = await ApiRequest.send(
        method: ApiMethod.GET,
        route: 'top-headlines',
        queries: {
          "country": "in",
          "category":category,
          "q":query,
          "page":page,
          "pageSize":limit,
          "apiKey":API_KEY
        }
      );
        return (response['articles']as List).map((e) => Results.fromJson(e)).toList();

    } catch (err) {
      print("fetching article error: $err");
      return [];
    }
  }
}