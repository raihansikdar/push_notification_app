import 'dart:async';

/// Controller to synchronize the fontSize of multiple AutoSizeText widgets.
class AutoSizeGroup {
  final _listeners = <dynamic, double>{};
  var _widgetsNotified = false;
  var fontSize = double.infinity;

  void register(dynamic textState) {
    _listeners[textState] = double.infinity;
  }

  void updateFontSize(dynamic textState, double maxFontSize) {
    final oldFontSize = fontSize;
    if (maxFontSize <= fontSize) {
      fontSize = maxFontSize;
      _listeners[textState] = maxFontSize;
    } else if (_listeners[textState] == fontSize) {
      _listeners[textState] = maxFontSize;
      fontSize = double.infinity;
      for (final size in _listeners.values) {
        if (size < fontSize) fontSize = size;
      }
    } else {
      _listeners[textState] = maxFontSize;
    }

    if (oldFontSize != fontSize) {
      _widgetsNotified = false;
      scheduleMicrotask(_notifyListeners);
    }
  }

  void _notifyListeners() {
    if (_widgetsNotified) return;
    _widgetsNotified = true;

    for (final textState in _listeners.keys) {
      if (textState.mounted) {
        textState._notifySync();
      }
    }
  }

  void remove(dynamic textState) {
    updateFontSize(textState, double.infinity);
    _listeners.remove(textState);
  }
}
