import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailController extends GetxController {
  void openTrailerDialog(String videoUrl) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl)!;

    YoutubePlayerController youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Youtube player widget
            YoutubePlayer(
              controller: youtubePlayerController,
              showVideoProgressIndicator: true,
              onReady: () {
                youtubePlayerController.play();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    youtubePlayerController.pause();
                    youtubePlayerController.dispose();
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
