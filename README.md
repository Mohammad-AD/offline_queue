# flutter_offline_queue

![Pub Version](https://img.shields.io/pub/v/offline_queue)
![License](https://img.shields.io/github/license/Mohammad-AD/offline_queue)

A Flutter/Dart package to queue API requests when offline and automatically retry them when the device goes back online.

---

## Features

- Automatically detects internet connectivity changes
- Queues HTTP requests (GET, POST, PUT, DELETE) when offline
- Persists queued requests locally using SQLite (`sqflite`)
- Retries all pending requests once connectivity is restored
- Allows handling success and failure callbacks for retried requests

---

## Getting Started

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_offline_queue: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

### Usage

Import the package:

```dart
import 'package:flutter_offline_queue/flutter_offline_queue.dart';
```

Initialize the queue early in your app (e.g., in `main()`):

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OfflineQueue.instance.init();
  runApp(MyApp());
}
```

Add requests like this:

```dart
// POST request example
await OfflineQueue.instance.post(
  url: 'https://your-api.com/endpoint',
  headers: {'Authorization': 'Bearer your_token'},
  body: {'key': 'value'},
);

// GET request example
await OfflineQueue.instance.get(url: 'https://your-api.com/items');
```

---

### Callbacks

You can set callbacks in initState to listen for retried requests:

```dart
OfflineQueue.instance.onRequestRetried = (request) {
  print('Request retried: ${request.method} ${request.url}');
};

OfflineQueue.instance.onRequestFailed = (request, error) {
  print('Request failed: ${request.method} ${request.url}, error: $error');
};
```

---

## Supported Methods

- GET
- POST
- PUT
- DELETE

---

## Limitations & Notes

- Only basic JSON request bodies are supported.
- Headers should be provided as a `Map<String, String>`.
- Make sure your API supports idempotent operations or handle duplicates accordingly.
- The package depends on `connectivity_plus`, `http`, `sqflite`, and `path`.

---

## Example

Here is a simple example that queues a POST request:

```dart
await OfflineQueue.instance.post(
  url: 'https://jsonplaceholder.typicode.com/posts',
  headers: {'Content-Type': 'application/json'},
  body: {
  'title': 'Test Post',
  'body': {'content': 'This is a test post', 'author': 'Mohammad'},
  'userId': 1,
  },
);
```

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contact

Created by Mohammad AD — feel free to reach out!
bummycakes.com - DCP
