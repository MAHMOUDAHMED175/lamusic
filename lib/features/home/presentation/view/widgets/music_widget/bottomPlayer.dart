import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/song_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../view_model/provider/song_data.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({Key? key, required this.songData}) : super(key: key);
  final SongData songData;

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  var currentSongIndex = 0;

  // handle songs
  _handleSongs() {
    widget.songData.songList.asMap().forEach((key, song) {
      if (song.id == widget.songData.playingSong?.id) {
        currentSongIndex = key;

        widget.songData.player.playerStateStream.listen((state) {
          switch (state.processingState) {
            case ProcessingState.completed:
              if (widget.songData.songList.length > 1) {
                if (key < widget.songData.songList.length - 1) {
                  Timer(const Duration(seconds: 1), () {
                    widget.songData.player.play();
                  });

                  // setting playing song on provider
                  widget.songData
                      .setPlayingSong(widget.songData.songList[key + 1]);

                  widget.songData.setIsPlaying(true);
                  widget.songData.player.setAudioSource(
                    AudioSource.uri(
                      Uri.parse(widget.songData.songList[key + 1].uri!),

                    ),
                  );
                }
              }
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _handleSongs();
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);


    // CONTINUE SONG
    _continueSong() {
      setState(() {
        songData.player.play();
        songData.setIsPlaying(true);
      });
    }

    // PAUSE SONG
    _pauseSong() {
      setState(() {
        songData.player.pause();
        songData.setIsPlaying(false);
      });
    }

    Size size = MediaQuery.of(context).size;

    return songData.isPlaying
        ? Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsApp.blueColor,
                    ColorsApp.orangeColor,
                    ColorsApp.blueColor,

                  ]
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SongPlayer(
                        song: songData.playingSong!,
                        player: songData.player,
                        songs: songData.songList,
                        songData: songData,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: QueryArtworkWidget(
                      id: songData.playingSong!.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      artworkBorder: BorderRadius.circular(30),
                      nullArtworkWidget:  Icon(
                        Icons.music_note,
                        color: ColorsApp.whiteColor,
                      ),
                    ),
                    title: Text(
                      songData.playingSong!.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      songData.playingSong!.artist!,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => {
                        songData.player.playing
                            ? setState(() {
                                _pauseSong();
                              })
                            : setState(() {
                                _continueSong();
                              })
                      },
                      child: Icon(
                        songData.player.playing
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        color:  ColorsApp.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
