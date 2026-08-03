import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/tutorial_data.dart';
import '../services/config_manager.dart';
import '../services/tutorial_manager.dart';

/// Full-screen, one-time onboarding slider shown right after the invitation
/// finishes opening. Blurs/darkens whatever is behind it, blocks all
/// interaction with the site until finished or skipped, and never reappears
/// once completed (persisted through [TutorialManager]).
///
/// Usage: place `if (showTutorial) const TutorialOverlay()` as the topmost
/// child of the root [Stack] in `main.dart`, right above the landing screen.
class TutorialOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const TutorialOverlay({super.key, required this.onFinished});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final PageController _pageController;
  final FocusNode _focusNode = FocusNode();

  int _page = 0;
  bool _closing = false;
  bool _keepShowing = true; // "Don't show this again" checkbox state
  DateTime _lastWheelStep = DateTime.fromMillisecondsSinceEpoch(0);

  late final List<TutorialStep> _all;

  @override
  void initState() {
    super.initState();
    // Ordered list: welcome step -> every content step -> final step.
    _all = [
      ...TutorialData.steps,
      TutorialData.finalStep,
    ];

    _pageController = PageController();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isLast => _page == _all.length - 1;
  bool get _isArabic => AppConfigManager.instance.selectedLanguage == 'ar';

  void _goTo(int index) {
    if (index < 0 || index >= _all.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _goTo(_page + 1);
    }
  }

  void _finish() {
    if (_closing) return;
    setState(() => _closing = true);
    if (_keepShowing) {
      TutorialManager.instance.markCompleted();
    } else {
      // User unchecked "don't show again" -> leave it uncompleted so it
      // greets them again on their next visit.
      TutorialManager.instance.reset();
    }
    _entrance.reverse().whenComplete(widget.onFinished);
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final isRtl = _isArabic;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      isRtl ? _goTo(_page - 1) : _goTo(_page + 1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      isRtl ? _goTo(_page + 1) : _goTo(_page - 1);
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _finish();
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _next();
    }
  }

  void _handleWheel(PointerSignalEvent signal) {
    if (signal is! PointerScrollEvent) return;
    final now = DateTime.now();
    if (now.difference(_lastWheelStep) < const Duration(milliseconds: 500)) {
      return; // debounce - one page per gesture
    }
    if (signal.scrollDelta.dy.abs() < 8) return;
    _lastWheelStep = now;
    if (signal.scrollDelta.dy > 0) {
      _goTo(_page + 1);
    } else {
      _goTo(_page - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, child) {
        final t = Curves.easeOutBack.transform(_entrance.value.clamp(0, 1));
        final fade = Curves.easeOut.transform(_entrance.value.clamp(0, 1));
        return Opacity(
          opacity: fade,
          child: Transform.scale(
            scale: 0.92 + (0.08 * t),
            child: child,
          ),
        );
      },
      child: Positioned.fill(
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKey,
          child: Listener(
            onPointerSignal: _handleWheel,
            child: Stack(
              children: [
                // Blurred, darkened backdrop over whatever is behind it.
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(color: Colors.black.withOpacity(0.55)),
                  ),
                ),
                // Absorb every tap so the site behind is fully locked.
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: const SizedBox.expand(),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _all.length,
                          onPageChanged: (i) => setState(() => _page = i),
                          itemBuilder: (context, index) {
                            final step = _all[index];
                            final isEdge = index == 0 || index == _all.length - 1;
                            return _TutorialPage(
                              step: step,
                              isArabic: _isArabic,
                              large: isEdge,
                            );
                          },
                        ),
                      ),
                      _buildIndicator(),
                      const SizedBox(height: 18),
                      _buildBottomBar(),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isLast)
            TextButton(
              onPressed: _finish,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.85),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: Text(
                _isArabic ? 'تخطي' : 'Skip',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_all.length, (i) {
        final active = i == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFC9A66B)
                : Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          if (_isLast)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () => setState(() => _keepShowing = !_keepShowing),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _keepShowing ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 20,
                        color: const Color(0xFFC9A66B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isArabic ? 'عدم عرض هذا الدليل مرة أخرى' : "Don't show this tutorial again",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC9A66B),
                foregroundColor: const Color(0xFF2b100a),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
              child: Text(
                _isLast
                    ? (_isArabic ? '✨ ابدأ الاستكشاف' : '✨ Start Exploring')
                    : (_isArabic ? 'التالي ←' : 'Next →'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialPage extends StatelessWidget {
  final TutorialStep step;
  final bool isArabic;
  final bool large;

  const _TutorialPage({
    required this.step,
    required this.isArabic,
    required this.large,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? step.titleAr : step.titleEn;
    final desc = isArabic ? step.descAr : step.descEn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: large
                  ? _GlowIcon(icon: step.icon, size: 96)
                  : _ScreenshotFrame(imageAsset: step.imageAsset, icon: step.icon),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Playfair',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              fontSize: 15,
              height: 1.6,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

/// Real screenshot with a soft glowing gold frame highlighting the section.
/// Falls back to a themed icon card if the asset hasn't been added yet, so
/// the tutorial always looks intentional even before real screenshots exist.
class _ScreenshotFrame extends StatelessWidget {
  final String? imageAsset;
  final String icon;

  const _ScreenshotFrame({required this.imageAsset, required this.icon});

  @override
  Widget build(BuildContext context) {
     final screen = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        maxWidth: screen.width > 900
            ? 850
            : screen.width * 0.92,
        maxHeight: screen.height * 0.62,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC9A66B), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC9A66B).withOpacity(0.45),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageAsset == null
          ? _GlowIcon(icon: icon, size: 64)
          : Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => _GlowIcon(icon: icon, size: 64),
            ),
    );
  }
}

class _GlowIcon extends StatelessWidget {
  final String icon;
  final double size;

  const _GlowIcon({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 1.8,
      height: size * 1.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFC9A66B).withOpacity(0.35),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(icon, style: TextStyle(fontSize: size)),
    );
  }
}
