import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../services/audio_player_service.dart';
import '../../screens/player_screen.dart';

class VideoCard extends StatelessWidget {
  final String thumbnail;
  final String title;
  final String views;
  final DateTime uploadTime;
  final String duration;
  final String videoUrl;
  final AudioPlayerService playerService;

  const VideoCard({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.views,
    required this.uploadTime,
    required this.duration,
    required this.videoUrl,
    required this.playerService,
  });

  void _navigateToPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(
          playerService: playerService,
          videoUrl: videoUrl,
        ),
      ),
    );
  }

  String formatDuration(String duration) {
    return duration.split('.').first;
  }

  String formatUploadTime(DateTime uploadTime) {
    final now = DateTime.now();
    final diff = now.difference(uploadTime);
    if (diff.inDays > 365) {
      return '${diff.inDays ~/ 365} years ago';
    }
    if (diff.inDays > 30) {
      return '${diff.inDays ~/ 30} months ago';
    }
    if (diff.inDays > 1) {
      return '${diff.inDays} days ago';
    }
    return 'Uploaded today';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: thumbnail,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      formatDuration(duration),
                      style: TextStyle(
                        color: TColorTheme.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: TColorTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$views • ${formatUploadTime(uploadTime)}',
              style: TextStyle(
                color: TColorTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 