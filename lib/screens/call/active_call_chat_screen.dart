import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../services/audio_recorder_service.dart';
import '../../services/audio_player_service.dart';
import '../../services/api_service.dart';
import 'end_call_modal.dart';

/// Active call chat screen with message bubbles.
/// Original: active_ai_conversation_2, _3
class ActiveCallChatScreen extends StatefulWidget {
  final int sessionId;

  const ActiveCallChatScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<ActiveCallChatScreen> createState() => _ActiveCallChatScreenState();
}

class _ActiveCallChatScreenState extends State<ActiveCallChatScreen> {
  late int _seconds;
  Timer? _timer;
  bool _isDarkMode = false;
  bool _isRecording = false;
  String? _recordingPath;
  bool _isWaitingForAI = false;
  bool _isSpeakerOn = true;

  // Audio services
  final AudioRecorderService _audioRecorder = AudioRecorderService();
  final AudioPlayerService _audioPlayer = AudioPlayerService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  final List<_ChatMessage> _messages = [];

  bool get _isThinking => _isWaitingForAI;

  @override
  void initState() {
    super.initState();
    _seconds = 0;
    _startTimer();

    // Load initial messages after first frame to get context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMessages();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  Future<void> _loadInitialMessages() async {
    // Load existing messages from the session
    try {
      final response = await ApiService.get('/sessions/${widget.sessionId}/messages');
      if (response.success && mounted) {
        final messages = response.data['messages'] as List;
        setState(() {
          _messages.clear();
          for (var msg in messages) {
            _messages.add(_ChatMessage(
              isUser: msg['sender'] == 'user',
              text: msg['text'],
              translation: msg['translated_text'],
              time: _formatTime(DateTime.parse(msg['timestamp'])),
              audioBase64: msg['audio_url'], // May be null
              messageId: msg['message_id'], // For feedback
            ));
          }
        });
        _scrollToBottom();

        // Auto-play AI greeting if it exists and speaker is on
        if (_isSpeakerOn && _messages.isNotEmpty) {
          final firstMessage = _messages.first;
          if (!firstMessage.isUser &&
              firstMessage.audioBase64 != null &&
              firstMessage.audioBase64!.isNotEmpty) {
            // Wait a bit before playing
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              await _audioPlayer.playFromBase64(firstMessage.audioBase64!);
            }
          }
        }
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final min = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Future<void> _toggleRecording() async {
    // On Web, recording is not supported - use text input instead
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice recording is not supported on Web. Please use the text input field below.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (_isRecording) {
      // Stop recording and send
      final path = await _audioRecorder.stopRecording();
      setState(() => _isRecording = false);

      if (path != null) {
        try {
          // Convert to base64
          final audioBase64 = await _audioRecorder.audioToBase64(path);

          // Send to backend
          await _sendAudioMessage(audioBase64);

          // Clean up temp file
          await _audioRecorder.deleteAudioFile(path);
        } catch (e) {
          print('Error processing audio: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error processing audio: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } else {
      // Start recording (Mobile only)
      try {
        final tempDir = await getTemporaryDirectory();
        _recordingPath = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

        final started = await _audioRecorder.startRecording(_recordingPath!);
        if (started) {
          setState(() => _isRecording = true);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to start recording. Check microphone permissions.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        print('Error starting recording: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Clear input
    _textController.clear();

    setState(() => _isWaitingForAI = true);

    try {
      final response = await ApiService.post(
        '/sessions/${widget.sessionId}/messages',
        {'text': text},
      );

      if (response.success && mounted) {
        final data = response.data;

        // Add user message
        final userMsg = _ChatMessage(
          isUser: true,
          text: text,
          time: _formatTime(DateTime.now()),
          messageId: data['message_id'], // Store message ID for feedback
        );

        // Add AI response (text only first)
        final aiResponse = data['ai_response'];
        final aiMsg = _ChatMessage(
          isUser: false,
          text: aiResponse['text'],
          translation: aiResponse['translated_text'],
          time: _formatTime(DateTime.now()),
          audioBase64: null, // Will be fetched in background
        );

        setState(() {
          _messages.add(userMsg);
          _messages.add(aiMsg);
          _isWaitingForAI = false;
        });

        _scrollToBottom();

        // Fetch TTS audio in background
        final aiMessageId = aiResponse['message_id'];
        if (_isSpeakerOn && aiMessageId != null) {
          _fetchAndPlayAudio(aiMessageId, _messages.length - 1);
        }
      } else {
        setState(() => _isWaitingForAI = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() => _isWaitingForAI = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendAudioMessage(String audioBase64) async {
    setState(() => _isWaitingForAI = true);

    try {
      final response = await ApiService.post(
        '/sessions/${widget.sessionId}/messages',
        {'audio_base64': audioBase64},
      );

      if (response.success && mounted) {
        final data = response.data;

        // Add user message (with STT transcription)
        final userMsg = _ChatMessage(
          isUser: true,
          text: data['text'] ?? 'Audio message',
          time: _formatTime(DateTime.now()),
          messageId: data['message_id'], // Store message ID for feedback
        );

        // Add AI response (text only first)
        final aiResponse = data['ai_response'];
        final aiMsg = _ChatMessage(
          isUser: false,
          text: aiResponse['text'],
          translation: aiResponse['translated_text'],
          time: _formatTime(DateTime.now()),
          audioBase64: null, // Will be fetched in background
        );

        setState(() {
          _messages.add(userMsg);
          _messages.add(aiMsg);
          _isWaitingForAI = false;
        });

        _scrollToBottom();

        // Fetch TTS audio in background
        final aiMessageId = aiResponse['message_id'];
        if (_isSpeakerOn && aiMessageId != null) {
          _fetchAndPlayAudio(aiMessageId, _messages.length - 1);
        }
      } else {
        setState(() => _isWaitingForAI = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error sending message: $e');
      setState(() => _isWaitingForAI = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Fetch TTS audio in background and play it
  Future<void> _fetchAndPlayAudio(int messageId, int messageIndex) async {
    try {
      print('🎵 Fetching TTS audio for message $messageId...');

      final response = await ApiService.get(
        '/sessions/${widget.sessionId}/messages/$messageId/audio',
      );

      if (response.success && mounted) {
        final audioBase64 = response.data['audio_base64'] as String?;

        if (audioBase64 != null && audioBase64.isNotEmpty) {
          // Update message with audio
          if (messageIndex < _messages.length) {
            setState(() {
              _messages[messageIndex] = _ChatMessage(
                isUser: _messages[messageIndex].isUser,
                text: _messages[messageIndex].text,
                translation: _messages[messageIndex].translation,
                time: _messages[messageIndex].time,
                audioBase64: audioBase64,
                messageId: _messages[messageIndex].messageId,
                pronunciationScore: _messages[messageIndex].pronunciationScore,
              );
            });
          }

          // Play audio immediately
          if (_isSpeakerOn) {
            await _audioPlayer.playFromBase64(audioBase64);
            print('🎵 TTS audio played successfully');
          }
        }
      } else {
        print('⚠️ Failed to fetch TTS audio: ${response.message}');
      }
    } catch (e) {
      print('❌ Error fetching TTS audio: $e');
    }
  }

  /// Fetch translation in background
  Future<void> _fetchTranslation(int messageId, int messageIndex) async {
    try {
      print('🌐 Fetching translation for message $messageId...');

      final response = await ApiService.get(
        '/sessions/${widget.sessionId}/messages/$messageId/translation',
      );

      if (response.success && mounted) {
        final translation = response.data['translation'] as String?;

        if (translation != null && translation.isNotEmpty) {
          // Update message with translation
          if (messageIndex < _messages.length) {
            setState(() {
              _messages[messageIndex] = _ChatMessage(
                isUser: _messages[messageIndex].isUser,
                text: _messages[messageIndex].text,
                translation: translation,
                time: _messages[messageIndex].time,
                audioBase64: _messages[messageIndex].audioBase64,
                messageId: _messages[messageIndex].messageId,
                pronunciationScore: _messages[messageIndex].pronunciationScore,
              );
            });
          }
          print('🌐 Translation updated successfully');
        }
      } else {
        print('⚠️ Failed to fetch translation: ${response.message}');
      }
    } catch (e) {
      print('❌ Error fetching translation: $e');
    }
  }

  void _toggleSpeaker() {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    if (!_isSpeakerOn) {
      _audioPlayer.stop();
    }
  }

  /// Show feedback dialog for a user message
  Future<void> _showFeedback(int messageId) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call feedback API
      final response = await ApiService.post(
        '/feedback/analyze',
        {'message_id': messageId},
      );

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      if (response.success) {
        final data = response.data;
        final grammarFeedback = data['grammar_feedback'] ?? '';
        final vocabularyFeedback = data['vocabulary_feedback'] ?? '';
        final suggestions = data['suggested_response'];

        // Show feedback dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.analytics, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('피드백'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (grammarFeedback.isNotEmpty) ...[
                    Text(
                      '문법 교정',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grammarFeedback,
                      style: AppTextStyles.bodyMedium(color: AppColors.textDark),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (vocabularyFeedback.isNotEmpty) ...[
                    Text(
                      '더 나은 표현',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vocabularyFeedback,
                      style: AppTextStyles.bodyMedium(color: AppColors.textDark),
                      softWrap: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (suggestions != null) ...[
                    Text(
                      '추천 표현',
                      style: AppTextStyles.labelLarge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    if (suggestions is List)
                      ...suggestions.map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• $s',
                              style: AppTextStyles.bodyMedium(
                                  color: AppColors.slate600),
                            ),
                          ))
                    else
                      Text(
                        suggestions.toString(),
                        style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                      ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
            ],
          ),
        );
      } else {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('피드백을 가져올 수 없습니다: ${response.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEndCallModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EndCallModal(sessionId: widget.sessionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? AppColors.darkBg : Colors.white;
    final textColor = _isDarkMode ? Colors.white : AppColors.textDark;
    final aiBubbleColor = _isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight;
    final borderColor = _isDarkMode ? AppColors.slate700 : AppColors.slate100;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.95),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                children: [
                  // AI Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: aiBubbleColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      size: 20,
                      color: _isDarkMode ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coach Alex',
                          style: AppTextStyles.bodyMedium(color: textColor)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.callGreen,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ACTIVE SESSION',
                              style: AppTextStyles.labelSmall(
                                color: AppColors.slate400,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.slate100,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      _formattedTime,
                      style: AppTextStyles.labelLarge(
                        color: _isDarkMode ? Colors.white : AppColors.slate600,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Dark mode toggle
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                    child: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: _isDarkMode ? Colors.white : AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),

            // Chat list
            Expanded(
              child: _messages.isEmpty && !_isThinking
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic,
                            size: 64,
                            color: _isDarkMode ? AppColors.slate700 : AppColors.slate300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap the mic button to start speaking',
                            style: AppTextStyles.bodyMedium(
                              color: _isDarkMode ? AppColors.slate500 : AppColors.slate400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length + (_isThinking ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isThinking) {
                          return _ThinkingIndicator(isDarkMode: _isDarkMode);
                        }
                        final msg = _messages[index];
                        return _ChatBubble(
                          message: msg,
                          isDarkMode: _isDarkMode,
                          onFeedbackTap: msg.isUser && msg.messageId != null
                              ? () => _showFeedback(msg.messageId!)
                              : null,
                        );
                      },
                    ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.95),
                border: Border(
                  top: BorderSide(color: borderColor),
                ),
              ),
              child: Column(
                children: [
                  // Text input for Web
                  if (kIsWeb) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? AppColors.slate800 : AppColors.slate100,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: _isDarkMode ? AppColors.slate700 : AppColors.slate200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              enabled: !_isWaitingForAI,
                              style: AppTextStyles.bodyMedium(color: textColor),
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: AppTextStyles.bodyMedium(
                                  color: _isDarkMode ? AppColors.slate500 : AppColors.slate400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _sendTextMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _isWaitingForAI ? null : _sendTextMessage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _isWaitingForAI
                                    ? AppColors.slate300
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Recording/Listening indicator
                  if (_isRecording || _isWaitingForAI)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Vertical bars
                          ...List.generate(5, (i) {
                            final heights = [12.0, 20.0, 28.0, 16.0, 24.0];
                            return Container(
                              width: 2,
                              height: heights[i],
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppRadius.full),
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            _isRecording ? 'RECORDING...' : 'PROCESSING...',
                            style: AppTextStyles.labelSmall(color: AppColors.primary)
                                .copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isRecording || _isWaitingForAI) const SizedBox(height: 24),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ChatControlButton(
                        icon: _isRecording ? Icons.stop : Icons.mic,
                        label: _isRecording ? 'Stop' : 'Record',
                        isDarkMode: _isDarkMode,
                        isActive: _isRecording,
                        isDisabled: _isWaitingForAI,
                        onTap: _isWaitingForAI ? () {} : _toggleRecording,
                      ),
                      _ChatControlButton(
                        icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                        label: 'Speaker',
                        isDarkMode: _isDarkMode,
                        isActive: _isSpeakerOn,
                        onTap: _toggleSpeaker,
                      ),
                      _ChatControlButton(
                        icon: Icons.replay,
                        secondaryIcon: Icons.pause,
                        label: 'Replay',
                        isDarkMode: _isDarkMode,
                        onTap: () {
                          // Replay last AI message if available
                          for (var msg in _messages.reversed) {
                            if (!msg.isUser && msg.audioBase64 != null && msg.audioBase64!.isNotEmpty) {
                              _audioPlayer.playFromBase64(msg.audioBase64!);
                              break;
                            }
                          }
                        },
                      ),
                      _ChatControlButton(
                        icon: Icons.call_end,
                        label: 'End Call',
                        isEndCall: true,
                        isDarkMode: _isDarkMode,
                        onTap: _showEndCallModal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  final String? translation;
  final String time;
  final String? audioBase64;
  final int? messageId; // For feedback API
  final int? pronunciationScore;

  _ChatMessage({
    required this.isUser,
    required this.text,
    this.translation,
    required this.time,
    this.audioBase64,
    this.messageId,
    this.pronunciationScore,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDarkMode;
  final VoidCallback? onFeedbackTap; // Callback for feedback button

  const _ChatBubble({
    required this.message,
    required this.isDarkMode,
    this.onFeedbackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? AppColors.userBubble
        : (isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight);
    final textColor = isUser
        ? Colors.white
        : (isDarkMode ? Colors.white : AppColors.textDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? AppRadius.xxl : 0),
                topRight: Radius.circular(isUser ? 0 : AppRadius.xxl),
                bottomLeft: const Radius.circular(AppRadius.xxl),
                bottomRight: const Radius.circular(AppRadius.xxl),
              ),
              boxShadow: isUser
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [AppShadows.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: AppTextStyles.bodyMedium(color: textColor)
                      .copyWith(height: 1.5),
                ),
                if (!isUser && message.translation != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.slate200.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Text(
                      message.translation!,
                      style: AppTextStyles.bodySmall(
                        color: isDarkMode ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: onFeedbackTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.slate700 : AppColors.slate100,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: isDarkMode ? AppColors.slate600 : AppColors.slate200,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Feedback',
                      style: AppTextStyles.labelSmall(color: AppColors.primary)
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThinkingIndicator extends StatelessWidget {
  final bool isDarkMode;

  const _ThinkingIndicator({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(AppRadius.xxl),
            bottomLeft: Radius.circular(AppRadius.xxl),
            bottomRight: Radius.circular(AppRadius.xxl),
          ),
          border: Border.all(
            color: isDarkMode ? AppColors.slate700 : AppColors.slate100,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouncing dots
            ...List.generate(3, (i) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 600 + (i * 200)),
                builder: (context, value, child) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(
                        alpha: 0.4 + (i * 0.2),
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(width: 8),
            Text(
              'ALEX IS THINKING',
              style: AppTextStyles.labelSmall(color: AppColors.primary).copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatControlButton extends StatelessWidget {
  final IconData icon;
  final IconData? secondaryIcon;
  final String label;
  final bool isEndCall;
  final bool isDarkMode;
  final bool isActive;
  final bool isDisabled;
  final VoidCallback onTap;

  const _ChatControlButton({
    required this.icon,
    this.secondaryIcon,
    required this.label,
    this.isEndCall = false,
    required this.isDarkMode,
    this.isActive = false,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEndCall
        ? AppColors.callRed
        : isActive
            ? AppColors.primary
            : isDisabled
                ? (isDarkMode ? Colors.white.withValues(alpha: 0.05) : AppColors.slate100)
                : (isDarkMode ? Colors.white.withValues(alpha: 0.1) : AppColors.slate100);
    final iconColor = isEndCall
        ? Colors.white
        : isActive
            ? Colors.white
            : isDisabled
                ? (isDarkMode ? AppColors.slate700 : AppColors.slate300)
                : (isDarkMode ? Colors.white : AppColors.slate600);
    final labelColor = isEndCall
        ? AppColors.callRed
        : isActive
            ? AppColors.primary
            : isDisabled
                ? (isDarkMode ? AppColors.slate700 : AppColors.slate300)
                : (isDarkMode ? AppColors.slate400 : AppColors.slate500);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: isEndCall
                  ? null
                  : Border.all(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.slate200,
                    ),
              boxShadow: isEndCall
                  ? [
                      BoxShadow(
                        color: AppColors.callRed.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: secondaryIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(secondaryIcon, size: 18, color: iconColor),
                        Icon(icon, size: 18, color: iconColor),
                      ],
                    )
                  : Icon(icon, size: 24, color: iconColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall(color: labelColor).copyWith(
              fontSize: 10,
              fontWeight: isEndCall ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
