import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import '../../../repositories/get_gift_list_repository.dart';
import '../../../repositories/gift_repository.dart';
import '../../dialogs/confirm_send_gift_dialog.dart';
import '../../../utils/T.dart';
import '../../../utils/progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'change_language_page.dart';
class GiftListingPage extends StatefulWidget {
  final int relationId;
  const GiftListingPage( this.relationId);
  @override
  State<StatefulWidget> createState() {
    return GiftListingPageState();
  }
}
class GiftListingPageState extends State<GiftListingPage> {

List selectedIndexes = [];
 GiftRepository giftRepository = GiftRepository();

 
sendGift() async {
  Navigator.of(context).pop();
  ProgressBar.client.showProgressBar(context);
  dynamic result = await giftRepository.sendGifts(widget.relationId, selectedIndexes);
   ProgressBar.client.dismissProgressBar();
  if(result == true){
    T.message("Gift is sent for approval.");
  context.bloc<GiftSentBloc>().add(GiftSentListChanged());

    Navigator.of(context).pop();
  }else{
    T.message(result);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                    children: [
                      
                      
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Select Gifts",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .apply(color: Colors.white),
                          )
                        ],
                      ))
                    ],
                  ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        

                        },
                        child: Container(
                        width: 32.0,
                        height: 32.0,

                        decoration: new BoxDecoration(
                          color:  Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.redAccent,
                            size: 21,
                          ),
                        ),
                      ),
                      ),
                    ],
                  ) ),
            ),
          )),

    body: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    
    child: GridView.builder(
  itemCount: GetGiftListRepository.gifts_list.length,
  
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2),
  itemBuilder: (BuildContext context, int index) {
    return new Card(
      shape: RoundedRectangleBorder(
    // side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
      child:Padding(padding: 
        EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            Flexible(child: 
            Stack(
                                            children: [
                                             CachedNetworkImage(imageUrl: GetGiftListRepository.gifts_list[index].imageSmall,
                                                                    imageBuilder: (context, imageProvider) => Container(
 
    height: 200,                                                                    
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider, fit: BoxFit.cover),
    ),

    
  )),
  selectedIndexes.contains(GetGiftListRepository.gifts_list[index].id)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green)
                                                        ],
                                                      ))
                                                  : Container(), 
  
  ])
            ),

            Text(GetGiftListRepository.gifts_list[index].name),
Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text("\$"+ GetGiftListRepository.gifts_list[index].price),

          InkWell(
            onTap: (){
           
              if(selectedIndexes.contains(GetGiftListRepository.gifts_list[index].id)){
                setState(() {
                  selectedIndexes.remove(GetGiftListRepository.gifts_list[index].id);
                });
              }else{
                 setState(() {
                  selectedIndexes.add(GetGiftListRepository.gifts_list[index].id);
                });
              }

            },
          child:            Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            color: Colors.red),
                                                                        
                                                                        padding:
                                                                            EdgeInsets.all(5.0),
                                                                      
                                                                        child:
                                                                            Icon(selectedIndexes.contains(GetGiftListRepository.gifts_list[index].id) ? Icons.remove : Icons.add, color: Colors.white,)
                                                                      ),

          )

        ],)
          ],
        ) )
    );
  },
),
    ) ,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: 200,
          child: FloatingActionButton.extended(
            hoverElevation: 8,
            elevation: 0,
            label: Text(
              'Send Gifts',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            onPressed: () async {

              if(selectedIndexes.isEmpty){
                T.message("Please select a gift.");

              }else{
                showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) =>
                ConfirmSendGiftDialog(onConfirmed: sendGift,)));
                }

            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
    );
  }
}
