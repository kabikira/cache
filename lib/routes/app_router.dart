import 'package:go_router/go_router.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) => const DetailPage(),
        ),
      ],
    ),
  ],
);
