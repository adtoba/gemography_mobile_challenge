import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';
import 'package:gemography_mobile_challenge/services/http/github/github_http_service.dart';
import 'package:gemography_mobile_challenge/services/http/github/github_service.dart';

class GithubState extends ChangeNotifier {
  static GithubService _service;
  static GithubState _instance;

  GithubState() {
    _service = GithubHttpService();
  }

  GithubState get instance {
    if (_instance == null) {
      _instance = GithubState();
    }
    return _instance;
  }

  Future<GithubApiResponse> getMostStarredRepo(
      {String sort, String order, String date}) async {
    try {
      final response = await _service.getMostStarredRepo(
          date: date, sort: sort, order: order);

      return response;
    } on DioError catch (e) {
      throw e;
    }
  }
}
