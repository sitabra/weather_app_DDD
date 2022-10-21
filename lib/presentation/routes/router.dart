import 'package:auto_route/auto_route.dart';
import '../dashboard/homepage.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route,Tab',
  routes: <AutoRoute>[
    AutoRoute(path: 'splash', page: Dashboard, initial: true),
  ],
)
class $AppRouter {}
