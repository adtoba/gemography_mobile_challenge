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
  Future<GithubApiResponse> _future;

  @override
  void initState() {
    var githubProvider = context.read(githubState);
    _future = githubProvider.getMostStarredRepo(
        date: "2017-10-22", sort: "stars", order: "desc");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GithubApiResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return RepoItem(
                      title: snapshot.data.items[index].name,
                      author: snapshot.data.items[index].owner.login,
                      description: snapshot.data.items[index].description,
                      imageLink: snapshot.data.items[index].owner.avatarUrl,
                      stars: snapshot.data.items[index].stargazersCount.toString());
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: 10);
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text('Error while fetching repos'),
                  SizedBox(height: 10),
                  TextButton(onPressed: () => _future, child: Text('Retry'))
                ],
              ),
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
