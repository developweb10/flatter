import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateDialog extends StatefulWidget {
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Update Available',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Please update the app to get best experience',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Expanded(
              //     child: RaisedButton(
              //         padding: EdgeInsets.symmetric(vertical: 16.0),
              //         elevation: 0,
              //         child: Text('Not Now'),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(32)),
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         })),
              // SizedBox(
              //   width: 8,
              // ),
              Expanded(
                  child: RaisedButton(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: Theme.of(context).primaryColor,
                      onPressed:  (){
                       StoreRedirect.redirect(androidAppId: "io.krushin.app",
                    iOSAppId: "1525910913").then((value) {
                       Navigator.pop(context);
                    });
                 
                      }))
            ],
          )
        ],
      ),
    );
  }
}
