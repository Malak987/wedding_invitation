import 'package:flutter/material.dart';

/// Defers building an expensive section (video, particle animation, network
/// fetch, form with many fields...) until it's about to enter the viewport,
/// instead of building every section on the page the instant the invitation
/// opens.
///
/// Once a section is built it **stays built** — it never gets torn down
/// again when scrolled away — so timers, videos, or streams already running
/// inside it are never interrupted or restarted.
///
/// Usage:
/// ```dart
/// LazyMount(
///   placeholderHeight: 500, // roughly the section's real height
///   builder: (context) => const GallerySection(),
/// )
/// ```
class LazyMount extends StatefulWidget {
  final WidgetBuilder builder;

  /// How far below the bottom of the screen (in logical pixels) a section
  /// should be built *before* it's actually visible, so it's ready the
  /// instant it scrolls in rather than popping in.
  final double preloadExtent;

  /// Placeholder height while not yet built, so the scrollbar/section
  /// anchors (used for "scroll to Gallery" nav links) stay roughly correct.
  final double placeholderHeight;

  const LazyMount({
    super.key,
    required this.builder,
    this.preloadExtent = 600,
    this.placeholderHeight = 400,
  });

  @override
  State<LazyMount> createState() => _LazyMountState();
}

class _LazyMountState extends State<LazyMount> {
  bool _built = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _position) {
      _position?.removeListener(_check);
      _position = newPosition;
      _position?.addListener(_check);
      // Also check once right after attaching, so content that's already
      // visible on the very first frame (e.g. a tall phone, or a returning
      // visitor mid-scroll) doesn't wait for a scroll event.
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    }
  }

  void _check() {
    if (_built || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;

    final topY = box.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;

    if (topY < screenHeight + widget.preloadExtent) {
      setState(() => _built = true);
      _position?.removeListener(_check);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_built) return widget.builder(context);
    return SizedBox(height: widget.placeholderHeight);
  }
}
