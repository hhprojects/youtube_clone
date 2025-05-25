import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/audio_player_service.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayerService playerService;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.playerService,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: TColorTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            StreamBuilder<String?>(
              stream: playerService.currentThumbnailStream,
              builder: (context, snapshot) {
                return Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            // Song Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<String?>(
                    stream: playerService.currentTitleStream,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: const TextStyle(
                          color: TColorTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  StreamBuilder<String?>(
                    stream: playerService.currentAuthorStream,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '',
                        style: TextStyle(
                          color: TColorTheme.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Playback Controls
            StreamBuilder<bool>(
              stream: playerService.playerStateStream.map((state) => state.playing),
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: TColorTheme.primaryColor,
                    size: 32,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      playerService.pause();
                    } else {
                      playerService.play();
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.skip_next,
                color: TColorTheme.textPrimary,
                size: 32,
              ),
              onPressed: () {
                // TODO: Implement next
              },
            ),
          ],
        ),
      ),
    );
  }
} 