import 'package:flutter/material.dart';

class ConfirmSendGiftDialog extends StatefulWidget {
  final Function onConfirmed;
  ConfirmSendGiftDialog({this.onConfirmed});
  @override
  _ConfirmSendGiftDialogState createState() => _ConfirmSendGiftDialogState();
}

class _ConfirmSendGiftDialogState extends State<ConfirmSendGiftDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Are you sure?',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Your gift will be sent to your krush for approval.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      elevation: 0,
                      child: Text('Cancel'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: RaisedButton(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Send Gift',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: Theme.of(context).primaryColor,
                      onPressed: widget.onConfirmed))
            ],
          )
        ],
      ),
    );
  }
}
