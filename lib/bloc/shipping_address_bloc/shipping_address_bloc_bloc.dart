import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/addressModel.dart';
import '../../repositories/address_repository.dart';

part 'shipping_address_bloc_event.dart';
part 'shipping_address_bloc_state.dart';

class ShippingAddressBlocBloc extends Bloc<ShippingAddressBlocEvent, ShippingAddressBlocState> {
  ShippingAddressBlocBloc() : super(ShippingAddressLoading());
AddressRepository  addressRepository = AddressRepository();
  @override
  Stream<ShippingAddressBlocState> mapEventToState(
    ShippingAddressBlocEvent event,
  ) async* {
       if (event is LoadShippingAddress) {
       yield ShippingAddressLoading();
      try {
        final result = await addressRepository
            .getShippingAddress("get_shipping_address");
        yield ShippingAddressLoaded(result);
      } catch (error) {
        yield ShippingAddressError(error);
      }
    } else if (event is SelectShippingAddress) {
      try {
       
        yield ShippingIndexSelected(event.index);
      } catch (error) {
        yield ShippingAddressError(error);
      }
    }
   
  }
}
