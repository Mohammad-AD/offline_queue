import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_queue/src/offline_queue.dart';

Future<void> main() async {
  // Ensure that the Flutter engine is initialized before using any Flutter features
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the OfflineQueue instance
  await OfflineQueue.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Offline Queue Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OfflineQueue queue = OfflineQueue.instance;

  @override
  void initState() {
    super.initState();
    // Set up the queue to handle requests
    queue.onRequestRetried = (request) {
      if (kDebugMode) {
        print('Request retried: ${request.method} ${request.url}');
      }
    };
    // Set up the queue to handle failed requests
    queue.onRequestFailed = (request, error) {
      if (kDebugMode) {
        print(
          'Request failed: ${request.method} ${request.url} with error $error',
        );
      }
    };
  }

  void _sendPostRequest() async {
    // Post a request to the queue
    await queue.post(
      url: 'https://jsonplaceholder.typicode.com/posts',
      headers: {'Content-Type': 'application/json'},
      body: {
        'title': 'Test Post',
        'body': {'content': 'This is a test post', 'author': 'Mohammad'},
        'userId': 1,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post request queued or sent')),
    );
  }

  void _sendGetRequest() async {
    // Get a request from the queue
    await queue.get(url: 'https://jsonplaceholder.typicode.com/posts/1');
    // Show a snackbar to indicate the request was queued or sent
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Get request queued or sent')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Queue Example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              // Button to send a POST request
              onPressed: _sendPostRequest,
              child: const Text('Send POST request'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Button to send a GET request
              onPressed: _sendGetRequest,
              child: const Text('Send GET request'),
            ),
          ],
        ),
      ),
    );
  }
}
