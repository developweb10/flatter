import 'package:flutter/material.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/utils/zoomImage.dart';
import 'package:krushapp/utils/Constants.dart';
class KrushRevealPage extends StatefulWidget {


  Map args;
  KrushRevealPage(this.args);
  @override
  _KrushRevealPageState createState() => _KrushRevealPageState();
}

class _KrushRevealPageState extends State<KrushRevealPage>
    with TickerProviderStateMixin {
  AnimationController _imageController;
  Animation _imageAnimation;

  AnimationController _cardController;
  Animation _cardAnimation;

  String token, relationId, tag;
  ImageProvider imageProvider;
  @override
  void initState() {

    this.token = widget.args['token'];
    this.relationId = widget.args['relationId'];
    this.tag = widget.args['tag'];
    this.imageProvider = widget.args['imageProvider'];

    _imageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _imageAnimation =
        CurvedAnimation(parent: _imageController, curve: Curves.easeOutBack);

    _cardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _cardAnimation =
        CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack);

    Future.delayed(Duration(milliseconds: 500), () {
      _imageController.forward();
      Future.delayed(Duration(milliseconds: 500), () {
        _cardController.forward();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiClient.apiClient.seenReveal( this.relationId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColor,
              // leading: IconButton(
              //     icon: Icon(
              //       Icons.share,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {}),
              title: Text(
                "Krush Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                // IconButton(
                //     icon: Icon(
                //       Icons.chat,
                //       color: Colors.white,
                //     ),
                //     onPressed: () {})
              ],
            ),
            body: Container(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                         Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomImage(
                  imageProvider: imageProvider ?? Image.network(snapshot.data.data.user
                                                .profile.profilePic ==
                                            null
                                        ? Constants.defaultProfileImage
                                        : snapshot
                                            .data.data.user.profile.profilePic).image,
                  tag: this.tag ?? 'heroTag',
                ),
              ),
            );
                    },
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ScaleTransition(
                      scale: _imageAnimation,
                      child: Hero(tag: this.tag ?? 'heroTag',
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider ?? Image.network(snapshot.data.data.user
                                                .profile.profilePic ==
                                            null
                                        ? Constants.defaultProfileImage
                                        : snapshot
                                            .data.data.user.profile.profilePic)
                                    .image),
                            borderRadius: BorderRadius.circular(16)),
                      ) ,
                      )
                    ),
                  ),
                  ) ,
                  Positioned(
                      bottom: 16,
                      right: 16,
                      left: 16,
                      child: ScaleTransition(
                        scale: _cardAnimation,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                              title:
                                  snapshot.data.data.user.profile.displayName ==
                                          null
                                      ? Text("Name not revealed")
                                      : Row(
                                          children: [
                                            Text(snapshot.data.data.user.profile
                                                        .displayName ==
                                                    null
                                                ? "Name not revealed"
                                                : snapshot.data.data.user
                                                    .profile.displayName),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                        snapshot.data.data.user.mobileNumber == null? "Mobile Number not revealed":
                                          snapshot.data.data.user.mobileNumber,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                   Text(
                                        snapshot.data.data.user.profile.gender == null? "Gender not revealed":
                                          snapshot
                                              .data.data.user.profile.gender,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                          snapshot.data.data.user.profile
                                                      .dateOfBirth ==
                                                  null
                                              ? "Date of Birth not revealed"
                                              : snapshot.data.data.user.profile
                                                      .dateOfBirth.day
                                                      .toString() +
                                                  "-" +
                                                  snapshot.data.data.user.profile
                                                      .dateOfBirth.month
                                                      .toString() +
                                                  "-" +
                                                  snapshot.data.data.user.profile
                                                      .dateOfBirth.year
                                                      .toString(),
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                          snapshot.data.data.user.profile.city ==
                                                  null
                                              ? "City not revealed"
                                              : snapshot.data.data.user.profile.city,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                          snapshot.data.data.user.profile.state ==
                                                  null
                                              ? "State not revealed"
                                              : snapshot
                                                  .data.data.user.profile.state,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                 Text(
                                          snapshot.data.data.user.profile.country ==
                                                  null
                                              ? "Country not revealed"
                                              : snapshot
                                                  .data.data.user.profile.country,
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5),
                                        ),
                                ],
                              )),
                        ),
                      ))
                ],
              ),
            ),
          );
        } else
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          );
      },
    );
  }
}
