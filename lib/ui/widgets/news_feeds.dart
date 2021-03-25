import 'dart:io';
import 'dart:math';
import 'package:krushapp/ui/pages/newspage/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:share/share.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsFeeds extends StatefulWidget {
  const NewsFeeds({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _NewsFeedstate();
  }
}

class _NewsFeedstate extends State<NewsFeeds>
    with AutomaticKeepAliveClientMixin<NewsFeeds>, TickerProviderStateMixin {
  ChatConversationsBloc conversationsBloc = ChatConversationsBloc();
  TextEditingController chatSearchController = TextEditingController();
  String searchQuery = '';
  List<String> videosthumbnail = new List();
  List<String> videoTiming = new List();
  AnimationController _animationController;
  bool sharevisibilityTag = false;
  bool commentvisibilityTag = false;
  bool imagesvisibilityTag = false;
  bool linksvisibilityTag = false;
  bool videovisibilityTag = false;
  int selected_item_index = -1;
  Function wp;
  String userId;
  String userName = '';
  int toView = 0;
  String adLink = '';
  @override
  String selected_image_path="";
  String video_time="";
  bool get wantKeepAlive => true;
  var files;

  void getFiles(bool isImages) async { //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    if(isImages){
      files = await fm.filesTree(
        //set fm.dirsTree() for directory/folder tree list
          excludedPaths: ["/storage/emulated/0/Android"],
          extensions: ["png", "jpg","jpeg"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
      );
    }else{
      files = await fm.filesTree(
        //set fm.dirsTree() for directory/folder tree list
          excludedPaths: ["/storage/emulated/0/Android"],
          extensions: [".mp4"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
      );
      videosthumbnail.clear();
      videoTiming.clear();
      videosthumbnail.add("test");
      videoTiming.add("0.00");
      for (int i = 0; i < files.length; i++) {
        getThumbnailfromvideo(files[i].path,files.length,i);
      }
    }
    setState(() {}); //update the UI
  }
   getThumbnailfromvideo(path, length,  currentvalue) async {
        String thumb = await Thumbnails.getThumbnail(
        videoFile: path,
        imageType: ThumbFormat.PNG,
        quality: 30);
        videosthumbnail.add(thumb);
        final videoInfo = FlutterVideoInfo();
        String videoFilePath = path ;
         var info = await videoInfo.getVideoInfo(videoFilePath);


     var seconds = info.duration / 1000;
     var minutes = (info.duration / 1000) / 60;

     videoTiming.add(minutes.toInt().toString()+":"+seconds.toInt().toString());
     setState(() {});
     return thumb;
  }


  @override
  void initState() {
    checkStroagePermission();
    super.initState();
  }
  Future<void> checkStroagePermission() async {
    if (await Permission.storage.request().isGranted) {
    }
  }


  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 25, left: 30, right: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: wp(5),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                      'assets/svg/send_message_icon.svg'),
                                  iconSize: 20.0,
                                  color: Colors.white,
                                  onPressed: () async {},
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.red,width: 2,),
                                ),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(left:10,right: 10),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'What is in your mind?',

                                        ),
                                      ),
                                      Stack(

                                        children: <Widget>[
                                          Visibility(
                                            visible: (selected_image_path.isNotEmpty) ? true:false,
                                            child: Container(
                                              height: 200,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: FadeInImage(
                                                  image: FileImage(
                                                    File(selected_image_path),
                                                  ),
                                                  placeholder: MemoryImage(kTransparentImage),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Visibility(
                                              visible: video_time.isNotEmpty && videovisibilityTag ? true:false,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 20,left: 10),
                                                child: Container(
                                                  height: 200,
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Container(
                                                      height: 20,
                                                      width: 40,
                                                      decoration: new BoxDecoration(
                                                          color: const Color(0x000000).withOpacity(0.5),
                                                          border: Border.all(
                                                              color: const Color(0x000000).withOpacity(0.5),
                                                              width: 0.0),
                                                          borderRadius: BorderRadius.all(Radius.circular(5))
                                                      ),
                                                      child: Center(
                                                        child: Text(video_time,
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.white),
                                                            // Set text alignment to center
                                                            textAlign: TextAlign.right),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: video_time.isNotEmpty && videovisibilityTag ? true:false,
                                            child: Positioned.fill(
                                              child: SizedBox(
                                                child: Center(
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    child: Image.asset("assets/images/video_play_icon.png",
                                                       ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                                   ],
                         )),
                    Padding(
                      padding: const EdgeInsets.only(left: 80, top: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){

                              setState(() {
                                if (imagesvisibilityTag) {
                                  imagesvisibilityTag = false;

                                } else {
                                  selected_item_index=-1;
                                  video_time="";
                                  imagesvisibilityTag = true;
                                  videovisibilityTag =false;
                                  linksvisibilityTag =false;
                                  getFiles(true);
                                }
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Image.asset(imagesvisibilityTag==true ? "assets/images/icons/camera_active.png":"assets/images/icons/camera.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.20),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                if (videovisibilityTag) {
                                  videovisibilityTag = false;

                                } else {
                                  videovisibilityTag = true;
                                  selected_item_index=-1;
                                  video_time="";
                                  imagesvisibilityTag = false;
                                  linksvisibilityTag = false;
                                  getFiles(false);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Image.asset(videovisibilityTag==true ?"assets/images/video_active.png":"assets/images/video.png",
                                    height: MediaQuery.of(context).size.height * 0.20),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                if (linksvisibilityTag) {
                                  linksvisibilityTag = false;

                                } else {
                                  linksvisibilityTag = true;
                                  selected_item_index=-1;
                                  video_time="";
                                  imagesvisibilityTag = false;
                                  videovisibilityTag =false;
                                  getFiles(true);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 25,
                                width: 25,
                                child: Image.asset(linksvisibilityTag==true ?"assets/images/news_feed_active_chain.png":"assets/images/icons/chain.png",
                                    height: MediaQuery.of(context).size.height * 0.20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: linksvisibilityTag,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,left: 80, right: 20),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(7.0),
                          child: Container(
                            height: 100,
                            child: ColoredBox(
                                color: Colors.red,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center //Center Column contents vertically,
                                      ,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center //Center Column contents horizontally,
                                      ,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 60,
                                          child: Text('Title:',
                                              style: TextStyle(
                                                  fontSize:
                                                  20.0,
                                                  color: Colors
                                                      .white),
                                              textAlign:
                                              TextAlign
                                                  .center),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 30,
                                            margin:
                                            EdgeInsets.only(
                                                left: 10,
                                                right: 10),
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontSize: 17),
                                              decoration:
                                              InputDecoration(
                                                contentPadding:
                                                EdgeInsets
                                                    .all(5),
                                                fillColor:
                                                Colors
                                                    .white,
                                                filled: true,
                                                labelText:
                                                'Crazy Link.',
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .white,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          8.0)),
                                                  borderSide:
                                                  BorderSide(
                                                      color:
                                                      Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center //Center Column contents vertically,
                                        ,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center //Center Column contents horizontally,
                                        ,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 60,
                                            child: Text('URL:',
                                                style: TextStyle(
                                                    fontSize:
                                                    20.0,
                                                    color: Colors
                                                        .white),
                                                textAlign:
                                                TextAlign
                                                    .center),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              margin:
                                              EdgeInsets.only(
                                                  left: 10,
                                                  right: 10),
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors
                                                        .black,
                                                    fontSize: 17),
                                                decoration:
                                                InputDecoration(
                                                  contentPadding:
                                                  EdgeInsets
                                                      .all(5),
                                                  fillColor:
                                                  Colors
                                                      .white,
                                                  filled: true,
                                                  labelText:
                                                  'www.crazylink.com',
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .white,
                                                        width: 2),
                                                  ),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                    borderSide:
                                                    BorderSide(
                                                        color:
                                                        Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: linksvisibilityTag,
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 5,left: 80),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                border: Border.all(
                                    color: Colors.red,
                                    width: 0.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Center(
                                child: Text('Insert',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white),
                                    // Set text alignment to center
                                    textAlign: TextAlign.right),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: imagesvisibilityTag,
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 10,right: 10),
                        child: Container(
                          height: 400,

                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),//if file/folder list is grabbed, then show here
                            itemCount: files?.length ?? 0,
                            itemBuilder: (context, index) {
                              if(index==0){
                                return Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CameraPage())),
                                        child: Container(
                                          color: Color(0xffffdfdd),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                            "assets/images/news_feed_post_photo.png"),
                                      ),
                                    ],
                                  ),
                                );

                              }else{
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // ontap of each card, set the defined int to the grid view index
                                      if(selected_item_index==index){
                                        selected_item_index=-1;
                                        selected_image_path ="";
                                      }else{
                                        selected_item_index = index;
                                        selected_image_path= files[index].path;
                                      }
                                    });
                                  },
                                  child: Container(

                                    child: Stack(

                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: FadeInImage(
                                            image: FileImage(
                                              File(files[index].path),
                                            ),
                                            placeholder: MemoryImage(kTransparentImage),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Visibility(
                                          visible: selected_item_index == index ? true : false,
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: const Color(0xffffdfdd).withOpacity(0.7),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selected_item_index == index ? true : false,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                                "assets/images/news_feed_photo_selected.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: videovisibilityTag,
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 10,right: 10),
                        child: Container(
                          height: 400,

                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),//if file/folder list is grabbed, then show here
                            itemCount: videosthumbnail.length,
                            itemBuilder: (context, index) {

                              if(index==0){
                                return Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        color: Color(0xffffdfdd),


                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                            "assets/images/video.png"),
                                      ),
                                    ],
                                  ),
                                );

                              }else{
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // ontap of each card, set the defined int to the grid view index
                                      if(selected_item_index==index){
                                        selected_item_index=-1;
                                        selected_image_path ="";
                                      }else{
                                        selected_item_index = index;
                                        selected_image_path= videosthumbnail[index];
                                        video_time= videoTiming[index];
                                      }

                                    });
                                  },
                                  child: Container(

                                    child: Stack(

                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: FadeInImage(
                                            image: FileImage(
                                              File(videosthumbnail[index]),
                                            ),
                                            placeholder: MemoryImage(kTransparentImage),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 10,left: 10),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              height: 20,
                                              width: 40,
                                              decoration: new BoxDecoration(
                                                  color: const Color(0x000000).withOpacity(0.5),
                                                  border: Border.all(
                                                      color: const Color(0x000000).withOpacity(0.5),
                                                      width: 0.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                              ),
                                              child: Center(
                                                child: Text(videoTiming[index],
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.white),
                                                    // Set text alignment to center
                                                    textAlign: TextAlign.right),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selected_item_index == index ? true : false,
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: const Color(0xffffdfdd).withOpacity(0.7),

                                          ),
                                        ),
                                        Visibility(
                                          visible: selected_item_index == index ? true : false,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                                "assets/images/news_feed_photo_selected.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 10, right: 10),
                                child: Column(
                                  mainAxisSize:MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: ColoredBox(
                                          color: Color(0xffffdfdd),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(5),
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: Image.asset(
                                                          "assets/images/green_profile.png",
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Center(
                                                        child: Text(
                                                          'Starfire',
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: Container(
                                                            height: 30,
                                                            width: 60,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: Container(
                                                                      height: 30,
                                                                      width: 70,
                                                                      child: Text(
                                                                          '10/01/2021',
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.red))),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                      height: 50,
                                                                      width: 70,
                                                                      child: Text(
                                                                          '7:03 PM ',
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.red))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(

                                      child: Container(
                                          height: 300,
                                          child: Image.asset(
                                              "assets/images/bee_icon.png", fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      height: 80,
                                      color: Color(0xfff3f4f9),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'These killer bee must be a symptom of 2020'),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (commentvisibilityTag) {
                                                          commentvisibilityTag = false;
                                                        } else {
                                                          commentvisibilityTag = true;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      child: Image.asset(
                                                        commentvisibilityTag==true ? "assets/images/icons/comment_active.png":"assets/images/icons/comment.png",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  child: Text(
                                                    '1',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  child: Image.asset(
                                                    "assets/images/icons/heart_active.png",
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  child: Text(
                                                    '2',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  child: Image.asset(
                                                    "assets/images/icons/message.png",
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {

                                                      setState(() {
                                                        if (sharevisibilityTag) {
                                                          sharevisibilityTag = false;

                                                        } else {
                                                          sharevisibilityTag = true;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      child: Image.asset(sharevisibilityTag==true ? "assets/images/icons/share_active.png":"assets/images/icons/share.png",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: sharevisibilityTag,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          child: Container(
                                            height: 120,
                                            child: ColoredBox(
                                                color: Colors.red,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center //Center Column contents vertically,
                                                        ,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center //Center Column contents horizontally,
                                                        ,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 80,
                                                            child: Text('E-mail:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 30,
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 10,
                                                                      right: 10),
                                                              child: TextField(
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 17),
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(5),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  labelText:
                                                                      'dvailmazra@gmail.com',
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                10.0)),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width: 2),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                8.0)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                              width: 80,
                                                              child: Center(
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center //Center Column contents vertically,
                                                                      ,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center //Center Column contents horizontally,
                                                                      ,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/icons/mail.png",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/icons/facebook.png",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center //Center Column contents vertically,
                                                                      ,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center //Center Column contents horizontally,
                                                                      ,
                                                                      children: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/icons/twitter.png",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/icons/instagram.png",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              )),
                                                          Expanded(
                                                            child: Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 10,
                                                                      right: 10),
                                                              child: TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  labelText:
                                                                      'Check out this amazing krushin post by downloading our app at',
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                10.0)),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width: 2),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                8.0)),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 17),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: sharevisibilityTag,
                                      child: GestureDetector(
                                        onTap: () {
                                          Share.share(
                                              'Check out this amazing krushin post by downloading our app at',
                                              subject: 'Look what I made!');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              decoration: new BoxDecoration(
                                                color: Colors.red,
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 0.0),
                                              ),
                                              child: Center(
                                                child: Text('SEND',
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.white),
                                                    // Set text alignment to center
                                                    textAlign: TextAlign.right),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: commentvisibilityTag,
                                      child: Container(
                                        height: 250,
                                        child: Expanded(
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Container(
                                                color: (index % 2 == 0) ? Colors.white : Color(0xfff3f4f9),
                                                child:  Padding(
                                                  padding: const EdgeInsets.only(top:10),
                                                  child: Container(
                                                    height: 110,

                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 10),
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: Image.asset(
                                                              "assets/images/green_profile.png",
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    top: 5, left: 10),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    'NBA Fan',  style: TextStyle(
                                                                      color: Colors.red),),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    top: 1, left: 10),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                      'Those look super agressive! Hopefull i never run into these but if i do, I will be ready'),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                child: Container(
                                                                  height: 40,
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 10),
                                                                        child: Container(
                                                                          height: 25,
                                                                          width: 25,
                                                                          child: Image.asset(
                                                                            "assets/images/icons/comment.png",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 20,
                                                                        child: Text(
                                                                          '1',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 25,
                                                                        width: 25,
                                                                        child: Image.asset(
                                                                          "assets/images/icons/heart_active.png",
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 20,
                                                                        child: Text(
                                                                          '2',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 25,
                                                                        width: 25,
                                                                        child: Image.asset(
                                                                          "assets/images/icons/message.png",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 25,
                                                                        width: 25,
                                                                        child: Image.asset(
                                                                          "assets/images/icons/share.png",
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
