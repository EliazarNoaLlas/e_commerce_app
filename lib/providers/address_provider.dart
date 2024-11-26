import 'package:ecommerce/models/cart/address.dart';
import 'package:ecommerce/services/order_api.dart';
import 'package:flutter/cupertino.dart';

class AddressProvider with ChangeNotifier {
  List<Address> addressList = [];
  bool isLoading = true;
  final OrderApi _orderApi = OrderApi();

  Future fetchAddressList() async {
    setIsLoading(true);
    var addressList = await _orderApi.getAddresses();
    setAddressList(addressList);
    setIsLoading(false);
  }

  Future addAddressToOrder(int addressId) async {
    setIsLoading(true);
    await _orderApi.addAddressToOrder(addressId);
    setIsLoading(false);
  }

  Future<Address?> createAddress(Address address) async {
    return await _orderApi.postAddresses(address);
  }

  void addAddress(Address address) {
    addressList.add(address);
    notifyListeners();
  }

  void setAddressList(List<Address> addressList) {
    this.addressList = addressList;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    this.isLoading = value;
    notifyListeners();
  }
}
