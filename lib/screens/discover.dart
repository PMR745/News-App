import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api/Components/bottom_navbar.dart';
import 'package:news_api/Components/image_container.dart';
import 'package:news_api/models/news.dart';
import 'package:news_api/services/news_api.dart';
import 'package:news_api/constants/constant.dart';

class Discover extends StatefulWidget {
  static const routeName = '/discover';
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<News> news = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: NewsApi.categories.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const _DiscoverNews(),
            _CategoryNews(
              tabs: NewsApi.categories,
              news: news,
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(
          index: 1,
        ),
      ),
    );
  }

  Future<void> _fetchNews() async {
    final response = await NewsApi.fetchNews();

    setState(() {
      news = response;
    });
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({
    super.key,
    required this.tabs,
    required this.news,
  });

  final List<String> tabs;
  final List<News> news;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: tabs
                .map((tab) => FutureBuilder(
                    future: NewsApi.getNews(tab),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final newsItem = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                NewsApi.viewNews(newsItem.url.toString());
                              },
                              child: Row(
                                children: [
                                  ImageContainer(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(
                                            vertical: 10.0)
                                        .copyWith(right: 10),
                                    borderRadius: 5,
                                    imageUrl: newsItem.urlToImage != null
                                        ? newsItem.urlToImage.toString()
                                        : DEFAULT_IMAGE_ADDRESS,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          newsItem.title.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                height: 1.2,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.schedule,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                "${DateTime.now().difference(DateTime.parse(
                                                      newsItem.dateOfPublished
                                                          .toString(),
                                                    )).inHours} hours ago"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text("Sorry currently Services are down!");
                      } else {
                        return const CupertinoActivityIndicator();
                      }
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.13,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "News from all over the world",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
