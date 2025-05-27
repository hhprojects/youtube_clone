import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../services/audio_player_service.dart';
import '../theme/app_colors.dart';
import '../utils/youtube_downloader.dart';

class PlayerScreen extends StatefulWidget {
  final AudioPlayerService playerService;
  final String videoUrl;

  const PlayerScreen({
    super.key,
    required this.playerService,
    required this.videoUrl,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _audioInfo;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      final audioInfo = await YoutubeDownloader.getAudioStream(widget.videoUrl);

      widget.playerService.playAudio(
        audioInfo['audioUrl'],
        audioInfo['title'],
        audioInfo['author'],
        audioInfo['thumbnailUrl'],
      );

      setState(() {
        _audioInfo = audioInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: const Text('Now Playing', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading audio: $_error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAudio,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Album Art
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 10.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _audioInfo!['thumbnailUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Song Info
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _audioInfo!['title'],
                            style: const TextStyle(
                              color: TColorTheme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _audioInfo!['author'],
                            style: TextStyle(
                              color: TColorTheme.textSecondary,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Progress Bar
                          StreamBuilder<Duration?>(
                            stream: widget.playerService.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration?>(
                                stream: widget.playerService.durationStream,
                                builder: (context, snapshot) {
                                  final duration =
                                      snapshot.data ?? Duration.zero;
                                  return ProgressBar(
                                    progress: position,
                                    total: duration,
                                    onSeek: (position) {
                                      widget.playerService.seek(position);
                                    },
                                    progressBarColor: TColorTheme.primaryColor,
                                    baseBarColor: TColorTheme.textSecondary
                                        .withOpacity(0.2),
                                    thumbColor: TColorTheme.primaryColor,
                                    timeLabelTextStyle: TextStyle(
                                      color: TColorTheme.textSecondary,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Playback Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shuffle),
                                color: TColorTheme.textPrimary,
                                onPressed: () {
                                  // TODO: Implement shuffle
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                color: TColorTheme.textPrimary,
                                iconSize: 48,
                                onPressed: () {
                                  // TODO: Implement previous
                                },
                              ),
                              StreamBuilder<bool>(
                                stream: widget.playerService.playerStateStream
                                    .map((state) => state.playing),
                                builder: (context, snapshot) {
                                  final isPlaying = snapshot.data ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                    ),
                                    color: TColorTheme.primaryColor,
                                    iconSize: 64,
                                    onPressed: () {
                                      if (isPlaying) {
                                        widget.playerService.pause();
                                      } else {
                                        widget.playerService.play();
                                      }
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                color: TColorTheme.textPrimary,
                                iconSize: 48,
                                onPressed: () {
                                  // TODO: Implement next
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.repeat),
                                color: TColorTheme.textPrimary,
                                onPressed: () {
                                  // TODO: Implement repeat
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
