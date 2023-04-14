import 'package:flutter/material.dart';

class TabIndexNotifier extends ValueNotifier<int> {
  var tabIndex = 0;
  TabIndexNotifier({int? tabIndex}) : super(tabIndex ?? 0);
}

class FindJobTabIndexNotifier extends ValueNotifier<int> {
  var tabIndex = 0;
  FindJobTabIndexNotifier({int? tabIndex}) : super(tabIndex ?? 0);
}

