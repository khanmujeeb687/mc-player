import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mc_player/utils/video_util.dart';

import '../components/vlc_player_with_controls.dart';

class VideoScreen extends StatefulWidget {
  final File file;

  const VideoScreen(this.file, {Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VlcPlayerController _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  VideoData? videoData;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,
        overlays: SystemUiOverlay.values); // to hide only bottom bar
    super.initState();
    _controller = VlcPlayerController.file(
      widget.file,
    );
    _controller.addOnInitListener(() async {
      await _controller.startRendererScanning(
          rendererService: widget.file.path);
    });
    _controller.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
    VideoUtil().getInfo(widget.file.path).then((value) {
      videoData = value;
      if (videoData?.orientation == 0 || videoData?.orientation == 180) {
        AutoOrientation.landscapeAutoMode(forceSensor: true);
      } else {
        AutoOrientation.portraitAutoMode(forceSensor: true);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoData == null) return SizedBox();
    return Scaffold(
      body: VlcPlayerWithControls(
          key: _key,
          controller: _controller,
          onStopRecording: (recordPath) {},
          videoData: videoData),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    AutoOrientation.fullAutoMode();
    try {
      await _controller.stopRecording();
      await _controller.stopRendererScanning();
    } catch (e) {}
    await _controller.dispose();
  }
}
