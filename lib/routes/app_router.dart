import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import '../pages/modal_page.dart';
import '../pages/tab_example_page.dart';
import '../providers/fetch_flag_provider.dart';
import '../managers/fetch_manager.dart';
import '../widgets/tab_shell.dart';

class ApiObserver extends NavigatorObserver {
  ApiObserver(this.fetchManager);

  final FetchManager fetchManager;

  String? _label(Route<dynamic>? route) =>
      route?.settings.name ?? route?.runtimeType.toString();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    fetchManager.onNavigation(
      event: 'push',
      current: _label(route),
      previous: _label(previousRoute),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    fetchManager.onNavigation(
      event: 'pop',
      current: _label(previousRoute),
      previous: _label(route),
    );
  }
}

class RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final fetchManager = ref.read(fetchManagerProvider);
  final refreshNotifier = RouterRefreshNotifier();

  // fetchFlag が変わったらリダイレクト評価を促す
  ref.listen<bool>(fetchFlagProvider, (previous, next) {
    refreshNotifier.refresh();
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    observers: [ApiObserver(fetchManager)],
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      fetchManager.onNavigation(
        event: 'redirect',
        current: state.uri.toString(),
        previous: null,
      );

      final fetched = ref.read(fetchFlagProvider);
      final isModal = state.matchedLocation == '/modal';
      if (fetched && !isModal) {
        return '/modal';
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TabShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
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
                  GoRoute(
                    path: 'modal',
                    name: 'modal',
                    pageBuilder: (context, state) => MaterialPage(
                      fullscreenDialog: true,
                      child: const ModalPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tabs',
                name: 'tabs',
                builder: (context, state) => const TabExamplePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
