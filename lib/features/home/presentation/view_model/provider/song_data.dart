import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/features/home/presentation/view/favourities.dart';
import 'package:lamusic/features/home/presentation/view/music.dart';
import 'package:lamusic/features/home/presentation/view/video.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SongData with ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  List<AlbumModel>? dataOfAlbums;

  void listOfAlbums() {
    audioQuery
        .queryAlbums(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      sortType: null,
      ignoreCase: true,
    )
        .then((value) {
      dataOfAlbums = value;
    });
  }

  List<SongModel> songsSearch = [];

  void searchInSongs({required String word}) {
    audioQuery
        .querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      sortType: null,
      ignoreCase: true,
    )
        .then((value) {
      songsSearch = value
          .where((element) =>
              element.title.toLowerCase().contains(word.toLowerCase()))
          .toList();    notifyListeners();

    }).catchError((error) {
      print(error.toString());
    });
  }

  SongModel? playingSong;
  bool isPlaying = false;
  bool isPaused = false;

  setPlayingSong(SongModel song) {
    playingSong = song;
    isPlaying = true;
    isPaused = false;
    notifyListeners();
  }

  setIsPlaying(bool status) {
    isPlaying = status;
    isPaused = !status;
    notifyListeners();
  }

  bool isSongInPlaylist(
    int songId,
    int playlistId,
  ) {
    bool status = false;
    return status;
  }

  ///
  final List<SongModel> _favoritesSongs = [];

  toggleIsFav(SongModel song) {
    switch (isFav(song.id)) {
      case true:
        _favoritesSongs.removeWhere(
          (songs) => songs.id == song.id,
        );
        break;
      case false:
        _favoritesSongs.add(song);
        break;
    }
    notifyListeners();
  }

  bool isFav(int id) {
    return _favoritesSongs.any(
      (song) => song.id == id,
    );
  }

  getFavorites() {
    return [..._favoritesSongs];
  }

  ///
  ///
  ///
  ///
  ///

  List<SongModel> songList = [];
  var currentSongIndex = 0;

  List<String> videoFormatExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.wmv',
    '.flv',
    '.mov',
    '.webm',
    '.mpg',
    '.mpeg',
    '.3gp',
    '.m4v',
    '.ogv',
    '.divx',
    '.vob',
    '.rm',
    '.rmvb',
    '.swf',
    '.asf',
    '.mpg2',
    '.mpg4',
    '.m2v',
    '.mpeg2',
    '.mpeg4',
    '.h264',
    '.h265',
    '.ts',
    '.mts',
    '.m2ts',
    '.mxf',
    '.qt',
    '.f4v',
    '.amv',
    '.drc',
    '.gvi',
    '.k3g',
    '.m2p',
    '.mp2',
    '.mpe',
    '.m4p',
    '.mpg1',
    '.ogm',
    '.ogx',
    '.srt',
    '.viv',
    '.yuv'
  ];
  late List<File> videoFiles;
  late Directory externalDir;

  Future getStoragePermission() async {
    PermissionStatus storagepermission = await Permission.storage.request();
    if (storagepermission.isGranted) {
      debugPrint("Permission Granted");
      notifyListeners();
    } else {
      openAppSettings();
    }
  }

  Future<List<File>> GetDir() async {
    videoFiles = [];

    externalDir = (await getExternalStorageDirectory())!;
    List<FileSystemEntity> directories =
        externalDir.parent.parent.parent.parent.listSync();
    print(directories.toString());
    FileSystemEntity i;
    while (true) {
      if (directories.isEmpty) {
        notifyListeners();
        print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
        break;
      } else {
        i = directories[directories.length - 1];
        if (i.statSync().type == FileSystemEntityType.file) {
          for (var extension in videoFormatExtensions) {
            if (".${i.path.split(".").last}" == extension) {
              videoFiles.add(File(i.path));
              notifyListeners();
              break;
            }
          }
        } else if (i.statSync().type == FileSystemEntityType.directory) {
          if (i.path.split("/").last == "obb" ||
              i.path.split("/").last.startsWith(".") ||
              i.path.split("/").last == "data") {
            notifyListeners();
          } else if (Directory(i.path).listSync().isNotEmpty) {
            directories.addAll(
              Directory(i.path).listSync(),
            );
            print(directories.toString());
            notifyListeners();
          }
        }
      }
      directories.remove(i);
      notifyListeners();
    }
    print(videoFiles.toString());

    return videoFiles;
  }

  setCurrentSongIndex(songIndex) {
    currentSongIndex = songIndex;
    notifyListeners();
  }

  setSongs(List<SongModel> songs) {
    songList = songs;
    notifyListeners();
  }

  int currentIndex = 0;

  List<Widget> screen = [
    const LaMusic(),
    const HomePage(),
    const FavoritesScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
