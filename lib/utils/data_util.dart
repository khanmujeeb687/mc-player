import 'dart:io';

class DataUtil{
  static String getFileName(File file){
    List<String> _data = file.path.split("/");
    return _data[_data.length-1];
  }

  static formatDuration(Duration duration){
    return"${duration.inHours == 0 ? '': duration.inHours.toString()+":"}${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
  }
}