import 'package:ecommerce/models/cart/address.dart';
import 'package:ecommerce/models/cart/order_product.dart';

class Order {
  List<OrderProduct> productList;
  late Address shippingAddress;
  late Address billingAddress;

  Order({required this.productList});
}
