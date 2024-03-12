import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_api/constants/constant.dart';
import 'package:news_api/models/news.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsApi {
  static List<News> news = [];
  static List<String> categories = [
    "All",
    "Health",
    "Business",
    "Sports",
    "Entertainment",
    "Technology",
    "Science",
  ];

  static Future<List<News>> fetchNews() async {
    print("Fetching News...");
    const url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=${API_KEY}";

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final articles = json['articles'] as List<dynamic>;
    final transformed = articles.map((article) {
      return News.fromMap(article);
    }).toList();
    news = transformed;
    print("News Fetched");
    return transformed;
  }

  static Future<List<News>> fetchTopHeadlines() async {
    print("Fetching News...");
    const url =
        "https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=${API_KEY}";

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final articles = json['articles'] as List<dynamic>;
    final transformed = articles.map((article) {
      return News.fromMap(article);
    }).toList();
    news = transformed;
    print("News Fetched");
    return transformed;
  }

  static viewNews(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception("Could not launch $url");
    }
  }

  static Future<List<News>> getNews(String category) async {
    print("Fetching News...");
    final url;
    if (category == "All") {
      url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=${API_KEY}";
    } else {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=${category}&apiKey=${API_KEY}";
    }

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final articles = json['articles'] as List<dynamic>;
    final transformed = articles.map((article) {
      return News.fromMap(article);
    }).toList();
    news = transformed;
    print("News Fetched");
    return transformed;
  }
}
