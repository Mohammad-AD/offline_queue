# flutter_offline_queue

![Pub Version](https://img.shields.io/pub/v/flutter_offline_queue)
![Publisher](https://img.shields.io/pub/publisher/flutter_offline_queue)
![License](https://img.shields.io/github/license/Mohammad-AD/offline_queue)
![Dart](https://img.shields.io/badge/Dart-%3E=3.2.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-%3E=3.13.0-blue)

A reliable Flutter package to ensure your app handles offline API requests gracefully.  
It queues failed HTTP calls and retries them once connectivity is restored — ideal for unstable network environments.

---

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Callbacks](#callbacks)
- [Supported Methods](#supported-methods)
- [Limitations & Notes](#limitations--notes)
- [Example](#example)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

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
  flutter_offline_queue: ^1.0.3
```

Then run:

```bash
flutter pub get
```

---

## Usage

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

Queue requests like this:

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

## Callbacks

You can set callbacks to listen for retried or failed requests:

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

- Currently supports basic JSON-encoded request bodies.
- Headers should be provided as a `Map<String, String>`.
- Ensure your API supports idempotent operations or handles duplicates appropriately.
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
    'content': 'This is a test post',
    'author': 'Mohammad',
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

Created by **Mohammad AD** — feel free to reach out!  
[bummycakes.com](https://bummycakes.com)