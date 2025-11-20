import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import '../services/mock_api.dart';

class ApiObserver extends NavigatorObserver {
  ApiObserver(this.api);

  final MockApi api;

  Future<void> _fetch(
    String event,
    Route<dynamic>? route,
    Route<dynamic>? previous,
  ) async {
    try {
      final data = await api.fetchDummyData();
      final routeLabel = route?.settings.name ?? route?.runtimeType.toString();
      final prevLabel =
          previous?.settings.name ?? previous?.runtimeType.toString();
      debugPrint(
        '[GoRouter:$event] route=$routeLabel prev=$prevLabel data=$data',
      );
    } catch (e, st) {
      debugPrint('[GoRouter:$event] fetch failed: $e\n$st');
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    unawaited(_fetch('push', route, previousRoute));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    unawaited(_fetch('pop', previousRoute, route));
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
