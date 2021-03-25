import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/bloc/krush_active_bloc/krush_active_bloc.dart'
    as active;
import 'package:krushapp/ui/pages/manage_subscription.dart';
import 'package:krushapp/ui/pages/subscriptions_revenuecat/manage_subscription_revenuecat.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../bloc/krush_recieved_bloc/krush_recieved_bloc_bloc.dart';
import '../../bloc/request_action_bloc/request_action_bloc.dart';
import '../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'subscription_dialog.dart';
import '../../utils/T.dart';

class ConfirmRequestAcceptDialog extends StatefulWidget {
  int relationId;
  String url;

  ConfirmRequestAcceptDialog(this.relationId, this.url);

  @override
  _ConfirmRequestAcceptDialogState createState() =>
      _ConfirmRequestAcceptDialogState();
}

class _ConfirmRequestAcceptDialogState
    extends State<ConfirmRequestAcceptDialog> {
  int free_accepts = 0;
  getData() async {
    free_accepts = await UserSettingsManager.getFreeAcceptRequestsAllowed();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    context.bloc<RequestActionBloc>().add(CheckAcceptKrush());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: context.bloc<RequestActionBloc>(),
      listener: (context, state) {
        if (state is RequestActionStateSuccess) {
          T.message("Krush request status updated successfully");
          context.bloc<KrushRequestBloc>().add(KrushRequestListChanged());
          context.bloc<active.KrushActiveBloc>().add(active.ListChanged());
          context.bloc<ChatConversationsBloc>().add(GetUserConversations());
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, RequestActionState state) {
        return Container(
          padding: EdgeInsets.all(16),
          child: state is RequestActionStateLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                )
              :      state is RequestActionStateError ?  Column(
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
                ):
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    state is SubscribedOkToAccept ?           Column(children: [
                      Text(
            'You are a premium subscriber!',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Enjoy unlimited request accepts',
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
                          'Free Krush accepts left',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          free_accepts.toString(),
                          style: Theme.of(context).textTheme.headline6.apply(
                              color: state is RequestActionStateOkToSend
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
                                  state is RequestActionStateOkToSend || state is SubscribedOkToAccept
                                      ? 'Accept Krush'
                                      :  'Add Subsciption',
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if ((state is RequestActionStateOkToSend || state is SubscribedOkToAccept)) {
                                    context.bloc<RequestActionBloc>().add(RequestAction(
                                        widget.relationId, widget.url));
                                    context.bloc<KrushRequestBloc>().add(KrushRequestListChanged());
                                  } else {
                                
  Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ManageSubscriptionRevenuecat(fromAcceptDialog: true)),
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
