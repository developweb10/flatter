part of 'billing_address_bloc_bloc.dart';

abstract class BillingAddressBlocEvent extends Equatable {
  const BillingAddressBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadBillingAddress extends BillingAddressBlocEvent {
 List<AddressModel> addressList;

  LoadBillingAddress({this.addressList});

  @override
  String toString() => "SearchTextChanged { query: ${addressList.toString} }";
}


class AddShippingAddress extends BillingAddressBlocEvent {
   List<AddressModel> addressList;

  AddShippingAddress({this.addressList});

  @override
  String toString() => "SearchTextChanged { query: ${addressList.toString} }";
}



class SelectBillingAddress extends BillingAddressBlocEvent {
   int index;

  SelectBillingAddress({this.index});

  @override
  String toString() => "SearchTextChanged { query: ${index.toString} }";
}