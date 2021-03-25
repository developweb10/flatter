part of 'billing_address_bloc_bloc.dart';

abstract class BillingAddressBlocState extends Equatable {
  const BillingAddressBlocState();
  
  @override
  List<Object> get props => [];
}

class BillingAddressBlocInitial extends BillingAddressBlocState {}



class BillingAddressBlocEmpty extends BillingAddressBlocState {
  @override
  String toString() => 'BillingAddressBlocEmpty';
}

class BillingAddressLoading extends BillingAddressBlocState {
  @override
  String toString() => 'BillingAddressLoading';
}

class BillingAddressLoaded extends BillingAddressBlocState {
   List<AddressModel> addressList;
  BillingAddressLoaded(this.addressList);

  @override
  String toString() => 'SearchStateSuccess { songs: ${addressList.toString()} }';
}

class BillingIndexSelected extends BillingAddressBlocState {
  int index;
  BillingIndexSelected(this.index);

  @override
  String toString() => 'SearchStateSuccess { songs: ${index.toString()} }';
}

class BillingAddressError extends BillingAddressBlocState {
  final String error;

  BillingAddressError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}


