part of 'shipping_address_bloc_bloc.dart';

abstract class ShippingAddressBlocState extends Equatable {
  const ShippingAddressBlocState();
  
  @override
  List<Object> get props => [];
}

class ShippingAddressBlocInitial extends ShippingAddressBlocState {}



class ShippingAddressBlocEmpty extends ShippingAddressBlocState {
  @override
  String toString() => 'ShippingAddressBlocEmpty';
}

class ShippingAddressLoading extends ShippingAddressBlocState {
  @override
  String toString() => 'ShippingAddressLoading';
}

class ShippingAddressLoaded extends ShippingAddressBlocState {
   List<AddressModel> addressList;
  ShippingAddressLoaded(this.addressList);

  @override
  String toString() => 'SearchStateSuccess { songs: ${addressList.toString()} }';
}

class ShippingIndexSelected extends ShippingAddressBlocState {
  int index;
  ShippingIndexSelected(this.index);

  @override
  String toString() => 'SearchStateSuccess { songs: ${index.toString()} }';
}

class ShippingAddressError extends ShippingAddressBlocState {
  final String error;

  ShippingAddressError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}


