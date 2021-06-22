import 'package:flutter/material.dart';
import 'package:gemography_mobile_challenge/components/fragments/list_items/repo_item.dart';
import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';
import 'package:gemography_mobile_challenge/registry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReposPage extends StatefulHookWidget {
  const ReposPage({Key key}) : super(key: key);

  @override
  _ReposPageState createState() => _ReposPageState();
}

class _ReposPageState extends State<ReposPage> {
  final _scrollController = ScrollController();

  int currentPageNumber = 1;

  @override
  void initState() {
    super.initState();
    loadRepos(pageNumber: currentPageNumber.toString());
    _scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var githubProvider = useProvider(githubState);
    return Container(
      child: StreamBuilder<List<Items>>(
        stream: githubProvider.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
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
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error while fetching repos'),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () => githubProvider.getMostStarredRepo(
                          date: "2017-10-22",
                          pageNumber: currentPageNumber.toString()),
                      child: Text('Retry'))
                ],
              ),
            );
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
        date: "2017-10-22", pageNumber: pageNumber);
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
            date: "2017-10-22", pageNumber: currentPageNumber.toString());
      }
    }
  }
}
