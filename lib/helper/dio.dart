import 'package:dio/dio.dart';

Dio dio() {
  var dio = Dio(BaseOptions(
    baseUrl: 'https://api.chapa.co/v1/transaction/initialize',
    headers: {'accept': 'application/json', 'content-type': 'application/json'},
    responseType: ResponseType.json,
  ));

  return dio;
}
