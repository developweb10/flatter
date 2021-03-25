import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/shapes.dart';

class GiftReturnPolicy extends StatefulWidget {
  @override
  _GiftReturnPolicyState createState() => _GiftReturnPolicyState();
}

class _GiftReturnPolicyState extends State<GiftReturnPolicy> {
  List<Panel> panels = [
    Panel(
        'What shipping methods do you use?',
        'All orders are shipped via UPS, Fed Ex or USPS. We ship Monday through Friday, major holidays excluded.',
        false),
    Panel(
        'How quickly can you ship?',
        'Nearly all orders placed by 3 PM EST, Monday through Friday, will ship the same day (other than Labor Day and other official bank holidays).',
        false),
    Panel(
        "When will my krush's gift arrive?",
        "While we have control over when we ship it out, we trust our carriers to get it to its final destination, so we can't guarantee a delivery date - but we'll give you a tracking number so you can keep a close eye on it!",
        false),
    Panel(
        'How do you ship perishable items?',
        "During the summer months (usually from June until October, depending on the weather), we will only ship Fruit and Chocolate baskets Monday through Thursday so that the order doesn't end up stuck in a FedEx terminal over the weekend. Melted chocolate is delicious but your krush probably don't want it to arrive that way.During the summer months (usually from June until October, depending on the weather), we will only ship Fruit and Chocolate baskets Monday through Thursday so that the order doesn't end up stuck in a FedEx terminal over the weekend. Melted chocolate is delicious but your krush probably don't want it to arrive that way.",
        false),
    Panel(
        'What terms apply to Free Shipping?',
        "We occasionally offer free shipping as a promotion. Subscribe to our mailing list if you'd like to receive coupons or other special offers!",
        false),
    Panel(
        'Do you ship internationally?',
        'Oui! International orders ship via USPS and time in transit will be a function of the destination. Canada: quick! Djibouti: not so much. There are also certain countries we cannot serve, and shipping options will not appear if you attempt to ship there.',
        false),
    Panel(
        'Can I ship to a hospital or hotel?',
        "Absolutely, but we can't guarantee that the order will arrive prior to the patient or guest checking out, so we'd recommend you contact the facility to ensure they're on the lookout and can get it to its intended recipient.",
        false),
    Panel(
        'Can I ship to a PO Box?',
        'Unfortunately, no - FedEx only ships to addresses.',
        false),
    Panel(
        "What's your return policy?",
        'Simple: if your krush does not accept your gift then your money will be returned to your card. but if they accept your gift, then there is no return of the gift or money at that point.',
        false)        
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            Icons.arrow_back_ios,
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
                            "Gift Return Policy",
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
      body: SafeArea(
        bottom: true,
        child: Container(
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
          child:  Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            children: <Widget>[
              
              ...panels
                  .map((panel) => ExpansionTile(
                          title: Text(
                            panel.title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                          ),
                          children: [
                            Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                   color: Color(0xffFAF1E2),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
                                ),
                               
                                child: Text(panel.content,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16)))
                          ]))
                  .toList(),
            ],
          ),
        ),)
        ) 
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}
