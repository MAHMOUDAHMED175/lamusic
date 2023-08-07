import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Functions/video_fetch.dart';
import '../widget/video_list.dart';

VideoFetch videoFetch = VideoFetch();

class Vid extends StatefulWidget {
  final String title;

  const Vid({super.key, this.title = "Video list"});

  @override
  State<Vid> createState() => _VidState();
}

class _VidState extends State<Vid> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    videoFetch.getStoragePermission().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: videoFetch.GetDir(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return VideoList(videoList: snapshot.data);
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
