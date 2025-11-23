import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fetch_flag_provider.dart';
import '../services/mock_api.dart';

/// 画面遷移やリダイレクトで共通にモックAPIを叩くマネージャ。
class FetchManager {
  FetchManager(this.api, this.ref);

  final MockApi api;
  final Ref ref;
  DateTime? _lastFetchedAt;
  bool _isFetching = false;

  bool _shouldFetch() {
    if (_lastFetchedAt == null) return true;
    final elapsed = DateTime.now().difference(_lastFetchedAt!);
    return elapsed >= const Duration(minutes: 1);
  }

  void onNavigation({
    required String event,
    String? current,
    String? previous,
  }) {
    if (_isFetching || !_shouldFetch()) return;
    unawaited(_runFetch(event, current: current, previous: previous));
  }

  Future<void> _runFetch(
    String event, {
    String? current,
    String? previous,
  }) async {
    _isFetching = true;
    try {
      final data = await api.fetchDummyData();
      _lastFetchedAt = DateTime.now();
      ref.read(fetchFlagProvider.notifier).setSuccess();
      debugPrint(
        '[FetchManager:$event] モックAPI取得時刻を更新: ${_lastFetchedAt!.toIso8601String()}',
      );
      debugPrint(
        '[FetchManager:$event] current=$current prev=$previous data=$data',
      );
    } catch (e, st) {
      ref.read(fetchFlagProvider.notifier).setFailure();
      debugPrint('[FetchManager:$event] fetch failed: $e\n$st');
    } finally {
      _isFetching = false;
    }
  }
}

/// Riverpodで共有するFetchManager
final fetchManagerProvider = Provider<FetchManager>((ref) {
  return FetchManager(MockApi(), ref);
});
