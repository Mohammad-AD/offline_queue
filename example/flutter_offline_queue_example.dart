import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_queue/src/offline_queue.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    queue.onRequestRetried = (request) {
      if (kDebugMode) {
        print('Request retried: ${request.method} ${request.url}');
      }
    };

    queue.onRequestFailed = (request, error) {
      if (kDebugMode) {
        print(
          'Request failed: ${request.method} ${request.url} with error $error',
        );
      }
    };
  }

  void _sendPostRequest() async {
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
    await queue.get(url: 'https://jsonplaceholder.typicode.com/posts/1');
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
              onPressed: _sendPostRequest,
              child: const Text('Send POST request'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendGetRequest,
              child: const Text('Send GET request'),
            ),
          ],
        ),
      ),
    );
  }
}
