
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'T.dart';

import 'package:krushapp/ui/pages/krush_reveal_page.dart';
class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.tag,
    this.title,
    this.relationId,
    this.token,
    this.hasRevealed,
    this.type
  });

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;
  final String title;
  final String relationId;
  final String token;
  final bool hasRevealed;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title:Text(title,),
      backgroundColor: Colors.black,
      actions: [
        type != 'ownPhoto' ? 
        Padding(padding: EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () {
            if(hasRevealed == true){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => KrushRevealPage({
                  'relationId': relationId,
                  'token': token,
                  'tag': tag,
                  'imageProvider': imageProvider
                })));  
            }else{
              T.message("Your krush is not revealed");
            }
            
            
            
          },

          child: Icon( Icons.info_outline, size: 35, color: hasRevealed? Colors.white : Colors.white.withOpacity(0.5),),
        ),
        ): Container()
        
      ],
      
      ),
      body: Container(
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
    ),
    )
     ;
  }
}