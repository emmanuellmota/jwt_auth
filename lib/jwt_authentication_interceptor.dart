import 'package:dio/dio.dart';
import 'package:jwt_auth/jwt_authentication_repository.dart';

class JwtAuthenticationInterceptor extends Interceptor {

  final dio = Dio();
  final JwtAuthenticationRepository _authenticationRepository;

  JwtAuthenticationInterceptor(this._authenticationRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      "Content-Type": "application/json",
    });

    if (_authenticationRepository.jwtToken != null) {
      options.headers.addAll({
        "Authorization": "Bearer ${_authenticationRepository.jwtToken!.accessToken}",
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    if (err.response?.statusCode == 401) {
      // Refresh the user's authentication token.
      await _authenticationRepository.refreshToken();
      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
    final options = Options(
      method: requestOptions.method,
      headers: {
        "Authorization": "Bearer ${_authenticationRepository.jwtToken!.accessToken}",
      },
    );

    // Retry the request with the new `RequestOptions` object.
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
