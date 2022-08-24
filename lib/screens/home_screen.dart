import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:mc_player/components/video_grid.dart';
import 'package:mc_player/utils/video_util.dart';
import 'package:mc_player/values/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AssetEntity> videos = [];
  int page = 0;
  bool loading = false;

  @override
  void initState() {
    AutoOrientation.portraitUpMode();
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.all(10),
            child: const CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage('assets/images/music-note.png'),
            ),
          ),
          title: const Text("mc player"),
          backgroundColor: kDarkGrey,
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 20),
            child: VideoGrid(
              videos,
              onEndReached: onEndReached,
            )));
  }

  void fetch() async {
    List<AssetEntity> _videos = await VideoUtil.getPagedVideos(page);
    if (_videos.isNotEmpty) {
      setState(() {
        videos.addAll(_videos);
        page++;
      });
    }
  }

  void onEndReached() async {
    if (!loading) {
      loading = true;
      fetch();
      loading = false;
    }
  }
}
