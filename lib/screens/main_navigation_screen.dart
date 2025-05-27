import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/audio_player_service.dart';
import 'home_screen.dart';
import 'placeholder_screen.dart';
import '../widgets/homepage_widgets/mini_player_widget.dart';
import 'player_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  late final AudioPlayerService _playerService;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _playerService = AudioPlayerService();
    _playerService.init();

    _screens = [
      HomeScreen(playerService: _playerService),
      const PlaceholderScreen(title: 'Playlist'),
      const PlaceholderScreen(title: 'Library'),
    ];
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
            Icon(
              Icons.play_circle_outline,
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
      body: Stack(
        children: [
          _screens[_selectedIndex],
          // Mini player overlay
          StreamBuilder<bool>(
            stream: _playerService.playerStateStream.map(
              (state) => state.playing,
            ),
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              if (!isPlaying) return const SizedBox.shrink();

              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MiniPlayer(
                  playerService: _playerService,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PlayerScreen(
                              playerService: _playerService,
                              videoUrl:
                                  'current_video_url', // You'll need to track this
                            ),
                      ),
                    );
                  },
                ),
              );
            },
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list),
            label: 'Playlist',
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
