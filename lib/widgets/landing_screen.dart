import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import 'intro_video_player.dart';
import 'instruction.dart';
import 'seal_hotspot.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const LandingScreen({
    super.key,
    required this.onCompleted,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _videoLoaded = false;
  bool _audioLoaded = false;
  bool _openTriggered = false;
  bool _videoPlaying = false;
  bool _showInstructionCard = false;

  // Anchor for both the seal hotspot and the instruction card above it.
  // The wax seal itself is baked into intro.mp4 (BoxFit.cover, full-bleed),
  // so this alignment approximates its on-screen position. Nudge this (and
  // _sealHotspotSize below) if it doesn't line up with your video's seal.
  static const Alignment _sealAlignment = Alignment(0, -0.1);
  static const double _sealHotspotSize = 320;

  @override
  void initState() {
    super.initState();

    AppAudioService.instance.preload().then((_) {
      if (!mounted) return;

      setState(() {
        _audioLoaded = true;
      });
    }).catchError((error) {
      debugPrint('Audio preload error: $error');

      if (!mounted) return;

      // لا نمنع المستخدم من فتح الدعوة لو الموسيقى بها مشكلة.
      setState(() {
        _audioLoaded = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      const AssetImage('assets/images/story_young.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/images/story_now.jpg'),
      context,
    );
  }

  bool _instructionTimerScheduled = false;

  bool get _isFullyPreloaded => _videoLoaded && _audioLoaded;

  void _maybeScheduleInstructionCard() {
    if (_instructionTimerScheduled || _videoPlaying) return;
    _instructionTimerScheduled = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _videoPlaying) return;
      setState(() => _showInstructionCard = true);
    });
  }

  Future<void> _handleOpenInvitation() async {
    if (!_isFullyPreloaded || _openTriggered) return;

    setState(() {
      _openTriggered = true;
      _videoPlaying = true;
      // Instant onboarding teardown: card, hotspot glow/shine, everything.
      _showInstructionCard = false;
    });

    try {
      await AppAudioService.instance.play();
    } catch (error) {
      debugPrint('Music play error: $error');
    }
  }

  void _onVideoFinished() {
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // Once the experience is actually interactive, show the instruction
    // card shortly after (mirrors "wait 800ms then guide the user").
    if (_isFullyPreloaded) _maybeScheduleInstructionCard();

    return Stack(
      children: [
        Opacity(
          opacity: _isFullyPreloaded ? 1 : 0,
          child: IntroVideoPlayer(
            videoPath: 'assets/images/video/intro.mp4',
            playTriggered: _videoPlaying,
            onInitialized: () {
              if (!mounted) return;

              setState(() {
                _videoLoaded = true;
              });
            },
            onCompleted: _onVideoFinished,
          ),
        ),

        // Seal hotspot + instruction card, anchored together above the
        // wax seal. Both disappear the instant the seal is tapped and stay
        // gone for the rest of this session (LandingScreen simply unmounts
        // once the invitation is opened — see main.dart).
        if (!_videoPlaying)
          Positioned.fill(
            child: Align(
              alignment: _sealAlignment,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InstructionWidget(
                    isReady: _isFullyPreloaded,
                    visible: _isFullyPreloaded ? _showInstructionCard : true,
                  ),
                  const SizedBox(height: 14),
                  SealHotspot(
                    enabled: _isFullyPreloaded,
                    size: _sealHotspotSize,
                    onTap: _handleOpenInvitation,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}