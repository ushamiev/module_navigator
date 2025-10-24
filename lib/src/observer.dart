import 'package:flutter/widgets.dart';

/// Навигатор-обсервер для обновления canPop
class Observer extends NavigatorObserver {
  Observer({required this.onChanged});

  final VoidCallback onChanged;

  @override
  void didPush(_, _) => onChanged();

  @override
  void didPop(_, _) => onChanged();
}
