import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  AudioPlayerService() {
    // Listen to player state changes
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  /// Play audio from Base64-encoded data
  ///
  /// [audioBase64] - Base64-encoded audio data
  /// Returns true if playback started successfully
  ///
  /// Platform-specific implementation:
  /// - Web: Uses data URL (BytesSource not supported)
  /// - Mobile: Uses BytesSource for better performance
  Future<bool> playFromBase64(String audioBase64) async {
    if (audioBase64.isEmpty) {
      print('Empty audio Base64, skipping playback');
      return false;
    }

    try {
      // Decode Base64 to bytes
      final bytes = base64Decode(audioBase64);
      final sizeMB = bytes.length / (1024 * 1024);

      // Warn if audio is too large for data URLs
      if (kIsWeb && sizeMB > 5) {
        print('Warning: Audio size (${sizeMB.toStringAsFixed(2)} MB) may exceed browser limits');
      }

      print('Playing audio (${bytes.length} bytes, ${sizeMB.toStringAsFixed(2)} MB)');

      // Stop any currently playing audio
      if (_isPlaying) {
        await stop();
      }

      // Web platform requires data URLs (BytesSource not supported)
      if (kIsWeb) {
        // Create data URL with WAV MIME type
        // Format: data:audio/wav;base64,<base64-data>
        final dataUrl = 'data:audio/wav;base64,$audioBase64';
        print('Using data URL for web platform');

        await _player.play(UrlSource(dataUrl));
      } else {
        // Mobile platforms can use BytesSource directly
        print('Using BytesSource for mobile platform');
        final source = BytesSource(bytes);
        await _player.play(source);
      }

      return true;
    } catch (e) {
      print('Error playing audio from Base64: $e');
      return false;
    }
  }

  /// Play audio from a file path
  ///
  /// [path] - Path to the audio file
  Future<void> playFromFile(String path) async {
    try {
      // Stop any currently playing audio
      if (_isPlaying) {
        await stop();
      }

      await _player.play(DeviceFileSource(path));
    } catch (e) {
      print('Error playing audio from file: $e');
      rethrow;
    }
  }

  /// Play audio from a URL
  ///
  /// [url] - URL to the audio file
  Future<void> playFromUrl(String url) async {
    try {
      // Stop any currently playing audio
      if (_isPlaying) {
        await stop();
      }

      await _player.play(UrlSource(url));
    } catch (e) {
      print('Error playing audio from URL: $e');
      rethrow;
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      await _player.resume();
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Stop playback
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Seek to a position
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  /// Get current playback position
  Future<Duration?> getCurrentPosition() async {
    try {
      return await _player.getCurrentPosition();
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Get total duration
  Future<Duration?> getDuration() async {
    try {
      return await _player.getDuration();
    } catch (e) {
      print('Error getting duration: $e');
      return null;
    }
  }

  /// Listen to player state changes
  Stream<PlayerState> get onPlayerStateChanged =>
      _player.onPlayerStateChanged;

  /// Listen to playback completion
  Stream<void> get onPlayerComplete => _player.onPlayerComplete;

  /// Listen to position updates
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  /// Listen to duration updates
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;

  /// Dispose the player
  Future<void> dispose() async {
    await stop();
    _player.dispose();
  }
}
