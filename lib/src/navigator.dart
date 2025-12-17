import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'observer.dart';

class ModuleNavigator extends StatefulWidget {
  const ModuleNavigator({
    super.key,
    required this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.initialRoute,
    this.navKey,
  });

  final GlobalKey<NavigatorState>? navKey;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(NavigatorState, String)? onGenerateInitialRoutes;
  final String? initialRoute;

  @override
  State<ModuleNavigator> createState() => _ModuleNavigatorState();
}

class _ModuleNavigatorState extends State<ModuleNavigator> {
  final _canPopNotifier = ValueNotifier<bool>(true);
  late final GlobalKey<NavigatorState> _navKey;

  @override
  void initState() {
    super.initState();

    _navKey = widget.navKey ?? GlobalKey<NavigatorState>();
  }

  void _updateCanPop() {
    if (_navKey.currentState == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _canPopNotifier.value = !_navKey.currentState!.canPop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ValueNotifier<bool>>(
      create: (_) => _canPopNotifier,
      child: ValueListenableBuilder<bool>(
        valueListenable: _canPopNotifier,
        builder: (context, canPop, child) => PopScope(canPop: canPop, child: child!),
        child: Navigator(
          key: _navKey,
          initialRoute: widget.initialRoute,
          observers: [Observer(onChanged: _updateCanPop)],
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes ?? Navigator.defaultGenerateInitialRoutes,
          onGenerateRoute: widget.onGenerateRoute,
        ),
      ),
    );
  }
}
