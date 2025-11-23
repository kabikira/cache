import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../managers/fetch_manager.dart';

class InitCompletedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markDone() => state = true;
}

/// 初期化フェッチが完了したかどうか。
final initCompletedProvider =
    NotifierProvider<InitCompletedNotifier, bool>(InitCompletedNotifier.new);

/// アプリ起動時に一度だけモックAPIをフェッチする。
final appInitProvider = FutureProvider<void>((ref) async {
  final fetchManager = ref.read(fetchManagerProvider);
  await fetchManager.fetchForInit();
  ref.read(initCompletedProvider.notifier).markDone();
});
