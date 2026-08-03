import 'package:flutter/material.dart';
import '../utils/web_runtime_stub.dart'
    if (dart.library.html) '../utils/web_runtime.dart';

/// Tracks whether the first-time interactive tutorial has already been
/// shown to this visitor. Persisted the same way the rest of the app
/// persists state: via [WebRuntime]'s browser localStorage wrapper, so it
/// survives refreshes but is scoped per-browser (never shown twice unless
/// the user resets it or clears site data).
class TutorialManager extends ChangeNotifier {
  static const String _storageKey = 'tutorial_completed';

  static TutorialManager? _instance;
  static TutorialManager get instance {
    _instance ??= TutorialManager();
    return _instance!;
  }

  bool _hasCompleted = false;
  bool get hasCompleted => _hasCompleted;

  TutorialManager() {
    _load();
  }

  void _load() {
    try {
      _hasCompleted = WebRuntime.readStorage(_storageKey) == 'true';
    } catch (_) {
      _hasCompleted = false;
    }
  }

  /// Called when the visitor finishes ("Start Exploring") or explicitly
  /// skips the tutorial. Both count as "seen" so it never reappears
  /// automatically afterwards.
  void markCompleted() {
    _hasCompleted = true;
    try {
      WebRuntime.writeStorage(_storageKey, 'true');
    } catch (_) {}
    notifyListeners();
  }

  /// Exposed for a future Settings screen: "Show tutorial again".
  void reset() {
    _hasCompleted = false;
    try {
      WebRuntime.writeStorage(_storageKey, 'false');
    } catch (_) {}
    notifyListeners();
  }
}
