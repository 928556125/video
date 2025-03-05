import 'package:dio/dio.dart';

class VideoApi {
  static const String baseUrl = 'https://sjys.linkpc.net/api.php/provide';
  static final Dio _dio = Dio();

  // 获取视频列表
  static Future<Map<String, dynamic>> getVideoList({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/vod',
        queryParameters: {
          'ac': 'detail',
          'pg': page,
          'limit': limit,
          if (type != null) 't': type,
        },
      );
      return response.data;
    } catch (e) {
      print('获取视频列表错误: $e');
      return {'code': 0, 'msg': '请求失败', 'list': []};
    }
  }

  // 获取视频详情
  static Future<Map<String, dynamic>> getVideoDetail(String id) async {
    try {
      final response = await _dio.get(
        '$baseUrl/vod',
        queryParameters: {
          'ac': 'detail',
          'ids': id,
        },
      );
      return response.data;
    } catch (e) {
      print('获取视频详情错误: $e');
      return {'code': 0, 'msg': '请求失败', 'list': []};
    }
  }
}
