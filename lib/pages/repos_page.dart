import 'package:flutter/material.dart';
import 'package:gemography_mobile_challenge/components/fragments/list_items/repo_item.dart';
import 'package:gemography_mobile_challenge/components/fragments/loaders/loader.dart';
import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';
import 'package:gemography_mobile_challenge/registry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReposPage extends StatefulHookWidget {
  const ReposPage({Key key}) : super(key: key);

  @override
  _ReposPageState createState() => _ReposPageState();
}

class _ReposPageState extends State<ReposPage> with AutomaticKeepAliveClientMixin {

  // Scroll controller that can be used to check for the scroll extent of listview
  final _scrollController = ScrollController();

  // Holds the currentPage for the api request
  int currentPageNumber = 1;

  // Subtracts 30 days from current date as specified in the app idea
  DateTime date = DateTime.now().subtract(Duration(days: 30));

  @override
  void initState() {
    loadRepos(pageNumber: currentPageNumber.toString());
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var githubProvider = useProvider(githubState);
    return Container(
      // Stream builder to listen for items
      child: StreamBuilder<List<Items>>(
        stream: githubProvider.stream,
        builder: (context, snapshot) {
          if (githubProvider.hasError) {
            return ErrorStateWidget(
              date: date.toString().split(" ").first,
              currentPageNumber: currentPageNumber,
            );
          }
          // checks connection state and show loader as necessary
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppLoader();
          }

          if (snapshot.hasData) {
            return ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index == snapshot.data.length) {
                    if (githubProvider.fetchBusy) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  }
                  return RepoItem(
                      title: githubProvider.allItems[index].name,
                      author: githubProvider.allItems[index].owner.login,
                      description: githubProvider.allItems[index].description,
                      imageLink: githubProvider.allItems[index].owner.avatarUrl,
                      stars: githubProvider.allItems[index].stargazersCount
                          .toString());
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: githubProvider.allItems.length + 1);
          }
          return Container();
          //
        },
      ),
    );
  }

  void loadRepos({String pageNumber}) {
    var githubProvider = context.read(githubState);
    githubProvider.getMostStarredRepo(
        date: date.toString().split(" ").first, pageNumber: pageNumber);
  }

  void scrollListener() {
    var githubProvider = context.read(githubState);
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      if (!githubProvider.fetchBusy &&
          (githubProvider.allItems.length <
              githubProvider.githubApiResponse.totalCount)) {
        setState(() {
          currentPageNumber++;
        });
        githubProvider.loadMore(
            date: date.toString().split(" ").first,
            pageNumber: currentPageNumber.toString());
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class ErrorStateWidget extends ConsumerWidget {
  const ErrorStateWidget({Key key, this.date, this.currentPageNumber}) : super(key: key);

  final String date;
  final int currentPageNumber;

  @override
  Widget build(BuildContext context, watch) {
    var githubProvider = watch(githubState);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error while fetching repos'),
          SizedBox(height: 10),
          TextButton(
              onPressed: () => githubProvider.getMostStarredRepo(
                  date: date.toString().split(" ").first,
                  pageNumber: currentPageNumber.toString()),
              child: Text('Retry'))
        ],
      ),
    );
  }
}

