import 'package:flutter/material.dart';
import 'package:flutter_offline_queue/flutter_offline_queue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OfflineQueue.instance.init();
}
