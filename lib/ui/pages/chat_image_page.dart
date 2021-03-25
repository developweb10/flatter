import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class ChatImageScreen extends StatefulWidget {
  final String imageURL;
  final int id;
  ChatImageScreen(this.id, this.imageURL);

  @override
  _ChatImageScreenState createState() => _ChatImageScreenState();
}

class _ChatImageScreenState extends State<ChatImageScreen> {
  bool downloading = false;
  double imageProgress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          downloading
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(
                        value: imageProgress,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () async {
                    var status = Permission.storage.status;
                    if(Platform.isAndroid && !(await status.isGranted)){
                      return;
                    }
                    Directory dir = await getTemporaryDirectory();
                    String folderPath = path.join(dir.path, 'krushin_images');
                    Directory folderDir;
                    if (!(await Directory(folderPath).exists())) {
                      folderDir =
                          await Directory(folderPath).create(recursive: true);
                    }
                    folderDir = Directory(folderPath);
                    if (folderDir.existsSync()) {
                      DateTime dateTime = DateTime.now();
                      String imageName =
                          'Krushin_Images_${dateTime.millisecondsSinceEpoch}';
                      String fileName = path.join(folderDir.path,
                          imageName + path.extension(widget.imageURL));
                      setState(() {
                        downloading = true;
                      });
                      Dio dio = Dio();
                      await dio.download(
                        widget.imageURL,
                        fileName,
                        onReceiveProgress: (count, total) {
                          if (mounted)
                            setState(() {
                              imageProgress = count / total;
                            });
                        },
                      );
                      await GallerySaver.saveImage(fileName);
                      Fluttertoast.showToast(msg: 'Image Downloaded');
                      await File(fileName).delete();
                      setState(() {
                        imageProgress = null;
                        downloading = false;
                      });
                    }
                  })
        ],
      ),
      body: Center(
        child: Hero(
            tag: widget.id,
            child: CachedNetworkImage(imageUrl: widget.imageURL)),
      ),
    );
  }
}
