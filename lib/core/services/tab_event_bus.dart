import 'dart:async';

class TabEventBus {
  static final StreamController<int> tabStream = StreamController<int>.broadcast();
}
