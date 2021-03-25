part of 'shipping_address_bloc_bloc.dart';

abstract class ShippingAddressBlocEvent extends Equatable {
  const ShippingAddressBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadShippingAddress extends ShippingAddressBlocEvent {
 List<AddressModel> addressList;

  LoadShippingAddress({this.addressList});

  @override
  String toString() => "SearchTextChanged { query: ${addressList.toString} }";
}


class AddShippingAddress extends ShippingAddressBlocEvent {
   List<AddressModel> addressList;

  AddShippingAddress({this.addressList});

  @override
  String toString() => "SearchTextChanged { query: ${addressList.toString} }";
}



class SelectShippingAddress extends ShippingAddressBlocEvent {
   int index;

  SelectShippingAddress({this.index});

  @override
  String toString() => "SearchTextChanged { query: ${index.toString} }";
}