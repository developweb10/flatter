import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/ui/pages/manage_subscription.dart';
import 'package:krushapp/ui/pages/manage_subscription.dart';
import 'package:krushapp/ui/pages/subscriptions_revenuecat/manage_subscription_revenuecat.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/krush_add_bloc/krush_add_bloc.dart';
import '../../bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart';
import '../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
import '../../utils/T.dart';

class ConfirmAddKrushDialog extends StatefulWidget {
  String krushPhoneNumber;
  String krushName;
  String krushChatName;
  String krushComment;
  String avatarUrl;

  ConfirmAddKrushDialog(
      this.krushPhoneNumber,
      this.krushName,
      this.krushChatName,
      this.krushComment,
      this.avatarUrl);

  @override
  _ConfirmAddKrushDialogState createState() => _ConfirmAddKrushDialogState();
}

class _ConfirmAddKrushDialogState extends State<ConfirmAddKrushDialog> {
  int free_requests = 0;
  getData() async {
    free_requests = await UserSettingsManager.getFreesendRequestssAllowed();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    context.bloc<KrushAddBloc>().add(CheckAddKrush());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: context.bloc<KrushAddBloc>(),
      listener: (context, state) {
        if (state is KrushAddStateSuccess) {
          T.message("Krush Request sent successfully");
          context.bloc<KrushSentBloc>().add(KrushSentListChanged());
          Navigator.of(context).pop(true);
        }
      },
      builder: (BuildContext context, KrushAddState state) {
        return Container(
          padding: EdgeInsets.all(16),
          child: state is KrushAddStateLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ) 
              : state is KrushAddStateError ?  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                                state.error.toString(),
                                  style: TextStyle(color: Colors.black, fontSize: 17),
                                ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white,  fontSize: 17),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                  ],
                )
               : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     state is SubscribedOkToAdd ?  Column(children: [
                      Text(
            'You are a premium subscriber!',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Enjoy unlimited krush requests',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 8,
          ),
                     
                    ],) :
            Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Free Krush requests left',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          free_requests.toString(),
                          style: Theme.of(context).textTheme.headline6.apply(
                              color: state is KrushAddStateOkToSend
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
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
                                  state is KrushAddStateOkToSend || state is SubscribedOkToAdd
                                      ? 'Add Krush'
                                      : 'Add Subscription',
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                 
                                  if ((state is KrushAddStateOkToSend || state is SubscribedOkToAdd)) {
                                    context.bloc<KrushAddBloc>().add(KrushAdd(
                                        widget.krushPhoneNumber,
                                        widget.krushChatName,
                                        widget.krushName,
                                        widget.krushComment,
                                        widget.avatarUrl));
                                         
                                  } else {
  Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ManageSubscriptionRevenuecat(fromAddDialog: true)),
                                        );  
                                  }


                                })) //  widget.free_requests>0 ?widget.onConfirmed: widget.coins>499?widget.onConfirmed:widget.onAddCoins,))
                      ],
                    )
                  ],
                ),
        );
        
      },
    );
  }
}
