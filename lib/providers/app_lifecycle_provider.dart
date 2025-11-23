import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/app_router.dart';
import 'fetch_flag_provider.dart';
import '../managers/fetch_manager.dart';

/// アプリライフサイクル監視を Riverpod で管理。
final appLifecycleProvider = Provider<AppLifecycleHandler>((ref) {
  final handler = AppLifecycleHandler(ref);
  WidgetsBinding.instance.addObserver(handler);
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(handler);
  });
  return handler;
});

class AppLifecycleHandler extends WidgetsBindingObserver {
  AppLifecycleHandler(this.ref);

  final Ref ref;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final fetchManager = ref.read(fetchManagerProvider);
    if (state == AppLifecycleState.resumed) {
      // アプリ復帰時にモックAPIを取得（1分制御は FetchManager 側）
      fetchManager.onNavigation(event: 'resume', current: 'app_resumed');

      // フラグがtrueならモーダルを表示
      final fetched = ref.read(fetchFlagProvider);
      final router = ref.read(goRouterProvider);
      final currentPath = router.routeInformationProvider.value.uri.path;
      if (fetched && currentPath != '/modal') {
        router.go('/modal');
      }
    }
    super.didChangeAppLifecycleState(state);
  }
}
