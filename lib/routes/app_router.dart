import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import '../services/mock_api.dart';

class ApiObserver extends NavigatorObserver {
  ApiObserver(this.api);

  final MockApi api;
  DateTime? _lastFetchedAt;
  bool _isFetching = false;

  bool _shouldFetch() {
    if (_lastFetchedAt == null) return true;
    final elapsed = DateTime.now().difference(_lastFetchedAt!);
    return elapsed >= const Duration(minutes: 1);
  }

  Future<void> _maybeFetch(
    String event,
    Route<dynamic>? route,
    Route<dynamic>? previous,
  ) async {
    if (_isFetching || !_shouldFetch()) return;
    _isFetching = true;
    try {
      final data = await api.fetchDummyData();
      _lastFetchedAt = DateTime.now();
      debugPrint(
        '[GoRouter:$event] モックAPI取得時刻を更新: ${_lastFetchedAt!.toIso8601String()}',
      );
      final routeLabel = route?.settings.name ?? route?.runtimeType.toString();
      final prevLabel =
          previous?.settings.name ?? previous?.runtimeType.toString();
      debugPrint(
        '[GoRouter:$event] route=$routeLabel prev=$prevLabel data=$data',
      );
    } catch (e, st) {
      debugPrint('[GoRouter:$event] fetch failed: $e\n$st');
    } finally {
      _isFetching = false;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    unawaited(_maybeFetch('push', route, previousRoute));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    unawaited(_maybeFetch('pop', previousRoute, route));
  }
}

final GoRouter appRouter = GoRouter(
  observers: [ApiObserver(MockApi())],
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'detail',
          name: 'detail',
          builder: (context, state) => const DetailPage(),
        ),
      ],
    ),
  ],
);
