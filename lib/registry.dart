import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemography_mobile_challenge/state/github_state.dart';

final githubState = ChangeNotifierProvider((create) => GithubState());