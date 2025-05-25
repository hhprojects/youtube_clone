import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  
  // Getters for player state
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  
  // Current state
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  
  // Initialize player
  Future<void> init() async {
    await _audioPlayer.setAudioSource(_playlist);
  }
  
  // Play a single audio
  Future<void> playAudio(String url, String title, String artist, String thumbnailUrl) async {
    try {
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          title: title,
          artist: artist,
          artUri: Uri.parse(thumbnailUrl),
        ),
      );
      
      await _playlist.clear();
      await _playlist.add(audioSource);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }
  
  // Playback controls
  Future<void> play() => _audioPlayer.play();
  Future<void> pause() => _audioPlayer.pause();
  Future<void> stop() => _audioPlayer.stop();
  Future<void> previous() => _audioPlayer.seekToPrevious();
  Future<void> seek(Duration position) => _audioPlayer.seek(position);
  Future<void> setVolume(double volume) => _audioPlayer.setVolume(volume);
  
  // Cleanup
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
} 