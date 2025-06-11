/// Flutter Offline Queue
/// A library for managing offline requests in Flutter applications.
/// /// This library provides functionality to queue requests when offline and process them
/// /// when the device is back online.
///
/// /// Example usage:
/// /// ```dart
/// import 'package:flutter_offline_queue/flutter_offline_queue.dart';
/// /// final queueManager = QueueManager();
/// /// // Add a request to the queue
/// /// queueManager.addRequest(RequestModel(url: 'https://example.com/api', method: 'POST', body: {'key': 'value'}));
/// /// // Process the queue when back online
/// /// queueManager.processQueue();
/// /// ```dart
///
library flutter_offline_queue;

export 'src/offline_queue.dart';
export 'src/queue_manager.dart';
export 'src/request_model.dart';
