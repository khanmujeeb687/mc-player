import 'package:flutter/material.dart';
import 'package:mc_player/components/video_grid.dart';
import 'package:photo_manager/photo_manager.dart';

import '../components/video_grid_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: VideoGrid()
    );
  }
}
