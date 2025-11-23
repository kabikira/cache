import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/app_router.dart'; // fetchManager を利用するため

/// アプリライフサイクル監視を Riverpod で管理。
final appLifecycleProvider = Provider<AppLifecycleHandler>((ref) {
  final handler = AppLifecycleHandler();
  WidgetsBinding.instance.addObserver(handler);
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(handler);
  });
  return handler;
});

class AppLifecycleHandler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // アプリ復帰時にモックAPIを取得（1分制御は FetchManager 側）
      fetchManager.onNavigation(event: 'resume', current: 'app_resumed');
    }
    super.didChangeAppLifecycleState(state);
  }
}
