import 'package:ecommerce/models/cart/order_product.dart';
import 'package:ecommerce/screens/cart/components/quantity_bottom_sheet.dart';
import 'package:ecommerce/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartProductCard extends StatelessWidget {
  final OrderProduct orderProduct;
  const CartProductCard({Key? key, required this.orderProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15)),
              child: Image.network(orderProduct.product.image),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderProduct.product.title,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return QuantityBottomSheet(
                          orderProductId: orderProduct.id,
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3))),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Text(
                              'Quantity: ${orderProduct.quantity}',
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(15)),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        orderProduct.product.discountPrice != 0.0
                            ? Text(
                                '\$${orderProduct.product.price}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 10),
                        Text(
                          orderProduct.product.discountPrice == 0.0
                              ? '\$${orderProduct.product.price}'
                              : '\$${orderProduct.product.discountPrice}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
