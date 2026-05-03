import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/firebase_service.dart';
import 'core/utils/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Environment.init();
  await FirebaseService.instance.initialize();

  runApp(
    const ProviderScope(child: DuoDayApp()),
  );
}
