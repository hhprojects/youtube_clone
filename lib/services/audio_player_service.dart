import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  String? _currentTitle;
  String? _currentAuthor;
  String? _currentThumbnail;
  
  // Getters for player state
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  
  // Current state
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  
  // Current track info streams
  Stream<String?> get currentTitleStream => Stream.value(_currentTitle);
  Stream<String?> get currentAuthorStream => Stream.value(_currentAuthor);
  Stream<String?> get currentThumbnailStream => Stream.value(_currentThumbnail);
  
  // Initialize player
  Future<void> init() async {
    await _audioPlayer.setAudioSource(_playlist);
  }
  
  // Play a single audio
  Future<void> playAudio(String url, String title, String author, String thumbnailUrl) async {
    _currentTitle = title;
    _currentAuthor = author;
    _currentThumbnail = thumbnailUrl;
    
    try {
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          title: title,
          artist: author,
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
  Future<void> seek(Duration position) => _audioPlayer.seek(position);
  Future<void> setVolume(double volume) => _audioPlayer.setVolume(volume);
  
  // Cleanup
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
} 