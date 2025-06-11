///
class QueuedRequest {
  ///
  final String method;

  ///
  final String url;

  ///
  final Map<String, String>? headers;

  ///
  final Map<String, dynamic>? body;

  ///
  QueuedRequest({
    required this.method,
    required this.url,
    this.headers,
    this.body,
  });

  ///
  Map<String, dynamic> toJson() => {
    'method': method,
    'url': url,
    'headers': headers,
    'body': body,
  };

  ///
  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
    method: json['method'],
    url: json['url'],
    headers: Map<String, String>.from(json['headers'] ?? {}),
    body: Map<String, dynamic>.from(json['body'] ?? {}),
  );
}
