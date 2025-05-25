import 'package:flutter/material.dart';
import '../widgets/homepage_widgets/videocard_widget.dart';
import '../theme/app_colors.dart';
import '../services/audio_player_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../utils/youtube_downloader.dart';
import '../widgets/homepage_widgets/mini_player_widget.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  final AudioPlayerService playerService;
  
  const HomeScreen({
    super.key,
    required this.playerService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Video> _songs = [];
  bool _isLoadingSongs = true;

  Future<void> getTrendingSongs() async {
    _songs = await YoutubeDownloader.getTrendingSongs();
    setState(() {
      _isLoadingSongs = false;
    });
  }

  Future<void> searchSongs(String query) async {
    setState(() {
      _isLoadingSongs = true;
    });

    var songs = await YoutubeDownloader.search(query);

    setState(() {
      _songs = songs;
      _isLoadingSongs = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTrendingSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: TextField(
                  style: TextStyle(color: TColorTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search songs, albums, artists',
                    hintStyle: TextStyle(color: TColorTheme.textSecondary),
                    prefixIcon: Icon(Icons.search, color: TColorTheme.textPrimary),
                    filled: true,
                    fillColor: TColorTheme.searchBarFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: TColorTheme.primaryColor[300]!, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (query) => searchSongs(query)
                ),
              ),
              // Video list
              Expanded(
                child: _isLoadingSongs ? const Center(child: CircularProgressIndicator()) : 
                ListView.builder(
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    return VideoCard(
                      thumbnail: _songs[index].thumbnails.highResUrl,
                      title: _songs[index].title,
                      views: '${_songs[index].engagement.viewCount} views',
                      uploadTime: _songs[index].uploadDate ?? DateTime.now(),
                      duration: _songs[index].duration.toString(),
                      videoUrl: _songs[index].url,
                      playerService: widget.playerService,
                    );
                  },
                ),
              ),
            ],
          ),
          // Mini player overlay
          StreamBuilder<bool>(
            stream: widget.playerService.playerStateStream.map((state) => state.playing),
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              if (!isPlaying) return const SizedBox.shrink();
              
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MiniPlayer(
                  playerService: widget.playerService,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          playerService: widget.playerService,
                          videoUrl: 'current_video_url', // You'll need to track this
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      );
  }
} 