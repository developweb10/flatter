part of 'subscription_bloc_bloc.dart';

abstract class SubscriptionBlocEvent extends Equatable {
  const SubscriptionBlocEvent();

  @override
  List<Object> get props => [];
}

class ShowSubscription extends SubscriptionBlocEvent {
  @override
  String toString() => "SearchTextChanged { }";
}

class CheckSubscribed extends SubscriptionBlocEvent {
}

class CheckToShowSubsciptionDialog extends SubscriptionBlocEvent {
}

class ShowSubsciptionDialog extends SubscriptionBlocEvent {
}

class UpdateSubscription extends SubscriptionBlocEvent {
String status;
EntitlementInfo  purchaseDetails;

UpdateSubscription(this.status,this.purchaseDetails);
  @override
  String toString() => "SearchTextChanged { }";
}

class AddSubscription extends SubscriptionBlocEvent {
String status;
EntitlementInfo purchaseDetails;

AddSubscription(this.status,this.purchaseDetails);
  @override
  String toString() => "SearchTextChanged { }";
}

class CheckSubscription extends SubscriptionBlocEvent {
bool status;

CheckSubscription(this.status);
}