import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../dashboard/music.dart';
import '../dashboard/colors.dart';

/// A small floating play/pause control for background music.
/// Isolated as its own StatefulWidget so audio state changes never
/// rebuild the rest of the page.
class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(AppMusic.loop ? ReleaseMode.loop : ReleaseMode.release);
    _player.setVolume(AppMusic.volume);
    if (AppMusic.autoPlay) {
      _play();
    }
  }

  Future<void> _play() async {
    // Defensive: audioplayers' AssetSource path must be relative to the
    // assets root declared in pubspec.yaml (no "assets/" prefix).
    final path = AppMusic.trackAsset.startsWith('assets/')
        ? AppMusic.trackAsset.substring('assets/'.length)
        : AppMusic.trackAsset;

    try {
      await _player.play(AssetSource(path));
      if (mounted) setState(() => _isPlaying = true);
    } catch (e) {
      // Autoplay can also be blocked by the browser until the user
      // interacts with the page at least once — that's expected and
      // harmless. Anything else (e.g. 404 / format error) usually means
      // the file name in music.dart doesn't match the file inside
      // assets/music/, or the file wasn't added to assets/music/ at all.
      if (kDebugMode) {
        debugPrint('MusicPlayer: could not play "$path" — $e');
      }
    }
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      child: FloatingActionButton(
        heroTag: 'music_player',
        backgroundColor: AppColorsData.primary,
        onPressed: _toggle,
        child: Icon(_isPlaying ? Icons.pause : Icons.music_note, color: Colors.white),
      ),
    );
  }
}
