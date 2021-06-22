import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';

// An abstract class to handle all required github services
abstract class GithubService {
  Future<GithubApiResponse> getMostStarredRepo(
      {String date, String sort, String order});
}
