import 'package:flutter/material.dart';

class ConfirmRevealDialog extends StatefulWidget {
  final Function onConfirmed;
  ConfirmRevealDialog({this.onConfirmed});
  @override
  _ConfirmRevealDialogState createState() => _ConfirmRevealDialogState();
}

class _ConfirmRevealDialogState extends State<ConfirmRevealDialog> {
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
            'Do you really want to reveal yourself?',
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
                        'Reveal',
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
