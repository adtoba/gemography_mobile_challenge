import 'package:dio/dio.dart';
import 'package:gemography_mobile_challenge/helpers/json_decoder.dart';
import 'package:gemography_mobile_challenge/main.dart';
import 'package:gemography_mobile_challenge/values/endpoints.dart';

class GTransformer extends DefaultTransformer {
  GTransformer() : super(jsonDecodeCallback: parseJson);
}

class BaseHttpService {
  Dio http;
  CancelToken cancelToken;

  BaseHttpService() {
    cancelToken = CancelToken();
    http = Dio(
      BaseOptions(
          baseUrl: BASE_URL,
          receiveTimeout: 30 * 1000,
          connectTimeout: 30 * 1000
      ),
    )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions opts, handler) async {
          logger.d({
            "requestPath" : opts.path,
            "data": opts?.data
          });
          return handler.next(opts);
        },
        onError: (DioError error, handler) {
          logger.e({
            "statusCode": error?.response?.statusCode,
            "message" : error.message,
            "data": error?.response?.data
          });

          return handler.next(error);
        },
        onResponse: (Response res, handler) {
          // logger.d({
          //   "statusCode" : res.statusCode,
          //   "data": res.data
          // });
          return handler.next(res);
        }
      )
    )..transformer = GTransformer();
  }
}