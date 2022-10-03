import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://purplebook-i3b.onrender.com/api',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postData({required String url,
    Map<String, dynamic>? data,
    String? token}) async {
    return await dio.post(url,data: data,options: Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }));
  }

  static Future<Response> postFormData({required String url,
   required var data,
    String? token}) async {
    return await dio.post(url,data: data,options: Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }));
  }

  static Future<Response> getData(
      {required String url, Map<String, dynamic>? query, String? token}) async {
    return await dio.get(url,
        queryParameters: query,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }));
  }

  static Future<Response> patchData(
  {
  required String url,
    required Map<String,dynamic>  data,
    String? token
})async{
    return await dio.patch(url,data: data,options: Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }));
  }

  static Future<Response> patchFormData(
      {
        required String url,
        required var data,
        String? token
      })async{
    return await dio.patch(url,data: data,options: Options(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }));
  }
  
  static Future<Response> deleteData({
  required String url,
    Map<String,dynamic>? date,
    String? token
})async{
  return await dio.delete(url,options: Options(headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
    }));
  }
}
