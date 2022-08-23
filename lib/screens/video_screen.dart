import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = VlcPlayerController.file(
      widget.file,
    );
    _controller.addOnInitListener(() async {
      await _controller.startRendererScanning();
    });
    _controller.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 400,
        child: VlcPlayerWithControls(
          key: _key,
          controller: _controller,
          onStopRecording: (recordPath) {},
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller.stopRecording();
    await _controller.stopRendererScanning();
    await _controller.dispose();
  }
}
