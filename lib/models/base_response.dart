class BaseResponse<T> {
  final int statusCode;
  final String msg;
  final T data;

  BaseResponse({
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return BaseResponse<T>(
      statusCode: json['statusCode'],
      msg: json['msg'],
      data: fromJsonT(json['data']),
    );
  }
}
