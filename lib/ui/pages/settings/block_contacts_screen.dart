
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/blocked_contacts.dart';
import 'package:krushapp/model/receivedModel.dart';
import 'package:krushapp/repositories/account_repository.dart';
import 'package:krushapp/repositories/block_repository.dart';
import 'package:krushapp/ui/dialogs/add_block_contact.dart';
import 'package:krushapp/utils/T.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../../model/contact_model.dart';
import '../../../utils/shapes.dart';
import 'package:permission_handler/permission_handler.dart';

import 'black_contacts_page.dart';

class BlockContactsScreen extends StatefulWidget {
  @override
  _BlockContactsScreenState createState() =>
      _BlockContactsScreenState();
}

class _BlockContactsScreenState extends State<BlockContactsScreen> {
  List<ContactModel> blockedNumbers_original = [];
List<ContactModel> blockedNumbers_new = [];
BlockRepository blockRepository = BlockRepository();


getBlockedContacts() async {
    // ProgressBar.client.showProgressBar(context);
  
  BlockedContacts blockedContacts =  await ApiClient.apiClient.getBlockedContacts();

  for (ReceivedContactModel receivedContactModel in blockedContacts.data.receivedContacts){
    blockedNumbers_original.add(ContactModel( name: receivedContactModel.contactName, phone: receivedContactModel.contactPhone));
  }
    
  // ProgressBar.client.dismissProgressBar();
    setState((){
  blockedNumbers_new = List.from(blockedNumbers_original);
  });
}
  @override
  void initState() {
    // TODO: implement initState
    
getBlockedContacts();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // here the desired height
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFfe4a49),
                    Color(0xFFfe4a49),
                    Color(0xFFff6060),
                    Color(0xFFff6060),
                  ]),
            ),
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        

                        },
                        child: Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      ),
                      
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Block Numbers",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .apply(color: Colors.white),
                          )
                        ],
                      ))
                    ],
                  )),
            ),
          )),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.4, 0.7, 0.9],
          colors: [
            Color(0xFFff6060),
            Color(0xFFff6060),
            Color(0xFFfe4a49),
            Color(0xFFfe4a49),
          ],
        )),
        child: Card(
          shape: cardShapeFromTop(20),
          color: Theme.of(context).backgroundColor,
          elevation: 0,
          child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 0.0),
                      child: SingleChildScrollView(
  child:   Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                       
                        ListTile(
                            title: Text(
                              'Select from contacts',
                              style: TextStyle(fontSize: 20.0),
                            ),
                       
                            leading: Icon(Icons.contacts, color: Colors.black,),
                            trailing: Icon(Icons.arrow_forward_ios),
                   onTap: () =>    selectContacts(),
                          ),
   SizedBox(height: 20),

    ListView.builder(
  itemCount: blockedNumbers_new.length,
  shrinkWrap: true,
  itemBuilder: (context, i) {
   return Container(
    //  height: 100,
      margin: EdgeInsets.all(5),
      child:   Row(
                                        mainAxisSize: MainAxisSize.min,
                                        
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                   Text(
                                                    blockedNumbers_new[i].name ?? '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                       blockedNumbers_new[i].phone,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                        .accentColor,
                                                        fontSize: 19),
                                                  ),
                                                 
                                                
                                                ]),

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                
                                                // color: Color(0xffFF5252),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            // height: 50,
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          InkWell(
                                            onTap: () {
                                              removeContact(i);
                                            },
                                            child: Container(
                                         
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                               
                                                  Icon(Icons.cancel, color: Colors.white,),
                                                

                                                
                                                ]),

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Color(0xffFF5252),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            // height: 50,
                                          ),
                                          )
                                          

                                          

                                         
                                        ],
                                      ),
    );
  
   },
),
      SizedBox(height: 50),
                           
                         
                      
                        ],
                      ),)
                    ), ),
      ), 
       floatingActionButton: Column(
         mainAxisSize: MainAxisSize.min,

         children: [
FloatingActionButton(
  heroTag: "btn1",
      elevation: 0.0,
      child: new Icon(Icons.add),
      backgroundColor:  Colors.redAccent,
      onPressed: (){
        _showContactAlert();
      }
    ),

    SizedBox(height: 10),
    FloatingActionButton(
      heroTag: "btn2",
      elevation: 0.0,
      child: new Icon(Icons.check),
      backgroundColor:  Colors.redAccent,
      onPressed: () async {
    ProgressBar.client.showProgressBar(context);
    var result = await blockRepository.sendBlockList(blockedNumbers_original, blockedNumbers_new);
if(result == true){
  T.message("List updated successfully.");
}else{
    T.message(result.toString());
}

  ProgressBar.client.dismissProgressBar();
      }
    )
       ],)  
    );
  }

    Future selectContacts() async {
    if (await Permission.contacts.request().isGranted) {
      var contact = await Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => BlockContactsPage(blockedNumbers_new, addContact, removeContact)));
      if (contact != null) {
        setState(() {
          blockedNumbers_new = contact;
        });
      }
    }
  }


void _showContactAlert() {
showDialog(context: context, child: AddBlockContact(onConfirmed: addContact));
}

addContact(String name, String number){
  List value = blockedNumbers_new.where((element) {
       return element.phone == number;
    }).toList();

 if(value == null || value.length == 0){
   setState(() {
      blockedNumbers_new.insert(0,ContactModel(name: name, phone: number));
   });
 }
}

removeContact(int index,{number}){
 if(index == null){
   int index_new;
     List value = blockedNumbers_new.where((element) {
       bool value = element.phone == number;
       if(value){
         index_new = blockedNumbers_new.indexOf(element);
       }
       return value;
    }).toList();
  
  if(index_new != null){
    setState(() {
       blockedNumbers_new.removeAt(index_new);
    });
     
  }
 }else{
   setState(() {
      blockedNumbers_new.removeAt(index);
   });
 }


}
  
}



