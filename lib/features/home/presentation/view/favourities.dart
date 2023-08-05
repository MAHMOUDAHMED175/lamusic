import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/bottomPlayer.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/song_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colors.dart';
import '../view_model/provider/song_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var songData = Provider.of<SongData>(context);
    _playSong(String? uri) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(uri!),
          ),
        );
      } on Exception {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorsApp.orangeColor,
            content: Text(
              'Song can not play!',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        );
      }
    }

    _loadNewSongOnTrack(SongModel song, songs) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongPlayer(
            song: song,
            player: songData.player,
            songs: songData.getFavorites(),
            songData: songData,
          ),
        ),
      );
      songData.setSongs(songs);
      songData.setPlayingSong(song);
      _playSong(song.uri);
    }

    return SafeArea(
      child: Stack(
        alignment:Alignment.bottomCenter,
        children:[
          SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 18,
            ),            child: SizedBox(
            height: MediaQuery.of(context).size.height/1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "LA",
                          style: TextStyle(
                              color: ColorsApp.blueColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 25),
                          children: const [
                            TextSpan(
                              text: "Favorites",
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      Text(
                        '${songData.getFavorites().length} songs ',
                        style: const TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                  songData.getFavorites().length == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty.png',
                              width: 90,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Favorite Songs are empty!',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : SizedBox(
                    height: size.height / 1,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: songData.getFavorites().length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          _loadNewSongOnTrack(songData.getFavorites()[index],
                              songData.getFavorites());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: QueryArtworkWidget(
                              id: songData.getFavorites()[index].id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(30),
                            ),
                            title: Text(
                              songData.getFavorites()[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              songData.getFavorites()[index].artist!,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => songData
                                      .toggleIsFav(songData.getFavorites()[index]),
                                  child: Icon(
                                    songData.isFav(
                                            songData.getFavorites()[index].id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: songData.isFav(
                                            songData.getFavorites()[index].id)
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Icon(
                                  Icons.play_circle,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
          BottomPlayer(
            songData: songData,
          )
        ]
      ),
    );
  }
}
