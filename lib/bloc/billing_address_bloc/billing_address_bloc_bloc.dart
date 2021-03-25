import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/addressModel.dart';
import '../../repositories/address_repository.dart';

part 'billing_address_bloc_event.dart';
part 'billing_address_bloc_state.dart';

class BillingAddressBlocBloc extends Bloc<BillingAddressBlocEvent, BillingAddressBlocState> {
  BillingAddressBlocBloc() : super(BillingAddressLoading());
AddressRepository  addressRepository = AddressRepository();
  @override
  Stream<BillingAddressBlocState> mapEventToState(
    BillingAddressBlocEvent event,
  ) async* {
       if (event is LoadBillingAddress) {
       yield BillingAddressLoading();
      try {
        final result = await addressRepository
            .getBillingAddress("get_billing_address");
        yield BillingAddressLoaded(result);
      } catch (error) {
        yield BillingAddressError(error);
      }
    } else if (event is SelectBillingAddress) {
      try {
       
        yield BillingIndexSelected(event.index);
      } catch (error) {
        yield BillingAddressError(error);
      }
    }
   
  }
}
