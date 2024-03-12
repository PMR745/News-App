import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api/Components/custom_tag.dart';
import 'package:news_api/Components/image_container.dart';
import 'package:news_api/constants/constant.dart';
import 'package:news_api/models/news.dart';
import 'package:news_api/Components/bottom_navbar.dart';
import 'package:news_api/services/news_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<News>> news;

  @override
  void initState() {
    super.initState();
    news = _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _NewsOfTheDay(
                  newsItem: snapshot.data![0],
                ),
                _BreakingNews(
                  news: snapshot.data!,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error Occurred: ${snapshot.error}"),
            );
          } else {
            return const Center(
                child: CupertinoActivityIndicator(
              radius: 15,
            ));
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(
        index: 0,
      ),
    );
  }

  Future<List<News>> _fetchNews() async {
    final response = await NewsApi.fetchNews();

    return response;
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    super.key,
    required this.news,
  });

  final List<News> news;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Breaking News",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Text(
              //   "More",
              //   style: Theme.of(context).textTheme.bodyLarge,
              // ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: news.length > 10 ? 10 : news.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: InkWell(
                      onTap: () {
                        NewsApi.viewNews(news[index].url.toString());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageContainer(
                            width: MediaQuery.of(context).size.width * 0.5,
                            imageUrl: news[index].urlToImage != null
                                ? news[index].urlToImage.toString()
                                : DEFAULT_IMAGE_ADDRESS,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            news[index].title.toString(),
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            news[index].author != null
                                ? news[index].author.toString()
                                : "Unknown",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      // fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                          ),
                          Text(
                            "${DateTime.now().difference(DateTime.parse(news[index].dateOfPublished.toString())).inHours} hours ago",
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({
    super.key,
    required this.newsItem,
  });
  final News newsItem;
  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      // padding: const EdgeInsets.all(20),
      imageUrl: newsItem.urlToImage.toString(),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
          // color: Colors.black.withOpacity(.3),
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            stops: [0.3, 0.9],
            colors: [
              Colors.black.withOpacity(.7),
              Colors.black.withOpacity(.4),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor: Colors.grey.withAlpha(150),
              children: [
                Text(
                  "News of the Day",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newsItem.title.toString(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: Colors.white,
                  ),
            ),
            TextButton(
              onPressed: () {
                NewsApi.viewNews(newsItem.url.toString());
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Row(
                children: [
                  Text(
                    "Learn More",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
