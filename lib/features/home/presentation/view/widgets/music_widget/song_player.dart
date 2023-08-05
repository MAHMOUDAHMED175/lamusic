import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:just_audio_background/just_audio_background.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../core/widgets/kBackground.dart';
import '../../../../../../core/widgets/seekbar.dart';
import '../../../../data/models/provider_data.dart';
import '../../../view_model/provider/song_data.dart';
import '../../../../../../core/widgets/kText.dart';

class SongPlayer extends StatefulWidget {
  SongPlayer({
    Key? key,
    required this.song,
    required this.player,
    required this.songs,
    required this.songData,
  }) : super(key: key);
  SongModel song;
  final AudioPlayer player;
  final List songs;
  final SongData songData;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> with WidgetsBindingObserver {
  final OnAudioQuery audioQuery = OnAudioQuery();

  // this will be holding the current index of the music list array
  var currentSongIndex = 0;

  bool isRepeatOne = false;
  bool isShuffle = false;

  // handle songs
  _handleSongs() {
    widget.songs.asMap().forEach((key, song) {
      if (song.id == widget.songData.playingSong?.id) {
        currentSongIndex = key;

        widget.player.playerStateStream.listen((state) {
          switch (state.processingState) {
            case ProcessingState.completed:
              if (!isRepeatOne) {
                if (widget.songData.songList.length > 1) {
                  if (currentSongIndex < widget.songs.length - 1) {
                    setState(() {
                      currentSongIndex += 1;
                    });
                  }

                  // set current playing song
                  Timer(const Duration(seconds: 3), () {
                    setState(() {
                      widget.song = widget.songData.playingSong!;
                    });
                  });

                  //setting playingSong on provider
                  widget.songData
                      .setPlayingSong(widget.songData.songList[key + 1]);

                  widget.songData.setIsPlaying(true); // setting playing to true

                  // setting audio-source
                  widget.songData.player.setAudioSource(
                    AudioSource.uri(
                      Uri.parse(widget.songData.songList[key + 1].uri!),
                    ),
                  );

                  // playing song after a song
                  Timer(const Duration(seconds: 1), () {
                    widget.songData.player.play();
                  });
                } else {
                  // pausing a music if it's the only on the list when completed
                  widget.songData.player.pause();
                  widget.songData.setIsPlaying(false);
                }
              } else {
                // repeating a music without incrementing the counter if isRepeatOne is active
                widget.player.play();
              }
          }
        });
      }
    });
  }

  // toggling isRepeat
  _toggleIsRepeat() {
    setState(() {
      isRepeatOne = !isRepeatOne;
    });

    if (isRepeatOne) {
      setState(() {
        widget.player.setLoopMode(LoopMode.one);
        widget.player.loopMode;
      });
    } else {
      setState(() {
        widget.player.setLoopMode(LoopMode.all);
        widget.player.loopMode;
      });
    }
  }

  //toggling shuffle
  _toggleIsShuffle() {
    setState(() {
      isShuffle = !isShuffle;
      widget.player.setShuffleModeEnabled(isShuffle);
    });
    if (isShuffle) {
      widget.player.shuffle();
    }
  }

  // PLAY SONG
  _playSong() {
    widget.player.play();
    widget.songData.setIsPlaying(true);
  }

  // PAUSE SONG
  _pauseSong() {
    widget.player.pause();
    widget.songData.setIsPlaying(false);
  }

  // To next song
  skipNext() {
    if (currentSongIndex != widget.songs.length - 1) {
      currentSongIndex += 1;
    } else {
      currentSongIndex = 0;
    }

    setState(() {
      widget.song = widget.songs[currentSongIndex];
    });

    widget.songData.setPlayingSong(widget.songs[currentSongIndex]);
    widget.player.play();
    widget.songData.setCurrentSongIndex(currentSongIndex);
    widget.songData.setIsPlaying(true);
    widget.songData.player.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.songs[currentSongIndex].uri),
      ),
    );
  }

  // to previous song
  skipPrevious() {
    if (currentSongIndex != 0) {
      currentSongIndex -= 1;
    }

    setState(() {
      widget.song = widget.songs[currentSongIndex];
    });

    widget.songData.setPlayingSong(widget.songs[currentSongIndex]);
    widget.player.play();
    widget.songData.setCurrentSongIndex(currentSongIndex);
    widget.songData.setIsPlaying(true);
    widget.songData.player.setAudioSource(
      AudioSource.uri(
        Uri.parse(widget.songs[currentSongIndex].uri),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.player.play();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _handleSongs();
    super.didChangeDependencies();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        widget.player.positionStream,
        widget.player.bufferedPositionStream,
        widget.player.durationStream,
            (position, bufferedPosition, duration) =>
            PositionData(
              position,
              bufferedPosition,
              duration ?? Duration.zero,
            ),
      );

  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ColorsApp.orangeColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 45.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) =>
                          GestureDetector(
                            onTap: () =>
                            {
                              //setting song current index on provider
                              widget.songData.setCurrentSongIndex(
                                  currentSongIndex),
                              Navigator.of(context).pop(),
                            },
                            child: Container(
                              height: 25,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorsApp.orangeColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: ColorsApp.whiteColor,
                                ),
                              ),
                            ),
                          ),
                    ),
                    // const Spacer(),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      // color: ColorsApp.blackColor,
                      itemBuilder: (BuildContext context) =>
                      [
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              songData.toggleIsFav(widget.song);
                            });
                          },
                          child: Text(
                            songData.isFav(widget.song.id)
                                ? 'Remove from favorites'
                                : 'Add to favorites',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Set as ringtone',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Delete Song',
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => {},
                          child: const Text(
                            'Share',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                const KText(
                  firstText: 'Pla',
                  secondText: 'yer',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.2,
                  width: double.infinity,
                  child: Hero(
                    tag: widget.song.id,
                    transitionOnUserGestures: true,
                    child: QueryArtworkWidget(
                      id: widget.song.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Center(
                        child: Icon(Icons.music_note, size: 80, color: ColorsApp
                            .blueColor,),
                      ),
                      artworkBorder: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width / 1.5,
                      child: Text(
                        widget.song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorsApp.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() {
                            songData.toggleIsFav(widget.song);
                          }),
                      child: Icon(
                        songData.isFav(widget.song.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: songData.isFav(widget.song.id)
                            ? Colors.red
                            : ColorsApp.orangeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.song.artist == '<unknown>'
                      ? 'Unknown Artist'
                      : widget.song.artist!,
                  style: TextStyle(
                    color: ColorsApp.blueColor,
                  ),
                ),
                const SizedBox(height: 40),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition: positionData?.bufferedPosition ??
                          Duration.zero,
                      onChangeEnd: widget.player.seek,
                      func: skipNext,
                    );
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleIsRepeat(),
                      child: Icon(
                        isRepeatOne ? Icons.repeat_one_outlined : Icons.repeat,
                        color: isRepeatOne ? ColorsApp.blueColor : ColorsApp
                            .orangeColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        skipPrevious();
                      },
                      child: Icon(
                        Icons.skip_previous_outlined,
                        color: ColorsApp.orangeColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                      {
                        widget.player.playing
                            ? setState(() {
                          _pauseSong();
                        })
                            : setState(() {
                          _playSong();
                        })
                      },
                      child: Icon(
                        widget.player.playing
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outlined,
                        color: widget.player.playing
                            ? ColorsApp.blueColor
                            : ColorsApp.orangeColor,
                        size: 60,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        skipNext();
                      },
                      child: Icon(
                        Icons.skip_next_outlined,
                        color: ColorsApp.orangeColor,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _toggleIsShuffle(),
                      child: Icon(
                        Icons.shuffle_outlined,
                        color: isShuffle ? ColorsApp.blueColor : ColorsApp
                            .orangeColor,
                        size: 30,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
