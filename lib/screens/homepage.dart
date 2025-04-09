import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/homepage_widgets/videocard_widget.dart';
import '../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return VideoCard(
                  thumbnail: 'https://picsum.photos/seed/$index/300/200',
                  title: 'Video Title ${index + 1}',
                  views: '${(index + 1) * 100}K views',
                  uploadTime: '${index + 1} months ago',
                  duration: '${index + 1}:00',
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
