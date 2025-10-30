import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'observer.dart';

class ModuleNavigator extends StatefulWidget {
  const ModuleNavigator({
    super.key,
    required this.navKey,
    required this.onGenerateRoute,
    required this.onGenerateInitialRoutes,
  });

  final GlobalKey<NavigatorState> navKey;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(NavigatorState, String)
  onGenerateInitialRoutes;

  @override
  State<ModuleNavigator> createState() => _ModuleNavigatorState();
}

class _ModuleNavigatorState extends State<ModuleNavigator> {
  final _canPopNotifier = ValueNotifier<bool>(true);
  GlobalKey<NavigatorState> get navKey => widget.navKey;

  void _updateCanPop() {
    if (navKey.currentState == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _canPopNotifier.value = !navKey.currentState!.canPop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ValueNotifier<bool>>(
      create: (_) => _canPopNotifier,
      child: ValueListenableBuilder<bool>(
        valueListenable: _canPopNotifier,
        builder: (context, canPop, child) =>
            PopScope(canPop: canPop, child: child!),
        child: Navigator(
          key: navKey,
          observers: [Observer(onChanged: _updateCanPop)],
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onGenerateRoute: widget.onGenerateRoute,
        ),
      ),
    );
  }
}
