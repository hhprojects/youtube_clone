import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/homepage_widgets/videocard_widget.dart';
import '../theme/app_colors.dart';
import '../services/audio_player_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../utils/youtube_downloader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final AudioPlayerService _playerService;
  List<Video> _songs = [];
  bool _isLoadingSongs = true;

  Future<void> getTrendingSongs() async {
    _songs = await YoutubeDownloader.getTrendingSongs();
    setState(() {
      _isLoadingSongs = false;
    });
  }

  Future<void> searchSongs(String query) async{
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
    _playerService = AudioPlayerService();
    _playerService.init();
    getTrendingSongs();
  }

  @override
  void dispose() {
    _playerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColorTheme.backgroundColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.play_circle_outline, 
              color: TColorTheme.primaryColor[300],
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'YouTube Music',
              style: GoogleFonts.roboto(
                color: TColorTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
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
                  playerService: _playerService,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: TColorTheme.backgroundColor,
        selectedItemColor: TColorTheme.primaryColor[300],
        unselectedItemColor: TColorTheme.bottomNavUnselected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
