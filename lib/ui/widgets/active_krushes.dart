import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../model/chat_conversation_model.dart';
import '../../model/user_model.dart';
import '../pages/chat_screen.dart';
import '../../model/message_model.dart';
import '../../model/recieve_request.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ActiveKrushes extends StatefulWidget {

  @override
  _ActiveKrushesState createState() => _ActiveKrushesState();
}

class _ActiveKrushesState extends State<ActiveKrushes> with AutomaticKeepAliveClientMixin<ActiveKrushes> {
  Function wp;
  String token;
  int coins_left;
  int free_requests;
  RecieveRequest recieveRequest;
  bool _loading = false;

 @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    context.bloc<ChatConversationsBloc>().add(GetUserConversations());
    super.initState();
  }


@override
Widget build(BuildContext context) {
      wp = Screen(MediaQuery.of(context).size).wp;
  return BlocBuilder(
    cubit: context.bloc<ChatConversationsBloc>(),
    builder: (BuildContext context, ChatConversationsState state) {

        return ListView(
          shrinkWrap: true,
              children: <Widget>[
               Container(
               
                child: 

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children:[
Text(
                  'My Krushes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: FloatingActionButton.extended(
            hoverElevation: 8,
            elevation: 0,
            icon: Icon(Icons.add),
            label: Text(
              'Add Krush',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            onPressed: () async {
              // await  krushRequestBloc.add(ListChanged());
              Navigator.pushNamed(context, '/AddKrushPage');
            },
            backgroundColor: Theme.of(context).primaryColor,
            heroTag: "btn1",
          ),
                )
                      
                   ]   
                    ) 
              ),

                            SizedBox(
                height: 15,
              ),

              Container(
                child: Text(
                  'Current  krushes',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

                         SizedBox(
                height: 10,
              ),

                    state is ChatConversationsLoading ? 
       Container(
                  height: wp(30), child:  Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        )) :
    state is ChatConversationsError ? Text("failure") :
    state is ChatConversationsLoaded?
 ValueListenableBuilder(
                          builder: (context, box, child) {
                            box = box as Box<ChatsConversationModel>;
                          

                            if ((box as Box<ChatsConversationModel>)
                                .values
                                .isEmpty) {
                          return  Container(
       
      height: wp(30),
      child: Center(child: Text(
      "No active krushes!"
    ),))  ;                   }
                        return Container(
                          height: wp(29),
                          child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                       scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: box.length,
                                      itemBuilder: (context, index) {
                                        

                                        return buildListItem(box.getAt(index), index);
                                      }),
                        );
                        
                          },
                          valueListenable: Hive.box<ChatsConversationModel>(
                                  'conversationsBox')
                              .listenable(),
                        ): Container(),
 
    
                    
                ]
              
            );
 
}
      
    
  );
}

Widget buildListItem(conversation, index){
return InkWell(
  onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              user: User(
                                id: conversation.id,
                                displayName: conversation.chatName,
                              ),
                              requestData: conversation,
                            )));
                    context.bloc<ChatConversationsBloc>().add(GetUserConversations());

  },

  child:  Padding(
                                  padding:  EdgeInsets.all(wp(2)),
                                  child: Stack(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          CircleAvatar(
                                              radius: 28,               
                                            child:
                                              CachedNetworkImage(imageUrl: conversation.avatar,
                                                                    imageBuilder: (context, imageProvider) => Container(
    width: 120.0,
    height: 120.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: imageProvider, fit: BoxFit.cover),
    ),
  ))
                                                                      // AssetImage(
                                                                      //     aviators[index]
                                                                      //         .imageUrl),
                                                                ),
                                    
                                      
                                          SizedBox(height: wp(2.5)),
                                          Text(
                                            conversation.chatName,
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
);
}

  String getAvatarImage(String senderAvatar) {
    String imagUrl = "";


    int j = aviators.indexWhere((note) => note.name.contains(senderAvatar));
    if (j < 0 || j >= aviators.length) {
      j = 0;
    }
    imagUrl = aviators[j].imageUrl;
    return imagUrl;
  }
}
