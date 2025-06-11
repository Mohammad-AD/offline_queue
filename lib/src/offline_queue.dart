import 'queue_manager.dart';
import 'request_model.dart';

/// A singleton class that manages offline requests in a queue.
class OfflineQueue {
  /// The singleton instance of [OfflineQueue].
  static final OfflineQueue instance = OfflineQueue._();

  OfflineQueue._();

  final QueueManager _manager = QueueManager();

  /// Initializes the offline queue manager.
  Future<void> init() async {
    await _manager.init();
  }

  /// Closes the offline queue manager.
  Future<void> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _manager.addRequest(
      QueuedRequest(method: 'POST', url: url, headers: headers, body: body),
    );
  }

  ///this is a singleton class that manages offline requests in a queue.0
  Future<void> get({required String url, Map<String, String>? headers}) async {
    await _manager.addRequest(
      QueuedRequest(method: 'GET', url: url, headers: headers),
    );
  }

  /// Closes the offline queue manager.
  Future<void> put({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _manager.addRequest(
      QueuedRequest(method: 'PUT', url: url, headers: headers, body: body),
    );
  }

  /// Closes the offline queue manager.
  Future<void> delete({
    required String url,
    Map<String, String>? headers,
  }) async {
    await _manager.addRequest(
      QueuedRequest(method: 'DELETE', url: url, headers: headers),
    );
  }

  set onRequestRetried(void Function(QueuedRequest request)? callback) {
    _manager.onRequestRetried = callback;
  }

  set onRequestFailed(
    void Function(QueuedRequest request, dynamic error)? callback,
  ) {
    _manager.onRequestFailed = callback;
  }
}
