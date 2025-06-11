/// Class representing a queued HTTP request.
class QueuedRequest {
  /// String representing the HTTP method for the request.
  final String method;

  /// String representing the URL for the request.
  final String url;

  /// Optional headers for the request.
  final Map<String, String>? headers;

  /// Optional body for the request.
  final Map<String, dynamic>? body;

  /// QueuedRequest constructor.
  QueuedRequest({
    required this.method,
    required this.url,
    this.headers,
    this.body,
  });

  /// To JSON representation of the request.
  Map<String, dynamic> toJson() => {
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
      };

  /// Factory constructor to create a QueuedRequest from JSON.
  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
        method: json['method'],
        url: json['url'],
        headers: Map<String, String>.from(json['headers'] ?? {}),
        body: Map<String, dynamic>.from(json['body'] ?? {}),
      );
}
