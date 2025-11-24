import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/flavor_provider.dart';
import '../providers/app_init_provider.dart';
import '../providers/startup_gate_provider.dart';

/// dev/test フレーバー時にスプラッシュ→デバッグメニューを挟むゲート。
class StartupGate extends ConsumerWidget {
  const StartupGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = ref.watch(startupGateProvider);
    final flavor = ref.watch(flavorProvider);
    ref.watch(appInitProvider);

    // 初期化完了時にステージ遷移
    ref.listen(appInitProvider, (previous, next) {
      next.when(
        data: (_) =>
            ref.read(startupGateProvider.notifier).proceedAfterInit(flavor),
        error: (_, __) =>
            ref.read(startupGateProvider.notifier).proceedAfterInit(flavor),
        loading: () {},
      );
    });

    if (stage == StartupStage.ready) {
      FlutterNativeSplash.remove();
      return child;
    }

    if (stage == StartupStage.splash) {
      // ネイティブスプラッシュを維持するため、Flutter側では何も描画しない
      return const SizedBox.shrink();
    }

    // Debugメニュー
    FlutterNativeSplash.remove();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('デバッグメニュー')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('FLAVOR: ${flavor.name.toUpperCase()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(startupGateProvider.notifier).toReady(),
                child: const Text('アプリを開始する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
