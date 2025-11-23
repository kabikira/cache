import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_lifecycle_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アプリライフサイクル監視を起動（dispose 時に自動解除）
    ref.watch(appLifecycleProvider);

    return MaterialApp.router(
      title: 'GoRouter Demo',
      routerConfig: appRouter,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}
