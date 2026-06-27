import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  String? _token;

  ApiService._internal() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
    ));
  }

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  void setToken(String? token) {
    _token = token;
  }

  // Auth API
  Future<Map<String, dynamic>> register(String email, String password, {String? name}) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name ?? '',
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['access_token'] as String;
      _token = token;
      return token;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  void logout() {
    _token = null;
  }

  // Templates API
  Future<List<dynamic>> getTemplates({String? category, String? query}) async {
    try {
      final response = await _dio.get('/templates/', queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (query != null && query.isNotEmpty) 'query': query,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Projects API
  Future<List<dynamic>> getProjects() async {
    try {
      final response = await _dio.get('/projects/');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProject(int id) async {
    try {
      final response = await _dio.get('/projects/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createProject({
    required String name,
    String duration = '00:00',
    String size = '0MB',
    String? thumbnail,
    String? timelineData,
  }) async {
    try {
      final response = await _dio.post('/projects/', data: {
        'name': name,
        'duration': duration,
        'size': size,
        if (thumbnail != null) 'thumbnail': thumbnail,
        if (timelineData != null) 'timeline_data': timelineData,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProject(int id, {
    String? name,
    String? duration,
    String? size,
    String? thumbnail,
    String? timelineData,
  }) async {
    try {
      final response = await _dio.put('/projects/$id', data: {
        if (name != null) 'name': name,
        if (duration != null) 'duration': duration,
        if (size != null) 'size': size,
        if (thumbnail != null) 'thumbnail': thumbnail,
        if (timelineData != null) 'timeline_data': timelineData,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _dio.delete('/projects/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final detail = e.response?.data?['detail'];
      if (detail != null) {
        return Exception(detail.toString());
      }
      return Exception('Server Error: ${e.response?.statusCode}');
    }
    return Exception(e.message ?? 'Network connection error');
  }
}
