import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Start recording audio
  ///
  /// [path] - Full path where the audio file will be saved
  /// Returns true if recording started successfully
  Future<bool> startRecording(String path) async {
    try {
      // Check permission
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          throw Exception('Microphone permission denied');
        }
      }

      // Check if already recording
      if (_isRecording) {
        print('Warning: Already recording');
        return false;
      }

      // Configure recording settings
      const config = RecordConfig(
        encoder: AudioEncoder.wav, // WAV format for Azure Speech
        sampleRate: 16000, // 16kHz sample rate
        numChannels: 1, // Mono
      );

      // Start recording
      await _recorder.start(config, path: path);
      _isRecording = true;
      print('Recording started: $path');
      return true;
    } catch (e) {
      print('Error starting recording: $e');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording and return the file path
  ///
  /// Returns the path to the recorded audio file, or null if not recording
  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) {
        print('Warning: Not currently recording');
        return null;
      }

      final path = await _recorder.stop();
      _isRecording = false;
      print('Recording stopped: $path');
      return path;
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Cancel recording without saving
  Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorder.cancel();
        _isRecording = false;
        print('Recording cancelled');
      }
    } catch (e) {
      print('Error cancelling recording: $e');
      _isRecording = false;
    }
  }

  /// Convert audio file to Base64 string
  ///
  /// [path] - Path to the audio file
  /// Returns Base64-encoded audio data
  Future<String> audioToBase64(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $path');
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      print('Audio file converted to Base64 (${bytes.length} bytes)');
      return base64String;
    } catch (e) {
      print('Error converting audio to Base64: $e');
      rethrow;
    }
  }

  /// Delete audio file
  ///
  /// [path] - Path to the audio file to delete
  Future<void> deleteAudioFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print('Audio file deleted: $path');
      }
    } catch (e) {
      print('Error deleting audio file: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    if (_isRecording) {
      await cancelRecording();
    }
    _recorder.dispose();
  }

  /// Check if recording is supported on this device
  Future<bool> isEncoderSupported(AudioEncoder encoder) async {
    return await _recorder.isEncoderSupported(encoder);
  }
}
