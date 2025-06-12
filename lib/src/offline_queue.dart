import 'queue_enum.dart';
import 'queue_manager.dart';
import 'request_model.dart';

/// A singleton class that manages offline requests in a queue.
class OfflineQueue {
  /// The singleton instance of [OfflineQueue].
  static final OfflineQueue instance = OfflineQueue._();

  OfflineQueue._();

  late final QueueManager _manager;

  /// Initializes the offline queue manager.
  Future<void> init({RequestType clientType = RequestType.http}) async {
    _manager = QueueManager(clientType: clientType);
    await _manager.init();
  }

  /// posts a request to the offline queue.
  Future<void> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _manager.addRequest(
      QueuedRequest(method: 'POST', url: url, headers: headers, body: body),
    );
  }

  /// this method is used to get a request from the offline queue.
  Future<void> get({required String url, Map<String, String>? headers}) async {
    await _manager.addRequest(
      QueuedRequest(method: 'GET', url: url, headers: headers),
    );
  }

  /// this method is used to put a request in the offline queue.
  Future<void> put({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    await _manager.addRequest(
      QueuedRequest(method: 'PUT', url: url, headers: headers, body: body),
    );
  }

  /// this method is used to delete a request in the offline queue.
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
