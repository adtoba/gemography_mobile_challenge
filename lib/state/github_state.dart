import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gemography_mobile_challenge/models/http/github_api_response.dart';
import 'package:gemography_mobile_challenge/services/http/github/github_http_service.dart';
import 'package:gemography_mobile_challenge/services/http/github/github_service.dart';

class GithubState extends ChangeNotifier {
  static GithubState _instance;
  GithubService _service;

  GithubState() {
    _service = GithubHttpService();
  }

  static GithubState get instance {
    if (_instance == null) {
      _instance = GithubState();
    }
    return _instance;
  }

  bool _fetchBusy = false;
  bool _hasError = false;

  GithubApiResponse githubApiResponse;

  bool get fetchBusy => _fetchBusy;
  bool get hasError => _hasError;

  StreamController<List<Items>> _streamController;
  Stream<List<Items>> stream;
  List<Items> allItems = [];

  Future<void> getMostStarredRepo({String date, String pageNumber}) async {
    _streamController = StreamController<List<Items>>.broadcast();
    stream = _streamController.stream.map((List<Items> data) {
      return data;
    });
    await loadMore(date: date, pageNumber: pageNumber);
  }

  Future<void> loadMore({String date, String pageNumber}) async {
    _hasError = false;
    _fetchBusy = true;
    notifyListeners();
    try {
      final response =
          await _service.getMostStarredRepo(date: date, pageNumber: pageNumber);
      if (response != null) {
        githubApiResponse = response;
        _streamController.add(allItems);
        allItems.addAll(response.items);
        notifyListeners();
      }
      return allItems;
    } on DioError catch (e) {
      _hasError = true;
      notifyListeners();
    } finally {
      _fetchBusy = false;
      notifyListeners();
    }
  }
}
