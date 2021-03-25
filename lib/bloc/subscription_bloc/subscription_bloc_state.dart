part of 'subscription_bloc_bloc.dart';

abstract class SubscriptionBlocState extends Equatable {
  const SubscriptionBlocState();
  
  @override
  List<Object> get props => [];
}

class SubscriptionBlocInitial extends SubscriptionBlocState {

}

class ShowSubscriptionDialog extends SubscriptionBlocState {
bool initStore;

ShowSubscriptionDialog(this.initStore);
}



class SubscriptionsLoading extends SubscriptionBlocState {

}

class ConfirmSubscription extends SubscriptionBlocState {

}

class SubscriptionLoaded extends SubscriptionBlocState {
  
}



class SubscriptionStatus extends SubscriptionBlocState {
  bool isSubscribed;
  String errorText;
  EntitlementInfo purchaseDetails;
  SubscriptionStatus(this.isSubscribed, {this.purchaseDetails,this.errorText});

}

class SubscriptionAdded extends SubscriptionBlocState {
  bool isSubscribed;
  String errorText;
  EntitlementInfo purchaseDetails;
  SubscriptionAdded(this.isSubscribed, this.purchaseDetails,this.errorText);

}




