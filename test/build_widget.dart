import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<BuildContext> buildWidget(
  WidgetTester tester,
  WidgetBuilder widget, {
  ValueChanged<String>? onNavigate,
  bool isPushPage = false,
}) async {
  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  await tester.pumpWidget(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: isPushPage ? '/push' : '/test',
        redirect: (_, GoRouterState state) {
          onNavigate?.call(state.uri.path);
          return null;
        },
        routes: <GoRoute>[
          if (isPushPage)
            GoRoute(
              path: '/push',
              builder: (BuildContext context, __) => Scaffold(
                body: TextButton(
                  onPressed: () => context.push('/test'),
                  child: const Text('Show'),
                ),
              ),
            ),
          GoRoute(
            path: '/test',
            builder: (_, __) => Scaffold(
              body: Builder(
                builder: widget,
              ),
            ),
          ),
          GoRoute(
            path: '/',
            builder: (_, __) => const Scaffold(),
          ),
          GoRoute(
            path: '/:path',
            builder: (_, __) => const Scaffold(),
          ),
        ],
      ),
    ),
  );

  if (isPushPage) {
    await tester.tap(find.text('Show'));

    for (int i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  return rootNavigatorKey.currentContext!;
}
