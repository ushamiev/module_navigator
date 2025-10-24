import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'observer.dart';

class ModuleNavigator extends StatefulWidget {
  const ModuleNavigator({
    super.key,
    required this.onGenerateRoute,
    required this.onGenerateInitialRoutes,
  });

  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(NavigatorState, String)
  onGenerateInitialRoutes;

  @override
  State<ModuleNavigator> createState() => _ModuleNavigatorState();
}

class _ModuleNavigatorState extends State<ModuleNavigator> {
  final _canPopNotifier = ValueNotifier<bool>(true);
  final _navKey = GlobalKey<NavigatorState>();

  void _updateCanPop() {
    if (_navKey.currentState == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _canPopNotifier.value = !_navKey.currentState!.canPop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _canPopNotifier,
      child: ValueListenableBuilder<bool>(
        valueListenable: _canPopNotifier,
        builder: (context, canPop, child) =>
            PopScope(canPop: canPop, child: child!),
        child: Navigator(
          key: _navKey,
          observers: [Observer(onChanged: _updateCanPop)],
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onGenerateRoute: widget.onGenerateRoute,
        ),
      ),
    );
  }
}
