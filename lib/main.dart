import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_init_provider.dart';
import 'providers/app_lifecycle_provider.dart';
import 'routes/app_router.dart';
import 'widgets/startup_gate.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アプリライフサイクル監視を起動（dispose 時に自動解除）
    ref.watch(appLifecycleProvider);
    // 初期化フェッチを起動
    ref.watch(appInitProvider);

    final router = ref.watch(goRouterProvider);

    return StartupGate(
      child: MaterialApp.router(
        title: 'GoRouter Demo',
        routerConfig: router,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
