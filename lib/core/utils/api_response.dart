class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final String error;

  const ApiResponse({this.success = false, this.data, this.error = '', this.message = ''});

  factory ApiResponse.parse(Map<String, dynamic> json, {T Function(dynamic json)? fromJsonT, String? key}) =>
      ApiResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? false,
        data: fromJsonT == null ? json[key ?? 'data'] : fromJsonT(json[key ?? 'data']),
        message: json['message'] ?? '',
      );

  factory ApiResponse.error({String error = "", String message = ""}) =>
      ApiResponse(success: false, data: null, error: error, message: message);
}

class ApiListResponse<T> {
  final bool success;
  final List<T> data;
  final int count;
  final String error;
  final String message;

  const ApiListResponse({
    this.success = false,
    this.data = const [],
    this.count = 0,
    this.error = '',
    this.message = '',
  });

  factory ApiListResponse.parse(
    Map<String, dynamic> json, {
    String? key,
    T Function(dynamic json)? fromJsonT,
  }) {
    if (json[key ?? 'data'] == null) {
      return ApiListResponse(success: false, data: [], count: json['count'] ?? 0);
    }
    final list = json[key ?? 'data'] is List<dynamic> ? json[key ?? 'data'] : (json[key ?? 'data']['rows'] ?? []);
    return ApiListResponse(
      success: json['success'] ?? false,
      data: fromJsonT == null ? List<T>.from(list) : List<T>.from((list).map((x) => fromJsonT(x))),
      count: json[key ?? 'data'] is List<dynamic> ? 0 : json[key ?? 'data']['count'] ?? 0,
      error: json['error'] ?? '',
      message: json['message'] ?? '',
    );
  }

  factory ApiListResponse.error({String error = ""}) => ApiListResponse(success: false, data: [], count: 0, error: error, message: "");
}
