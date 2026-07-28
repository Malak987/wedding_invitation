import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../services/audio_service.dart';
import 'intro_video_player.dart';
import 'instruction.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const LandingScreen({super.key, required this.onCompleted});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  bool _videoLoaded = false;
  bool _audioLoaded = false;
  bool _openTriggered = false;
  bool _videoPlaying = false;

  bool _isHovered = false;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerController.repeat(period: const Duration(seconds: 3));

    // Preload audio service
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _audioLoaded = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the hero background and story images so they render instantly with 0 delay!
    try {
      precacheImage(const AssetImage('assets/images/1.jpg'), context);
      precacheImage(const AssetImage('assets/images/2.jpg'), context);
      precacheImage(const AssetImage('assets/images/3.jpg'), context);
    } catch (e) {
      debugPrint('Pre-caching images failed: $e');
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  bool get _isFullyPreloaded => _videoLoaded && _audioLoaded;

  void _handleOpenInvitation() async {
    if (!_isFullyPreloaded || _openTriggered) return;

    setState(() {
      _openTriggered = true;
      _videoPlaying = true;
    });

    // 1. Synchronously trigger music playback with a smooth fader
    await AppAudioService.instance.play();
  }

  void _onVideoFinished() {
    if (mounted) {
      setState(() {
        _videoPlaying = false;
      });
    }
    // Immediately invoke parent callback to handle the premium stack transition!
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color(0xFFD4AF37); // Champagne Gold

    return Stack(
      children: [
        // 1. Fullscreen Intro Video Player Layer
        // Paused on frame 1 until _videoPlaying is true.
        IntroVideoPlayer(
          videoPath: 'assets/images/video/s&m.mp4',
          playTriggered: _videoPlaying,
          onInitialized: () {
            if (mounted) {
              setState(() {
                _videoLoaded = true;
              });
            }
          },
          onCompleted: _onVideoFinished,
        ),

        // 2. Invisible Hot-Spot Overlay on top of the physical wax seal (exactly at center of viewport)
        if (!_videoPlaying)
          Positioned.fill(
            child: Center(
              child: MouseRegion(
                cursor: _isFullyPreloaded ? SystemMouseCursors.click : SystemMouseCursors.wait,
                onEnter: (_) {
                  if (_isFullyPreloaded) setState(() => _isHovered = true);
                },
                onExit: (_) {
                  if (_isFullyPreloaded) setState(() => _isHovered = false);
                },
                child: GestureDetector(
                  onTap: _handleOpenInvitation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Invisible clickable circle overlay matching the seal dimensions
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: _isHovered && _isFullyPreloaded
                                ? goldColor.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            if (_isHovered && _isFullyPreloaded)
                              BoxShadow(
                                color: goldColor.withOpacity(0.25),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                      ),

                      // Extremely subtle golden shimmer overlay that sweeps across the seal hotspot
                      if (_isFullyPreloaded)
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            final val = _shimmerController.value;
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: ClipOval(
                                child: FractionalTranslation(
                                  translation: Offset(val * 2.5 - 1.2, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.0),
                                          Colors.white.withOpacity(0.08),
                                          goldColor.withOpacity(0.15),
                                          Colors.white.withOpacity(0.08),
                                          Colors.white.withOpacity(0.0),
                                        ],
                                        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                      // Soft loading feedback inside the seal until preloaded
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: goldColor.withOpacity(0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // 3. Elegant Bottom Instruction Overlay (Cairo font, champagne gold, low opacity)
        if (!_videoPlaying)
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: InstructionWidget(),
            ),
          ),
      ],
    );
  }
}
