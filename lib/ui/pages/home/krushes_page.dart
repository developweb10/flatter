import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import '../receive_request_page.dart';
import '../../widgets/active_krushes.dart';
import '../sent_requests_page.dart';

class KrushesPage extends StatefulWidget {

  @override
  _KrushesPageState createState() => _KrushesPageState();
}

class _KrushesPageState extends State<KrushesPage>
    with TickerProviderStateMixin {
  TabController _tabController;
    int _tabIndex = 0;

      _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

   
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0), // here the desired height
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFfe4a49), Color(0xFFfff6060)
                      // Color(0xFFff6060),
                      // Color(0xFFff6060),
                    ]),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'My Krushes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          child:
        ListView(
          shrinkWrap: true,
          children: [
            Container(
               
                child: ActiveKrushes(),),
            Container(
                      child: Text(
                        'Krush Requests',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
            Container(
              color: Color(0xffF3F4F9),
              child: TabBar(
                  controller: _tabController,
                  // indicator: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                  // ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Theme.of(context).primaryColor,
                  unselectedLabelStyle: TextStyle(color: Colors.black),
                  tabs: [
                    Tab(
                      text: 'Received',
                    ),
                    Tab(
                      text: 'Sent',
                    ),
                    
                  ]),
            ),
            Center(
              child: [
                    ReceiveRequestTab(),
                     SentRequestTab(
                                  ),
                              
              ][_tabIndex],
            ),
           
          ],
        ))

        ,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: SizedBox(
        //   width: 246,
        //   child: FloatingActionButton.extended(
        //     hoverElevation: 8,
        //     elevation: 0,
        //     label: Text(
        //       'Add Krush',
        //       style: GoogleFonts.dmSans(
        //         textStyle: TextStyle(
        //           color: Colors.white,
        //           letterSpacing: 0.8,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 17,
        //         ),
        //       ),
        //     ),
        //     onPressed: () async {
        //       // await  krushRequestBloc.add(ListChanged());
        //       Navigator.pushNamed(context, '/AddKrushPage');
        //     },
        //     backgroundColor: Theme.of(context).primaryColor,
        //     heroTag: "btn1",
        //   ),
        // ),
      ),
    );
  }
}
