import 'package:dio/dio.dart';
import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';
import 'package:gemography_mobile_challenge/services/http/base_http.dart';
import 'package:gemography_mobile_challenge/services/http/github/github_service.dart';

class GithubHttpService extends BaseHttpService implements GithubService {
  // Implements the getMostStarredRepo api call
  @override
  Future<GithubApiResponse> getMostStarredRepo(
      {String date, String sort = "stars", String order = "desc", String pageNumber}) async {
    try {
      // response from api endpoint
      final response =
          await http.get("?q=created:>$date&sort=$sort&order=$order&page=$pageNumber");

      // transform the data into a GithubApiResponse object
      return GithubApiResponse.fromJson(Map.from(response.data));

    } on DioError catch (e) {
      // Throws dio error incase an error occurs
      throw e;

    }
  }
}
