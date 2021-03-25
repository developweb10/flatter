
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
class ZoomImage extends StatelessWidget {
  const ZoomImage({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.tag,
  });

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: PhotoViewHeroAttributes(tag: tag),
      ),
    )
     ;
  }
}