import 'package:flutter/material.dart';

class CancelKrushDialog extends StatefulWidget {
  final int relationId;
    final Function reject;
        final Function block;
  CancelKrushDialog({this.relationId, this.reject, this.block});
  @override
  _CancelKrushDialogState createState() => _CancelKrushDialogState();
}

class _CancelKrushDialogState extends State<CancelKrushDialog> {
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
          // Text(
          //   'Do you really want to reveal yourself?',
          //   style: Theme.of(context).textTheme.bodyText2,
          // ),
          // SizedBox(
          //   height: 8,
          // ),
          Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      elevation: 0,
                      child: Text('Reject Krush'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        widget.reject(widget.relationId);
                      })),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: RaisedButton(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Block Krush',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: Theme.of(context).primaryColor,
                      onPressed:(){
                         widget.block(widget.relationId);
                      }))
            ],
          )
        ],
      ),
    );
  }
}
