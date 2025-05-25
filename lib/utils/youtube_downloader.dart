import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDownloader {
  YoutubeDownloader._();

  static Future<List<Video>> getTrendingSongs() async {
    final yt = YoutubeExplode();

    var trendingSongs = await yt.search.search('"(Official Music Video)"');
    //var trendingSongs = await yt.search.search('official music videos trending english hits -playlist');

    return trendingSongs;
  }

  static Future<List<Video>> search(String query) async{
    final yt = YoutubeExplode();

    var searchResults = await yt.search.search(query);
    
    yt.close();

    return searchResults;
  }

  static Future<Map<String, dynamic>> getAudioStream(String url) async {
    final yt = YoutubeExplode();
    try {
      // Get video details
      final video = await yt.videos.get(url);
      
      // Get audio stream
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioInfo = manifest.audioOnly.withHighestBitrate();
      
      return {
        'title': video.title,
        'author': video.author,
        'duration': video.duration,
        'thumbnailUrl': video.thumbnails.highResUrl,
        'audioUrl': audioInfo.url.toString(),
      };
    } finally {
      yt.close();
    }
  }
}
