import 'dart:async';

import 'package:analyzer/error/error.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:krushapp/model/result.dart';
import 'package:purchases_flutter/entitlement_info_wrapper.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/subscription_repository.dart';

part 'subscription_bloc_event.dart';
part 'subscription_bloc_state.dart';

class SubscriptionBlocBloc
    extends Bloc<SubscriptionBlocEvent, SubscriptionBlocState> {
  SubscriptionBlocBloc() : super(SubscriptionBlocInitial());
  final SubscriptionRepository subscriptionRepository =
      SubscriptionRepository();
  @override
  Stream<SubscriptionBlocState> mapEventToState(
    SubscriptionBlocEvent event,
  ) async* {
    if (event is CheckToShowSubsciptionDialog) {
      try {
        int result1 = await UserSettingsManager.getsubscriptionShownStatus();
        if (result1 == 0) {
          int result2 = await subscriptionRepository.checkSubscription();
          if (result2 == 0) {
            String transactionID =
                await UserSettingsManager.getSubscriptionTransactionID();
            UserSettingsManager.setsubscriptionShownStatus(
                (await UserSettingsManager.getsubscriptionShownStatus()));
            yield ShowSubscriptionDialog(transactionID != null);
          }
        } else {
          UserSettingsManager.setsubscriptionShownStatus(
              (await UserSettingsManager.getsubscriptionShownStatus()));
        }
      } catch (error) {
      }
    } else if (event is ShowSubsciptionDialog) {
      try {
        String transactionID = await UserSettingsManager.getSubscriptionTransactionID();
        yield ShowSubscriptionDialog(transactionID != null);
        
      } catch (error) {
      }
    } else if (event is UpdateSubscription) {
      try {
        yield SubscriptionsLoading();
        Result result = await subscriptionRepository.addSubscription(
            event.status,
            event.purchaseDetails == null ? null : event.purchaseDetails.originalPurchaseDate,
            event.purchaseDetails == null ? null : event.purchaseDetails.expirationDate);
        if (result.status) {
          if (event.status == "1") {
          UserSettingsManager.setSubsciptionStatus(int.parse(event.status));
          UserSettingsManager.setSubscriptionTransactionID(event.purchaseDetails == null ? null : event.purchaseDetails.originalPurchaseDate);
          UserSettingsManager.setSubscriptionExpiryDate(event.purchaseDetails == null ? null : event.purchaseDetails.expirationDate);
          yield SubscriptionStatus(true,purchaseDetails:event.purchaseDetails);
        }else{
          yield SubscriptionStatus(false, errorText: result.message);
        }
        }else{
           yield SubscriptionStatus(false, errorText: result.message);
        }
        
      } catch (error) {
      }
    }else if (event is AddSubscription) {
      try {
        yield SubscriptionsLoading();
        Result result = await subscriptionRepository.addSubscription(
            event.status,
            event.purchaseDetails == null ? null : event.purchaseDetails.originalPurchaseDate,
            event.purchaseDetails == null ? null : event.purchaseDetails.expirationDate);
        if (result.status) {
          UserSettingsManager.setSubsciptionStatus(1);
          UserSettingsManager.setSubscriptionTransactionID(event.purchaseDetails == null ? null : event.purchaseDetails.originalPurchaseDate);
          UserSettingsManager.setSubscriptionExpiryDate(event.purchaseDetails == null ? null : event.purchaseDetails.expirationDate);
          yield SubscriptionAdded(true,event.purchaseDetails, null);
        }else{
          yield SubscriptionAdded(false, null, result.message);
        }
      } catch (error) {
      }
    }else  if (event is CheckSubscription) {
      try {
        int result2 = await subscriptionRepository.checkSubscription();
        yield SubscriptionStatus(result2 == 1);
      } catch (error) {
      }
    } 
  }
}
