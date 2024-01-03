import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'settings/settings_page.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, __) => ChangeNotifierProvider<SettingsPageVm>(
        create: (_) => SettingsPageVm(),
        child: const SettingsPage(),
      ),
    ),
  ],
);
