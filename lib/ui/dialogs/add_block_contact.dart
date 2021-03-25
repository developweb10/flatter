import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/model/aviator_model.dart';
import 'package:krushapp/model/message_model.dart';
import 'package:krushapp/utils/T.dart';

class AddBlockContact extends StatefulWidget {
 
   final Function onConfirmed;
  AddBlockContact({Key key,this.onConfirmed}) : super(key: key);


  @override
  _AddBlockContactState createState() => _AddBlockContactState();
}


class _AddBlockContactState extends State<AddBlockContact> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
      ),      
      elevation: 0.0,
      backgroundColor:   Color(0xFFff6060),
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {

  return Container(
// height:MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
  padding: EdgeInsets.only(
    top: 16,
    bottom: 16,
    left: 16,
    right: 16,
  ),
  margin: EdgeInsets.only(top: 0),
  decoration: new BoxDecoration(
    color:  Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min, // To make the card compact
    children: <Widget>[
      // Text(
      //   "Chat Settings",
      //   style: TextStyle(
      //     fontSize: 24.0,
      //     color: Colors.white,
      //     fontWeight: FontWeight.w700,
      //   ),
      // ),
      SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2),
                    child: TextField(
                      
                      style: TextStyle(color: Colors.redAccent),
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                          hintText: "Name(optional)",
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18)
                          ),
                            
                    ),
                  ),
      SizedBox(height: 16.0),
             Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(2),
                    child: TextField(
                      style: TextStyle(color: Colors.redAccent),
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18)
//                  prefixIcon: Icon(Icons.person),
                          ),
                    ),
                  ),
                   SizedBox(height: 16.0),
      Align(alignment: Alignment.bottomRight,
      child:      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
        alignment: Alignment.bottomRight,
        child: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel",style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          // fontWeight: FontWeight.w700,
        ),
        ),
        )
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: FlatButton(
          onPressed: (){
            if(phonecontroller.text.isEmpty){
              T.message("Please fill phone number.");
            }else{
widget.onConfirmed(nameController.text.isEmpty ? "" : nameController.text, phonecontroller.text);
Navigator.of(context).pop();
            }
            
          } ,
          child: Text("Done",style: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        ),
        )
      ),
      ],) ,)


    ]
      
  ),
);
}
}

