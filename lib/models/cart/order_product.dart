import 'package:ecommerce/models/minimal_product.dart';

class OrderProduct {
  int id;
  final MinimalProduct product;
  int quantity;

  OrderProduct(
      {required this.id, required this.product, required this.quantity});
}
