import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'request_model.dart';

//// A class that manages offline requests in a queue.
class QueueManager {
  Database? _db;
  bool _isOnline = true;

  /// A singleton instance of [QueueManager].
  void Function(QueuedRequest request)? onRequestRetried;

  /// A callback that is called when a request is retried successfully.
  void Function(QueuedRequest request, dynamic error)? onRequestFailed;

  /// A callback that is called when a request fails to retry.
  Future<void> init() async {
    await _initDb();
    _listenToConnectivity();
    await _retryPendingRequests();
  }

  Future<void> _initDb() async {
    final path = join(await getDatabasesPath(), 'offline_queue.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            method TEXT,
            url TEXT,
            headers TEXT,
            body TEXT
          )
        ''');
      },
    );
  }

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      if (_isOnline) {
        _retryPendingRequests();
      }
    });
  }

  ///
  Future<void> addRequest(QueuedRequest request) async {
    if (_isOnline) {
      try {
        await _sendRequest(request);
        onRequestRetried?.call(request);
        return;
      } catch (e, st) {
        print('Failed to send request online: $e\n$st');
      }
    }

    await _db!.insert('requests', {
      'method': request.method,
      'url': request.url,
      'headers': jsonEncode(request.headers ?? {}),
      'body': jsonEncode(request.body ?? {}),
    });
  }

  Future<void> _retryPendingRequests() async {
    final list = await _db!.query('requests');
    for (final row in list) {
      final request = QueuedRequest(
        method: row['method'] as String,
        url: row['url'] as String,
        headers: Map<String, String>.from(
          jsonDecode(row['headers'] as String) ?? {},
        ),
        body: Map<String, dynamic>.from(
          jsonDecode(row['body'] as String) ?? {},
        ),
      );

      try {
        await _sendRequest(request);
        await _db!.delete('requests', where: 'id = ?', whereArgs: [row['id']]);
        onRequestRetried?.call(request);
      } catch (e, st) {
        print('Retry failed for ${request.method} ${request.url}: $e\n$st');
        onRequestFailed?.call(request, e);
      }
    }
  }

  Future<void> _sendRequest(QueuedRequest request) async {
    final uri = Uri.parse(request.url);
    late http.Response response;

    switch (request.method.toUpperCase()) {
      case 'POST':
        response = await http.post(
          uri,
          headers: request.headers,
          body: jsonEncode(request.body),
        );
        break;
      case 'GET':
        response = await http.get(uri, headers: request.headers);
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: request.headers,
          body: jsonEncode(request.body),
        );
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: request.headers);
        break;
      default:
        throw UnimplementedError('${request.method} not supported');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'HTTP error: ${response.statusCode} - ${response.reasonPhrase}',
        uri,
      );
    }
  }
}
